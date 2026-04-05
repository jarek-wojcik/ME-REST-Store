Class SFSBotManagerChoiceUI extends SFSManager within SFXPawn;

var BioSFHandler_ChoiceGUI m_ChoiceGUI;
var string sfsUICommand;

public event simulated function HandlePostAdd()
{
    local BioPlayerController PC;
    local BioPlayerInput BPI;
    
    PC = BioPlayerController(Outer.Controller);
    BPI = BioPlayerInput(PC.PlayerInput);
    if (BPI.bUsingGamepad)
    {
        log(Self.Name, "Using a Gamepad", Outer);
        Class'SFSInputUtility'.static.SetXboxKeyBindInternal(BPI, 'XboxTypeS_Back', sfsUICommand);
    }
    else
    {
        log(Self.Name, "Using KB/M", Outer);
        Class'SFSInputUtility'.static.SetPCKeyBindInternal(BPI, 'Z', sfsUICommand, FALSE, FALSE, FALSE);
    }
}
public function ShowBotChoiceGui()
{
    local SFXGUIInteraction GUIManager;
    local BioPlayerController PC;
    local SFXGameChoiceGUIData Data;
    local SFXChoiceEntry Entry;
    
    // Get the player controller
    PC = BioPlayerController(Outer.Controller);
    if (PC == None)
    {
        return;
    }
    // Create the ChoiceGUI
    GUIManager = Class'SFXGUIInteraction'.static.GetInstance();
    m_ChoiceGUI = GUIManager.CreateChoiceGUI('ChoiceGUI', PC, TRUE);
    if (m_ChoiceGUI == None)
    {
        log(Self.Name, "Test Choice GUI is none", Outer);
        return;
    }
    // Hide MPHUD
    log(Self.Name, "Hiding MPHUD", Outer);
    PC.myHUD.bShowHUD = FALSE;
    PC.myHUD.bShowGameHUD = FALSE;
    // Disable player input (movement, looking, and buttons)
    PC.IgnoreMoveInput(TRUE);
    PC.IgnoreLookInput(TRUE);
    // Create the data object
    Data = new (m_ChoiceGUI) Class'SFXGameChoiceGUIData';
    // Option 1
    Entry.sChoiceName = "Jack";
    Entry.sChoiceTitle = "Jack";
    Entry.sChoiceDescription = "This is the first option";
    Entry.nChoiceID = 0;
    Entry.bDefaultSelection = TRUE;
    Data.AddChoice(Entry);
    // Option 2
    Entry.sChoiceName = "Garrus";
    Entry.sChoiceTitle = "Garrus";
    Entry.sChoiceDescription = "This is the second option";
    Entry.nChoiceID = 1;
    Entry.bDefaultSelection = FALSE;
    Data.AddChoice(Entry);
    // Option 3
    Entry.sChoiceName = "Wrex";
    Entry.sChoiceTitle = "Wrex";
    Entry.sChoiceDescription = "This is the third option";
    Entry.nChoiceID = 2;
    Data.AddChoice(Entry);
    // Option 4
    Entry.sChoiceName = "Tali";
    Entry.sChoiceTitle = "Tali";
    Entry.sChoiceDescription = "This is the fourth option";
    Entry.nChoiceID = 3;
    Data.AddChoice(Entry);
    // Set up the callback
    m_ChoiceGUI.SetInputDelegate(OnChoiceSelected);
    // Initialize and show
    m_ChoiceGUI.Initialize(Data);
    m_ChoiceGUI.ShowChoiceGUI();
    // Capture all input (prevents shooting on click)
    m_ChoiceGUI.SetFocus(TRUE);
}
public function OnChoiceSelected(bool bAPressed, int nContext)
{
    local BioPlayerController PC;
    
    // bAPressed = TRUE means user confirmed selection (A button / Enter)
    // bAPressed = FALSE means user cancelled (B button / Escape)
    // nContext = index of the selected option (0-3)
    if (bAPressed)
    {
        log(Self.Name, "User selected option:" @ nContext, Outer);
    }
    else
    {
        log(Self.Name, "User cancelled the menu", Outer);
    }
    // Re-enable player input
    PC = BioPlayerController(Outer.Controller);
    if (PC != None)
    {
        PC.IgnoreMoveInput(FALSE);
        PC.IgnoreLookInput(FALSE);
        // Restore MPHUD visibility
        PC.myHUD.bShowHUD = TRUE;
        PC.myHUD.bShowGameHUD = TRUE;
    }
    // Hide and clean up
    if (m_ChoiceGUI != None)
    {
        m_ChoiceGUI.HideChoiceGUI(TRUE);
        m_ChoiceGUI = None;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    sfsUICommand = "sendtoconsole showSFSUI"
}