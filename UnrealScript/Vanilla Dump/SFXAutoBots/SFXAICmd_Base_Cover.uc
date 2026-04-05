Class SFXAICmd_Base_Cover extends SFXAICommand_Base_Combat within SFXAI_Cover
    abstract;

public function NotifyTakeHit(Controller instigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum)
{
    local EAICustomAction EvadeAction;
    
    Super(SFXAICommand).NotifyTakeHit(instigatedBy, HitLocation, Damage, DamageType, Momentum);
    if (ClassIsChildOf(DamageType, Class'SFXDamageType_Weapon'))
    {
        Outer.EvadeDamageTaken += float(Damage);
        Outer.SetTimer(Outer.EvadeResetDuration, FALSE, 'ResetEvadeDamage', );
        if (Outer.MyBP.IsInCover() == FALSE)
        {
            if (instigatedBy != None && instigatedBy.Pawn != None && Outer.MyBP.CurrentCustomAction == 0)
            {
                if (Outer.WorldInfo.GameTimeSeconds - Outer.LastEvadeTime >= Outer.EvadeFrequency && Outer.EvadeDamageTaken >= Outer.EvadeHealthThreshold)
                {
                    EvadeAction = Outer.GetBestEvadeDir(instigatedBy.Pawn.location, None, instigatedBy.Pawn);
                    if (EvadeAction != EAICustomAction.CA_None)
                    {
                        Outer.MyBP.StartCustomAction(int(EvadeAction));
                        Outer.LastEvadeTime = Outer.WorldInfo.GameTimeSeconds;
                        Outer.ClearTimer('ResetEvadeDamage');
                        Outer.ResetEvadeDamage();
                    }
                }
            }
        }
        else if (ChildCommand == None)
        {
            Outer.BeginCombatCommand(Class'SFXAICmd_Reaction_ShotInCover');
        }
    }
}
public function bool NotifyMoodChange()
{
    if (Outer.CombatMood == EAICombatMood.AI_Fallback)
    {
        if (Outer.MoveGoal == Outer.FireTarget)
        {
            Outer.MoveTarget = None;
        }
    }
    return Super(SFXAICommand).NotifyMoodChange();
}
public function NotifyPendingPowerImpact(Name Label, float TimeBeforeImpact, SFXPowerCustomAction Power, SFXProjectile_PowerCustomAction Projectile)
{
    local EAICustomAction EvadeAction;
    
    Super(SFXAICommand).NotifyPendingPowerImpact(Label, TimeBeforeImpact, Power, Projectile);
    if (Outer.MyBP.CurrentCustomAction == 0)
    {
        if (Label == 'CombatRoll')
        {
            if (Outer.WorldInfo.GameTimeSeconds - Outer.LastEvadeTime >= Outer.EvadeFrequency && Outer.ShouldPowerEvade())
            {
                EvadeAction = Outer.GetBestEvadeDir(Projectile.location, Projectile);
                if (EvadeAction != EAICustomAction.CA_None)
                {
                    Outer.MyBP.StartCustomAction(int(EvadeAction));
                    Outer.LastEvadeTime = Outer.WorldInfo.GameTimeSeconds;
                    if (Projectile != None)
                    {
                        Projectile.PawnEvadedPower(Outer.MyBP, Label, TimeBeforeImpact);
                    }
                }
            }
        }
    }
}
public function Pushed()
{
    Super.Pushed();
    if (Outer.MyBP != None && Outer.MyBP.IsInCover() == FALSE)
    {
        Outer.bAcquireNewCover = TRUE;
    }
}
public function Resumed(Name OldCommandName)
{
    Super.Resumed(OldCommandName);
    if (Outer.MyBP != None && Outer.MyBP.IsInCover() == FALSE)
    {
        Outer.bAcquireNewCover = TRUE;
        Outer.ClearTimer('FindNewCover');
    }
}
public function bool ShouldAttack()
{
    local float HealthPct;
    
    if (Outer.MyBP.IsInCover() == FALSE)
    {
        return TRUE;
    }
    if (Outer.WorldInfo.GameTimeSeconds - Outer.LastShotAtTime < 3.0 && Outer.WorldInfo.GameTimeSeconds - Outer.LastFireTime < Outer.MaxFireWaitTime)
    {
        return FALSE;
    }
    HealthPct = Outer.MyBP.GetHealthPct();
    if (FRand() < 0.25 + HealthPct * 0.5)
    {
        return TRUE;
    }
    return FALSE;
}

auto state Combat extends InCombat 
{
    
Begin:
    Outer.FindDrivablePawn();
    if (Outer.FireTarget == None)
    {
        while (Outer.SelectTarget() == FALSE)
        {
            Outer.Sleep(1.0);
        }
    }
    if (Outer.bAcquireNewCover)
    {
        if (SFXPawn(Outer.Pawn) != None)
        {
            SFXPawn(Outer.Pawn).PlayMoveToCoverSound();
        }
        if (Outer.CombatMood == EAICombatMood.AI_Aggressive && !Outer.IsTargetStealthed())
        {
            Class'SFXAICmd_AcquireCover'.static.AcquireNewCover(Outer, Outer.AtCover_Aggressive, Outer.FireTarget);
        }
        else
        {
            Class'SFXAICmd_AcquireCover'.static.AcquireNewCover(Outer, Outer.AtCover_WeaponRange, Outer.FireTarget);
        }
        if (Outer.bReachedCover == FALSE && Outer.CombatMood == EAICombatMood.AI_Aggressive && !Outer.IsTargetStealthed())
        {
            Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, Outer.FireTarget, 100.0);
            Outer.bAcquireNewCover = FALSE;
        }
        Outer.SetTimer(Outer.GetCoverDelayTime(), FALSE, 'FindNewCover', );
    }
    if (Outer.bAcquireNewCover == FALSE || Outer.bReachedCover)
    {
        Outer.bAcquireNewCover = FALSE;
        Outer.bReachedCover = FALSE;
        if (ShouldAttack())
        {
            Outer.ShootWeaponAtFireTarget(Outer.MyBP.GetMaxHealth() * Outer.CancelFirePct);
            if (!Outer.bAcquireNewCover)
            {
                Outer.Sleep(Outer.GetActionDelayTime());
            }
        }
    }
    Outer.Sleep(0.100000001);
    goto 'Begin';
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}