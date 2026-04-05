Class UICalloutButtonPanel extends UIContainer
    native
    placeable
    perobjectconfig
    config(UI);

enum ECalloutButtonLayoutType
{
    CBLT_None,
    CBLT_DockLeft,
    CBLT_DockRight,
    CBLT_Centered,
    CBLT_Justified,
};

var(ZDebug) editconst transient array<UICalloutButton> CalloutButtons;
var config array<Name> CalloutButtonAliases;
var const transient native Object ButtonInputKeyMappings;
var(Appearance) UIScreenValue_Extent ButtonPadding[2];
var(ZDebug) editconst duplicatetransient UICalloutButton ButtonTemplate;
var transient bool bGeneratingInitialButtons;
var(Interaction) bool bSupportsButtonRepeat;
var(ZDebug) transient bool bRefreshButtonDocking;
var(Appearance) EUIOrientation ButtonBarOrientation;
var(Appearance) ECalloutButtonLayoutType ButtonLayout;

public event function AddedChild(UIScreenObject WidgetOwner, UIObject NewChild)
{
    local UICalloutButton ChildButton;
    local int InsertIndex;
    
    Super(UIScreenObject).AddedChild(WidgetOwner, NewChild);
    ChildButton = UICalloutButton(NewChild);
    if (ChildButton != None && WidgetOwner == Self)
    {
        ChildButton.bSupportsButtonRepeat = bSupportsButtonRepeat;
        ChildButton.__NotifyVisibilityChanged__Delegate = OnButtonVisibilityChanged;
        if (!bGeneratingInitialButtons)
        {
            if (CalloutButtons.Find(ChildButton) == -1)
            {
                InsertIndex = FindBestInsertionIndex(ChildButton, FALSE);
                if (InsertIndex == -1)
                {
                    InsertIndex = CalloutButtons.Length;
                }
                CalloutButtons.InsertItem(InsertIndex, ChildButton);
            }
            ConfigureChildButton(ChildButton);
            SynchronizeInputAliases();
        }
    }
}
public event function bool CanButtonAcceptFocus(Name InputAliasTag, optional int PlayerIndex = GetBestPlayerIndex())
{
    local bool bResult;
    local UICalloutButton TargetButton;
    
    TargetButton = FindButton(InputAliasTag);
    if (TargetButton != None)
    {
        bResult = TargetButton.CanAcceptFocus(PlayerIndex);
    }
    return bResult;
}
public event function bool ContainsButton(Name ButtonInputAlias)
{
    local UICalloutButton TargetButton;
    
    TargetButton = FindButton(ButtonInputAlias);
    return TargetButton != None;
}
public native function UICalloutButton CreateCalloutButton(Name ButtonInputAlias, optional Name ButtonName, optional bool bInsertChild = TRUE);

public event function bool EnableButton(Name ButtonInputAlias, optional int PlayerIndex = GetBestPlayerIndex(), optional bool bEnableButton = TRUE, optional bool bUpdateButtonVisibility = TRUE)
{
    local UICalloutButton TargetButton;
    local bool bResult;
    
    TargetButton = FindButton(ButtonInputAlias);
    if (TargetButton != None)
    {
        if (TargetButton.SetEnabled(bEnableButton, PlayerIndex))
        {
            bResult = TRUE;
            if (bUpdateButtonVisibility || bEnableButton)
            {
                TargetButton.SetVisibility(bEnableButton);
            }
        }
    }
    return bResult;
}
public native function int FindBestInsertionIndex(UICalloutButton ButtonToInsert, optional bool bSearchChildrenArray);

public event function UICalloutButton FindButton(Name ButtonInputAlias)
{
    local int ButtonIdx;
    local UICalloutButton Result;
    
    ButtonIdx = FindButtonIndex(ButtonInputAlias);
    if (ButtonIdx >= 0 && ButtonIdx < CalloutButtons.Length)
    {
        Result = CalloutButtons[ButtonIdx];
    }
    return Result;
}
public event function int FindButtonIndex(Name ButtonInputAlias)
{
    local int ButtonIdx;
    local int Result;
    
    Result = -1;
    for (ButtonIdx = 0; ButtonIdx < CalloutButtons.Length; ButtonIdx++)
    {
        if (CalloutButtons[ButtonIdx] != None && CalloutButtons[ButtonIdx].InputAliasTag == ButtonInputAlias && CalloutButtons[ButtonIdx].Outer == Self)
        {
            Result = ButtonIdx;
            break;
        }
    }
    return Result;
}
public final native function GetAvailableCalloutButtonAliases(out array<Name> AvailableAliases, optional LocalPlayer PlayerOwner);

public final native function UIEvent_CalloutButtonInputProxy GetCalloutInputProxy(optional bool bCreateIfNecessary);

public event function int InsertButton(UICalloutButton NewButton)
{
    local int Result;
    local int InsertIndex;
    
    Result = -1;
    if (NewButton != None && NewButton.InputAliasTag != 'None')
    {
        if (ContainsButton(NewButton.InputAliasTag))
        {
        }
        else
        {
            InsertIndex = FindBestInsertionIndex(NewButton, TRUE);
            Result = InsertChild(NewButton, InsertIndex);
        }
    }
    else if (NewButton == None)
    {
    }
    return Result;
}
public event function PostInitialize()
{
    Super(UIScreenObject).PostInitialize();
    bGeneratingInitialButtons = TRUE;
    PopulateCalloutButtonArray();
    bGeneratingInitialButtons = FALSE;
    RequestButtonDockingUpdate();
    InitializeInputProxy();
}
public event function bool RemoveAllButtons()
{
    RemoveChildren(CalloutButtons);
    return CalloutButtons.Length == 0;
}
public event function bool RemoveButton(UICalloutButton ButtonToRemove)
{
    local bool bResult;
    
    if (ButtonToRemove != None && ContainsButton(ButtonToRemove.InputAliasTag))
    {
        bResult = RemoveChild(ButtonToRemove);
    }
    return bResult;
}
public event function bool RemoveButtonByAlias(Name ButtonInputAlias)
{
    local UICalloutButton TargetButton;
    local bool bResult;
    
    TargetButton = FindButton(ButtonInputAlias);
    if (TargetButton != None)
    {
        bResult = RemoveChild(TargetButton);
    }
    return bResult;
}
public event function RemovedChild(UIScreenObject WidgetOwner, UIObject OldChild, optional array<UIObject> ExclusionSet)
{
    local UICalloutButton ChildButton;
    
    Super(UIScreenObject).RemovedChild(WidgetOwner, OldChild, ExclusionSet);
    ChildButton = UICalloutButton(OldChild);
    if (ChildButton != None)
    {
        ChildButton.__NotifyVisibilityChanged__Delegate = None;
        CalloutButtons.RemoveItem(ChildButton);
        SynchronizeInputAliases();
    }
    RequestButtonDockingUpdate();
}
public event function RemovedFromParent(UIScreenObject WidgetOwner)
{
    local UISequence ProxyParentSequence;
    local UIEvent_CalloutButtonInputProxy InputProxy;
    local int ButtonIdx;
    
    Super(UIScreenObject).RemovedFromParent(WidgetOwner);
    InputProxy = GetCalloutInputProxy(FALSE);
    if (InputProxy != None)
    {
        for (ButtonIdx = 0; ButtonIdx < CalloutButtons.Length; ButtonIdx++)
        {
            if (CalloutButtons[ButtonIdx] != None)
            {
                CalloutButtons[ButtonIdx].UnsubscribeFromInputProxy(InputProxy);
            }
        }
        ProxyParentSequence = UISequence(InputProxy.ParentSequence);
        if (ProxyParentSequence != None)
        {
            ProxyParentSequence.RemoveSequenceObject(InputProxy);
        }
    }
}
public final native function RequestButtonDockingUpdate(optional bool bImmediately);

public event function bool SetButtonCallback(Name ButtonInputAlias, delegate<OnClicked> NewClickHandler)
{
    local UICalloutButton TargetButton;
    local bool bResult;
    
    TargetButton = FindButton(ButtonInputAlias);
    if (TargetButton != None)
    {
        TargetButton.__OnClicked__Delegate = NewClickHandler;
        bResult = TRUE;
    }
    return bResult;
}
public event function bool SetButtonCaption(Name ButtonInputAlias, string NewButtonCaption)
{
    local UICalloutButton TargetButton;
    local bool bResult;
    
    TargetButton = FindButton(ButtonInputAlias);
    if (TargetButton != None)
    {
        TargetButton.SetDataStoreBinding(NewButtonCaption);
        RequestButtonDockingUpdate();
        bResult = TRUE;
    }
    return bResult;
}
public event function bool SetButtonInputAlias(Name ButtonInputAlias, coerce Name NewButtonInputAlias)
{
    local UICalloutButton TargetButton;
    local bool bResult;
    
    TargetButton = FindButton(ButtonInputAlias);
    if (TargetButton != None)
    {
        if (!ContainsButton(NewButtonInputAlias) && TargetButton.SetInputAlias(NewButtonInputAlias))
        {
            RequestSceneUpdate(TRUE, FALSE);
            bResult = TRUE;
        }
    }
    return bResult;
}
public event function bool ShowButton(Name ButtonInputAlias, optional bool bShowButton = TRUE)
{
    local UICalloutButton TargetButton;
    local bool bResult;
    local bool bVisible;
    
    TargetButton = FindButton(ButtonInputAlias);
    if (TargetButton != None)
    {
        bVisible = TargetButton.IsVisible();
        TargetButton.SetVisibility(bShowButton);
        bResult = bVisible != bShowButton && bShowButton == TargetButton.IsVisible();
    }
    return bResult;
}
public event function SynchronizeInputAliases()
{
    local int AliasIdx;
    
    CalloutButtonAliases.Length = CalloutButtons.Length;
    for (AliasIdx = 0; AliasIdx < CalloutButtons.Length; AliasIdx++)
    {
        CalloutButtonAliases[AliasIdx] = CalloutButtons[AliasIdx].InputAliasTag;
    }
}
public function ConfigureChildButton(UICalloutButton ChildButton)
{
    if (ChildButton != None && ChildButton.Outer == Self)
    {
        RequestButtonDockingUpdate();
        ChildButton.bSupportsButtonRepeat = bSupportsButtonRepeat;
        ChildButton.__NotifyVisibilityChanged__Delegate = OnButtonVisibilityChanged;
    }
}
public function InitializeInputProxy()
{
    local UIEvent_CalloutButtonInputProxy InputProxy;
    local int ButtonIdx;
    
    InputProxy = GetCalloutInputProxy(TRUE);
    if (InputProxy != None)
    {
        for (ButtonIdx = 0; ButtonIdx < CalloutButtons.Length; ButtonIdx++)
        {
            if (CalloutButtons[ButtonIdx] != None)
            {
                CalloutButtons[ButtonIdx].SubscribeToInputProxy(InputProxy);
            }
        }
    }
}
public function OnButtonVisibilityChanged(UIScreenObject SourceWidget, bool bIsVisible)
{
    local UICalloutButton ButtonSender;
    
    ButtonSender = UICalloutButton(SourceWidget);
    if (ButtonSender != None)
    {
        RequestButtonDockingUpdate();
    }
}
public function PopulateCalloutButtonArray()
{
    local int ButtonIdx;
    local int AliasIdx;
    local UICalloutButton ChildButton;
    local array<UICalloutButton> TempArray;
    local bool bCreateButton;
    
    for (ButtonIdx = 0; ButtonIdx < Children.Length; ButtonIdx++)
    {
        ChildButton = UICalloutButton(Children[ButtonIdx]);
        if (ChildButton != None)
        {
            ChildButton.bSupportsButtonRepeat = bSupportsButtonRepeat;
            ChildButton.__NotifyVisibilityChanged__Delegate = OnButtonVisibilityChanged;
            TempArray[TempArray.Length] = ChildButton;
        }
    }
    CalloutButtons.Length = 0;
    for (AliasIdx = 0; AliasIdx < CalloutButtonAliases.Length; AliasIdx++)
    {
        bCreateButton = TRUE;
        for (ButtonIdx = 0; ButtonIdx < TempArray.Length; ButtonIdx++)
        {
            ChildButton = TempArray[ButtonIdx];
            if (ChildButton.InputAliasTag == CalloutButtonAliases[AliasIdx])
            {
                bCreateButton = FALSE;
                TempArray.Remove(ButtonIdx, 1);
                CalloutButtons[CalloutButtons.Length] = ChildButton;
                break;
            }
        }
        if (bCreateButton)
        {
            ChildButton = CreateCalloutButton(CalloutButtonAliases[AliasIdx], CalloutButtonAliases[AliasIdx]);
        }
    }
    for (ButtonIdx = 0; ButtonIdx < TempArray.Length; ButtonIdx++)
    {
        CalloutButtons[CalloutButtons.Length] = TempArray[ButtonIdx];
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=UICalloutButton Name=CalloutButtonTemplate
        Begin Template Class=UIComp_DrawImage Name=BackgroundImageTemplate
        End Template
        Begin Template Class=UIComp_DrawString Name=LabelStringRenderer
        End Template
        Begin Template Class=UIComp_Event Name=WidgetEventComponent
        End Template
        StringRenderComponent = LabelStringRenderer
        BackgroundImageComponent = BackgroundImageTemplate
        EventProvider = WidgetEventComponent
    End Object
    Begin Template Class=UIComp_Event Name=WidgetEventComponent
    End Template
    ButtonPadding[1] = {Value = 0.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_Pixels, Orientation = EUIOrientation.UIORIENT_Vertical}
    ButtonTemplate = CalloutButtonTemplate
    ButtonLayout = ECalloutButtonLayoutType.CBLT_DockRight
    PrimaryStyle = {RequiredStyleClass = Class'UIStyle_Image', DefaultStyleTag = 'DefaultImageStyle'}
    DockTargets = {bLockWidthWhenDocked = TRUE, bLockHeightWhenDocked = TRUE}
    PrivateFlags = 1024
    Position = {Value[1] = 0.949999988, Value[3] = 0.0500000007}
    EventProvider = WidgetEventComponent
    bNeverFocus = TRUE
}