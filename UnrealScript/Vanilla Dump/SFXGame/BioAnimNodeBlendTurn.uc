Class BioAnimNodeBlendTurn extends AnimNodeBlendList
    native;

enum EBioAnimNodeBlendTurn
{
    eBioAnimNodeBlendTurn_Idle,
    eBioAnimNodeBlendTurn_TurnLeft,
    eBioAnimNodeBlendTurn_TurnRight,
};

var(BioAnimNodeBlendTurn) const float BlendTime;
var(BioAnimNodeBlendTurn) const float YawTurnTriggerDegrees;
var transient BioAnimCheckBlendOut BlendOut;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BlendTime = 0.200000003
    YawTurnTriggerDegrees = 45.0
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Center', 
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
                 Name = 'TurnLeft', 
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
                 Name = 'TurnRight', 
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