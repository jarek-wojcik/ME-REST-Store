Class RvrClientEffectPool
    native;

struct native RvrClientEffectList 
{
    var array<RvrClientEffectResource> Resources;
    var int MaxEffects;
};
struct native RvrClientEffectResource 
{
    var RvrClientEffectSpawnable Effect;
    var int Priority;
    var float TimeStamp;
};

var transient native Object m_mModuleCount;
var transient native Object m_mModuleMax;
var transient native Object m_mHighestPriorityHiddenModules;
var transient native Object m_mLowestPriorityActiveModules;
var transient native Object m_mEffects;
var transient int m_nTotalEffectCount;
var transient int m_nMaxTotalEffects;
var transient bool m_bInitialized;

public simulated native function bool CountModule(RvrClientEffectModuleInstance pModule, bool bInc);

public simulated native function FlushAllPools(bool bPreserveRunningEffects);

public simulated native function Prime(RvrClientEffectInterface pTemplate, int nMin, int nMax);

public simulated native function RecomputePriorities(Class<Object> pClass);

public simulated native function ResetAllPools(optional bool bSpawnableOnly = FALSE);

public simulated native function bool ShouldReactivate(RvrClientEffectModuleInstance pModule);

public simulated native function UpdatePriorities(RvrClientEffectModuleInstance pModule, bool bActivate);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}