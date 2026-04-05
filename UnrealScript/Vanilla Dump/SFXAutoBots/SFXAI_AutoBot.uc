Class SFXAI_AutoBot extends SFXAI_Cover
    placeable
    config(AI);

public function Initialize()
{
    local SFXDifficultyHandler DH;
    local SFXModule_Damage DmgMod;
    
    Super(SFXAI_Core).Initialize();
    DH = SFXGRI(WorldInfo.GRI).DifficultyHandler;
    if (DH != None)
    {
        MeleeAttackInterval = DH.GetFloat('MeleeAttackInterval', 'AssaultTrooper');
        CancelFirePct = DH.GetFloat('CancelFirePct', 'AssaultTrooper');
        MaxFireWaitTime = DH.GetFloat('MaxFireWaitTime', 'AssaultTrooper');
        EvadeDamagePct.X = DH.GetFloat('EvadeDamagePctLow', 'AssaultTrooper');
        EvadeDamagePct.Y = DH.GetFloat('EvadeDamagePctHigh', 'AssaultTrooper');
        EvadeFrequency = DH.GetFloat('EvadeFrequency', 'AssaultTrooper');
        EvadeResetDuration = DH.GetFloat('EvadeResetDuration', 'AssaultTrooper');
        PartialLeanPct = DH.GetFloat('PartialLeanPct', 'AssaultTrooper');
        PowerEvadeChance = DH.GetFloat('PowerEvadeChance', 'AssaultTrooper');
        FlankReactionTime = DH.GetFloat('FlankReactionTime', 'AssaultTrooper');
        DmgMod = MyBP.GetModule(Class'SFXModule_Damage');
        if (DmgMod != None)
        {
            DmgMod.NormalizedHealth = DH.GetFloatNormalized('MaxHealth', 'AssaultTrooper');
            DmgMod.LevelScaledHealth = DH.GetFloat('MaxHealth', 'AssaultTrooper');
            DmgMod.InitializeMaxHealth(DmgMod.LevelScaledHealth);
        }
    }
}
public function bool ChooseAttack(Actor oTarget, out Name nmPowerName)
{
    local SFXWeapon oWeapon;
    local int nRequiresAttackTicket;
    local Vector AttackOrigin;
    local ECoverAction AttackerCoverAction;
    local ECoverAction TargetCoverAction;
    local BioWorldInfo BWI;
    
    BWI = BioWorldInfo(WorldInfo);
    if (MyBP == None)
    {
        return FALSE;
    }
    if (BWI != None && FRand() <= BWI.m_fAutoBotDefensePowerPercent)
    {
        if (ChooseDefensivePower(nmPowerName))
        {
            return TRUE;
        }
    }
    if (oTarget == None)
    {
        return FALSE;
    }
    if (IsTargetInFiringArc(MyBP, oTarget, m_fFiringArcAngle) == FALSE)
    {
        return FALSE;
    }
    if (Vehicle(oTarget) != None)
    {
        if (VSize(oTarget.location - MyBP.location) > MyBP.SightRadius)
        {
            return FALSE;
        }
    }
    if (FRand() <= GetPowerUsePercent())
    {
        ChooseAttackPower(oTarget, nmPowerName, nRequiresAttackTicket, AttackOrigin);
    }
    if (nmPowerName == 'None')
    {
        oWeapon = SFXWeapon(MyBP.Weapon);
        if (oWeapon == None)
        {
            return FALSE;
        }
        if (CanShootWeapon(oTarget) == FALSE)
        {
            return FALSE;
        }
        if (ShouldReload() && RELOAD())
        {
            m_AttackResult = AttackResult.ATTACK_FAIL_RELOADING;
            return FALSE;
        }
    }
    if (MyBP.IsInCover())
    {
        if (GetBestCoverAction(Cover, FireTarget, AttackerCoverAction, TargetCoverAction) == FALSE)
        {
            m_AttackResult = AttackResult.ATTACK_FAIL_NO_LOS;
            return FALSE;
        }
        PendingCoverAction = AttackerCoverAction;
        BestTargetCoverAction = TargetCoverAction;
    }
    if (m_bCheckLOS && CanAttack(oTarget) == FALSE)
    {
        m_AttackResult = AttackResult.ATTACK_FAIL_NO_LOS;
        if (nmPowerName != 'None')
        {
            ClearPowerReservation(nmPowerName);
        }
        return FALSE;
    }
    return TRUE;
}
public function float GetCoverDelayTime()
{
    if (FireTarget == None)
    {
        return 1.0;
    }
    return RandRange(FarCoverDelayTime.X, FarCoverDelayTime.Y);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=Goal_AtCover Name=AtCov_EvalAggressive
        Begin Template Class=CovGoal_CombatZones Name=CovGoal_CombatZones0
        End Template
        Begin Template Class=CovGoal_Enemies Name=CovGoal_Enemies0
        End Template
        Begin Template Class=CovGoal_MovementDistance Name=CovGoal_MovDistAggressive
        End Template
        Begin Template Class=CovGoal_TeammateProximity Name=CovGoal_TeamProx0
        End Template
        Begin Template Class=CovGoal_WeaponRange Name=CovGoal_WeaponRange0
        End Template
        CoverGoalConstraints = (CovGoal_WeaponRange0, CovGoal_Enemies0, CovGoal_TeamProx0, CovGoal_MovDistAggressive, CovGoal_CombatZones0)
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
    Begin Template Class=Goal_AtCover Name=AtCov_EvalNearGoal
        Begin Template Class=CovGoal_Enemies Name=CovGoal_Enemies0
        End Template
        Begin Template Class=CovGoal_GoalProximity Name=CovGoal_NearMoveGoal
        End Template
        CoverGoalConstraints = (CovGoal_NearMoveGoal, CovGoal_Enemies0)
    End Template
    Begin Template Class=Goal_AtCover Name=AtCov_EvalWeaponRange
        Begin Template Class=CovGoal_CombatZones Name=CovGoal_CombatZones0
        End Template
        Begin Template Class=CovGoal_Enemies Name=CovGoal_Enemies0
        End Template
        Begin Template Class=CovGoal_MovementDistance Name=CovGoal_MovDistWeapon
        End Template
        Begin Template Class=CovGoal_TeammateProximity Name=CovGoal_TeamProx0
        End Template
        Begin Template Class=CovGoal_WeaponRange Name=CovGoal_WeaponRange0
        End Template
        CoverGoalConstraints = (CovGoal_WeaponRange0, CovGoal_Enemies0, CovGoal_TeamProx0, CovGoal_MovDistWeapon, CovGoal_CombatZones0)
    End Template
    AtCover_WeaponRange = AtCov_EvalWeaponRange
    AtCover_Defensive = AtCov_EvalDefensive
    AtCover_Aggressive = AtCov_EvalAggressive
    AtCover_NearMoveGoal = AtCov_EvalNearGoal
    DefaultCommand = Class'SFXAICmd_Base_AutoBot'
    m_fNearbyEnemyDistance = 500.0
    m_bAvoidDangerLinks = TRUE
    bIsAutoBot = TRUE
}