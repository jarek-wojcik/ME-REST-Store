Class BioAnim_TurnInPlace_Rotator extends AnimNodeBlendBase
    native;

var const transient array<BioAnimNodeBlend_TurnInPlace> TurnInPlaceNodes;
var const transient BioPawn BioPawnOwner;
var const transient BioAnimNodeBlend_TurnInPlace ActiveTurnInPlaceNode;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Input', 
                 Weight = 1.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
    bFixNumChildren = TRUE
    bSkipTickWhenZeroWeight = TRUE
}