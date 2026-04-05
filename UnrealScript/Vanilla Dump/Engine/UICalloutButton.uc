Class UICalloutButton extends UILabelButton
    native
    config(UI);

var const config string DefaultMarkupStringTemplate;
var const config Name CalloutDataStoreTag;
var(Data) const editconst Name InputAliasTag;
var transient bool bSupportsButtonRepeat;
var const config bool bPlayErrorSoundWhenDisabled;
var(Appearance) const EUIAlignment IconAlignment;

public event function string GenerateCompleteCaptionMarkup(optional Name InputAlias)
{
    local string IconMarkup;
    local string CurrentMarkup;
    local string NewMarkup;
    local string CalloutMarkupString;
    
    CurrentMarkup = GetDataStoreBinding();
    CalloutMarkupString = GetCalloutMarkupString();
    if (CurrentMarkup != "" && InStr(CurrentMarkup, "<Color:/>", , , ) == -1)
    {
        CalloutMarkupString = Repl(Repl(CalloutMarkupString, "<Color:R=1,B=1,G=1>", "", ), "<Color:/>", "", );
    }
    if (InputAliasTag != 'None')
    {
        if (CurrentMarkup != "")
        {
            CurrentMarkup = Repl(CurrentMarkup, "`InputAliasTag`", string(InputAliasTag), );
        }
        switch (IconAlignment)
        {
            case EUIAlignment.UIALIGN_Left:
                IconMarkup = GetCalloutMarkupString(InputAlias);
                NewMarkup = IconMarkup $ Repl(CurrentMarkup, CalloutMarkupString, "", );
                break;
            case EUIAlignment.UIALIGN_Center:
                break;
            case EUIAlignment.UIALIGN_Right:
                IconMarkup = GetCalloutMarkupString(InputAlias);
                NewMarkup = Repl(CurrentMarkup, CalloutMarkupString, "", ) $ IconMarkup;
                break;
            case EUIAlignment.UIALIGN_Default:
                if (InputAlias != 'None' && InStr(CurrentMarkup, string(InputAliasTag), , , ) != -1)
                {
                    NewMarkup = Repl(CurrentMarkup, string(InputAliasTag), string(InputAlias), );
                }
                break;
            default:
        }
    }
    else if (InputAlias != 'None' && CurrentMarkup != "" && InStr(CurrentMarkup, "`InputAliasTag`", , , ) != -1)
    {
        NewMarkup = Repl(CurrentMarkup, "`InputAliasTag`", string(InputAlias), );
    }
    else
    {
        NewMarkup = GetCalloutMarkupString(InputAlias);
    }
    return NewMarkup;
}
public final native function UIDataStore_InputAlias GetCalloutDataStore(optional LocalPlayer AlternatePlayer);

public event function Name GetCalloutDataStoreName()
{
    return CalloutDataStoreTag != 'None' ? CalloutDataStoreTag : 'ButtonCallouts';
}
public function UIEvent_CalloutButtonInputProxy GetCalloutInputProxy(optional bool bCreateIfNecessary)
{
    local UICalloutButtonPanel PanelOwner;
    local UIEvent_CalloutButtonInputProxy InputProxy;
    
    PanelOwner = GetPanelOwner();
    if (PanelOwner != None)
    {
        InputProxy = PanelOwner.GetCalloutInputProxy(bCreateIfNecessary);
    }
    return InputProxy;
}
public event function string GetCalloutMarkupString(optional Name AlternateInputAlias)
{
    local string Result;
    
    if (InputAliasTag != 'None' || AlternateInputAlias != 'None')
    {
        Result = "<Color:R=1,B=1,G=1>" $ Repl(VerifyDefaultMarkupString() ? DefaultMarkupStringTemplate : "<" $ GetCalloutDataStoreName() $ ":`InputAliasTag`>", "`InputAliasTag`", string(AlternateInputAlias == 'None' ? InputAliasTag : AlternateInputAlias), ) $ "<Color:/>";
    }
    return Result;
}
public native function bool OnReceivedInputKey(const out InputEventParameters EventParms);

public event function PostInitialize()
{
    local string CurrentMarkup;
    local UIEvent_CalloutButtonInputProxy InputProxy;
    
    Super(UIScreenObject).PostInitialize();
    CurrentMarkup = GenerateCompleteCaptionMarkup();
    if (CurrentMarkup != "" && CurrentMarkup != CaptionDataSource.MarkupString)
    {
        SetDataStoreBinding(CurrentMarkup);
    }
    InputProxy = GetCalloutInputProxy(TRUE);
    SubscribeToInputProxy(InputProxy);
}
public event function RemovedFromParent(UIScreenObject WidgetOwner)
{
    local UIEvent_CalloutButtonInputProxy InputProxy;
    
    Super(UIScreenObject).RemovedFromParent(WidgetOwner);
    InputProxy = GetCalloutInputProxy();
    UnsubscribeFromInputProxy(InputProxy);
}
public event function bool SetInputAlias(Name NewInputAlias)
{
    local bool bResult;
    local string CurrentMarkup;
    local string NewMarkup;
    
    if (NewInputAlias != 'None')
    {
        CurrentMarkup = GetDataStoreBinding();
        NewMarkup = GenerateCompleteCaptionMarkup(NewInputAlias);
        if (NewMarkup != "")
        {
            SetDataStoreBinding(NewMarkup, 100 - 1);
            if (CaptionDataSource.MarkupString == NewMarkup)
            {
                SetInputTag(NewInputAlias);
                bResult = TRUE;
            }
            else
            {
                SetDataStoreBinding(CurrentMarkup, 100 - 1);
            }
        }
    }
    return bResult;
}
protected final native function SetInputTag(Name NewInputAlias);

public final native function bool SubscribeToInputProxy(UIEvent_CalloutButtonInputProxy InputProxy, optional bool bUpdateProxyOutputLinks = TRUE, optional int PlayerIndex = -1);

public final native function bool UnsubscribeFromInputProxy(UIEvent_CalloutButtonInputProxy InputProxy, optional bool bUpdateProxyOutputLinks = TRUE, optional int PlayerIndex = -1);

public function UICalloutButtonPanel GetPanelOwner()
{
    return UICalloutButtonPanel(GetOwner());
}
protected function bool VerifyDefaultMarkupString()
{
    local bool bResult;
    
    if (InStr(DefaultMarkupStringTemplate, "`InputAliasTag`", , , ) != -1)
    {
        bResult = TRUE;
    }
    return bResult;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=UIComp_DrawString Name=LabelStringRenderer
        StringStyle = {DefaultStyleTag = 'CalloutButtonStringStyle'}
        AutoSizeParameters[0] = {bAutoSizeEnabled = TRUE}
        AutoSizeParameters[1] = {bAutoSizeEnabled = TRUE}
    End Template
    Begin Template Class=UIComp_DrawImage Name=BackgroundImageTemplate
        ImageStyle = {DefaultStyleTag = 'CalloutButtonBackgroundStyle'}
    End Template
    Begin Template Class=UIComp_Event Name=WidgetEventComponent
    End Template
    DefaultMarkupStringTemplate = "<ButtonCallouts:`InputAliasTag`>"
    StringRenderComponent = LabelStringRenderer
    BackgroundImageComponent = BackgroundImageTemplate
    DockTargets = {bLockWidthWhenDocked = TRUE}
    PrivateFlags = 640
    __OnRawInputKey__Delegate = OnReceivedInputKey
    EventProvider = WidgetEventComponent
    bNeverFocus = TRUE
    bOverrideInputOrder = TRUE
}