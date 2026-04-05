Class BioSFHandler_Conversation extends SFXGUIMovieLegacyAdapter
    native
    config(UI);

enum BioConvWheelPositions
{
    REPLY_WHEEL_MIDDLE_RIGHT,
    REPLY_WHEEL_BOTTOM_RIGHT,
    REPLY_WHEEL_BOTTOM_LEFT,
    REPLY_WHEEL_MIDDLE_LEFT,
    REPLY_WHEEL_TOP_LEFT,
    REPLY_WHEEL_TOP_RIGHT,
};
const INVESTIGATE_OPTION = -3;
const RETURN_OPTION = -2;
const UNUSED_SLOT = -1;
const MODE_Illegal = 4;
const MODE_Intimidate = 3;
const MODE_Charm = 2;
const MODE_Investigate = 1;
const MODE_None = 0;

var int m_aReplyLocations[6];
var int m_aInvestigateLocations[6];
var int m_nSlotsUsed[6];
var Vector vInput;
var Name InterruptAppearRenegade;
var Name InterruptDisappearRenegade;
var Name InterruptAppearParagon;
var Name InterruptDisappearParagon;
var config stringref m_srTextInvestigate;
var config stringref m_srTextReturn;
var config int m_nReplyLocationMiddleLeft;
var config int m_nReplyLocationTopLeft;
var config int m_nReplyLocationBottomLeft;
var config int m_nReplyLocationTopRight;
var config int m_nReplyLocationBottomRight;
var config int m_nReplyLocationMiddleRight;
var config int m_nInvestigateLocationMiddleLeft;
var config int m_nInvestigateLocationTopLeft;
var config int m_nInvestigateLocationBottomLeft;
var config int m_nInvestigateLocationTopRight;
var config int m_nInvestigateLocationBottomRight;
var config int m_nInvestigateLocationMiddleRight;
var float fLastRadius;
var transient int m_nLastArrowPosition;
var bool m_bDisplayInvestigateSubMenu;
var bool m_bDisplayingWheel;
var bool m_bDisplayingParagonInterrupt;
var bool m_bDisplayingRenegadeInterrupt;
var bool m_bMonitor16x9Enforcement;
var transient bool m_bWasTriggered;
var transient bool m_bEnforcing16x9;

public final event function AS_Enforce16x9(bool bTrue)
{
    ActionScriptVoid("Enforce16x9");
}
public final event function AS_HideWheel()
{
    ActionScriptVoid("HideWheel");
}
public final event function AS_SetArrowPosition(int nDegrees, bool bNuiSpeechEnabled)
{
    ActionScriptVoid("SetArrowPosition");
}
public final event function AS_SetParagonInterrupt(bool bTurnOn)
{
    ActionScriptVoid("SetParagonInterrupt");
}
public final event function AS_SetRenegadeInterrupt(bool bTurnOn)
{
    ActionScriptVoid("SetRenegadeInterrupt");
}
public event function bool HandleInputEvent(BioGuiEvents Event, optional float fValue = 1.0)
{
    switch (Event)
    {
        case BioGuiEvents.BIOGUI_EVENT_AXIS_LSTICK_X:
            vInput.X = fValue;
            break;
        case BioGuiEvents.BIOGUI_EVENT_AXIS_LSTICK_Y:
            vInput.Y = fValue;
            break;
        default:
            return Super(SFXGUIMovie).HandleInputEvent(Event, fValue);
    }
    return TRUE;
}
public event function bool IsVisible()
{
    return (m_bDisplayingWheel || m_bDisplayInvestigateSubMenu) && GetVisible();
}
public final native function NuiSpeechClearOptions();

public final native function NuiSpeechUpdateOptions(array<stringref> ReplyOptions, array<int> ReplyOptionPositions);

public function OnPanelAdded()
{
    Super.OnPanelAdded();
    m_aReplyLocations[0] = m_nReplyLocationMiddleRight;
    m_aReplyLocations[1] = m_nReplyLocationBottomRight;
    m_aReplyLocations[2] = m_nReplyLocationBottomLeft;
    m_aReplyLocations[3] = m_nReplyLocationMiddleLeft;
    m_aReplyLocations[4] = m_nReplyLocationTopLeft;
    m_aReplyLocations[5] = m_nReplyLocationTopRight;
    m_aInvestigateLocations[0] = m_nInvestigateLocationMiddleRight;
    m_aInvestigateLocations[1] = m_nInvestigateLocationBottomRight;
    m_aInvestigateLocations[2] = m_nInvestigateLocationBottomLeft;
    m_aInvestigateLocations[3] = m_nInvestigateLocationMiddleLeft;
    m_aInvestigateLocations[4] = m_nInvestigateLocationTopLeft;
    m_aInvestigateLocations[5] = m_nInvestigateLocationTopRight;
    oPanel.m_bUseThumbstickAsDPad = FALSE;
    m_bDisplayingRenegadeInterrupt = FALSE;
    m_bDisplayingParagonInterrupt = FALSE;
    oPanel.bIgnoreGCOnPanelCleanup = TRUE;
    oPanel.SetInputDisabled(TRUE);
}
public function OnPanelRemoved()
{
    Super.OnPanelRemoved();
    fLastRadius = 0.0;
    m_bDisplayInvestigateSubMenu = FALSE;
    m_bDisplayingWheel = FALSE;
}
public final event function SelectEntry(int nEntry)
{
    local BioConversationController pConvCont;
    
    pConvCont = oWorldInfo.GetConversationManager().GetFullConversation();
    if (pConvCont == None)
    {
        return;
    }
    if (SelectConversationEntry(byte(nEntry)))
    {
        if (pConvCont.SkipNode() == FALSE)
        {
            PlayGuiSound('ConvError');
        }
    }
}
public final event function SelectInterrupt(bool bParagon)
{
    local BioConversationController pConvCont;
    
    pConvCont = oWorldInfo.GetConversationManager().GetFullConversation();
    if (pConvCont == None)
    {
        return;
    }
    PlayGuiSound(bParagon ? 'InterruptTriggeredParagon' : 'InterruptTriggeredRenegade');
    pConvCont.SelectInterruption();
    m_bWasTriggered = TRUE;
}
public event function SetVisible(bool bVal)
{
    if (!bVal)
    {
        m_bDisplayInvestigateSubMenu = FALSE;
        m_bDisplayingWheel = FALSE;
    }
    Super(SFXGUIMovie).SetVisible(bVal);
}
public final function SkipNode()
{
    local BioConversationController pConvCont;
    
    pConvCont = oWorldInfo.GetConversationManager().GetFullConversation();
    if (pConvCont == None)
    {
        return;
    }
    if (pConvCont.SkipNode() == FALSE)
    {
        PlayGuiSound('ConvError');
    }
}
public final event function UpdateConversationOptions(BioConversationController oConversation)
{
    local stringref ConversationOptionStringRefs[6];
    local string sConversationOptions[6];
    local int nConversationOptionModes[6];
    local BioConvWheelPositions ePosition;
    local int i;
    local int nInvestigateReplyCount;
    local int nInvestigateReplyIteration;
    local int nReplyCategory;
    local stringref srOption;
    local bool bDisplayReply;
    local bool bFirstInvestigateFound;
    local array<stringref> lstNuiStrrefs;
    local array<int> lstNuiWheelPosition;
    
    nInvestigateReplyCount = GetInvestigateReplyCount(oConversation);
    for (i = 0; i < 6; i++)
    {
        m_nSlotsUsed[i] = -1;
    }
    for (i = 0; i < GetNumReplies(oConversation); i++)
    {
        srOption = $0;
        bDisplayReply = FALSE;
        nReplyCategory = oConversation.GetReplyCategory(i);
        if (m_bDisplayInvestigateSubMenu)
        {
            if (nReplyCategory == 5)
            {
                bDisplayReply = TRUE;
            }
        }
        else if (nReplyCategory == 5)
        {
            if (!bFirstInvestigateFound)
            {
                bDisplayReply = TRUE;
                bFirstInvestigateFound = TRUE;
                nInvestigateReplyIteration = 0;
                if (nInvestigateReplyCount > 1)
                {
                    srOption = m_srTextInvestigate;
                }
            }
        }
        else
        {
            bDisplayReply = TRUE;
        }
        if (bDisplayReply)
        {
            ePosition = 6;
            if (m_bDisplayInvestigateSubMenu)
            {
                if (nInvestigateReplyIteration < 0)
                {
                    nInvestigateReplyIteration = 0;
                }
                if (nReplyCategory == 5)
                {
                    nInvestigateReplyIteration++;
                    ePosition = GetInvestigateReplyLocation(nInvestigateReplyIteration);
                }
            }
            else
            {
                ePosition = GetReplyLocation(nReplyCategory);
            }
            if (int(ePosition) != 6)
            {
                if (srOption == 0)
                {
                    ConversationOptionStringRefs[int(ePosition)] = oConversation.GetReplyParaphraseStrref(i);
                    sConversationOptions[int(ePosition)] = oConversation.GetReplyParaphraseText(i);
                    nConversationOptionModes[int(ePosition)] = MapGuiStyleToOptionMode(oConversation.GetReplyGUIStyle(i));
                    m_nSlotsUsed[int(ePosition)] = i;
                    continue;
                }
                ConversationOptionStringRefs[int(ePosition)] = srOption;
                sConversationOptions[int(ePosition)] = string(srOption);
                nConversationOptionModes[int(ePosition)] = 1;
                m_nSlotsUsed[int(ePosition)] = -3;
            }
        }
    }
    if (m_bDisplayInvestigateSubMenu)
    {
        ePosition = GetInvestigateReplyLocation(0);
        if (int(ePosition) != 6)
        {
            ConversationOptionStringRefs[int(ePosition)] = m_srTextReturn;
            sConversationOptions[int(ePosition)] = string(m_srTextReturn);
            m_nSlotsUsed[int(ePosition)] = -2;
        }
    }
    for (i = 0; i < 6; i++)
    {
        if (nConversationOptionModes[i] == 4)
        {
            lstNuiStrrefs.AddItem($0);
        }
        else
        {
            lstNuiStrrefs.AddItem(ConversationOptionStringRefs[i]);
        }
        lstNuiWheelPosition.AddItem(i);
    }
    NuiSpeechUpdateOptions(lstNuiStrrefs, lstNuiWheelPosition);
    AS_SetConversationOptions(sConversationOptions[0], nConversationOptionModes[0], sConversationOptions[1], nConversationOptionModes[1], sConversationOptions[2], nConversationOptionModes[2], sConversationOptions[3], nConversationOptionModes[3], sConversationOptions[4], nConversationOptionModes[4], sConversationOptions[5], nConversationOptionModes[5]);
    m_nLastArrowPosition = -1;
    fLastRadius = -1.0;
}
public final function AS_SetConversationOptions(string sMiddleRight, int nMiddleRightMode, string sBottomRight, int nBottomRightMode, string sBottomLeft, int nBottomLeftMode, string sMiddleLeft, int nMiddleLeftMode, string sTopLeft, int nTopLeftMode, string sTopRight, int nTopRightMode)
{
    ActionScriptVoid("SetConversationOptions");
}
public final function int GetInvestigateReplyCount(BioConversationController oConversation)
{
    local int nCount;
    local int i;
    
    if (oConversation == None)
    {
        return 0;
    }
    nCount = 0;
    for (i = 0; i < GetNumReplies(oConversation); i++)
    {
        if (oConversation.GetReplyCategory(i) == 5)
        {
            nCount++;
        }
    }
    return nCount;
}
public final function BioConvWheelPositions GetInvestigateReplyLocation(int nInvestigateSlot)
{
    local int i;
    local int J;
    
    for (i = nInvestigateSlot; i < 6; i++)
    {
        for (J = 0; J < 6; J++)
        {
            if (m_aInvestigateLocations[J] == i)
            {
                if (m_nSlotsUsed[J] == -1)
                {
                    return byte(J);
                }
                break;
            }
        }
    }
    return 6;
}
public final function int GetNumReplies(BioConversationController oConversation)
{
    return oConversation.m_aCurrentReplyIndices.Length;
}
public final function BioConvWheelPositions GetReplyLocation(int nReplyCategory)
{
    local int i;
    
    for (i = 0; i < 6; i++)
    {
        if (nReplyCategory == m_aReplyLocations[i] || i == 6 - 1)
        {
            if (m_nSlotsUsed[i] == -1)
            {
                return byte(i);
                continue;
            }
            return 6;
        }
    }
    return 6;
}
public function HighlightDefaultConvSegment();

public final function InterruptParagon()
{
    oPanel.InvokeMethod("InteruptParagon");
}
public final function InterruptRenegade()
{
    oPanel.InvokeMethod("InteruptRenegade");
}
public final function int MapGuiStyleToOptionMode(EConvGUIStyles eGUIStyle)
{
    local int nMode;
    
    nMode = 0;
    switch (eGUIStyle)
    {
        case EConvGUIStyles.GUI_STYLE_CHARM:
            nMode = 2;
            break;
        case EConvGUIStyles.GUI_STYLE_INTIMIDATE:
            nMode = 3;
            break;
        case EConvGUIStyles.GUI_STYLE_ILLEGAL:
            nMode = 4;
            break;
        default:
    }
    return nMode;
}
public final function QueueEntry(int nEntry)
{
    SelectConversationEntry(byte(nEntry));
}
public final function bool SelectConversationEntry(BioConvWheelPositions nWheelLocation)
{
    local BioConversationController oConvCont;
    local bool bChangingMenu;
    local int nReplyIndex;
    local string sReason;
    
    NuiSpeechClearOptions();
    oConvCont = oWorldInfo.GetConversationManager().GetFullConversation();
    bChangingMenu = FALSE;
    nReplyIndex = m_nSlotsUsed[int(nWheelLocation)];
    if (nReplyIndex >= 0)
    {
        if (int(oConvCont.GetReplyGUIStyle(nReplyIndex)) == 4)
        {
            PlayGuiSound('ConvError');
            return FALSE;
        }
        m_bDisplayInvestigateSubMenu = FALSE;
        if (oConvCont.QueueReply(nReplyIndex) == FALSE)
        {
            sReason = "QueueReply failed within the conversation wheel GUI";
            oConvCont.m_bInterrupted = TRUE;
            oWorldInfo.GetConversationManager().RemoveConversation(oConvCont, sReason);
        }
    }
    else if (nReplyIndex == -2 && m_bDisplayInvestigateSubMenu)
    {
        m_bDisplayInvestigateSubMenu = FALSE;
        bChangingMenu = TRUE;
    }
    else if (nReplyIndex == -3 && !m_bDisplayInvestigateSubMenu)
    {
        m_bDisplayInvestigateSubMenu = TRUE;
        bChangingMenu = TRUE;
    }
    else
    {
        PlayGuiSound('ConvError');
    }
    if (bChangingMenu)
    {
        UpdateConversationOptions(oConvCont);
    }
    return !bChangingMenu;
}
public final function SelectConversationSegment()
{
    oPanel.InvokeMethod("SelectConversationSegment");
}
public final function ShowReplyWheel()
{
    local BioConversationController pConvCont;
    
    pConvCont = oWorldInfo.GetConversationManager().GetFullConversation();
    if (pConvCont == None)
    {
        return;
    }
    pConvCont.m_bForceShowReplies = TRUE;
}
public final function SkipConversation()
{
    oPanel.InvokeMethod("SelectOrSkipConversation");
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    InterruptAppearRenegade = 'InterruptAppearRenegade'
    InterruptDisappearRenegade = 'InterruptDisappear'
    InterruptAppearParagon = 'InterruptAppearParagon'
    InterruptDisappearParagon = 'InterruptDisappear'
    m_srTextInvestigate = $122746
    m_srTextReturn = $122747
    m_nReplyLocationMiddleLeft = 5
    m_nReplyLocationTopLeft = 3
    m_nReplyLocationBottomLeft = 4
    m_nReplyLocationTopRight = 1
    m_nReplyLocationBottomRight = 2
    m_nInvestigateLocationMiddleLeft = 3
    m_nInvestigateLocationTopLeft = 2
    m_nInvestigateLocationBottomLeft = 1
    m_nInvestigateLocationTopRight = 5
    m_nInvestigateLocationBottomRight = 4
    m_bMonitor16x9Enforcement = TRUE
    bSetGameMode = FALSE
}