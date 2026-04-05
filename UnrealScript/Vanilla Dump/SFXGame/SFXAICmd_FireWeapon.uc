Class SFXAICmd_FireWeapon extends SFXAICommand within SFXAI_Core;

var transient float DamageTaken;
var transient float DamageThreshold;
var transient bool bForceShoot;

public static function bool FireWeapon(SFXAI_Core AI, optional float DmgThreshold, optional bool ForceShoot)
{
    local SFXAICmd_FireWeapon Cmd;
    
    if (AI != None)
    {
        Cmd = new (AI) Class'SFXAICmd_FireWeapon';
        if (Cmd != None)
        {
            Cmd.DamageThreshold = DmgThreshold;
            Cmd.bForceShoot = ForceShoot;
            AI.PushCommand(Cmd);
            return TRUE;
        }
    }
    return FALSE;
}
public event function bool NotifyBump(Actor Other, Vector HitNormal)
{
    if (SFXChildCommand != None)
    {
        return SFXChildCommand.NotifyBump(Other, HitNormal);
    }
    return Outer.RespondToBump(Other, HitNormal);
}
public function Paused(GameAICommand NewCommand)
{
    if (Outer.IsTimerActive('StartFiring'))
    {
        Outer.NotifyAiming(Outer.FireTarget, FALSE);
        Outer.ClearTimer('StartFiring');
        Outer.m_bCancelAction = TRUE;
    }
    Super.Paused(NewCommand);
}
public function NotifyTakeHit(Controller instigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum)
{
    Super.NotifyTakeHit(instigatedBy, HitLocation, Damage, DamageType, Momentum);
    if (DamageThreshold > float(0))
    {
        DamageTaken += float(Damage);
        if (DamageTaken > DamageThreshold)
        {
            Outer.m_bCancelAction = TRUE;
        }
    }
}
public function NotifyWeaponFinishedFiring(Weapon W, byte FireMode)
{
    Super.NotifyWeaponFinishedFiring(W, FireMode);
    if (int(FireMode) != 4)
    {
        Outer.m_bDelayWeaponUse = TRUE;
        Outer.SetTimer(Outer.GetMoveFireDelayTime(), FALSE, 'NotifyWeaponDelayFinished', );
    }
}
public function bool CancelCommand(optional int nReason)
{
    if (Outer.ShouldStayLeanedOut())
    {
        Outer.m_bStayLeanedOut = TRUE;
    }
    return Super.CancelCommand(nReason);
}
public function bool CanStartFiring()
{
    local ECoverAction AttackerCoverAction;
    local ECoverAction TargetCoverAction;
    local BioPawn EnemyPawn;
    local CoverInfo TargetCover;
    
    if (Outer.MyBP.Weapon == None)
    {
        return FALSE;
    }
    if (Outer.MyBP.IsReloading(TRUE))
    {
        return FALSE;
    }
    if (!bForceShoot)
    {
        if (Outer.HasValidTarget() == FALSE)
        {
            return FALSE;
        }
        if (Outer.IsTargetInFiringArc(Outer.MyBP, Outer.FireTarget, Outer.m_fFiringArcAngle) == FALSE)
        {
            Outer.m_nWeaponCompletionReason = 3;
            return FALSE;
        }
        if (Vehicle(Outer.FireTarget) != None)
        {
            if (VSize(Outer.FireTarget.location - Outer.MyBP.location) > Outer.MyBP.SightRadius)
            {
                return FALSE;
            }
        }
        if (Outer.CanShootWeapon(Outer.FireTarget) == FALSE)
        {
            return FALSE;
        }
        EnemyPawn = BioPawn(Outer.FireTarget);
        if (Outer.MyBP.IsInCover())
        {
            if (Outer.GetBestCoverAction(Outer.Cover, Outer.FireTarget, AttackerCoverAction, TargetCoverAction) == FALSE)
            {
                return FALSE;
            }
            Outer.PendingCoverAction = AttackerCoverAction;
            Outer.BestTargetCoverAction = TargetCoverAction;
        }
        else if (Outer.GetPawnCover(EnemyPawn, TargetCover))
        {
            if (Outer.GetBestCoverAction(TargetCover, Outer.MyBP, TargetCoverAction, AttackerCoverAction))
            {
                Outer.BestTargetCoverAction = TargetCoverAction;
            }
        }
        if (Outer.m_bCheckLOS && Outer.CanAttack(Outer.FireTarget) == FALSE)
        {
            Outer.m_nWeaponCompletionReason = 3;
            return FALSE;
        }
        if (!Outer.AcquireTicket(Outer.FireTarget, 2))
        {
            Outer.m_bFailedTicket = TRUE;
            return FALSE;
        }
    }
    return TRUE;
}
public function bool LeanBackInAfterShooting()
{
    if (Outer.MyBP.IsInCover())
    {
        if (Outer.m_bStayLeanedOut == FALSE && Outer.MyBP.CoverAction != ECoverAction.CA_Default)
        {
            Outer.MyBP.SetCoverAction(0);
            Outer.MyBP.ShouldCrouch(Outer.MyBP.CoverType == ECoverType.CT_MidLevel);
        }
        Outer.MyBP.SetAnimatedTransitionPending();
        Class'SFXAICmd_WaitForAnimatedTransition'.static.InitCommand(Outer);
    }
    return TRUE;
}
public function bool LeanBeforeShooting()
{
    local ECoverAction AttackerCoverAction;
    local ECoverAction TargetCoverAction;
    
    if (Outer.MyBP.IsInCover() && Outer.MyBP.IsInCoverLeaning() == FALSE)
    {
        if (Outer.PendingCoverAction != ECoverAction.CA_Default)
        {
            switch (Outer.PendingCoverAction)
            {
                case ECoverAction.CA_LeanLeft:
                case ECoverAction.CA_BlindLeft:
                case ECoverAction.CA_PeekLeft:
                    Outer.MyBP.SetCoverDirection(1);
                    break;
                case ECoverAction.CA_LeanRight:
                case ECoverAction.CA_BlindRight:
                case ECoverAction.CA_PeekRight:
                    Outer.MyBP.SetCoverDirection(2);
                    break;
                default:
            }
            Outer.MyBP.SetCoverAction(Outer.PendingCoverAction);
        }
        else
        {
            if (Outer.GetBestCoverAction(Outer.Cover, Outer.FireTarget, AttackerCoverAction, TargetCoverAction) == FALSE)
            {
                return FALSE;
            }
            switch (AttackerCoverAction)
            {
                case ECoverAction.CA_LeanLeft:
                case ECoverAction.CA_BlindLeft:
                case ECoverAction.CA_PeekLeft:
                    Outer.MyBP.SetCoverDirection(1);
                    break;
                case ECoverAction.CA_LeanRight:
                case ECoverAction.CA_BlindRight:
                case ECoverAction.CA_PeekRight:
                    Outer.MyBP.SetCoverDirection(2);
                    break;
                default:
            }
            Outer.MyBP.SetCoverAction(AttackerCoverAction);
        }
        Outer.MyBP.ShouldCrouch(Outer.MyBP.CoverType == ECoverType.CT_MidLevel && Outer.MyBP.CoverAction != ECoverAction.CA_PopUp);
        Outer.MyBP.SetAnimatedTransitionPending();
        Class'SFXAICmd_WaitForAnimatedTransition'.static.InitCommand(Outer);
    }
    return TRUE;
}
public function Popped()
{
    Outer.ReleaseTicket(Outer.FireTarget, 2);
    if (Outer.MyBP.IsInCover())
    {
        if (Outer.m_bStayLeanedOut == FALSE && Outer.MyBP.CoverAction != ECoverAction.CA_Default)
        {
            Outer.MyBP.SetCoverAction(0);
            Outer.MyBP.ShouldCrouch(Outer.MyBP.CoverType == ECoverType.CT_MidLevel);
        }
    }
    Outer.ResetAimInstability();
    Outer.m_bStayLeanedOut = FALSE;
    if (Outer.__FireWeaponDelegate__Delegate != None)
    {
        Outer.__FireWeaponDelegate__Delegate(Outer.m_nWeaponCompletionReason);
        Outer.__FireWeaponDelegate__Delegate = None;
    }
    Outer.m_bCheckLOS = TRUE;
    Outer.PendingCoverAction = ECoverAction.CA_Default;
    Outer.BestTargetCoverAction = ECoverAction.CA_Default;
    Outer.NotifyAiming(Outer.FireTarget, FALSE);
    Outer.ClearTimer('StartFiring');
    Super(GameAICommand).Popped();
}
public function Pushed()
{
    Super(GameAICommand).Pushed();
    Outer.ClearCancelAction();
}
public function bool StartFiringWeapon()
{
    if (Outer.WeaponAimDelay > 0.0)
    {
        Outer.NotifyAiming(Outer.FireTarget, TRUE);
        Outer.SetTimer(Outer.WeaponAimDelay, FALSE, 'StartFiring', );
    }
    else
    {
        Outer.StartFiring();
    }
    return TRUE;
}
public final function UpdateFocus()
{
    local int nEnemyIndex;
    
    if (Outer.Focus == None)
    {
        nEnemyIndex = Outer.GetEnemyIndex(Pawn(Outer.FireTarget));
        if (nEnemyIndex >= 0)
        {
            if (Outer.IsEnemyVisibleByIndex(nEnemyIndex))
            {
                Outer.Focus = Outer.FireTarget;
            }
            else
            {
                Outer.SetFocalPoint(Outer.GetEnemyLocationByIndex(nEnemyIndex, 1));
            }
        }
    }
}

auto state FiringWeapon extends DebugState 
{
    
Begin:
    Outer.m_nWeaponCompletionReason = 2;
    if (Outer.MyBP == None || Outer.MyBP.IsDead())
    {
        Outer.PopCommand(Self);
    }
    if (Outer.ShouldReload())
    {
        Outer.RELOAD();
    }
    while (Outer.m_bDelayWeaponUse || Outer.IsReloading())
    {
        Outer.Sleep(0.0500000007);
    }
    if (CanStartFiring() == FALSE)
    {
        Outer.PopCommand(Self);
    }
    if (LeanBeforeShooting() == FALSE)
    {
        Outer.PopCommand(Self);
    }
    if (StartFiringWeapon() == FALSE)
    {
        Outer.PopCommand(Self);
    }
    do {
        Outer.Sleep(0.25);
        UpdateFocus();
    } until (Outer.m_bCancelAction || Outer.IsReloading() || Outer.IsFiringWeapon() == FALSE && Outer.IsTimerActive('StartFiring') == FALSE || Outer.IsTargetInFiringArc(Outer.MyBP, Outer.FireTarget, Outer.m_fFiringArcAngle) == FALSE);
    Outer.StopFiring();
    if (Outer.IsTimerActive('StartFiring'))
    {
        Outer.NotifyAiming(Outer.FireTarget, FALSE);
        Outer.ClearTimer('StartFiring');
    }
    if (LeanBackInAfterShooting() == FALSE)
    {
        Outer.PopCommand(Self);
    }
    if (Outer.m_bCancelAction)
    {
        Outer.m_nWeaponCompletionReason = 0;
    }
    else
    {
        Outer.m_nWeaponCompletionReason = 1;
    }
    Outer.PopCommand(Self);
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}