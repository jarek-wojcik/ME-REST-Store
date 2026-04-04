Class SFXPowerCustomAction_CombatDroneZap extends SFXPowerCustomAction
    config(Game);

var config float MaxJumpDistance;
var config float JumpDelay;
var config float IncapacitateChance;
var config int NumCharges;
var transient Actor LastHitActor;

public function bool OnImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_CombatDroneZapChain Effect;
    
    if (m_oPawn != None)
    {
        Manager = oImpacted.GetModule(Class'SFXModule_GameEffectManager');
        Effect = CreateZapChainEffect(Manager);
        if (Effect != None)
        {
            LastHitActor = oImpacted;
            Effect.OnApplied();
            return TRUE;
        }
    }
    return FALSE;
}
public static function PrecacheVFX(SFXObjectPool ObjectPool, RvrClientEffectManager ClientEffects)
{
    Super.PrecacheVFX(ObjectPool, ClientEffects);
    Class'SFXGameEffect_CombatDroneZapChain'.static.PrecacheVFX(ObjectPool, ClientEffects);
}
public function ClientDoPowerSubsequentImpact(Actor oActor, optional int CustomActionReactionType, optional float Duration, optional int ImpactCount, optional float Delay, optional bool DoCallback)
{
    local SFXGameEffect_CombatDroneZapChain Effect;
    local SFXModule_GameEffectManager Manager;
    
    if (m_oPawn == None)
    {
        return;
    }
    Manager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
    Effect = CreateZapChainEffect(Manager);
    if (Effect != None)
    {
        Effect.Target = LastHitActor;
        LastHitActor = oActor;
        Effect.ImpactAdditionalTarget(oActor);
        Manager.RemoveEffect(Effect);
    }
    if (BioPawn(oActor) != None)
    {
        BioPawn(oActor).ClientPlayAnimatedReaction(CustomActionReactionType);
    }
}
public function float GetImpactDamage(Actor oImpacted, out Class<SFXDamageType> DamageType)
{
    return 0.0;
}
public function float GetImpactForce(Actor oImpacted)
{
    return 0.0;
}
public function SFXGameEffect_CombatDroneZapChain CreateZapChainEffect(SFXModule_GameEffectManager oManager)
{
    local SFXGameEffect_CombatDroneZapChain Effect;
    
    if (oManager != None)
    {
        Effect = SFXGameEffect_CombatDroneZapChain(oManager.CreateEffect(Class'SFXGameEffect_CombatDroneZapChain', Name, JumpDelay + 1.0, 1, 0.0, m_oPawn.Controller));
        if (Effect != None)
        {
            Effect.NumChargesLeft = NumCharges;
            Effect.MaxJumpDistance = MaxJumpDistance;
            Effect.JumpDelay = JumpDelay;
            Effect.Caster = m_oPawn;
            Effect.Power = Self;
            Effect.Damage = Damage.CurrentValue;
            Effect.Force = Force.CurrentValue;
            Effect.DamageOrigin = m_oPawn.location;
            Effect.DamageType = DefaultDamageType;
            Effect.LastHitActor = m_oPawn;
            Effect.IncapacitateChance = IncapacitateChance;
        }
    }
    return Effect;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxJumpDistance = 1000.0
    JumpDelay = 0.5
    DefaultDamageType = None
    DetonationParameters = {DistancedSorted = FALSE}
    ReleaseEffectBoneName = 'Root'
    CE_ReleaseEffectTemplate = RvrClientEffect'BioVFX_T_TechBall.VCFX.Tech_Attack_Muzzle_VCFX'
    CastSound = WwiseEvent'Wwise_Power_Tech_Drone.Play_power_tech_S_combatdrone_attack_cast'
    Discipline = EBioCapMode.BIO_CAPMODE_TECH
    MaximumRange = {BaseValue = 1000.0}
    MaximumImpactTargets = {BaseValue = 1.0, Formula = EPowerDataFormula.BonusIsHardValue}
    Force = {BaseValue = 175.0}
    PowerName = 'CombatDroneZap'
    PowerCustomActionID = 48
    Rank = 1.0
    DelayBeforeFirstUse = 1.0
    UsesSharedCooldown = FALSE
}