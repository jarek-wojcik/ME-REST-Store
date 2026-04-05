Class SFXSaveGameCallback
    native
    transient;

var array<delegate<SFXEngine.SFXSaveCommandCallback>> SaveCommandCompleteDelegates;

public final native function AddSaveCommandCompleteDelegate(delegate<SFXEngine.SFXSaveCommandCallback> SaveCommandCompleteDelegate);

public final native function ClearSaveCommandCompleteDelegate(delegate<SFXEngine.SFXSaveCommandCallback> SaveCommandCompleteDelegate);

private final native function SaveGameCommandComplete(SFXSaveGameCommandEventArgs Args);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}