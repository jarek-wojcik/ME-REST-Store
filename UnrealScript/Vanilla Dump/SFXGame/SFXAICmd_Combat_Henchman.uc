Class SFXAICmd_Combat_Henchman extends SFXAICommand_Base_Combat within SFXAI_Henchman;

public event function bool NotifyBump(Actor Other, Vector HitNormal)
{
    if (SFXChildCommand != None)
    {
        return SFXChildCommand.NotifyBump(Other, HitNormal);
    }
    return Outer.RespondToBump(Other, HitNormal);
}
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
public function bool CancelCommand(optional int nReason)
{
    if (Super(SFXAICommand).CancelCommand(nReason))
    {
        if (ChildCommand == None && nReason == 2)
        {
            Outer.PopCommand(Self);
        }
        return TRUE;
    }
    return FALSE;
}
public function Popped()
{
    Outer.m_bAvoidDangerLinks = TRUE;
    Outer.ClearTimer('CheckMeleeAttacker');
    Outer.ClearTimer('CheckThreatRadius');
    Outer.ClearTimer('FindNewCover');
    Super.Popped();
}
public function Pushed()
{
    Super.Pushed();
    Outer.SetTimer(1.0 + FRand() * 0.25, TRUE, 'CheckMeleeAttacker', );
    Outer.SetTimer(1.0 + FRand() * 0.25, TRUE, 'CheckThreatRadius', );
    Outer.SetSquadIntoCombat();
    GotoState('Combat', , , );
}
public function Resumed(Name OldCommandName)
{
    Super.Resumed(OldCommandName);
    if (Outer.m_bCancelAction && (Outer.m_nCancelReasons & 2) != 0)
    {
        Outer.PopCommand(Self);
    }
}

state Combat extends InCombat 
{
    
Begin:
    if (Outer.ForcedTarget != None)
    {
        SFXGRI(Outer.WorldInfo.GRI).TriggerVocalizationEvent(2, Outer.MyBP, BioPawn(Outer.ForcedTarget), , , TRUE);
        Outer.FireTarget = Outer.ForcedTarget;
        Outer.PreferredTarget = Outer.ForcedTarget;
        Outer.ForcedTarget = None;
    }
    while (TRUE)
    {
        if (Outer.m_Orders.Length > 0)
        {
            Outer.PopCommand(Self);
        }
        if (Outer.FireTarget == None && Outer.SelectTarget() == FALSE)
        {
            Outer.PopCommand(Self);
        }
        if (Outer.ShouldFollowPlayer())
        {
            Outer.PopCommand(Self);
        }
        if (Outer.m_bHoldingPosition == FALSE)
        {
            if (Outer.MyBP.IsInCover() == FALSE || Outer.IsInWeaponRange(Outer.FireTarget) == FALSE || Outer.CanAttack(Outer.FireTarget) == FALSE || Outer.IsWithinThreatRadius())
            {
                Outer.HenchmanMoveToCover();
                if (Outer.m_bInvalidatedCover)
                {
                    Outer.HenchmanMoveToCover();
                }
                if (Outer.MyBP != None && Outer.MyBP.IsInCover() == FALSE)
                {
                    if (Outer.IsWithinThreatRadius())
                    {
                        Outer.m_nBackingAwayCount++;
                        Class'SFXAICmd_MoveAway'.static.MoveAway(Outer, Outer.FireTarget);
                    }
                    else
                    {
                        if (VSize(Outer.FireTarget.location - Outer.MyBP.location) > 2000.0)
                        {
                            Outer.m_bTooFarToAttack = TRUE;
                            Outer.SetTimer(2.0 + FRand() * 0.5, FALSE, 'ResetFarAwayFlag', );
                            Outer.PopCommand(Self);
                        }
                        Outer.SetTimer(1.5 + FRand() * 0.5, FALSE, 'FindNewCover', );
                    }
                }
            }
        }
        else if (Outer.bAcquireNewCover)
        {
            Outer.m_bAvoidDangerLinks = FALSE;
            if (!Outer.MyBP.IsInCover())
            {
                Outer.MyBP.ShouldCrouch(FALSE);
            }
            Outer.MoveToCoverNearHoldLocation(FALSE);
            if (!Outer.bReachedMoveGoal)
            {
                if (!IsZero(Outer.m_vHoldLocation) && VSizeSq(Outer.m_vHoldLocation - Outer.MyBP.location) > 90000.0)
                {
                    Outer.PathfindToHoldLocation();
                }
            }
            else
            {
                Outer.FindCoverNearHoldLocationCount = 0;
            }
            Outer.m_bAvoidDangerLinks = TRUE;
        }
        if (Outer.m_Orders.Length > 0)
        {
            Outer.PopCommand(Self);
        }
        Outer.bAcquireNewCover = FALSE;
        while (Outer.bAcquireNewCover == FALSE)
        {
            if (Outer.m_Orders.Length > 0)
            {
                Outer.PopCommand(Self);
            }
            if (Outer.FireTarget == None && Outer.SelectTarget() == FALSE)
            {
                Outer.PopCommand(Self);
            }
            if (Outer.MyBP != None && Outer.MyBP.IsInCover() == FALSE)
            {
                Outer.Focus = Outer.FireTarget;
            }
            if (Outer.ShouldAttack())
            {
                Outer.Attack();
                if (Outer.m_AttackResult == AttackResult.ATTACK_FAIL_NO_LOS)
                {
                    if (Outer.IsTimerActive('FindNewCover') == FALSE)
                    {
                        Outer.SetTimer(3.0, FALSE, 'FindNewCover', );
                    }
                }
            }
            if (Outer.m_Orders.Length > 0 || Outer.ShouldFollowPlayer())
            {
                Outer.PopCommand(Self);
            }
            if (Outer.IsInWeaponRange(Outer.FireTarget) == FALSE && Outer.ShouldWaitForPlayer() == FALSE)
            {
                if (Outer.IsTimerActive('FindNewCover') == FALSE)
                {
                    Outer.SetTimer(3.0, FALSE, 'FindNewCover', );
                }
            }
            if (Outer.bAcquireNewCover == FALSE)
            {
                if (Outer.m_bHoldingPosition == FALSE)
                {
                    if (Outer.IsTargetInFiringArc(Outer.MyBP, Outer.FireTarget, Outer.m_fFiringArcAngle) == FALSE)
                    {
                        Outer.bAcquireNewCover = TRUE;
                    }
                }
                else if (!Outer.MyBP.IsInCover() && Outer.FindCoverNearHoldLocationCount < Outer.MaxAttemptsToFindCoverNearHoldLocation)
                {
                    Outer.bAcquireNewCover = TRUE;
                    Outer.FindCoverNearHoldLocationCount++;
                }
                if (Outer.MyBP.IsInCover() && Outer.IsFlankedByTarget(Outer.FireTarget))
                {
                    Outer.MyBP.LeaveCover();
                    Outer.Focus = Outer.FireTarget;
                }
                if (Outer.m_bWaitBeforeNextAttack)
                {
                    Outer.m_bWaitBeforeNextAttack = FALSE;
                    Outer.Sleep(Outer.AttackDelayAfterBeingShot);
                    continue;
                }
                Outer.Sleep(0.5 + FRand());
            }
        }
        Outer.Sleep(0.5);
    }
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}