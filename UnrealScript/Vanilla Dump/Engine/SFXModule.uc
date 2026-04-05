Class SFXModule
    native
    abstract;

var transient Actor ModuleOwner;
var transient int ModuleNetIndex;
var const transient bool bNetInitial;
var const transient bool bNetDirty;
var const transient bool bNetOwner;
var const transient bool bNetVisible;
var bool bTickWhilePaused;
var bool bUserCreated;

public event native function HandlePostAdd();

public event native function HandlePostBeginPlay();

public event native function HandlePreBeginPlay();

public event native function HandlePreRemove();

public event native function HandleSetInitialEditorState();

public final simulated native function bool IsClient();

public final simulated native function bool IsServer();

public final simulated native function bool IsServerOrStandalone();

public final native function ModulePostAdd(Actor oHost);

public final native function ModulePostBeginPlay(Actor oHost);

public final native function ModulePreBeginPlay(Actor oHost);

public final native function ModulePreRemove(Actor oHost);

public final native function ModuleSetInitialEditorState(Actor oHost);

public simulated native function ReInitialize(Actor oHost);

public event simulated function ReplicatedEvent(Name VarName);

public event function Tick(float DeltaTime);

public simulated function DebugShowDestructibles(CheatManager CM);

public final simulated function ENetRole GetActorRemoteRole()
{
    return ModuleOwner.RemoteRole;
}
public final simulated function ENetRole GetActorRole()
{
    return ModuleOwner.Role;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ModuleNetIndex = -1
}