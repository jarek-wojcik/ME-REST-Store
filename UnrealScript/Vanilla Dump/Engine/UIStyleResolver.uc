Class UIStyleResolver extends Interface
    native
    abstract;

public native function Name GetStyleResolverTag();

public native function bool NotifyResolveStyle(UISkin ActiveSkin, bool bClearExistingValue, optional UIState CurrentMenuState, optional const Name StylePropertyName);

public native function bool SetStyleResolverTag(Name NewResolverTag);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}