Class BioSeqAct_ShowChoiceGUI extends BioSequenceLatentAction
    native;

var Name m_nmTag;
var Name m_nmResource;
var stringref m_srTitle;
var stringref m_srSubTitle;
var stringref m_srAButton;
var stringref m_srBButton;
var stringref m_srOptionalPaneTitleText;
var stringref m_srOptionalPaneItemValuePrefixText;
var transient int m_nSelectionIndex;
var transient BioSFHandler_ChoiceGUI m_ChoiceGUIHandler;
var transient int m_nSelectionID;
var transient int m_nInitialSelectionID;
var bool m_ShowOptionalPane;
var(BioSeqAct_ShowChoiceGUI) bool m_bAutoClose;
var transient bool m_bFinished;
var transient bool m_bAborted;
var transient bool m_bAPressed;
var transient bool m_bWasPaused;
var EInventoryResourceTypes m_eResource;

public final function ChoiceGUIInputPressed(bool bAPressed, int nContext)
{
    local SFXGameChoiceGUIData oData;
    local int nChoiceID;
    
    m_bFinished = TRUE;
    m_bAPressed = bAPressed;
    m_nSelectionIndex = nContext;
    SetIntVars("SelectionIndex", nContext);
    nChoiceID = -1;
    if (VariableLinks[0].LinkedVariables.Length > 0)
    {
        oData = BioSeqVar_ChoiceGUIData(VariableLinks[0].LinkedVariables[0]).m_ChoiceData;
        if (oData != None)
        {
            if (nContext >= 0 && nContext < oData.lstChoices.Length)
            {
                nChoiceID = oData.lstChoices[nContext].nChoiceID;
            }
        }
    }
    SetIntVars("SelectionID", nChoiceID);
    GetWorldInfo().bPlayersOnly = m_bWasPaused;
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 5;
}
public function bool UpdateOp(float fDeltaT)
{
    local BioPlayerController PC;
    local BioWorldInfo WorldInfo;
    
    if (m_bAborted)
    {
        m_bFinished = FALSE;
        if (OutputLinks.Length > 2)
        {
            OutputLinks[2].bHasImpulse = TRUE;
        }
        m_bAborted = FALSE;
        return TRUE;
    }
    if (m_bFinished)
    {
        m_bFinished = FALSE;
        if (m_ChoiceGUIHandler != None)
        {
            if (m_bAutoClose)
            {
                m_ChoiceGUIHandler.HideChoiceGUI(TRUE);
                WorldInfo = BioWorldInfo(GetWorldInfo());
                if (WorldInfo != None)
                {
                    PC = WorldInfo.GetLocalPlayerController();
                    if (PC != None)
                    {
                        PC.GameModeManager2.DisableMode(9, 'ChoiceGUI');
                    }
                }
            }
            m_ChoiceGUIHandler = None;
        }
        if (m_bAPressed)
        {
            OutputLinks[0].bHasImpulse = TRUE;
        }
        else
        {
            OutputLinks[1].bHasImpulse = TRUE;
        }
        return TRUE;
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_nmTag = 'ChoiceGUI'
    m_bAutoClose = TRUE
    bHasTargets = FALSE
    bCallHandler = FALSE
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "A Pressed", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "B Pressed", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Aborted", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "ChoiceGUIData", 
                      ExpectedType = Class'BioSeqVar_ChoiceGUIData', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Title", 
                      ExpectedType = Class'BioSeqVar_StrRef', 
                      LinkVar = 'None', 
                      PropertyName = 'm_srTitle', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "SubTitle", 
                      ExpectedType = Class'BioSeqVar_StrRef', 
                      LinkVar = 'None', 
                      PropertyName = 'm_srSubTitle', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "AText", 
                      ExpectedType = Class'BioSeqVar_StrRef', 
                      LinkVar = 'None', 
                      PropertyName = 'm_srAButton', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "BText", 
                      ExpectedType = Class'BioSeqVar_StrRef', 
                      LinkVar = 'None', 
                      PropertyName = 'm_srBButton', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "ShowOptionalPane", 
                      ExpectedType = Class'SeqVar_Bool', 
                      LinkVar = 'None', 
                      PropertyName = 'm_ShowOptionalPane', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "OptionalPaneTitleText", 
                      ExpectedType = Class'BioSeqVar_StrRef', 
                      LinkVar = 'None', 
                      PropertyName = 'm_srOptionalPaneTitleText', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "OptionalPaneItemValuePrefixText", 
                      ExpectedType = Class'BioSeqVar_StrRef', 
                      LinkVar = 'None', 
                      PropertyName = 'm_srOptionalPaneItemValuePrefixText', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "OptionalPaneValuePrefixText", 
                      ExpectedType = Class'BioSeqVar_StrRef', 
                      LinkVar = 'None', 
                      PropertyName = 'm_srOptionalPaneValuePrefixText', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "nOptionalPaneValue", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'm_nOptionalPaneValue', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Required Resource", 
                      ExpectedType = Class'SeqVar_Name', 
                      LinkVar = 'None', 
                      PropertyName = 'm_nmResource', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Default SelectionID", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'm_nInitialSelectionID', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "SelectionIndex", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'm_nSelectionIndex', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "SelectionID", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'm_nSelectionID', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
    bManualHandleOutputs = TRUE
}