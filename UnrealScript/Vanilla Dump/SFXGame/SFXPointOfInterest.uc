Class SFXPointOfInterest extends Actor
    native
    placeable;

public function PostBeginPlay()
{
    SetDrawScale(1.0);
    Super.PostBeginPlay();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SFXSimpleUseModule Name=tempSelectionModule
        m_bTargetable = TRUE
    End Object
    Components = (None)
    Modules = (tempSelectionModule)
    bNoDelete = TRUE
}