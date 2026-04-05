Class WwiseAudioComponentMultiLoc extends WwiseAudioComponent
    native
    editinlinenew
    config(Engine)
    collapsecategories;

var native Map_Mirror m_Locations;
var transient Vector CachedMicPos;
var transient bool IsDirty;

public native function Set3D();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}