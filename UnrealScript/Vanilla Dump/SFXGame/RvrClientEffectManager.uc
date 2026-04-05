Class RvrClientEffectManager
    native
    config(Game);

struct native RvrClientEffectStack 
{
    var editinline export array<RvrClientEffectComponent> Elements;
};

var transient array<RvrClientEffectSpawnable> m_aLocalStoppableEffects;
var transient array<Actor> m_aTargets;
var editinline transient array<RvrClientEffectStack> m_aStacks;
var config transient float m_fMaxDistance_Multiplayer_Bias;
var config transient float m_fMaxDistance_LocalPlayer_Bias;
var transient float m_fMaxDistance_Debug_Override_Value;
var transient float m_fMaxDistance_Debug_Bias;
var transient bool m_bMaxDistance_Debug_Override;
var transient bool m_bOnVisible_Debug_Override;
var transient bool m_bOnVisible_Debug_Override_Value;
var transient bool m_bLogOnCleanup_Debug;

public final native function CleanUpPools();

public static final simulated native function RvrClientEffectManager GetClientEffectManager();

public final native function HideOn(Actor pOnActor, bool bHide);

public final native function Play(RvrClientEffectInterface pEffect, Actor pInstigator, optional Vector vParams);

public final native function PlayAtLocation(RvrClientEffectInterface pEffect, Vector vLocation, optional Vector vNormal, optional Vector vParams, optional Actor pOwner);

public final native function PlayHit(RvrClientEffectInterface pEffect, Actor pInstigator, const out ImpactInfo oImpactInfo, optional Vector vParams);

public final native function PlayOnTarget(RvrClientEffectInterface pEffect, const out RvrClientEffectTarget oTarget, optional Actor pOwner);

public final native function Prime(RvrClientEffectInterface pEffect, optional int MinCount = 1);

public final native function PrimeClass(Class<Object> pClass);

public final native function Guid Start(RvrClientEffectInterface pEffect, Actor pInstigator, optional Vector vParams);

public final native function Guid StartAtLocation(RvrClientEffectInterface pEffect, Vector vLocation, optional Vector vNormal, optional Vector vParams, optional Actor pOwner);

public final native function Guid StartHit(RvrClientEffectInterface pEffect, Actor pInstigator, const out ImpactInfo oImpactInfo, optional Vector vParams);

public final native function Guid StartOnTarget(RvrClientEffectInterface pEffect, const out RvrClientEffectTarget oTarget, optional Actor pOwner);

public final native function Stop(RvrClientEffectInterface pEffect, Guid Id, bool bAllowCooldown, optional Actor pOwner);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_fMaxDistance_Multiplayer_Bias = -1000.0
    m_fMaxDistance_LocalPlayer_Bias = 750.0
}