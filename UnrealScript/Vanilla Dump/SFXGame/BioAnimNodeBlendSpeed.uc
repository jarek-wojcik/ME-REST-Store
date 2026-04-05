Class BioAnimNodeBlendSpeed extends BioAnimNodeBlendBase
    native;

enum EBioAnim_SpeedType
{
    eBioAnim_SpeedStandard,
    eBioAnim_SpeedStarting,
    eBioAnim_SpeedSnapshot,
};

var(BioAnimNodeBlendSpeed) float BlendTimeToIdle;
var(BioAnimNodeBlendSpeed) float BlendTimeFromIdle;
var(BioAnimNodeBlendSpeed) float BlendTimeMoving;
var(BioAnimNodeBlendSpeed) float WalkSpeed;
var(BioAnimNodeBlendSpeed) float RunSpeed;
var(BioAnimNodeBlendSpeed) float WalkRateScaled;
var(BioAnimNodeBlendSpeed) float RunRateScaled;
var float m_fStartSpeed;
var float m_fCurrentSpeed;
var float m_fStartCheckTime;
var bool m_bIsStarting;
var bool m_bIsStarted;
var(BioAnimNodeBlendSpeed) EBioAnim_SpeedType SpeedType;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BlendTimeToIdle = 0.200000003
    BlendTimeFromIdle = 0.200000003
    BlendTimeMoving = 0.200000003
    WalkSpeed = 112.5
    RunSpeed = 400.0
    WalkRateScaled = 1.0
    RunRateScaled = 1.5
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Idle', 
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
                 Name = 'Walk', 
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
                 Name = 'Run', 
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