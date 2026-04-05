Class SFXGUI_MainMenu_RightComputer
    native
    config(UI);

var config array<SFXOnlineConnection_MessageType> MessagePriorities;
var array<SFXGUI_MainMenu_Message> Messages;
var array<SFXGUI_MainMenu_Message> TickerMessages;
var config array<stringref> DisconnectedTickerMessages;
var delegate<OnComputerDisplayRegistered> __OnComputerDisplayRegistered__Delegate;
var delegate<OnConnectButtonExecuted> __OnConnectButtonExecuted__Delegate;
var int nNextMessageID;
var SFXGUI_MainMenu_RTT_RC ComputerDisplay;
var int nCurrentlySelectedMessageIndex;
var int nLastTickerMessageIDDisplayed;
var int nCurrentlyDisplayedTickerMessageIndex;
var config int MaxNumberOfImages;
var bool bComputerOpen;

public final function ClearNotifications(optional array<SFXOnlineConnection_MessageType> MessageTypesToClear)
{
    local SFXGUI_MainMenu_Message oMessage;
    local SFXOnlineConnection_MessageType aType;
    local array<SFXGUI_MainMenu_Message> MessagesToRemove;
    
    if (MessageTypesToClear.Length == 0)
    {
        foreach Messages(oMessage, )
        {
            MessagesToRemove.AddItem(oMessage);
        }
        foreach TickerMessages(oMessage, )
        {
            MessagesToRemove.AddItem(oMessage);
        }
        Messages.Length = 0;
        TickerMessages.Length = 0;
    }
    else
    {
        foreach MessageTypesToClear(aType, )
        {
            foreach Messages(oMessage, )
            {
                if (int(oMessage.MessageType) == int(aType))
                {
                    MessagesToRemove.AddItem(oMessage);
                }
            }
            foreach TickerMessages(oMessage, )
            {
                if (int(oMessage.MessageType) == int(aType))
                {
                    MessagesToRemove.AddItem(oMessage);
                }
            }
        }
    }
    foreach MessagesToRemove(oMessage, )
    {
        oMessage.Cleanup();
        Messages.RemoveItem(oMessage);
        TickerMessages.RemoveItem(oMessage);
    }
    nLastTickerMessageIDDisplayed = 0;
    nCurrentlyDisplayedTickerMessageIndex = 0;
    SyncronizeGameAndGFxMessages();
}
public final native function string GetLocalizedNewsItemCount(int nCurrentlySelectedIndex);

public delegate function OnComputerDisplayRegistered();

public delegate function OnConnectButtonExecuted();

public final event function OnResortMessages()
{
    SyncronizeGameAndGFxMessages();
}
public final native function ResortMessages();

public final native function ResortTickerMessages();

public final function int FindIndex(SFXGUI_MainMenu_Message oMessageToFind)
{
    local int nIndex;
    
    for (nIndex = 0; nIndex < Messages.Length; nIndex++)
    {
        if (Messages[nIndex] == oMessageToFind)
        {
            return nIndex;
        }
    }
    return -1;
}
public final function AddDisconnectedTickerMessages()
{
    local stringref oMessage;
    
    foreach DisconnectedTickerMessages(oMessage, )
    {
        AddTickerMessage(7, Class'SFXGUIMovie'.static.GetUIString(oMessage), -1, -1);
    }
}
public final function AddDownloadPromtMessageItem(string i_sTitle, string i_sInfo, string i_sImage, SFXOnlineConnection_MessageType Type, int nDLC_ID, int ServerID)
{
    local SFXGUI_MainMenu_Message_Image NewMessage;
    local SFXGUI_MainMenu_Message_Image ExistingMessage;
    
    if (ComputerDisplay != None)
    {
        ExistingMessage = SFXGUI_MainMenu_Message_Image(FindMessageByServerId(ServerID));
        if (ExistingMessage == None)
        {
            NewMessage = SFXGUI_MainMenu_Message_Image(Class'SFXGUI_MainMenu_Message_NetworkImage'.static.CreateMessage(GetNextMessageID()));
            NewMessage.Title = i_sTitle;
            NewMessage.Message = i_sInfo;
            NewMessage.ImagePath = i_sImage;
            NewMessage.MessageType = Type;
            NewMessage.DLC_ID = nDLC_ID;
            NewMessage.ServerID = ServerID;
            Messages.AddItem(NewMessage);
            ComputerDisplay.AddImageMessage(NewMessage);
            ResortMessages();
            AddTickerMessageInternal(NewMessage);
        }
        else
        {
            ExistingMessage.Title = i_sTitle;
            ExistingMessage.Message = i_sInfo;
            ExistingMessage.ImagePath = i_sImage;
            ExistingMessage.DLC_ID = nDLC_ID;
            ComputerDisplay.UpdateImageMessage(ExistingMessage);
        }
    }
}
public final function AddGalaxyAtWarMessage()
{
    local SFXGUI_MainMenu_Message_GAW NewMessage;
    
    if (ComputerDisplay != None)
    {
        NewMessage = SFXGUI_MainMenu_Message_GAW(Class'SFXGUI_MainMenu_Message_GAW'.static.CreateMessage(GetNextMessageID()));
        Messages.AddItem(NewMessage);
        ComputerDisplay.AddGalaxyAtWarMessage(NewMessage);
        ResortMessages();
    }
}
public final function AddNetworkImageMessage(string i_sTitle, string i_sInfo, string i_sImagePath, SFXOnlineConnection_MessageType Type, int nDLC_ID, int ServerID)
{
    local SFXGUI_MainMenu_Message_Image NewMessage;
    local SFXGUI_MainMenu_Message_Image ExistingMessage;
    
    if (ComputerDisplay != None)
    {
        ExistingMessage = SFXGUI_MainMenu_Message_Image(FindMessageByServerId(ServerID));
        if (ExistingMessage == None)
        {
            NewMessage = SFXGUI_MainMenu_Message_Image(Class'SFXGUI_MainMenu_Message_NetworkImage'.static.CreateMessage(GetNextMessageID()));
            NewMessage.Title = i_sTitle;
            NewMessage.Message = i_sInfo;
            NewMessage.ImagePath = i_sImagePath;
            NewMessage.MessageType = Type;
            NewMessage.DLC_ID = nDLC_ID;
            NewMessage.ServerID = ServerID;
            Messages.AddItem(NewMessage);
            ComputerDisplay.AddImageMessage(NewMessage);
            ResortMessages();
        }
        else
        {
            ExistingMessage.Title = i_sTitle;
            ExistingMessage.Message = i_sInfo;
            ExistingMessage.ImagePath = i_sImagePath;
            ExistingMessage.DLC_ID = nDLC_ID;
            ComputerDisplay.UpdateImageMessage(ExistingMessage);
        }
    }
}
public final function AddTickerMessage(SFXOnlineConnection_MessageType Type, string i_sMessage, int nDLC_ID, int ServerID)
{
    local SFXGUI_MainMenu_Message_Text NewMessage;
    local SFXGUI_MainMenu_Message_Text ExistingMessage;
    
    if (ComputerDisplay != None)
    {
        ExistingMessage = SFXGUI_MainMenu_Message_Text(FindTickerMessageByServerId(ServerID));
        if (ExistingMessage == None)
        {
            NewMessage = SFXGUI_MainMenu_Message_Text(Class'SFXGUI_MainMenu_Message_Text'.static.CreateMessage(GetNextMessageID()));
            NewMessage.Message = i_sMessage;
            NewMessage.MessageType = Type;
            NewMessage.DLC_ID = nDLC_ID;
            NewMessage.ServerID = ServerID;
            AddTickerMessageInternal(NewMessage);
        }
        else
        {
            ExistingMessage.Message = i_sMessage;
            ExistingMessage.DLC_ID = nDLC_ID;
        }
    }
}
protected final function AddTickerMessageInternal(SFXGUI_MainMenu_Message_Text aTickerMessage)
{
    TickerMessages.AddItem(aTickerMessage);
    ResortTickerMessages();
    StartMessageTicker();
}
public final function bool CanLoadImages()
{
    return CountImageMessagesThatAreLoading() <= MaxNumberOfImages;
}
public final function ClearDisconnectedTickerMessages()
{
    local array<SFXOnlineConnection_MessageType> MessageTypesToClear;
    
    MessageTypesToClear.AddItem(7);
    ClearNotifications(MessageTypesToClear);
}
public final function CloseComputer()
{
    BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController().CauseEvent('CloseRightComputer');
    bComputerOpen = FALSE;
    StartMessageTicker();
}
public final function int CountImageMessagesThatAreLoading()
{
    local SFXGUI_MainMenu_Message oMessage;
    local int nCount;
    
    nCount = 0;
    foreach Messages(oMessage, )
    {
        if (SFXGUI_MainMenu_Message_Image(oMessage) != None)
        {
            if (int(oMessage.GetStatus()) != 0)
            {
                nCount++;
            }
        }
    }
    return nCount;
}
public final function FailImageAssets()
{
    local SFXGUI_MainMenu_Message oMessage;
    local SFXGUI_MainMenu_Message_Image oImageMessage;
    
    foreach Messages(oMessage, )
    {
        oImageMessage = SFXGUI_MainMenu_Message_Image(oMessage);
        if (oImageMessage != None)
        {
            oImageMessage.FailLoad();
        }
    }
}
public final function SFXGUI_MainMenu_Message FindMessage(int nID)
{
    local SFXGUI_MainMenu_Message oMessage;
    
    foreach Messages(oMessage, )
    {
        if (oMessage.Id == nID)
        {
            return oMessage;
        }
    }
    return None;
}
public final function SFXGUI_MainMenu_Message FindMessageByServerId(int nServerID)
{
    local SFXGUI_MainMenu_Message oMessage;
    
    foreach Messages(oMessage, )
    {
        if (oMessage.ServerID == nServerID)
        {
            return oMessage;
        }
    }
    return None;
}
public final function SFXGUI_MainMenu_Message FindTickerMessageByServerId(int nServerID)
{
    local SFXGUI_MainMenu_Message oMessage;
    
    foreach TickerMessages(oMessage, )
    {
        if (oMessage.ServerID == nServerID)
        {
            return oMessage;
        }
    }
    return None;
}
public final function SFXGUI_MainMenu_RTT_RC GetDisplayComputer()
{
    return ComputerDisplay;
}
public final function int GetNextMessageID()
{
    nNextMessageID = nNextMessageID + 1;
    return nNextMessageID;
}
public final function string GetNextTickerMessage()
{
    local SFXGUI_MainMenu_Message NextMessage;
    local int nConsiderMessageIndex;
    local int nStartIndex;
    local bool bIsDisplayableDLCPrompt;
    local bool bIsSameMessage;
    local bool bDone;
    local string Result;
    
    bDone = FALSE;
    Result = "";
    nStartIndex = nCurrentlyDisplayedTickerMessageIndex;
    if (nStartIndex >= TickerMessages.Length)
    {
        nStartIndex = 0;
    }
    nConsiderMessageIndex = nStartIndex + 1;
    while (!bDone && TickerMessages.Length > 0)
    {
        if (nConsiderMessageIndex >= TickerMessages.Length)
        {
            nConsiderMessageIndex = 0;
        }
        NextMessage = TickerMessages[nConsiderMessageIndex];
        bIsSameMessage = NextMessage.Id == nLastTickerMessageIDDisplayed;
        bIsDisplayableDLCPrompt = NextMessage.MessageType == SFXOnlineConnection_MessageType.SFXONLINE_MT_DOWNLOAD_PROMPT && !bComputerOpen;
        Result = NextMessage.Message;
        nLastTickerMessageIDDisplayed = NextMessage.Id;
        if (nStartIndex == nConsiderMessageIndex || !bIsSameMessage && (bIsDisplayableDLCPrompt || NextMessage.MessageType != SFXOnlineConnection_MessageType.SFXONLINE_MT_DOWNLOAD_PROMPT))
        {
            bDone = TRUE;
            continue;
        }
        nConsiderMessageIndex++;
    }
    nCurrentlyDisplayedTickerMessageIndex = nConsiderMessageIndex;
    return Result;
}
public final function bool IsComputerOpen()
{
    return bComputerOpen;
}
public final function LoadPendingMessageData()
{
    local SFXGUI_MainMenu_Message oMessage;
    local SFXGUI_MainMenu_Message_Image oImageMessage;
    
    foreach Messages(oMessage, )
    {
        if (int(oMessage.GetStatus()) == 0)
        {
            oImageMessage = SFXGUI_MainMenu_Message_Image(oMessage);
            if (oImageMessage != None)
            {
                if (CanLoadImages())
                {
                    oImageMessage.Load(OnImageMessageDataLoaded);
                }
                else
                {
                    oImageMessage.FailLoad();
                }
            }
            else
            {
                oMessage.Load();
            }
        }
    }
}
public final function MessageAboutToDisplay(int nMessageId, int nArrayIndexLocation)
{
    local SFXGUI_MainMenu_Message oMessage;
    local SFXGUI_MainMenu_Message_Image anImageMessage;
    
    oMessage = FindMessage(nMessageId);
    nCurrentlySelectedMessageIndex = nArrayIndexLocation;
    if (oMessage != None)
    {
        oMessage.OnDisplayed();
        anImageMessage = SFXGUI_MainMenu_Message_Image(oMessage);
        if (anImageMessage != None)
        {
            SetImageForMessage(anImageMessage);
        }
        if (ComputerDisplay != None)
        {
            ComputerDisplay.AS_DisplayPendingMessage();
        }
        UpdateNavigationButtons();
    }
}
public final function NextMessage()
{
    if (ComputerDisplay != None)
    {
        ComputerDisplay.AS_NextMessage();
    }
}
public function OnConnectButton()
{
    if (__OnConnectButtonExecuted__Delegate != None)
    {
        __OnConnectButtonExecuted__Delegate();
    }
}
public final function OnGFXClassLoaded(int nID)
{
    local SFXGUI_MainMenu_Message oMessage;
    
    oMessage = FindMessage(nID);
    if (oMessage != None)
    {
        oMessage.bGFxClassLoaded = TRUE;
    }
}
public final function OnImageMessageDataLoaded(SFXGUI_MainMenu_Message oMessageThatFinishedLoading)
{
    if (FindIndex(oMessageThatFinishedLoading) == nCurrentlySelectedMessageIndex)
    {
        SetImageForMessage(SFXGUI_MainMenu_Message_Image(oMessageThatFinishedLoading));
    }
}
public final function OnShutdown()
{
    ClearNotifications();
    __OnComputerDisplayRegistered__Delegate = None;
    __OnConnectButtonExecuted__Delegate = None;
    ComputerDisplay = None;
}
public final function OpenComputer()
{
    BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController().CauseEvent('OpenRightComputer');
    bComputerOpen = TRUE;
}
public final function OutputMessages()
{
    local SFXGUI_MainMenu_Message oMessage;
    
    foreach Messages(oMessage, )
    {
    }
    foreach TickerMessages(oMessage, )
    {
    }
}
public final function PrevMessage()
{
    if (ComputerDisplay != None)
    {
        ComputerDisplay.AS_PrevMessage();
    }
}
public final function SetConnectButtonState(string sMessage, optional bool bVisible = TRUE)
{
    if (ComputerDisplay != None)
    {
        ComputerDisplay.AS_SetConnectButtonState(sMessage, bVisible);
    }
}
public final function SetDisplayComputer(SFXGUI_MainMenu_RTT_RC oRC)
{
    ComputerDisplay = oRC;
    if (ComputerDisplay != None)
    {
        ComputerDisplay.ExternalInterface = Self;
        if (__OnComputerDisplayRegistered__Delegate != None)
        {
            __OnComputerDisplayRegistered__Delegate();
        }
    }
}
public final function SetImageForMessage(SFXGUI_MainMenu_Message_Image anImageMessage)
{
    if (anImageMessage != None && ComputerDisplay != None)
    {
        if (anImageMessage.ImageReference != None)
        {
            ComputerDisplay.SetExternalTexture(ComputerDisplay.ReplacementTextureSymbol, anImageMessage.ImageReference);
        }
    }
}
public final function StartMessageTicker()
{
    if (TickerMessages.Length == 1)
    {
        ComputerDisplay.AS_SetRepeatingText(GetNextTickerMessage());
    }
}
public final function SyncronizeGameAndGFxMessages()
{
    local SFXGUI_MainMenu_Message oMessage;
    local array<int> OrderedMessageIds;
    
    foreach Messages(oMessage, )
    {
        OrderedMessageIds.AddItem(oMessage.Id);
    }
    if (ComputerDisplay != None)
    {
        nCurrentlySelectedMessageIndex = ComputerDisplay.AS_SynchMessageArrays(OrderedMessageIds);
    }
    UpdateNavigationButtons();
}
public final function UpdateNavigationButtons()
{
    if (ComputerDisplay != None)
    {
        if (Messages.Length <= 1)
        {
            ComputerDisplay.AS_SetPrevButtonVisible(FALSE);
            ComputerDisplay.AS_SetNextButtonVisible(FALSE);
        }
        else
        {
            ComputerDisplay.AS_SetPrevButtonVisible(nCurrentlySelectedMessageIndex != 0);
            ComputerDisplay.AS_SetNextButtonVisible(nCurrentlySelectedMessageIndex != Messages.Length - 1);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MessagePriorities = (SFXOnlineConnection_MessageType.SFXONLINE_MT_GAW_SUMMARY, 
                         SFXOnlineConnection_MessageType.SFXONLINE_MT_DOWNLOAD_PROMPT, 
                         SFXOnlineConnection_MessageType.SFXONLINE_MT_GAW_STATUS_UPDATE, 
                         SFXOnlineConnection_MessageType.SFXONLINE_MT_MESSAGEOFTHEDAY, 
                         SFXOnlineConnection_MessageType.SFXONLINE_MT_FRIEND_LEADERBOARD_RANK_CHANGE, 
                         SFXOnlineConnection_MessageType.SFXONLINE_MT_FRIEND_ACHIVEMENT, 
                         SFXOnlineConnection_MessageType.SFXONLINE_MT_MESSAGEOFTHEDAY_TICKERONLY, 
                         SFXOnlineConnection_MessageType.SFXONLINE_MT_DISCONNECTED_TICKERONLY
                        )
    MaxNumberOfImages = 15
}