Class SFXShake_Power extends SFXCameraShakeBase;

var float MinDetonationShakeDistance;
var float MaxDetonationShakeDistance;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MinDetonationShakeDistance = 500.0
    MaxDetonationShakeDistance = 1500.0
    TheShake = {
                RotAmplitude = {X = 300.0, Y = 300.0, Z = 300.0}, 
                RotFrequency = {X = 10.0, Y = 10.0, Z = 10.0}, 
                LocFrequency = {X = 0.0, Y = 0.0, Z = 0.0}, 
                ShakeName = 'PowerHeavyImpact', 
                TimeDuration = 0.600000024
               }
}