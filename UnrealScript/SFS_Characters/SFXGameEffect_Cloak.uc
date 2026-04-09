Class SFXGameEffect_Cloak extends SFXGameEffect;

var delegate<OnCloakEnded> __OnCloakEnded__Delegate;
var Guid CloakEffectGuid;
var RvrClientEffectInterface CE_CloakEffect;
var float CloakTimer;

public function OnRemoved()
{
    local BioPawn oPawn;
    local float fDelay;
    
    Super.OnRemoved();
    oPawn = BioPawn(Owner);
    if (oPawn == None)
    {
        return;
    }
    if (CurrentTime < Duration)
    {
        fDelay = FMin(Duration - CurrentTime, 1.0);
        oPawn.SetTimer(fDelay, FALSE, 'DelayedRemoval', Self);
    }
    else
    {
        DelayedRemoval();
    }
}
public event function OnUpdate(float DeltaSeconds)
{
    local BioWorldInfo Info;
    local BioPlayerController PC;
    
    CloakTimer += DeltaSeconds;
    Info = BioWorldInfo(Owner.WorldInfo);
    if (Info != None)
    {
        PC = Info.GetLocalPlayerController();
        if (PC != None && (PC.GameModeManager2.IsActive(8) || PC.GameModeManager2.IsActive(7)))
        {
            OnCombatEnd();
            return;
        }
    }
}
public function OnApplied()
{
    local BioPawn oPawn;
    local SFXAI_Core oController;
    
    Super.OnApplied();
    oPawn = BioPawn(Owner);
    if (oPawn == None)
    {
        return;
    }
    oPawn.bIsStealthed = TRUE;
    foreach Owner.WorldInfo.AllControllers(Class'SFXAI_Core', oController)
    {
        if (oController.FireTarget == Owner)
        {
            oController.SelectTarget();
            if (oController.Focus == Owner || oController.MoveTarget == Owner || oController.MoveGoal == Owner)
            {
                oController.Focus = None;
                oController.MoveTarget = None;
            }
        }
    }
    TurnVFXOn();
}
public function OnCombatEnd()
{
    CurrentTime = Duration;
}
public function DelayedRemoval()
{
    local BioPawn oPawn;
    local SFXAI_Core C;
    
    oPawn = BioPawn(Owner);
    if (oPawn == None)
    {
        return;
    }
    oPawn.bIsStealthed = FALSE;
    if (SFXPawn_PlayerParty(oPawn) != None)
    {
        foreach Owner.WorldInfo.AllControllers(Class'SFXAI_Core', C)
        {
            if (C.IsHostile(oPawn.Controller) && C.EnemyList.Find('Pawn', oPawn) != -1)
            {
                SFXGRI(Owner.WorldInfo.GRI).TriggerVocalizationEvent(88, BioPawn(C.Pawn), oPawn);
            }
        }
    }
    Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_CloakEffect, CloakEffectGuid, TRUE);
    __OnCloakEnded__Delegate(CloakTimer);
}
public delegate function OnCloakEnded(float TimeInCloak);

public final function TurnVFXOn()
{
    local RvrClientEffectManager Manager;
    
    Manager = Class'RvrClientEffectManager'.static.GetClientEffectManager();
    if (Manager != None)
    {
        CloakEffectGuid = Manager.Start(CE_CloakEffect, Owner, vect(0.0, 0.0, 0.0));
    }
    else
    {
        Owner.SetTimer(0.100000001, FALSE, 'TurnVFXOn', Self);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CE_CloakEffect = RvrClientEffect'BioVFX_C_Stealth.VCFX.Stealth_VCFX'
}