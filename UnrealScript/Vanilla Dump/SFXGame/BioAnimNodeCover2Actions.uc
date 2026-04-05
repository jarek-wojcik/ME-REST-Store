Class BioAnimNodeCover2Actions extends AnimNodeBlendList
    native;

enum EBioAnimNodeCover2Actions
{
    eBioAnimNodeCover2Actions_Default,
    eBioAnimNodeCover2Actions_Lean,
    eBioAnimNodeCover2Actions_PopUp,
    eBioAnimNodeCover2Actions_PeekSide,
    eBioAnimNodeCover2Actions_PeekUp,
    eBioAnimNodeCover2Actions_PartialLean,
    eBioAnimNodeCover2Actions_PartialPopUp,
    eBioAnimNodeCover2Actions_Aimback,
};

var(BioAnimNodeCover2Actions) const float Default2LeanBlendDuration;
var(BioAnimNodeCover2Actions) const float Lean2DefaultBlendDuration;
var(BioAnimNodeCover2Actions) const float Default2PopupBlendDuration;
var(BioAnimNodeCover2Actions) const float Popup2DefaultBlendDuration;
var(BioAnimNodeCover2Actions) const float Default2PeekBlendDuration;
var(BioAnimNodeCover2Actions) const float Peek2DefaultBlendDuration;
var(BioAnimNodeCover2Actions) const float Default2PartialLeanBlendDuration;
var(BioAnimNodeCover2Actions) const float PartialLean2DefaultBlendDuration;
var(BioAnimNodeCover2Actions) const float Default2PartialPopUpBlendDuration;
var(BioAnimNodeCover2Actions) const float PartialPopUp2DefaultBlendDuration;
var(BioAnimNodeCover2Actions) const float Default2AimbackBlendDuration;
var(BioAnimNodeCover2Actions) const float Aimback2DefaultBlendDuration;
var transient BioAnimCheckBlendOut BlendOut;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Default2LeanBlendDuration = 0.200000003
    Lean2DefaultBlendDuration = 0.200000003
    Default2PopupBlendDuration = 0.200000003
    Popup2DefaultBlendDuration = 0.200000003
    Default2PeekBlendDuration = 0.200000003
    Peek2DefaultBlendDuration = 0.200000003
    Default2PartialLeanBlendDuration = 0.200000003
    PartialLean2DefaultBlendDuration = 0.200000003
    Default2PartialPopUpBlendDuration = 0.200000003
    PartialPopUp2DefaultBlendDuration = 0.200000003
    Default2AimbackBlendDuration = 0.200000003
    Aimback2DefaultBlendDuration = 0.200000003
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Default', 
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
                 Name = 'Lean', 
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
                 Name = 'PopUp', 
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
                 Name = 'PeekSide', 
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
                 Name = 'PeekUp', 
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
                 Name = 'PartialLean', 
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
                 Name = 'PartialPopUp', 
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
                 Name = 'Aimback', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
    bFixNumChildren = TRUE
    NodeName = 'BioAnimNodeCover2Actions'
}