Class SFXModule_Radar extends SFXModule
    native;

var bool bRadarDisabled;
var EBioRadarType RadarType;

public event simulated function HandlePostBeginPlay()
{
    Super.HandlePostBeginPlay();
    BioWorldInfo(ModuleOwner.WorldInfo).RadarActors.AddItem(ModuleOwner);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}