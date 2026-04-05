Class SFXModule_SavedUse extends SFXSimpleUseModule
    native
    editinlinenew;

var(SFXModule_SavedUse) Guid UseModuleGUID;

public function bool HasBeenUsed()
{
    local SFXEngine Engine;
    local Guid CurrentGUID;
    
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    if (Engine != None)
    {
        foreach Engine.UseModuleList(CurrentGUID, )
        {
            if (UseModuleGUID == CurrentGUID)
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}
public function OnUsed(Actor User)
{
    Used(User);
}
public function Used(Actor User)
{
    local SFXEngine Engine;
    
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    if (Engine != None && !HasBeenUsed() && UseModuleGUID.A != 0 && UseModuleGUID.B != 0 && UseModuleGUID.C != 0 && UseModuleGUID.D != 0)
    {
        Engine.UseModuleList.AddItem(UseModuleGUID);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}