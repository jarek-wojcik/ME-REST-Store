Class SFXAI_Liara extends SFXAI_Henchman
    placeable
    config(AI);

public function bool ChooseAttackPowerHelper(Actor oTarget, bool bPlayerRequest, out Name nmPower, out int nRequiresAttackTicket, out Vector AttackOrigin)
{
    local SFXPowerCustomActionBase oBase;
    local SFXPowerCustomAction oPower;
    local SFXPlayerController Controller;
    local string sOptionalInfo;
    local int iSingularityRank;
    local int iThrowRank;
    local int EnemyCount;
    local bool bShouldUseStasis;
    local bool bShouldUseSingularity;
    local bool bShouldUseThrow;
    local bool bHasStasis;
    local bool bHasSingularity;
    local bool bHasThrow;
    local Name nmStasis;
    local Name nmSingularity;
    local Name nmThrow;
    local SFXPawn_Player Player;
    
    if (!Super.ChooseAttackPowerHelper(oTarget, bPlayerRequest, nmPower, nRequiresAttackTicket, AttackOrigin))
    {
        nmPower = 'Error';
        return FALSE;
    }
    foreach MyBP.PowerManager.Powers(oBase, )
    {
        oPower = SFXPowerCustomAction(oBase);
        if (oPower == None)
        {
            return FALSE;
        }
        if (SFXPowerCustomAction_Stasis(oPower) != None)
        {
            bHasStasis = CanChoosePower(oPower, oTarget, FALSE) && oPower.Rank > float(0);
            bShouldUseStasis = bHasStasis && oPower.ShouldUsePower(oTarget, sOptionalInfo);
            nmStasis = oPower.PowerName;
        }
        if (SFXPowerCustomAction_Singularity(oPower) != None)
        {
            bHasSingularity = CanChoosePower(oPower, oTarget, FALSE) && oPower.Rank > float(0);
            bShouldUseSingularity = bHasSingularity && oPower.ShouldUsePower(oTarget, sOptionalInfo);
            nmSingularity = oPower.PowerName;
            iSingularityRank = int(oPower.Rank);
        }
        if (SFXPowerCustomAction_Throw(oPower) != None)
        {
            bHasThrow = CanChoosePower(oPower, oTarget, FALSE) && oPower.Rank > float(0);
            bShouldUseThrow = bHasThrow && oPower.ShouldUsePower(oTarget, sOptionalInfo);
            nmThrow = oPower.PowerName;
            iThrowRank = int(oPower.Rank);
        }
    }
    Player = SFXPawn_Player(BioWorldInfo(WorldInfo).GetLocalPlayerController().Pawn);
    EnemyCount = BioPlayerController(Player.Controller).EnemyList.Length;
    bShouldUseStasis = bShouldUseStasis && EnemyCount > 2;
    bShouldUseStasis = bShouldUseStasis && BioPawn(oTarget) != None && BioPawn(oTarget).HasAnyShieldResistance();
    Controller = SFXPlayerController(Player.Controller);
    bShouldUseStasis = bShouldUseStasis && (bPlayerRequest || Controller != None && oTarget != Controller.m_oPlayerSelection.m_oCurrentSelectionTarget);
    if (bShouldUseStasis)
    {
        nmPower = nmStasis;
    }
    else if (bShouldUseSingularity && bShouldUseThrow)
    {
        if (FRand() <= float(iThrowRank) / float((iThrowRank + iSingularityRank)))
        {
            nmPower = nmThrow;
        }
        else
        {
            nmPower = nmSingularity;
        }
    }
    else if (bShouldUseThrow)
    {
        nmPower = nmThrow;
    }
    else if (bShouldUseSingularity)
    {
        nmPower = nmSingularity;
    }
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=Goal_AtCover Name=AtCov_EvalWeaponRange
        Begin Template Class=CovGoal_WeaponRange Name=CovGoal_HenchWeaponRange
        End Template
        Begin Template Class=CovGoal_Enemies Name=CovGoal_HenchEnemies
        End Template
        Begin Template Class=CovGoal_MovementDistance Name=CovGoal_HenchMovDistWeapon
        End Template
        Begin Template Class=CovGoal_TeammateProximity Name=CovGoal_HenchTeamProx
        End Template
        Begin Template Class=CovGoal_AvoidEnemies Name=CovGoal_AvoidHenchEnemies
        End Template
        CoverGoalConstraints = (CovGoal_HenchWeaponRange, CovGoal_HenchEnemies, CovGoal_HenchMovDistWeapon, CovGoal_HenchTeamProx, CovGoal_AvoidHenchEnemies)
    End Template
    Begin Template Class=Goal_AtCover Name=AtCov_EvalDefensive
        Begin Template Class=CovGoal_Enemies Name=CovGoal_Enemies0
        End Template
        Begin Template Class=CovGoal_MovementDistance Name=CovGoal_MovDistDefensive
        End Template
        Begin Template Class=CovGoal_TeammateProximity Name=CovGoal_TeamProx0
        End Template
        CoverGoalConstraints = (CovGoal_Enemies0, CovGoal_MovDistDefensive, CovGoal_TeamProx0)
    End Template
    Begin Template Class=Goal_AtCover Name=AtCov_EvalAggressive
        Begin Template Class=CovGoal_WeaponRange Name=CovGoal_WeaponRange0
        End Template
        Begin Template Class=CovGoal_Enemies Name=CovGoal_Enemies0
        End Template
        Begin Template Class=CovGoal_TeammateProximity Name=CovGoal_TeamProx0
        End Template
        Begin Template Class=CovGoal_MovementDistance Name=CovGoal_MovDistAggressive
        End Template
        Begin Template Class=CovGoal_CombatZones Name=CovGoal_CombatZones0
        End Template
        CoverGoalConstraints = (CovGoal_WeaponRange0, CovGoal_Enemies0, CovGoal_TeamProx0, CovGoal_MovDistAggressive, CovGoal_CombatZones0)
    End Template
    Begin Template Class=Goal_AtCover Name=AtCov_EvalNearGoal
        Begin Template Class=CovGoal_GoalProximity Name=CovGoal_NearMoveGoal
        End Template
        Begin Template Class=CovGoal_Enemies Name=CovGoal_Enemies0
        End Template
        CoverGoalConstraints = (CovGoal_NearMoveGoal, CovGoal_Enemies0)
    End Template
    AtCover_WeaponRange = AtCov_EvalWeaponRange
    AtCover_Defensive = AtCov_EvalDefensive
    AtCover_Aggressive = AtCov_EvalAggressive
    AtCover_NearMoveGoal = AtCov_EvalNearGoal
}