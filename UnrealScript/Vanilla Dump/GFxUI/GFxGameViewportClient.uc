Class GFxGameViewportClient extends GameViewportClient within Engine
    native
    transient;

var Class<GFxInteraction> GFxUIControllerClass;
var GFxInteraction GFxUIController;

public event function bool Init(out string OutError)
{
    local int oldlen;
    
    oldlen = GlobalInteractions.Length;
    if (!Super.Init(OutError))
    {
        return FALSE;
    }
    GFxUIController = new (Self) GFxUIControllerClass;
    if (InsertInteraction(GFxUIController, oldlen + 1) == -1)
    {
        OutError = "Failed to add interaction to GlobalInteractions array:" @ GFxUIController;
        return FALSE;
    }
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    GFxUIControllerClass = Class'GFxInteraction'
}