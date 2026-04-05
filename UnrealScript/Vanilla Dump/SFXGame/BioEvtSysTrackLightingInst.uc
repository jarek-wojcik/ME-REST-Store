Class BioEvtSysTrackLightingInst extends SFXGameActorInterpTrackInst
    native;

var BioConvLightingData InitialLightingData;
var bool ResetLightingData;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    InitialLightingData = {
                           TargetBoneName = 'None', 
                           KeyLight_Scale_Red = 0.0, 
                           KeyLight_Scale_Green = 0.0, 
                           KeyLight_Scale_Blue = 0.0, 
                           FillLight_Scale_Red = 0.0, 
                           FillLight_Scale_Green = 0.0, 
                           FillLight_Scale_Blue = 0.0, 
                           RimLightColor = {B = 0, G = 0, R = 0, A = 0}, 
                           RimLightScale = 0.0, 
                           RimLightYaw = 0.0, 
                           RimLightPitch = 0.0, 
                           BouncedLightingIntensity = 0.300000012, 
                           LightRig = None, 
                           LightRigOrientation = 0.0, 
                           bLockEnvironment = FALSE, 
                           bTriggerFullUpdate = FALSE, 
                           bUseForNextCamera = FALSE, 
                           bCastShadows = TRUE, 
                           RimLightControl = ERimLightControlType.RLCT_Key, 
                           LightingType = EConvLightingType.ConvLighting_Cinematic
                          }
}