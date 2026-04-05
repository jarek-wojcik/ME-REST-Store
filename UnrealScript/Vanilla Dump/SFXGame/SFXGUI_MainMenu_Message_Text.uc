Class SFXGUI_MainMenu_Message_Text extends SFXGUI_MainMenu_Message
    transient;

public event function OnLoad()
{
    Self.Status = MMM_Status.MMM_DataLoadSuccess;
}
public static function SFXGUI_MainMenu_Message CreateMessage(int nMessageId)
{
    local SFXGUI_MainMenu_Message_Text NewMessage;
    
    NewMessage = new Class'SFXGUI_MainMenu_Message_Text';
    NewMessage.Id = nMessageId;
    return NewMessage;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}