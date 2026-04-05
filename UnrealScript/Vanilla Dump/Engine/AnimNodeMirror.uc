Class AnimNodeMirror extends AnimNodeBlendBase
    native;

var(AnimNodeMirror) bool bEnableMirroring;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bEnableMirroring = TRUE
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Child', 
                 Weight = 1.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
    bFixNumChildren = TRUE
}