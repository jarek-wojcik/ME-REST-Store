Class BioStage extends Actor
    native
    config(Game);

struct native BioStageCamera 
{
    var(BioStageCamera) BioStageDOFData tDOFData;
    var(BioStageCamera) editconst Name nmCameraTag;
    var(BioStageCamera) float fFov;
    var(BioStageCamera) float fNearPlane;
    var(BioStageCamera) float fHeightDelta;
    var(BioStageCamera) float fPitchDelta;
    var(BioStageCamera) float fYawDelta;
    var(BioStageCamera) bool bDisableHeightAdjustment;
    
    structdefaultproperties
    {
        fNearPlane = 10.0
    }
};

var transient native Map_Mirror m_mapPlacement;
var(BioStage) noclear editfixedsize array<BioStageCamera> m_aCameraList;
var transient Name m_nmCurrentCamera;
var(BioStage) editinline export noclear SkeletalMeshComponent m_pMeshComp;
var config transient float m_fHeightHumanMale;
var transient float m_fHeightAdjust;
var transient float m_fStageZ;
var transient float m_fSpeakerFeetZ;
var transient float m_fSpeakerEyeHeight;
var(BioStage) bool m_bEnabled;
var(BioStage) bool m_bDoHeightAdjustment;
var(BioStage) bool m_bLookAtActive;
var(BioStage) bool m_bDOFActive;
var config transient bool m_bDisableProceduralCameraHeightAdjust;

public native function ProfileStage(BioHUD HUD);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=CylinderComponent Name=CollisionCylinder
        CollisionHeight = 10.0
        CollisionRadius = 5.0
        ReplacementPrimitive = None
        BlockZeroExtent = FALSE
        BlockNonZeroExtent = FALSE
    End Object
    Begin Object Class=SkeletalMeshComponent Name=StageSkeletalMeshComponent
        ReplacementPrimitive = None
    End Object
    m_pMeshComp = StageSkeletalMeshComponent
    m_fHeightHumanMale = 171.039001
    m_bEnabled = TRUE
    m_bDoHeightAdjustment = TRUE
    m_bLookAtActive = TRUE
    m_bDOFActive = TRUE
    Components = (StageSkeletalMeshComponent, CollisionCylinder)
    CollisionComponent = CollisionCylinder
    bHidden = TRUE
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}