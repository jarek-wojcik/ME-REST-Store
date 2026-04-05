Class BioAnimNodeBlendByAction extends AnimNodeBlendList
    native;

struct native BlendTimeFrom 
{
    var(BlendTimeFrom) BlendTimeTo m_aBlendTimeTo[11];
    var(BlendTimeFrom) const editconst EBioActionAnimNode m_eAnimNode;
};
struct native BlendTimeTo 
{
    var(BlendTimeTo) float m_fTime;
    var(BlendTimeTo) const editconst EBioActionAnimNode m_eAnimNode;
};
const BIO_ACTION_ANIM_NODE_COUNT = 11;
enum EBioActionAnimNode
{
    ACTION_ANIM_NODE_POSTURE,
    ACTION_ANIM_NODE_MOUNT,
    ACTION_ANIM_NODE_HESITATE,
    ACTION_ANIM_NODE_FALL,
    ACTION_ANIM_NODE_RAGDOLL,
    ACTION_ANIM_NODE_SNAPSHOT,
    ACTION_ANIM_NODE_DIE,
    ACTION_ANIM_NODE_TECH,
    ACTION_ANIM_NODE_MATINEE,
    ACTION_ANIM_NODE_GETUP,
    ACTION_ANIM_NODE_GESTURES,
};

var(BioAnimNodeBlendByAction) BlendTimeFrom m_aBlendTimeNode[11];
var transient bool m_bHesitateAvailable;
var transient bool m_bFallingAvailable;
var transient EBioActionAnimNode m_eCurrentAnimNode;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_aBlendTimeNode[0] = {
                           m_aBlendTimeTo[0] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_POSTURE}, 
                           m_aBlendTimeTo[1] = {m_fTime = 0.200000003, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_MOUNT}, 
                           m_aBlendTimeTo[2] = {m_fTime = 0.5, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_HESITATE}, 
                           m_aBlendTimeTo[3] = {m_fTime = 0.400000006, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_FALL}, 
                           m_aBlendTimeTo[4] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_RAGDOLL}, 
                           m_aBlendTimeTo[5] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_SNAPSHOT}, 
                           m_aBlendTimeTo[6] = {m_fTime = 0.100000001, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_DIE}, 
                           m_aBlendTimeTo[7] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_TECH}, 
                           m_aBlendTimeTo[8] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_MATINEE}, 
                           m_aBlendTimeTo[9] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_GETUP}, 
                           m_aBlendTimeTo[10] = {m_fTime = 0.200000003, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_GESTURES}, 
                           m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_POSTURE
                          }
    m_aBlendTimeNode[1] = {
                           m_aBlendTimeTo[0] = {m_fTime = 0.25, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_POSTURE}, 
                           m_aBlendTimeTo[1] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_MOUNT}, 
                           m_aBlendTimeTo[2] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_HESITATE}, 
                           m_aBlendTimeTo[3] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_FALL}, 
                           m_aBlendTimeTo[4] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_RAGDOLL}, 
                           m_aBlendTimeTo[5] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_SNAPSHOT}, 
                           m_aBlendTimeTo[6] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_DIE}, 
                           m_aBlendTimeTo[7] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_TECH}, 
                           m_aBlendTimeTo[8] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_MATINEE}, 
                           m_aBlendTimeTo[9] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_GETUP}, 
                           m_aBlendTimeTo[10] = {m_fTime = 0.200000003, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_GESTURES}, 
                           m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_MOUNT
                          }
    m_aBlendTimeNode[2] = {
                           m_aBlendTimeTo[0] = {m_fTime = 0.200000003, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_POSTURE}, 
                           m_aBlendTimeTo[1] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_MOUNT}, 
                           m_aBlendTimeTo[2] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_HESITATE}, 
                           m_aBlendTimeTo[3] = {m_fTime = 0.200000003, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_FALL}, 
                           m_aBlendTimeTo[4] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_RAGDOLL}, 
                           m_aBlendTimeTo[5] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_SNAPSHOT}, 
                           m_aBlendTimeTo[6] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_DIE}, 
                           m_aBlendTimeTo[7] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_TECH}, 
                           m_aBlendTimeTo[8] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_MATINEE}, 
                           m_aBlendTimeTo[9] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_GETUP}, 
                           m_aBlendTimeTo[10] = {m_fTime = 0.200000003, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_GESTURES}, 
                           m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_HESITATE
                          }
    m_aBlendTimeNode[3] = {
                           m_aBlendTimeTo[0] = {m_fTime = 1.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_POSTURE}, 
                           m_aBlendTimeTo[1] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_MOUNT}, 
                           m_aBlendTimeTo[2] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_HESITATE}, 
                           m_aBlendTimeTo[3] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_FALL}, 
                           m_aBlendTimeTo[4] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_RAGDOLL}, 
                           m_aBlendTimeTo[5] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_SNAPSHOT}, 
                           m_aBlendTimeTo[6] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_DIE}, 
                           m_aBlendTimeTo[7] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_TECH}, 
                           m_aBlendTimeTo[8] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_MATINEE}, 
                           m_aBlendTimeTo[9] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_GETUP}, 
                           m_aBlendTimeTo[10] = {m_fTime = 0.200000003, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_GESTURES}, 
                           m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_FALL
                          }
    m_aBlendTimeNode[4] = {
                           m_aBlendTimeTo[0] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_POSTURE}, 
                           m_aBlendTimeTo[1] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_MOUNT}, 
                           m_aBlendTimeTo[2] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_HESITATE}, 
                           m_aBlendTimeTo[3] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_FALL}, 
                           m_aBlendTimeTo[4] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_RAGDOLL}, 
                           m_aBlendTimeTo[5] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_SNAPSHOT}, 
                           m_aBlendTimeTo[6] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_DIE}, 
                           m_aBlendTimeTo[7] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_TECH}, 
                           m_aBlendTimeTo[8] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_MATINEE}, 
                           m_aBlendTimeTo[9] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_GETUP}, 
                           m_aBlendTimeTo[10] = {m_fTime = 0.200000003, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_GESTURES}, 
                           m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_RAGDOLL
                          }
    m_aBlendTimeNode[5] = {
                           m_aBlendTimeTo[0] = {m_fTime = 1.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_POSTURE}, 
                           m_aBlendTimeTo[1] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_MOUNT}, 
                           m_aBlendTimeTo[2] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_HESITATE}, 
                           m_aBlendTimeTo[3] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_FALL}, 
                           m_aBlendTimeTo[4] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_RAGDOLL}, 
                           m_aBlendTimeTo[5] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_SNAPSHOT}, 
                           m_aBlendTimeTo[6] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_DIE}, 
                           m_aBlendTimeTo[7] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_TECH}, 
                           m_aBlendTimeTo[8] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_MATINEE}, 
                           m_aBlendTimeTo[9] = {m_fTime = 1.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_GETUP}, 
                           m_aBlendTimeTo[10] = {m_fTime = 0.200000003, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_GESTURES}, 
                           m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_SNAPSHOT
                          }
    m_aBlendTimeNode[6] = {
                           m_aBlendTimeTo[0] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_POSTURE}, 
                           m_aBlendTimeTo[1] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_MOUNT}, 
                           m_aBlendTimeTo[2] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_HESITATE}, 
                           m_aBlendTimeTo[3] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_FALL}, 
                           m_aBlendTimeTo[4] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_RAGDOLL}, 
                           m_aBlendTimeTo[5] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_SNAPSHOT}, 
                           m_aBlendTimeTo[6] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_DIE}, 
                           m_aBlendTimeTo[7] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_TECH}, 
                           m_aBlendTimeTo[8] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_MATINEE}, 
                           m_aBlendTimeTo[9] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_GETUP}, 
                           m_aBlendTimeTo[10] = {m_fTime = 0.200000003, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_GESTURES}, 
                           m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_DIE
                          }
    m_aBlendTimeNode[7] = {
                           m_aBlendTimeTo[0] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_POSTURE}, 
                           m_aBlendTimeTo[1] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_MOUNT}, 
                           m_aBlendTimeTo[2] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_HESITATE}, 
                           m_aBlendTimeTo[3] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_FALL}, 
                           m_aBlendTimeTo[4] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_RAGDOLL}, 
                           m_aBlendTimeTo[5] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_SNAPSHOT}, 
                           m_aBlendTimeTo[6] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_DIE}, 
                           m_aBlendTimeTo[7] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_TECH}, 
                           m_aBlendTimeTo[8] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_MATINEE}, 
                           m_aBlendTimeTo[9] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_GETUP}, 
                           m_aBlendTimeTo[10] = {m_fTime = 0.200000003, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_GESTURES}, 
                           m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_TECH
                          }
    m_aBlendTimeNode[8] = {
                           m_aBlendTimeTo[0] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_POSTURE}, 
                           m_aBlendTimeTo[1] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_MOUNT}, 
                           m_aBlendTimeTo[2] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_HESITATE}, 
                           m_aBlendTimeTo[3] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_FALL}, 
                           m_aBlendTimeTo[4] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_RAGDOLL}, 
                           m_aBlendTimeTo[5] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_SNAPSHOT}, 
                           m_aBlendTimeTo[6] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_DIE}, 
                           m_aBlendTimeTo[7] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_TECH}, 
                           m_aBlendTimeTo[8] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_MATINEE}, 
                           m_aBlendTimeTo[9] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_GETUP}, 
                           m_aBlendTimeTo[10] = {m_fTime = 0.200000003, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_GESTURES}, 
                           m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_MATINEE
                          }
    m_aBlendTimeNode[9] = {
                           m_aBlendTimeTo[0] = {m_fTime = 0.200000003, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_POSTURE}, 
                           m_aBlendTimeTo[1] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_MOUNT}, 
                           m_aBlendTimeTo[2] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_HESITATE}, 
                           m_aBlendTimeTo[3] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_FALL}, 
                           m_aBlendTimeTo[4] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_RAGDOLL}, 
                           m_aBlendTimeTo[5] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_SNAPSHOT}, 
                           m_aBlendTimeTo[6] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_DIE}, 
                           m_aBlendTimeTo[7] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_TECH}, 
                           m_aBlendTimeTo[8] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_MATINEE}, 
                           m_aBlendTimeTo[9] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_GETUP}, 
                           m_aBlendTimeTo[10] = {m_fTime = 0.200000003, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_GESTURES}, 
                           m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_GETUP
                          }
    m_aBlendTimeNode[10] = {
                            m_aBlendTimeTo[0] = {m_fTime = 0.200000003, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_POSTURE}, 
                            m_aBlendTimeTo[1] = {m_fTime = 0.200000003, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_MOUNT}, 
                            m_aBlendTimeTo[2] = {m_fTime = 0.200000003, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_HESITATE}, 
                            m_aBlendTimeTo[3] = {m_fTime = 0.200000003, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_FALL}, 
                            m_aBlendTimeTo[4] = {m_fTime = 0.200000003, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_RAGDOLL}, 
                            m_aBlendTimeTo[5] = {m_fTime = 0.200000003, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_SNAPSHOT}, 
                            m_aBlendTimeTo[6] = {m_fTime = 0.200000003, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_DIE}, 
                            m_aBlendTimeTo[7] = {m_fTime = 0.200000003, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_TECH}, 
                            m_aBlendTimeTo[8] = {m_fTime = 0.200000003, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_MATINEE}, 
                            m_aBlendTimeTo[9] = {m_fTime = 0.200000003, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_GETUP}, 
                            m_aBlendTimeTo[10] = {m_fTime = 0.0, m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_GESTURES}, 
                            m_eAnimNode = EBioActionAnimNode.ACTION_ANIM_NODE_GESTURES
                           }
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Posture', 
                 Weight = 1.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }, 
                {
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Mount', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }, 
                {
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Hesitate(OBSOLETE)', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }, 
                {
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Fall', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }, 
                {
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Ragdoll', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }, 
                {
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Snapshot', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }, 
                {
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Dying', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }, 
                {
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Tech(OBSOLETE)', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }, 
                {
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Matinee', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }, 
                {
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'GetUp', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }, 
                {
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Gestures', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
    bFixNumChildren = TRUE
}