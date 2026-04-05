Class BioAnimNodeBlendStateMovementBehavior extends BioAnimNodeBlendStateBehavior
    native
    editinlinenew;

enum EBioAnimNodeBlendStateMoveAxisDirMode
{
    BSMoveAxisDirMode_WorldRotation,
    BSMoveAxisDirMode_WorldVelDir,
    BSMoveAxisDirMode_WorldAccelDir,
    BSMoveAxisDirMode_LocalVelDir,
    BSMoveAxisDirMode_LocalAccelDir,
};
enum EBioAnimNodeBlendStateMoveAxisDir
{
    BSMoveAxisDir_X,
    BSMoveAxisDir_Y,
    BSMoveAxisDir_Z,
};
enum EBioMovementSpeedStates
{
    MSS_Idle,
    MSS_Walk,
    MSS_Run,
    MSS_Sprint,
};
enum EBioAnimNodeBlendStateMovementBehavior
{
    BSMove_None,
    BSMove_SpeedVelocity,
    BSMove_SpeedTacticalVelocity,
    BSMove_ScaleRate,
    BSMove_ScaleRateByWalkSpeed,
    BSMove_ScaleRateByRunSpeed,
    BSMove_ScaleRateBySprintSpeed,
    BSMove_ScaleRateByTacticalWalkSpeed,
    BSMove_ScaleRateByTacticalRunSpeed,
    BSMove_LookAtTurning,
    BSMove_TurningDirection,
    BSMove_AxisDirection,
    BSMove_FlyingState,
    BSMove_StopSwitch,
    BSMove_StopOnFoot,
    BSMove_StartSwitch,
    BSMove_ScaleRateByWalkRunRatio,
    BSMove_SkidTurnSwitch,
};

var(Speed) float BlendDownPerc;
var(Scale) float ScaleByValue;
var(Scale) float WalkRate;
var(Scale) float RunRate;
var(BioAnimNodeBlendStateMovementBehavior) float BlendResetWeight;
var float m_fStartCheckTime;
var int m_nLastPhys;
var(Speed) bool bUseSprint;
var(Speed) bool bUseSnapshotSpeed;
var(Speed) bool bUseSnapshotStartSpeed;
var(Start) bool bUseDirStartControl;
var bool m_bIsStarted;
var bool m_bInTakeoff;
var bool m_bInLanding;
var bool m_bPlayedAnim;
var bool m_bRootMotionOn;
var(Movement) EBioAnimNodeBlendStateMovementBehavior MovementBehavior;
var(AxisDir) EBioAnimNodeBlendStateMoveAxisDir AxisDir;
var(AxisDir) EBioAnimNodeBlendStateMoveAxisDirMode AxisDirMode;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BlendDownPerc = 0.200000003
    ScaleByValue = 1.0
    WalkRate = 1.0
    RunRate = 1.5
    BlendResetWeight = 0.75
    AxisDirMode = EBioAnimNodeBlendStateMoveAxisDirMode.BSMoveAxisDirMode_LocalVelDir
    m_aNodeDefinitions = ({
                           Children = ()
                          }, 
                          {
                           Children = ({
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.100000001, 0.100000001), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Idle', 
                                        DefaultWeight = 1.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.100000001, 0.0, 0.100000001), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Walk', 
                                        DefaultWeight = 0.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.100000001, 0.100000001, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Run', 
                                        DefaultWeight = 0.0
                                       }
                                      )
                          }, 
                          {
                           Children = ({
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.100000001, 0.100000001), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Idle', 
                                        DefaultWeight = 1.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.100000001, 0.0, 0.100000001), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Walk', 
                                        DefaultWeight = 0.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.100000001, 0.100000001, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Run', 
                                        DefaultWeight = 0.0
                                       }
                                      )
                          }, 
                          {
                           Children = ({
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Input', 
                                        DefaultWeight = 1.0
                                       }
                                      )
                          }, 
                          {
                           Children = ({
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Input', 
                                        DefaultWeight = 1.0
                                       }
                                      )
                          }, 
                          {
                           Children = ({
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Input', 
                                        DefaultWeight = 1.0
                                       }
                                      )
                          }, 
                          {
                           Children = ({
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Input', 
                                        DefaultWeight = 1.0
                                       }
                                      )
                          }, 
                          {
                           Children = ({
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Input', 
                                        DefaultWeight = 1.0
                                       }
                                      )
                          }, 
                          {
                           Children = ({
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Input', 
                                        DefaultWeight = 1.0
                                       }
                                      )
                          }, 
                          {
                           Children = ({
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'NoTurn', 
                                        DefaultWeight = 1.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.200000003, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Turning', 
                                        DefaultWeight = 0.0
                                       }
                                      )
                          }, 
                          {
                           Children = ({
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Left', 
                                        DefaultWeight = 1.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Right', 
                                        DefaultWeight = 0.0
                                       }
                                      )
                          }, 
                          {
                           Children = ({
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'PosAxis', 
                                        DefaultWeight = 1.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'NegAxis', 
                                        DefaultWeight = 0.0
                                       }
                                      )
                          }, 
                          {
                           Children = ({
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.200000003, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Flying', 
                                        DefaultWeight = 1.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.200000003, 0.0, 0.100000001, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Takeoff', 
                                        DefaultWeight = 0.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.100000001, 0.0, 0.200000003), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Landing', 
                                        DefaultWeight = 0.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.200000003, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Landed', 
                                        DefaultWeight = 0.0
                                       }
                                      )
                          }, 
                          {
                           Children = ({
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.200000003), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Default', 
                                        DefaultWeight = 1.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.200000003, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Stopping', 
                                        DefaultWeight = 0.0
                                       }
                                      )
                          }, 
                          {
                           Children = ({
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_Query
                                                      }, 
                                        Name = 'Left', 
                                        DefaultWeight = 1.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_Query
                                                      }, 
                                        Name = 'Right', 
                                        DefaultWeight = 0.0
                                       }
                                      )
                          }, 
                          {
                           Children = ({
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.200000003), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Default', 
                                        DefaultWeight = 1.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.200000003, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_Query
                                                      }, 
                                        Name = 'Starting', 
                                        DefaultWeight = 0.0
                                       }
                                      )
                          }, 
                          {
                           Children = ({
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Input', 
                                        DefaultWeight = 1.0
                                       }
                                      )
                          }, 
                          {
                           Children = ({
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.200000003), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Default', 
                                        DefaultWeight = 1.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.200000003, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'SkidTurning', 
                                        DefaultWeight = 0.0
                                       }
                                      )
                          }
                         )
}