Class BioAnimNodeBlendFall extends AnimNodeBlendList
    native;

enum EBioAnimNodeFall
{
    eBioAnimNodeFall_Falling,
    eBioAnimNodeFall_Landing,
};

var(BioAnimNodeBlendFall) float BlendIntoFallingTime;
var(BioAnimNodeBlendFall) float BlendIntoLandingTime;
var transient bool bRootMotionOverridden;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BlendIntoFallingTime = 0.200000003
    BlendIntoLandingTime = 0.200000003
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Falling', 
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
                 Name = 'Landing', 
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