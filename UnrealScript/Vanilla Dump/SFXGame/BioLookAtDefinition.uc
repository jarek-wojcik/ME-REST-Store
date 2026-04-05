Class BioLookAtDefinition
    native;

struct native LookAtBoneDefinition 
{
    var(LookAtBoneDefinition) array<Name> m_anTargetBones;
    var(LookAtBoneDefinition) Name m_nBoneName;
    var(LookAtBoneDefinition) Name m_nmMasterBoneName;
    var(LookAtBoneDefinition) float m_fLimit;
    var(LookAtBoneDefinition) float m_fUpDownLimit;
    var(LookAtBoneDefinition) float m_fDelay;
    var(LookAtBoneDefinition) float m_fSpeedFactor;
    var(LookAtBoneDefinition) float m_fMaxAcceleration;
    var(LookAtBoneDefinition) float m_fMaxDeceleration;
    var(LookAtBoneDefinition) float m_fConversationStrength;
    var(LookAtBoneDefinition) bool m_bSeparateUpDownLimit;
    var(LookAtBoneDefinition) bool m_bUseUpAxis;
    var(LookAtBoneDefinition) bool m_bUpAxisInLocalSpace;
    var(LookAtBoneDefinition) bool m_bLookAtInverted;
    var(LookAtBoneDefinition) bool m_bUpAxisInverted;
    var(LookAtBoneDefinition) bool m_bUseAcceleration;
    var(LookAtBoneDefinition) bool m_bUseMasterBone;
    var(LookAtBoneDefinition) byte m_nLookAxis;
    var(LookAtBoneDefinition) byte m_nUpAxis;
};

var(BioLookAtDefinition) array<LookAtBoneDefinition> BoneDefinitions;
var(BioLookAtDefinition) Name RootAnimBoneName;
var(BioLookAtDefinition) float ValidTargetAngleRange;
var(BioLookAtDefinition) bool RootAnimBoneLookAtInverted;
var(BioLookAtDefinition) bool RootAnimBoneUpInverted;
var(BioLookAtDefinition) bool RootBoneYawOnly;
var(BioLookAtDefinition) byte RootAnimBoneLookAtAxis;
var(BioLookAtDefinition) byte RootAnimBoneUpAxis;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BoneDefinitions = ({
                        m_anTargetBones = ('Eye_Left'), 
                        m_nBoneName = 'Eye_Right', 
                        m_nmMasterBoneName = 'None', 
                        m_fLimit = 70.0, 
                        m_fUpDownLimit = 35.0, 
                        m_fDelay = 0.0, 
                        m_fSpeedFactor = 45.0, 
                        m_fMaxAcceleration = 40.0, 
                        m_fMaxDeceleration = 20.0, 
                        m_fConversationStrength = 0.699999988, 
                        m_bSeparateUpDownLimit = TRUE, 
                        m_bUseUpAxis = TRUE, 
                        m_bUpAxisInLocalSpace = FALSE, 
                        m_bLookAtInverted = TRUE, 
                        m_bUpAxisInverted = TRUE, 
                        m_bUseAcceleration = TRUE, 
                        m_bUseMasterBone = FALSE, 
                        m_nLookAxis = 2, 
                        m_nUpAxis = 1
                       }, 
                       {
                        m_anTargetBones = ('Eye_Right'), 
                        m_nBoneName = 'Eye_Left', 
                        m_nmMasterBoneName = 'None', 
                        m_fLimit = 70.0, 
                        m_fUpDownLimit = 35.0, 
                        m_fDelay = 0.0, 
                        m_fSpeedFactor = 45.0, 
                        m_fMaxAcceleration = 40.0, 
                        m_fMaxDeceleration = 20.0, 
                        m_fConversationStrength = 0.699999988, 
                        m_bSeparateUpDownLimit = TRUE, 
                        m_bUseUpAxis = TRUE, 
                        m_bUpAxisInLocalSpace = FALSE, 
                        m_bLookAtInverted = TRUE, 
                        m_bUpAxisInverted = TRUE, 
                        m_bUseAcceleration = TRUE, 
                        m_bUseMasterBone = FALSE, 
                        m_nLookAxis = 2, 
                        m_nUpAxis = 1
                       }, 
                       {
                        m_anTargetBones = ('Head'), 
                        m_nBoneName = 'Head', 
                        m_nmMasterBoneName = 'None', 
                        m_fLimit = 120.0, 
                        m_fUpDownLimit = 100.0, 
                        m_fDelay = 0.100000001, 
                        m_fSpeedFactor = 40.0, 
                        m_fMaxAcceleration = 35.0, 
                        m_fMaxDeceleration = 10.0, 
                        m_fConversationStrength = 0.5, 
                        m_bSeparateUpDownLimit = TRUE, 
                        m_bUseUpAxis = TRUE, 
                        m_bUpAxisInLocalSpace = FALSE, 
                        m_bLookAtInverted = FALSE, 
                        m_bUpAxisInverted = TRUE, 
                        m_bUseAcceleration = TRUE, 
                        m_bUseMasterBone = FALSE, 
                        m_nLookAxis = 1, 
                        m_nUpAxis = 2
                       }, 
                       {
                        m_anTargetBones = ('Neck'), 
                        m_nBoneName = 'Neck', 
                        m_nmMasterBoneName = 'None', 
                        m_fLimit = 50.0, 
                        m_fUpDownLimit = 180.0, 
                        m_fDelay = 0.100000001, 
                        m_fSpeedFactor = 4.0, 
                        m_fMaxAcceleration = 8.0, 
                        m_fMaxDeceleration = 4.0, 
                        m_fConversationStrength = 0.5, 
                        m_bSeparateUpDownLimit = TRUE, 
                        m_bUseUpAxis = TRUE, 
                        m_bUpAxisInLocalSpace = FALSE, 
                        m_bLookAtInverted = FALSE, 
                        m_bUpAxisInverted = TRUE, 
                        m_bUseAcceleration = TRUE, 
                        m_bUseMasterBone = FALSE, 
                        m_nLookAxis = 1, 
                        m_nUpAxis = 2
                       }, 
                       {
                        m_anTargetBones = ('Chest1'), 
                        m_nBoneName = 'Chest1', 
                        m_nmMasterBoneName = 'None', 
                        m_fLimit = 160.0, 
                        m_fUpDownLimit = 50.0, 
                        m_fDelay = 0.100000001, 
                        m_fSpeedFactor = 4.0, 
                        m_fMaxAcceleration = 16.0, 
                        m_fMaxDeceleration = 8.0, 
                        m_fConversationStrength = 0.200000003, 
                        m_bSeparateUpDownLimit = TRUE, 
                        m_bUseUpAxis = TRUE, 
                        m_bUpAxisInLocalSpace = FALSE, 
                        m_bLookAtInverted = FALSE, 
                        m_bUpAxisInverted = TRUE, 
                        m_bUseAcceleration = TRUE, 
                        m_bUseMasterBone = FALSE, 
                        m_nLookAxis = 4, 
                        m_nUpAxis = 2
                       }
                      )
    RootAnimBoneName = 'Root'
    ValidTargetAngleRange = 2.3499999
    RootBoneYawOnly = TRUE
    RootAnimBoneLookAtAxis = 1
    RootAnimBoneUpAxis = 4
}