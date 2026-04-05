Class RvrClientEffectComponent extends ActorComponent
    native
    editinlinenew;

var(RvrClientEffectComponent) array<RvrClientEffectParameter> m_lstParameters;
var transient array<RvrClientEffectModuleInstance> m_lstModuleInstances;
var delegate<OnEffectFinished> __OnEffectFinished__Delegate;
var RvrClientEffectTarget m_oTarget;
var(RvrClientEffectComponent) RvrClientEffectInterface m_pClientEffect;
var transient int m_nExclusivePriority;
var transient float m_fTime;
var transient float m_fDistance;
var transient float m_fCoolDownTime;
var transient PostProcessChain m_pPostProcessChain;
var transient int m_nEffectIndex;
var transient bool m_bActive;
var transient bool m_bPrimed;
var transient bool m_bResetPending;
var transient bool m_bStopRequested;
var transient bool m_bHidden;
var transient bool m_bExclusiveOnTarget;
var transient bool m_bOnLocalPlayer;
var transient bool m_bInstigatorValid;
var transient bool m_bBehind;
var transient bool m_bMultiplayer;

public simulated native function ActivateModule(RvrClientEffectModuleInstance pInstance);

public simulated native function ApplyParameters(array<RvrClientEffectParameter> lstParams, RvrClientEffectModuleInstance pInstance);

public simulated native function RvrClientEffectModuleInstance CreateModule(RvrClientEffectModule pTemplate);

public simulated native function Hide(bool bHide);

public delegate function OnEffectFinished(RvrClientEffectComponent pComponent);

public simulated native function OnProjectileExploded(Projectile pProjectile);

public simulated native function Prime();

public simulated native function ResetEffect();

public simulated native function SetTemplate(RvrClientEffectInterface pTemplate);

public simulated native function StopEffect(optional bool bAllowCooldown = FALSE);

public simulated native function Tick(float fDeltaTime);

public simulated native function UpdateDistance();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_oTarget = {
                 Id = {A = 0, B = 0, C = 0, D = 0}, 
                 HitLocation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                 RefinedHitLocation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                 RefinedRayDir = {X = -1.0, Y = 0.0, Z = 0.0}, 
                 HitNormal = {X = 1.0, Y = 0.0, Z = 0.0}, 
                 RayDir = {X = -1.0, Y = 0.0, Z = 0.0}, 
                 SpawnValue = {X = 0.0, Y = 0.0, Z = 0.0}, 
                 HitBone = 'None', 
                 Instigator = None, 
                 HitActor = None, 
                 HitMaterial = None, 
                 bHasRefinedHitLocation = FALSE
                }
}