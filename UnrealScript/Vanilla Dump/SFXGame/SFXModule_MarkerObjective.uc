Class SFXModule_MarkerObjective extends SFXModule_Marker
    native
    editinlinenew;

var(SFXModule_MarkerObjective) EObjectiveMarkerIconType MarkerIconType;

replication
{
    if (bNetDirty && int(GetActorRole()) == 3)
        MarkerIconType;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    GUIMarkerClass = Class'SFXGUIValue_MarkerObjective'
}