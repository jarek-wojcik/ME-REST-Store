Class UIMessageBoxBase extends UIScene
    placeable
    abstract
    config(UI);

var delegate<OnOptionSelected> __OnOptionSelected__Delegate;
var(UIMessageBoxBase) Name TitleWidgetName;
var(UIMessageBoxBase) Name MessageWidgetName;
var(UIMessageBoxBase) Name QuestionWidgetName;
var(UIMessageBoxBase) Name ChoicesWidgetName;
var(UIMessageBoxBase) Name QuestionWidgetImageName;
var(UIMessageBoxBase) Name ButtonBarButtonBGStyleName;
var(UIMessageBoxBase) Name ButtonBarButtonTextStyleName;
var transient UILabel lblTitle;
var transient UILabel lblMessage;
var transient UILabel lblQuestion;
var transient UIImage imgQuestion;
var transient UICalloutButtonPanel btnbarChoices;
var(UIMessageBoxBase) bool bPerformAutomaticLayout;

public function int FindButtonIndex(Name ButtonAlias)
{
    if (btnbarChoices != None)
    {
        return btnbarChoices.FindButtonIndex(ButtonAlias);
    }
    return -1;
}
public function bool RemoveButton(Name ButtonAlias)
{
    local bool bResult;
    
    if (btnbarChoices != None)
    {
        bResult = btnbarChoices.RemoveButtonByAlias(ButtonAlias);
    }
    return bResult;
}
protected function SetButtonCallback(UICalloutButton TargetButton)
{
    TargetButton.SetWidgetStyleByName(TargetButton.BackgroundImageComponent.StyleResolverTag, ButtonBarButtonBGStyleName);
    TargetButton.SetWidgetStyleByName(TargetButton.StringRenderComponent.StyleResolverTag, ButtonBarButtonTextStyleName);
    btnbarChoices.SetButtonCallback(TargetButton.InputAliasTag, OptionChosen);
}
public function bool AddButton(Name ButtonAlias)
{
    local bool bResult;
    local UICalloutButton AddedButton;
    
    if (!HasButton(ButtonAlias) && btnbarChoices != None)
    {
        AddedButton = btnbarChoices.CreateCalloutButton(ButtonAlias, Name("btn" $ ButtonAlias));
        if (AddedButton != None)
        {
            SetButtonCallback(AddedButton);
            bResult = TRUE;
        }
    }
    return bResult;
}
public function UICalloutButtonPanel GetButtonBar()
{
    return btnbarChoices;
}
public function UILabel GetMessageLabel()
{
    return lblMessage;
}
public function UILabel GetTitleLabel()
{
    return lblTitle;
}
public function HandleSceneActivated(UIScene ActivatedScene, bool bInitialActivation)
{
    if (bInitialActivation)
    {
        lblTitle = UILabel(FindChild(TitleWidgetName, TRUE));
        lblMessage = UILabel(FindChild(MessageWidgetName, TRUE));
        lblQuestion = UILabel(FindChild(QuestionWidgetName, TRUE));
        imgQuestion = UIImage(FindChild(QuestionWidgetImageName, TRUE));
        btnbarChoices = UICalloutButtonPanel(FindChild(ChoicesWidgetName, TRUE));
        LayoutControls();
    }
}
public function bool HasButton(Name ButtonAlias)
{
    return FindButtonIndex(ButtonAlias) != -1;
}
public function LayoutControls()
{
    if (bPerformAutomaticLayout)
    {
        SetupDockingRelationships();
        lblTitle.StringRenderComponent.EnableAutoSizing(1, TRUE);
        lblMessage.StringRenderComponent.EnableAutoSizing(1, TRUE);
        lblTitle.StringRenderComponent.SetAlignment(0, 1);
        lblTitle.StringRenderComponent.SetAlignment(1, 0);
        lblMessage.StringRenderComponent.SetAlignment(0, 1);
        lblMessage.StringRenderComponent.SetAlignment(1, 0);
        lblTitle.StringRenderComponent.SetWrapMode(3);
        lblMessage.StringRenderComponent.SetWrapMode(3);
    }
}
public delegate function bool OnOptionSelected(UIMessageBoxBase Sender, Name SelectedInputAlias, int PlayerIndex)
{
    return TRUE;
}
public function bool OptionChosen(UIScreenObject EventObject, int PlayerIndex)
{
    local UICalloutButton SelectedButton;
    local GameUISceneClient GameSceneClient;
    
    SelectedButton = UICalloutButton(EventObject);
    if (SelectedButton != None && SelectedButton.InputAliasTag != 'None')
    {
        GameSceneClient = GetSceneClient();
        PlayUISound('Clicked');
        if (__OnOptionSelected__Delegate(Self, SelectedButton.InputAliasTag, PlayerIndex))
        {
            __OnOptionSelected__Delegate = None;
            if (GameSceneClient != None && GameSceneClient.FindSceneIndex(Self) != -1)
            {
                CloseScene();
            }
        }
    }
    return TRUE;
}
public function SetMessage(string NewMessageString)
{
    if (lblMessage != None)
    {
        lblMessage.SetDataStoreBinding(NewMessageString);
    }
}
public function SetQuestion(string NewMessageString)
{
    if (lblMessage != None)
    {
        if (NewMessageString == "")
        {
            lblQuestion.SetVisibility(FALSE);
            imgQuestion.SetVisibility(FALSE);
        }
        else
        {
            lblQuestion.SetVisibility(TRUE);
            imgQuestion.SetVisibility(TRUE);
            lblQuestion.SetDataStoreBinding(NewMessageString);
        }
    }
}
public function SetTitle(string NewTitleString)
{
    if (lblTitle != None)
    {
        lblTitle.SetDataStoreBinding(NewTitleString);
    }
}
public function SetupDockingRelationships();

public function SetupMessageBox(string Title, string Message, string Question, array<Name> ButtonAliases, optional delegate<OnOptionSelected> SelectionCallback)
{
    local int ButtonIdx;
    
    SetTitle(Title);
    SetMessage(Message);
    SetQuestion(Question);
    if (btnbarChoices != None)
    {
        btnbarChoices.RemoveAllButtons();
        for (ButtonIdx = 0; ButtonIdx < ButtonAliases.Length; ButtonIdx++)
        {
            AddButton(ButtonAliases[ButtonIdx]);
        }
        if (SelectionCallback != None)
        {
            __OnOptionSelected__Delegate = SelectionCallback;
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=UIComp_Event Name=SceneEventComponent
        DisabledEventAliases = ('CloseScene')
    End Template
    __OnSceneActivated__Delegate = HandleSceneActivated
    bRenderParentScenes = TRUE
    bPauseGameWhileActive = FALSE
    SceneRenderMode = ESplitscreenRenderMode.SPLITRENDER_Fullscreen
    Position = {Value[0] = 0.25, Value[1] = 0.25, Value[2] = 0.75, Value[3] = 0.75}
    EventProvider = SceneEventComponent
}