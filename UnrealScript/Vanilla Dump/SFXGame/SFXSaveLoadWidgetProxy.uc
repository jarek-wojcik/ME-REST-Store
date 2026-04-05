Class SFXSaveLoadWidgetProxy
    native
    transient
    config(UI);

var config stringref LoadingMessage;
var config stringref SavingMessage;
var config stringref DeletingMessage;
var config stringref NetworkMessage;
var config bool m_bShowMessage;

public final native function HideLoadingMessage(optional bool bDoTransition = TRUE);

public final native function HideNetworkMessage(optional bool bDoTransition = TRUE);

public final native function HideSavingMessage(optional bool bDoTransition = TRUE);

public final native function ShowDeletingMessage(bool bDoTransition, optional stringref srMessage = $0);

public final native function ShowLoadingMessage(optional bool bDoTransition = TRUE, optional stringref srMessage = $0);

public final native function ShowNetworkMessage(optional bool bDoTransition = TRUE, optional stringref srMessage = $0);

public final native function ShowSavingMessage(optional bool bDoTransition = TRUE, optional stringref srMessage = $0);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LoadingMessage = $170447
    SavingMessage = $350659
    DeletingMessage = $391261
    NetworkMessage = $638055
    m_bShowMessage = TRUE
}