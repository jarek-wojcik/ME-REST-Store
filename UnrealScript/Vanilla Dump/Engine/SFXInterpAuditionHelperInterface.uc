Class SFXInterpAuditionHelperInterface
    native
    abstract
    transient;

struct native BioScrubbingCamData 
{
    var Vector vCamPos;
    var Rotator rCamRot;
    var Name nmStageCam;
    var float fFov;
    var float fNearPlane;
    var float fAspectRatio;
    
    structdefaultproperties
    {
        fFov = -1234.0
    }
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}