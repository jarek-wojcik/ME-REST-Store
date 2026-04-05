Class SFXGameEffect_PowerCombo extends SFXGameEffect
    abstract
    config(Game);

var config array<Name> EffectsRemovedOnCombo;
var Class<SFXShake_Power> DetonationScreenShakeClass;
var Class<SFXRumble_Power> DetonationRumbleClass;
var Class<SFXDamageType> DamageType;
var Class<SFXDamageType> MaxRagdollDmgTypeOverride;
var config AreaEffectParameters DetonationParameters;
var Guid CrustGuid;
var config Vector2D ComboDamage;
var config Vector2D ComboForce;
var config Vector2D ComboRadius;
var clearcrosslevel SFXPowerCustomAction SourcePower;
var clearcrosslevel SFXPowerCustomAction CurrentDetonationPower;
var RvrClientEffectInterface DetonationVFX;
var WwiseEvent DetonationSound;
var RvrClientEffectInterface TargetCrustVFX;
var config int MaxTargets;
var float fPowerRatio;
var config int MaximumRagdollTargets;
var config int MaximumRagdollTargetsMP;
var config bool bOnlyOnDeath;

public function bool OnImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local BioPawn ImpactedPawn;
    local int PowerComboTypeUniqueID;
    
    if (Owner != None && Owner.Role == ENetRole.ROLE_Authority)
    {
        ImpactedPawn = BioPawn(oImpacted);
        if (ImpactedPawn != None)
        {
            PowerComboTypeUniqueID = SourcePower.GetPowerComboTypeUniqueIDFromClass(PathName(Class));
            SourcePower.ReplicatePowerComboImpact(ImpactedPawn, ImpactedPawn.CurrentCustomAction, CurrentDetonationPower.Rank, PowerComboTypeUniqueID, nPreviouslyImpacted);
        }
    }
    return TRUE;
}
public function OnRemoved()
{
    Super.OnRemoved();
    if (TargetCrustVFX != None)
    {
        Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(TargetCrustVFX, CrustGuid, TRUE);
    }
}
public function float CalculatePowerRatio(float DetonationPowerRank)
{
    return FClamp((SourcePower.Rank + DetonationPowerRank - float(2)) / 10.0, 0.0, 1.0);
}
public function ClientDoPowerComboImpact(Actor oActor, int CustomActionReactionType, float DetonationPowerRank, int MiscFlags)
{
    if (SourcePower == None)
    {
        return;
    }
    fPowerRatio = CalculatePowerRatio(DetonationPowerRank);
    if (oActor != None)
    {
        SourcePower.DoAreaExplosionForActor(oActor, oActor.location, MiscFlags, GetDamage(fPowerRatio), DamageType, GetForce(fPowerRatio), DetonationParameters, MaximumRagdollTargetsMP, OnImpact, MaxRagdollDmgTypeOverride);
        if (BioPawn(oActor) != None)
        {
            BioPawn(oActor).ClientPlayAnimatedReaction(CustomActionReactionType);
        }
    }
}
public function float GetDamage(float fRatio)
{
    return Lerp(ComboDamage.X, ComboDamage.Y, fRatio);
}
public function float GetForce(float fRatio)
{
    return Lerp(ComboForce.X, ComboForce.Y, fRatio);
}
public function OnApplied()
{
    local RvrClientEffectTarget CETarget;
    
    Super.OnApplied();
    if (TargetCrustVFX != None)
    {
        CETarget.Instigator = Owner;
        CrustGuid = Class'RvrClientEffectManager'.static.GetClientEffectManager().StartOnTarget(TargetCrustVFX, CETarget);
    }
}
public function OnPowerComboDetonated(SFXPowerCustomAction DetonationPower, Vector HitLocation, Vector HitNormal)
{
    local float fRadius;
    local bool bReplicateCustomActionBackup;
    local int nMaxRagdoll;
    local BioPlayerController PCPrimer;
    local BioPlayerController PCDetonator;
    
    if (Owner == None || SourcePower == None)
    {
        return;
    }
    if (DetonationVFX != None)
    {
        Class'RvrClientEffectManager'.static.GetClientEffectManager().PlayAtLocation(DetonationVFX, HitLocation);
    }
    if (DetonationSound != None)
    {
        Owner.PlaySound(DetonationSound, TRUE);
    }
    if (DetonationScreenShakeClass != None)
    {
        SourcePower.PlayPowerScreenShake(DetonationScreenShakeClass, HitLocation);
    }
    if (DetonationScreenShakeClass != None)
    {
        SourcePower.PlayPowerControllerRumble(DetonationRumbleClass, HitLocation);
    }
    fPowerRatio = CalculatePowerRatio(DetonationPower.Rank);
    if (Owner != None && Owner.Role == ENetRole.ROLE_Authority)
    {
        CurrentDetonationPower = DetonationPower;
        fRadius = Lerp(ComboRadius.X, ComboRadius.Y, fPowerRatio);
        bReplicateCustomActionBackup = SourcePower.bReplicateCustomAction;
        SourcePower.bReplicateCustomAction = FALSE;
        if (SFXGRI(Owner.WorldInfo.GRI).IsMultiplayerGame())
        {
            nMaxRagdoll = MaximumRagdollTargetsMP;
        }
        else
        {
            nMaxRagdoll = MaximumRagdollTargets;
        }
        SourcePower.AreaExplosion(HitLocation, fRadius, GetDamage(fPowerRatio), DamageType, GetForce(fPowerRatio), DetonationParameters, MaxTargets, OnImpact, nMaxRagdoll, MaxRagdollDmgTypeOverride);
        SourcePower.bReplicateCustomAction = bReplicateCustomActionBackup;
        CurrentDetonationPower = None;
    }
    PCPrimer = BioPlayerController(CheckOwnerInstigator(SourcePower.m_oPawn.Controller));
    PCDetonator = BioPlayerController(CheckOwnerInstigator(DetonationPower.m_oPawn.Controller));
    if (PCDetonator != None && PCDetonator.IsLocalPlayerController())
    {
        PCDetonator.UpdateAccomplishmentProgression('COMBOCOUNT');
    }
    else if (PCPrimer != None && PCPrimer.IsLocalPlayerController())
    {
        PCPrimer.UpdateAccomplishmentProgression('COMBOCOUNT');
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}