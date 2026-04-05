Class SFXGUI_MainMenu_Message_Image extends SFXGUI_MainMenu_Message_Text
    transient;

var string ImagePath;
var Texture ImageReference;

public function Cleanup()
{
    Super(SFXGUI_MainMenu_Message).Cleanup();
    ImageReference = None;
}
public static function SFXGUI_MainMenu_Message CreateMessage(int nMessageId)
{
    local SFXGUI_MainMenu_Message_Image NewMessage;
    
    NewMessage = new Class'SFXGUI_MainMenu_Message_Image';
    NewMessage.Id = nMessageId;
    return NewMessage;
}
public final function FailLoad()
{
    Self.Status = MMM_Status.MMM_DataLoadFailed;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}