Class SeqAct_CameraShake extends SequenceAction
    native;

var(SeqAct_CameraShake) protectedwrite float ShakeScale;
var(SeqAct_CameraShake) protectedwrite float RadialShake_InnerRadius;
var(SeqAct_CameraShake) protectedwrite float RadialShake_OuterRadius;
var(SeqAct_CameraShake) protectedwrite float RadialShake_Falloff;
var Actor LocationActor;
var(SeqAct_CameraShake) protectedwrite export CameraShake Shake;
var(SeqAct_CameraShake) protectedwrite bool bDoControllerVibration;
var(SeqAct_CameraShake) protectedwrite bool bRadialShake;
var(SeqAct_CameraShake) protectedwrite bool bOrientTowardRadialEpicenter;
var(SeqAct_CameraShake) protectedwrite ECameraAnimPlaySpace PlaySpace;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 1;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=CameraShake Name=Shake0
        RotOscillation = {
                          Pitch = {Amplitude = 150.0, Frequency = 40.0}, 
                          Yaw = {Amplitude = 75.0, Frequency = 30.0}, 
                          Roll = {Amplitude = 150.0, Frequency = 60.0}
                         }
        OscillationDuration = 1.0
    End Object
    ShakeScale = 1.0
    RadialShake_InnerRadius = 128.0
    RadialShake_OuterRadius = 512.0
    RadialShake_Falloff = 2.0
    Shake = Shake0
    bDoControllerVibration = TRUE
    InputLinks = ({
                   LinkDesc = "Start", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Stop", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Target", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'Targets', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Location", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'LocationActor', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}