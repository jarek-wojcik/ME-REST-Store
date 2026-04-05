Class BioAnimNodeCover2Transition extends AnimNodeBlendList
    native;

enum EBioAnimNodeCover2Transition
{
    eBioAnimNodeCover2Transition_Intro,
    eBioAnimNodeCover2Transition_Body,
    eBioAnimNodeCover2Transition_Outro,
};

var(BioAnimNodeCover2Transition) const float Intro2BodyBlendDuration;
var(BioAnimNodeCover2Transition) const float Body2OutroBlendDuration;
var(BioAnimNodeCover2Transition) const float Intro2OutroBlendDuration;
var(BioAnimNodeCover2Transition) const float Outro2IntroBlendDuration;
var transient BioAnimCheckBlendOut BlendOut;
var(BioAnimNodeCover2Transition) const bool IntroIsBlocking;
var(BioAnimNodeCover2Transition) const bool OutroIsBlocking;
var(BioAnimNodeCover2Transition) const bool bStopInputOnBlockingTransitions;
var transient bool bRequestedBlendOut;
var transient bool bCanceledBlendOut;
var transient bool bSkipIntro;
var transient bool bBlocking;
var(BioAnimNodeCover2Transition) const ERootMotionMode IntroRootMotionMode;
var(BioAnimNodeCover2Transition) const ERootMotionRotationMode IntroRootRotationMode;
var(BioAnimNodeCover2Transition) const ERootMotionMode OutroRootMotionMode;
var(BioAnimNodeCover2Transition) const ERootMotionRotationMode OutroRootRotationMode;
var transient EBioAnimNodeCover2Transition CurrentState;
var transient ERootMotionMode RootMotionMode;
var transient ERootMotionRotationMode RootRotationMode;

public event function IgnorePlayerInput(BioPawn pPawn, bool bIgnore)
{
    local BioPlayerController pPlayerController;
    
    pPlayerController = BioPlayerController(pPawn.Controller);
    if (pPlayerController != None && bStopInputOnBlockingTransitions)
    {
        pPlayerController.IgnoreMoveInput(bIgnore);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Intro2BodyBlendDuration = 0.200000003
    Body2OutroBlendDuration = 0.200000003
    Intro2OutroBlendDuration = 0.200000003
    Outro2IntroBlendDuration = 0.200000003
    IntroIsBlocking = TRUE
    OutroIsBlocking = TRUE
    bStopInputOnBlockingTransitions = TRUE
    IntroRootMotionMode = ERootMotionMode.RMM_Ignore
    OutroRootMotionMode = ERootMotionMode.RMM_Ignore
    CurrentState = None
    RootMotionMode = ERootMotionMode.RMM_Ignore
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Intro', 
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
                 Name = 'Body', 
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
                 Name = 'Outro', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
    bFixNumChildren = TRUE
    NodeName = 'BioAnimNodeCover2Transition'
}