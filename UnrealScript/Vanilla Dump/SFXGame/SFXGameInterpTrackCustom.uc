Class SFXGameInterpTrackCustom extends SFXGameInterpTrack
    native
    abstract
    collapsecategories;

public native function Actor GetGroupLinkedActor(InterpTrackInst TrackInst);

public static event function string GetNewTrackSubMenuName()
{
    return "SFX Cinematics";
}
public native function Object GetObjectRef(BioSeqVar_ObjectFindByTag FindByTagVar);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}