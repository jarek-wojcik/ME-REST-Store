Class BioAnimNodeBlendScalarMovementBehavior extends BioAnimNodeBlendScalarBehavior
    native
    editinlinenew;

enum EBioAnimNodeBlendScalarMoveAxisDirMode
{
    BScMvAxisDirMode_WorldRotation,
    BScMvAxisDirMode_WorldVelDir,
    BScMvAxisDirMode_WorldAccelDir,
    BScMvAxisDirMode_LocalVelDir,
    BScMvAxisDirMode_LocalAccelDir,
};
enum EBioAnimNodeBlendScalarMoveAxisDir
{
    BScMvAxisDir_X,
    BScMvAxisDir_Y,
    BScMvAxisDir_Z,
};
enum EBioAnimNodeBlendScalarMoveAxis
{
    BScMvAxis_All,
    BScMvAxis_2D,
    BScMvAxis_X,
    BScMvAxis_Y,
    BScMvAxis_Z,
};
enum EBioAnimNodeBlendScalarMoveSpeedStates
{
    BScMvSS_Idle,
    BScMvSS_Walk,
    BScMvSS_Run,
    BScMvSS_Sprint,
};
enum EBioAnimNodeBlendScalarMovementBehavior
{
    BScMv_None,
    BScMv_TurnAngle,
    BScMv_SpeedVelocity,
    BScMv_SpeedTacticalVelocity,
    BScMv_AxisDirection,
};

var(Speed) bool bUseSprint;
var(Speed) bool bUseSnapshotSpeed;
var(Speed) bool bUseSnapshotStartSpeed;
var(Speed) bool bUseLocalSpace;
var(Movement) EBioAnimNodeBlendScalarMovementBehavior MovementBehavior;
var(Speed) EBioAnimNodeBlendScalarMoveAxis MoveAxis;
var(AxisDir) EBioAnimNodeBlendScalarMoveAxisDir AxisDir;
var(AxisDir) EBioAnimNodeBlendScalarMoveAxisDirMode AxisDirMode;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    AxisDirMode = EBioAnimNodeBlendScalarMoveAxisDirMode.BScMvAxisDirMode_LocalVelDir
    m_aNodeDefinitions = ({
                           Children = (), 
                           Description = "", 
                           BlendPctPerSecond = 0.0, 
                           DefaultScalar = 0.0, 
                           BlendInstant = FALSE
                          }, 
                          {
                           Children = ({
                                        BlendParams = {Min = 0.0, Peak = 0.0, Max = 90.0}, 
                                        Name = '0Deg'
                                       }, 
                                       {
                                        BlendParams = {Min = 0.0, Peak = 90.0, Max = 180.0}, 
                                        Name = '90Deg'
                                       }, 
                                       {
                                        BlendParams = {Min = 90.0, Peak = 180.0, Max = 180.0}, 
                                        Name = '180Deg'
                                       }
                                      ), 
                           Description = "Turning angle", 
                           BlendPctPerSecond = 0.0, 
                           DefaultScalar = 0.0, 
                           BlendInstant = TRUE
                          }, 
                          {
                           Children = ({
                                        BlendParams = {Min = 0.0, Peak = 0.0, Max = 112.5}, 
                                        Name = 'Idle'
                                       }, 
                                       {
                                        BlendParams = {Min = 0.0, Peak = 112.5, Max = 400.0}, 
                                        Name = 'Walk'
                                       }, 
                                       {
                                        BlendParams = {Min = 112.5, Peak = 400.0, Max = 400.0}, 
                                        Name = 'Run'
                                       }
                                      ), 
                           Description = "Velocity scale", 
                           BlendPctPerSecond = 0.0, 
                           DefaultScalar = 0.0, 
                           BlendInstant = FALSE
                          }, 
                          {
                           Children = ({
                                        BlendParams = {Min = 0.0, Peak = 0.0, Max = 112.5}, 
                                        Name = 'Idle'
                                       }, 
                                       {
                                        BlendParams = {Min = 0.0, Peak = 112.5, Max = 400.0}, 
                                        Name = 'Walk'
                                       }, 
                                       {
                                        BlendParams = {Min = 112.5, Peak = 400.0, Max = 400.0}, 
                                        Name = 'Run'
                                       }
                                      ), 
                           Description = "Tactical velocity scale", 
                           BlendPctPerSecond = 0.0, 
                           DefaultScalar = 0.0, 
                           BlendInstant = FALSE
                          }, 
                          {
                           Children = ({
                                        BlendParams = {Min = -1.0, Peak = 1.0, Max = 1.0}, 
                                        Name = 'PosAxis'
                                       }, 
                                       {
                                        BlendParams = {Min = -1.0, Peak = -1.0, Max = 1.0}, 
                                        Name = 'NegAxis'
                                       }
                                      ), 
                           Description = "Axis direction scale", 
                           BlendPctPerSecond = 0.0, 
                           DefaultScalar = 0.0, 
                           BlendInstant = FALSE
                          }
                         )
}