Class PrefabSequence extends Sequence
    native;

var PrefabInstance OwnerPrefab;

public final native function PrefabInstance GetOwnerPrefab();

public final native function SetOwnerPrefab(PrefabInstance InOwner);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}