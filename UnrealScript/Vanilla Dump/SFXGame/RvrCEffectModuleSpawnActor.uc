Class RvrCEffectModuleSpawnActor extends RvrClientEffectModule
    native
    editinlinenew;

var(Spawn) editinline RawDistributionFloat m_SpawnRate;
var(Spawn) editinline RawDistributionFloat m_Lifetime;
var(Spawn) editinline RawDistributionVector m_Offset;
var(Spawn) editinline RawDistributionVector m_Rotation;
var(Ghosting) editinline RawDistributionFloat m_CopyDelay;
var(Configure) array<MaterialInterface> m_lstMaterials;
var(Spawn) Class<Actor> m_pActorClass;
var(Configure) Name m_nmEffectsMaterial;
var(Configure) Name m_nmAnimSeq;
var(Spawn) int m_nNumActors;
var(Configure) SkeletalMesh m_pSkeletalMesh;
var(Configure) AnimSet m_pAnimSet;
var(Ghosting) bool m_bCopyPosition;
var(Ghosting) bool m_bCopyRotation;
var(Ghosting) bool m_bPositionSmoothing;
var(Ghosting) bool m_bCopyAnimation;
var(Ghosting) bool m_bCopySkeletalMesh;
var(Ghosting) bool m_bCopyMaterialParams;
var(Ghosting) bool m_bCopyAttachments;
var(Ghosting) bool m_bCopyAttachmentAnim;
var(Ghosting) bool m_bDontMove;
var(Ghosting) bool m_bHideFirstFrame;
var(Configure) bool m_bSendTimeParam;
var(Configure) bool m_bInstantiateOtherMaterials;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionCopyDelay
        Constant = 1.0
    End Object
    Begin Object Class=DistributionFloatConstant Name=DistributionLifetime
        Constant = 1.0
    End Object
    Begin Object Class=DistributionFloatConstant Name=DistributionSpawnRate
        Constant = 1.0
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionOffset
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionRotation
    End Object
    m_SpawnRate = {
                   Distribution = DistributionSpawnRate, 
                   Type = 0, 
                   Op = 1, 
                   LookupTableNumElements = 1, 
                   LookupTableChunkSize = 1, 
                   LookupTable = (1.0, 1.0, 1.0, 1.0), 
                   LookupTableTimeScale = 0.0, 
                   LookupTableStartTime = 0.0
                  }
    m_Lifetime = {
                  Distribution = DistributionLifetime, 
                  Type = 0, 
                  Op = 1, 
                  LookupTableNumElements = 1, 
                  LookupTableChunkSize = 1, 
                  LookupTable = (1.0, 1.0, 1.0, 1.0), 
                  LookupTableTimeScale = 0.0, 
                  LookupTableStartTime = 0.0
                 }
    m_Offset = {
                Distribution = DistributionOffset, 
                Type = 0, 
                Op = 1, 
                LookupTableNumElements = 1, 
                LookupTableChunkSize = 3, 
                LookupTable = (0.0, 
                               0.0, 
                               0.0, 
                               0.0, 
                               0.0, 
                               0.0, 
                               0.0, 
                               0.0
                              ), 
                LookupTableTimeScale = 0.0, 
                LookupTableStartTime = 0.0
               }
    m_Rotation = {
                  Distribution = DistributionRotation, 
                  Type = 0, 
                  Op = 1, 
                  LookupTableNumElements = 1, 
                  LookupTableChunkSize = 3, 
                  LookupTable = (0.0, 
                                 0.0, 
                                 0.0, 
                                 0.0, 
                                 0.0, 
                                 0.0, 
                                 0.0, 
                                 0.0
                                ), 
                  LookupTableTimeScale = 0.0, 
                  LookupTableStartTime = 0.0
                 }
    m_CopyDelay = {
                   Distribution = DistributionCopyDelay, 
                   Type = 0, 
                   Op = 1, 
                   LookupTableNumElements = 1, 
                   LookupTableChunkSize = 1, 
                   LookupTable = (1.0, 1.0, 1.0, 1.0), 
                   LookupTableTimeScale = 0.0, 
                   LookupTableStartTime = 0.0
                  }
    m_pActorClass = Class'SkeletalMeshActorSpawnable'
    m_pInstanceClass = Class'RvrCEffectModuleSpawnActorInstance'
}