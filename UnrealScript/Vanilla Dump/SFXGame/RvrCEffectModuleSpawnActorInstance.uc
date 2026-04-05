Class RvrCEffectModuleSpawnActorInstance extends RvrClientEffectModuleInstance
    native
    transient;

struct native RvrClientEffectSavedState 
{
    var array<BoneAtom> Atoms;
    var editinline array<RvrClientEffectSavedAttachment> Attachments;
    var Vector location;
    var Rotator Rotation;
    var Vector Velocity;
    var Vector ComponentTranslation;
    var Rotator ComponentRotation;
    var Vector ComponentScale3D;
    var float ComponentScale;
    var int LOD;
    var float TimeStamp;
};
struct native RvrClientEffectSavedAttachment 
{
    var array<BoneAtom> Atoms;
    var editinline Attachment Attachment;
    var int LOD;
};
struct native RvrClientEffectSpawnedActor 
{
    var array<MaterialInstance> MaterialInstances;
    var Vector Offset;
    var Rotator Rotation;
    var Actor Actor;
    var float SpawnTime;
    var float Lifetime;
    var float CopyDelay;
};

var array<RvrClientEffectSpawnedActor> m_lstSpawns;
var editinline array<RvrClientEffectSavedState> m_lstSavedStates;
var array<int> m_lstBoneMap;
var int m_nSavedStateHead;
var int m_nSavedStates;
var int m_nRemainingSpawns;
var float m_fSpawnPotential;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}