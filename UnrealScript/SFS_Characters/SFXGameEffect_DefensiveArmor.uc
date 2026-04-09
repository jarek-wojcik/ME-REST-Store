Class SFXGameEffect_DefensiveArmor extends SFXGameEffect_DamageTakenBonus;

var Guid GUID_ArmorCrustTemplate;
var RvrClientEffectInterface CE_ArmorCrustTemplate;
var clearcrosslevel SFXPowerCustomAction_DefensiveShield Power;
var bool bArmorVFXOn;

public function OnRemoved()
{
    Super.OnRemoved();
    TurnVFXOff();
}
public function OnUpdate(float DeltaSeconds)
{
    local BioWorldInfo Info;
    local BioPlayerController PC;
    
    Super(SFXGameEffect).OnUpdate(DeltaSeconds);
    Info = BioWorldInfo(Owner.WorldInfo);
    if (Info != None)
    {
        PC = Info.GetLocalPlayerController();
        if (PC != None && (PC.GameModeManager2.IsActive(8) || PC.GameModeManager2.IsActive(7)))
        {
            TurnVFXOff();
            return;
        }
    }
    TurnVFXOn();
}
public function OnApplied()
{
    Super.OnApplied();
    TurnVFXOn();
}
public function TurnVFXOff()
{
    bArmorVFXOn = FALSE;
    Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_ArmorCrustTemplate, GUID_ArmorCrustTemplate, !Owner.bHidden);
}
public function TurnVFXOn()
{
    local RvrClientEffectTarget CETarget;
    local RvrClientEffectManager Manager;
    
    if (!bArmorVFXOn)
    {
        Manager = Class'RvrClientEffectManager'.static.GetClientEffectManager();
        if (Manager != None)
        {
            bArmorVFXOn = TRUE;
            CETarget.Instigator = Owner;
            GUID_ArmorCrustTemplate = Manager.StartOnTarget(CE_ArmorCrustTemplate, CETarget, Owner);
        }
        else
        {
            Owner.SetTimer(0.100000001, FALSE, 'TurnVFXOn', Self);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}