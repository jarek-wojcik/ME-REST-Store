Class SFXAI_Wrex extends SFXAI_Henchman
    placeable
    config(AI);

var float MeleeEngagementRange;

public function bool ReactToNearbyEnemy(Pawn NearbyPawn)
{
    if (NearbyPawn != FireTarget)
    {
        SelectTarget();
    }
    if (ShouldMelee(NearbyPawn))
    {
        DoMeleeAttack();
        return TRUE;
    }
    return FALSE;
}
public function bool ShouldMelee(Actor MeleeTarget)
{
    if (VSize(FireTarget.location - MyBP.location) > EnemyDistance_Melee)
    {
        return FALSE;
    }
    return Super.ShouldMelee(MeleeTarget);
}
public function bool EnemyWithinMeleeEngagementDistance()
{
    if (VSize(FireTarget.location - MyBP.location) < MeleeEngagementRange)
    {
        return TRUE;
    }
    return FALSE;
}

auto state Idle 
{
    public function Class<SFXAICommand> ChooseCommand()
    {
        local BioPlayerSquad oPlayerSquad;
        local float fDistance;
        
        if (m_bResetHenchman)
        {
            return Class'SFXAICmd_ResetHenchman';
        }
        if (m_RequestedActorToFollow != None)
        {
            m_vHoldLocation = vect(0.0, 0.0, 0.0);
            m_bHoldingPosition = FALSE;
            m_ActorToFollow = m_RequestedActorToFollow;
            return Class'SFXAICmd_HenchFollowActor';
        }
        if (ShouldFollowPlayer())
        {
            if (m_bFollowPlayer == FALSE && ForcedTarget != None)
            {
                SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(4, MyBP, , , , TRUE);
            }
            oPlayerSquad = MyBP != None ? BioPlayerSquad(MyBP.Squad) : None;
            if (oPlayerSquad != None && oPlayerSquad.m_playerPawn != None)
            {
                m_vHoldLocation = vect(0.0, 0.0, 0.0);
                m_bHoldingPosition = FALSE;
                if (SFXPawn(oPlayerSquad.m_playerPawn).DrivenAtlas != None)
                {
                    m_ActorToFollow = SFXPawn(oPlayerSquad.m_playerPawn).DrivenAtlas;
                }
                else
                {
                    m_ActorToFollow = oPlayerSquad.m_playerPawn;
                }
                return Class'SFXAICmd_HenchFollowActor';
            }
        }
        if (MyBP != None && IsZero(m_vHoldLocation) == FALSE && m_bHoldingPosition == FALSE)
        {
            oPlayerSquad = BioPlayerSquad(MyBP.Squad);
            if (oPlayerSquad != None && oPlayerSquad.m_playerPawn != None)
            {
                fDistance = VSize(oPlayerSquad.m_playerPawn.location - m_vHoldLocation);
                if (fDistance <= TetherDistanceWhileExecutingOrder)
                {
                    return Class'SFXAICmd_MoveToHoldLocation';
                }
                SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(11, MyBP, , , , TRUE);
            }
            m_vHoldLocation = vect(0.0, 0.0, 0.0);
        }
        if (HasAnyEnemies() == FALSE && m_bHoldingPosition && ForcedTarget == None)
        {
            return None;
        }
        return Class'SFXAICmd_Wrex';
    }
    
    stop;
};

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
    MeleeEngagementRange = 4000.0
    AtCover_WeaponRange = AtCov_EvalWeaponRange
    AtCover_Defensive = AtCov_EvalDefensive
    AtCover_Aggressive = AtCov_EvalAggressive
    AtCover_NearMoveGoal = AtCov_EvalNearGoal
    m_fNearbyEnemyDistance = 500.0
}