Class SFXAICmd_CoverUserStuck extends SFXAICommand_Base_Combat within SFXAI_Cover;

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
    }
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

auto state Combat extends InCombat 
{
    
Begin:
    if (Outer.FireTarget == None)
    {
        while (Outer.SelectTarget() == FALSE)
        {
            Outer.Sleep(1.0);
        }
    }
    Class'SFXAICmd_AcquireCover'.static.AcquireNewCover(Outer, Outer.AtCover_Aggressive, Outer.FireTarget);
    if (Outer.bReachedCover)
    {
        Outer.BeginDefaultCommand();
    }
    else
    {
        Class'SFXAICmd_MoveToGoal'.static.MoveToGoal(Outer, Outer.FireTarget, 200.0);
        if (Outer.bReachedMoveGoal)
        {
            Outer.BeginDefaultCommand();
        }
    }
    Outer.ShootWeaponAtFireTarget();
    Outer.Sleep(0.5);
    goto 'Begin';
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}