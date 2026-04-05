Class RB_Spring extends ActorComponent
    native;

var(RB_Spring) InterpCurveFloat SpringMaxForceTimeScale;
var const native Pointer SpringData;
var const Name BoneName1;
var const Name BoneName2;
var const editinline export PrimitiveComponent Component1;
var const editinline export PrimitiveComponent Component2;
var const native int SceneIndex;
var const native float TimeSinceActivation;
var const float MinBodyMass;
var(RB_Spring) float SpringSaturateDist;
var(RB_Spring) float SpringMaxForce;
var(RB_Spring) float MaxForceMassRatio;
var(RB_Spring) float DampSaturateVel;
var(RB_Spring) float DampMaxForce;
var const native bool bInHardware;
var(RB_Spring) bool bEnableForceMassRatio;

public native function Clear();

public native function SetComponents(PrimitiveComponent InComponent1, Name InBoneName1, Vector Position1, PrimitiveComponent InComponent2, Name InBoneName2, Vector Position2);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SpringMaxForceTimeScale = {
                               Points = ({InVal = 0.0, OutVal = 1.0, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_Linear}
                                        ), 
                               InterpMethod = EInterpMethodType.IMT_UseFixedTangentEvalAndNewAutoTangents
                              }
    TickGroup = ETickingGroup.TG_PreAsyncWork
}