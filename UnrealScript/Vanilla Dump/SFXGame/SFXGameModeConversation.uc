Class SFXGameModeConversation extends SFXGameModeBase within BioPlayerController
    config(Input);

var(SFXGameModeConversation) export BioCameraBehaviorConversation ConversationCam;
var(SFXGameModeConversation) export SFXCameraTransition_GalaxyMap InstantTransition;

public function Activated()
{
    local Actor A;
    local SFXSelectionModule SelMod;
    
    Super.Activated();
    Outer.m_oPlayerSelection.SelectionFlareComp.SetHidden(TRUE);
    foreach BioWorldInfo(Outer.WorldInfo).SelectableActors(A, )
    {
        SelMod = A.GetModule(Class'SFXSelectionModule');
        if (SelMod != None && SelMod.LensFlareComp != None)
        {
            SelMod.LensFlareComp.SetHidden(TRUE);
        }
    }
    RemoveTimeDilationEffects();
}
public function Deactivated()
{
    Super.Deactivated();
}
public function SFXCameraMode HACK_GetCameraMode()
{
    return ConversationCam;
}
public function SFXCameraMode GetCameraMode(SFXCameraMode OldCameraMode, out int PreserveTarget, out float TransitionTime, out SFXCameraMode_Interpolate Transition)
{
    Transition = InstantTransition;
    TransitionTime = 0.0;
    PreserveTarget = 0;
    return ConversationCam;
}
public exec function HighlightDefaultResponse()
{
    local SFXGUIInteraction GuiMan;
    local BioSFHandler_Conversation ConvHandler;
    
    GuiMan = Class'SFXGUIInteraction'.static.GetInstance();
    if (GuiMan != None)
    {
        ConvHandler = GuiMan.GetConversationHandler(Outer);
        if (ConvHandler != None)
        {
            ConvHandler.HighlightDefaultConvSegment();
        }
    }
}
public exec function InterruptParagon()
{
    local SFXGUIInteraction GuiMan;
    local BioSFHandler_Conversation ConvHandler;
    
    GuiMan = Class'SFXGUIInteraction'.static.GetInstance();
    if (GuiMan != None)
    {
        ConvHandler = GuiMan.GetConversationHandler(Outer);
        if (ConvHandler != None)
        {
            ConvHandler.InterruptParagon();
        }
    }
}
public exec function InterruptRenegade()
{
    local SFXGUIInteraction GuiMan;
    local BioSFHandler_Conversation ConvHandler;
    
    GuiMan = Class'SFXGUIInteraction'.static.GetInstance();
    if (GuiMan != None)
    {
        ConvHandler = GuiMan.GetConversationHandler(Outer);
        if (ConvHandler != None)
        {
            ConvHandler.InterruptRenegade();
        }
    }
}
public exec function SelectResponse()
{
    local SFXGUIInteraction GuiMan;
    local BioSFHandler_Conversation ConvHandler;
    
    GuiMan = Class'SFXGUIInteraction'.static.GetInstance();
    if (GuiMan != None)
    {
        ConvHandler = GuiMan.GetConversationHandler(Outer);
        if (ConvHandler != None)
        {
            ConvHandler.SelectConversationSegment();
        }
    }
}
public exec function SkipConversation()
{
    local SFXGUIInteraction GuiMan;
    local BioSFHandler_Conversation ConvHandler;
    
    GuiMan = Class'SFXGUIInteraction'.static.GetInstance();
    if (GuiMan != None)
    {
        ConvHandler = GuiMan.GetConversationHandler(Outer);
        if (ConvHandler != None)
        {
            ConvHandler.SkipConversation();
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioCameraBehaviorConversation Name=ConversationCam0
        CameraName = 'ConversationCam'
    End Object
    Begin Object Class=SFXCameraTransition_GalaxyMap Name=InstantTransition0
    End Object
    ConversationCam = ConversationCam0
    InstantTransition = InstantTransition0
    Bindings = ({
                 Command = "Shared_ConvSelect | Shared_ConvIntRenegade", 
                 Name = 'LeftMouseButton', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PC_ConvHilight | Shared_ConvIntParagon", 
                 Name = 'RightMouseButton', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Shared_ConvSkip", 
                 Name = 'SpaceBar', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }
               )
    bShowSubtitle = TRUE
    bClearPendingFire = TRUE
    bMergeNotifications = TRUE
    bQueueAndSuppressNotifications = TRUE
    bEnforce16x9Subtitles = TRUE
    bRestrictToPrimaryViewport = TRUE
    Priority = EGameModePriority2.ModePriority_Conversation
}