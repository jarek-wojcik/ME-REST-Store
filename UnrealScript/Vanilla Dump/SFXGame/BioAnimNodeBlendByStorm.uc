Class BioAnimNodeBlendByStorm extends AnimNodeBlendList
    native;

enum EBioAnimNodeBlendByStorm
{
    eBioAnimNodeBlendByStorm_Idle,
    eBioAnimNodeBlendByStorm_Storm,
};

var(BioAnimNodeBlendByStorm) const float Idle2StormBlendDuration;
var(BioAnimNodeBlendByStorm) const float Storm2IdleBlendDuration;
var transient BioAnimMovementSync MovementSync;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Idle2StormBlendDuration = 0.200000003
    Storm2IdleBlendDuration = 0.200000003
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Idle', 
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
                 Name = 'Storm', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
    bFixNumChildren = TRUE
    NodeName = 'BioAnimNodeBlendByStorm'
}