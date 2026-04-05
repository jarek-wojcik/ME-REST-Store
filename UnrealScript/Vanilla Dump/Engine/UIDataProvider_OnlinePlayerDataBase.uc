Class UIDataProvider_OnlinePlayerDataBase extends UIDataProvider
    native
    abstract
    transient;

var LocalPlayer Player;

public event function OnRegister(LocalPlayer InPlayer)
{
    Player = InPlayer;
}
public event function OnUnregister()
{
    Player = None;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}