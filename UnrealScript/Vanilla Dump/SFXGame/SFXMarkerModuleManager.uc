Class SFXMarkerModuleManager
    transient;

var array<Actor> AllMarkerActors;
var array<Actor> ActiveMarkerActors;
var array<delegate<OnActivated>> MarkerActivatedDelegates;
var array<delegate<OnDeactivated>> MarkerDeactivatedDelegates;
var array<delegate<OnDestroyed>> ManagerDestroyedDelegates;
var delegate<OnActivated> __OnActivated__Delegate;
var delegate<OnDeactivated> __OnDeactivated__Delegate;
var delegate<OnDestroyed> __OnDestroyed__Delegate;

public final function ClearAllMarkerActors()
{
    local Actor ActorIter;
    local SFXModule_Marker MarkerModule;
    
    foreach AllMarkerActors(ActorIter, )
    {
        do {
            MarkerModule = ActorIter.GetModule(Class'SFXModule_Marker');
            ActorIter.RemoveSFXModule(MarkerModule);
        } until (MarkerModule == None);
    }
}
public final function Destroyed()
{
    local delegate<OnDestroyed> ManagerDestroyedDelegateIter;
    
    ClearAllMarkerActors();
    foreach ManagerDestroyedDelegates(ManagerDestroyedDelegateIter, )
    {
        ManagerDestroyedDelegateIter();
    }
}
public final function AddManagerDestroyedDelegate(delegate<OnDestroyed> ManagerDestroyedDelegate)
{
    if (ManagerDestroyedDelegates.Find(ManagerDestroyedDelegate) == -1)
    {
        ManagerDestroyedDelegates.AddItem(ManagerDestroyedDelegate);
    }
}
public final function AddMarkerActivatedDelegate(delegate<OnActivated> MarkerActivatedDelegate)
{
    if (MarkerActivatedDelegates.Find(MarkerActivatedDelegate) == -1)
    {
        MarkerActivatedDelegates.AddItem(MarkerActivatedDelegate);
    }
}
public final function AddMarkerActor(Actor NewMarkerActor)
{
    if (AllMarkerActors.Find(NewMarkerActor) == -1)
    {
        AllMarkerActors.AddItem(NewMarkerActor);
    }
}
public final function AddMarkerDeactivatedDelegate(delegate<OnDeactivated> MarkerDeactivatedDelegate)
{
    if (MarkerDeactivatedDelegates.Find(MarkerDeactivatedDelegate) == -1)
    {
        MarkerDeactivatedDelegates.AddItem(MarkerDeactivatedDelegate);
    }
}
public final function ClearManagerDestroyedDelegate(delegate<OnDestroyed> ManagerDestroyedDelegate)
{
    ManagerDestroyedDelegates.RemoveItem(ManagerDestroyedDelegate);
}
public final function ClearMarkerActivatedDelegate(delegate<OnActivated> MarkerActivatedDelegate)
{
    MarkerActivatedDelegates.RemoveItem(MarkerActivatedDelegate);
}
public final function ClearMarkerDeactivatedDelegate(delegate<OnDeactivated> MarkerDeactivatedDelegate)
{
    MarkerDeactivatedDelegates.RemoveItem(MarkerDeactivatedDelegate);
}
public final function Actor FindActorInActiveMarkerActors(Actor ActorToSearchFor)
{
    local int Index;
    
    Index = ActiveMarkerActors.Find(ActorToSearchFor);
    if (Index == -1)
    {
        return None;
    }
    return ActiveMarkerActors[Index];
}
public final function Actor FindActorInAllMarkerActors(Actor ActorToSearchFor)
{
    local int Index;
    
    Index = AllMarkerActors.Find(ActorToSearchFor);
    if (Index == -1)
    {
        return None;
    }
    return AllMarkerActors[Index];
}
public final function array<Actor> GetActiveMarkerActors(optional string MarkerType = "")
{
    local array<Actor> OutArray;
    local Actor ActorIter;
    local SFXModule ModuleIter;
    
    if (MarkerType == "")
    {
        return ActiveMarkerActors;
    }
    foreach ActiveMarkerActors(ActorIter, )
    {
        foreach ActorIter.Modules(ModuleIter, )
        {
            if (SFXModule_Marker(ModuleIter) != None && SFXModule_Marker(ModuleIter).MarkerType == MarkerType)
            {
                OutArray.AddItem(ActorIter);
                break;
            }
        }
    }
    return OutArray;
}
public final function array<Actor> GetAllMarkerActors(optional string MarkerType = "")
{
    local array<Actor> OutArray;
    local Actor ActorIter;
    local SFXModule ModuleIter;
    
    if (MarkerType == "")
    {
        return AllMarkerActors;
    }
    foreach AllMarkerActors(ActorIter, )
    {
        foreach ActorIter.Modules(ModuleIter, )
        {
            if (SFXModule_Marker(ModuleIter) != None && SFXModule_Marker(ModuleIter).MarkerType == MarkerType)
            {
                OutArray.AddItem(ActorIter);
                break;
            }
        }
    }
    return OutArray;
}
public delegate function OnActivated(Actor ActivatedTarget);

public delegate function OnDeactivated(Actor DeactivatedTarget);

public delegate function OnDestroyed();

public final function RemoveMarkerActor(Actor MarkerActorToRemove)
{
    AllMarkerActors.RemoveItem(MarkerActorToRemove);
}
public final function SetMarkerActorAsActive(Actor NewActiveMarkerActor)
{
    local delegate<OnActivated> MarkerActivatedDelegateIter;
    
    if (ActiveMarkerActors.Find(NewActiveMarkerActor) == -1)
    {
        ActiveMarkerActors.AddItem(NewActiveMarkerActor);
        foreach MarkerActivatedDelegates(MarkerActivatedDelegateIter, )
        {
            MarkerActivatedDelegateIter(NewActiveMarkerActor);
        }
    }
}
public final function SetMarkerActorAsInactive(Actor NewInactiveMarkerActor)
{
    local delegate<OnDeactivated> MarkerDeactivatedDelegateIter;
    
    ActiveMarkerActors.RemoveItem(NewInactiveMarkerActor);
    foreach MarkerDeactivatedDelegates(MarkerDeactivatedDelegateIter, )
    {
        MarkerDeactivatedDelegateIter(NewInactiveMarkerActor);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}