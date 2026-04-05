Class UIDataStore_GameState extends UIDataStore
    native
    abstract
    transient;

var delegate<OnRefreshDataFieldValue> __OnRefreshDataFieldValue__Delegate;

public function bool NotifyGameSessionEnded()
{
    return TRUE;
}
public delegate function OnRefreshDataFieldValue();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}