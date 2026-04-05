Class SFXGUI_MainMenu_Message_NetworkImage extends SFXGUI_MainMenu_Message_Image
    transient;

public event function OnLoad()
{
    local SFXOnlineComponentImageManager imageManager;
    
    imageManager = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentImageManager();
    imageManager.RequestImage(ImagePath, OnImageRequestComplete);
}
public static function SFXGUI_MainMenu_Message CreateMessage(int nMessageId)
{
    local SFXGUI_MainMenu_Message_NetworkImage NewMessage;
    
    NewMessage = new Class'SFXGUI_MainMenu_Message_NetworkImage';
    NewMessage.Id = nMessageId;
    return NewMessage;
}
public final function OnImageRequestComplete(SFXOnlineImageRequest request)
{
    if (request.mCompleted)
    {
        Self.ImageReference = request.mDynamicImage;
        Self.Status = MMM_Status.MMM_DataLoadSuccess;
    }
    else
    {
        Self.Status = MMM_Status.MMM_DataLoadFailed;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}