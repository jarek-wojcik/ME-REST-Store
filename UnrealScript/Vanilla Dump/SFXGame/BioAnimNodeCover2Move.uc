Class BioAnimNodeCover2Move extends AnimNodeBlendList
    native;

enum EBioAnimNodeCover2Move
{
    eBioAnimNodeCover2Move_Idle,
    eBioAnimNodeCover2Move_Move,
};

var(BioAnimNodeCover2Move) const float Idle2MoveBlendDuration;
var(BioAnimNodeCover2Move) const float Move2IdleBlendDuration;
var transient BioAnimCheckBlendOut BlendOut;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Idle2MoveBlendDuration = 0.200000003
    Move2IdleBlendDuration = 0.200000003
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
                 Name = 'Move', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
    bFixNumChildren = TRUE
    NodeName = 'BioAnimNodeCover2Move'
}