Class SFXVersionDependentSelectionModule extends SFXSelectionModule
    native
    editinlinenew
    config(Game);

var config bool selectable;

public event simulated function HandlePostBeginPlay()
{
    if (IsEnglishBuild())
    {
        m_bTargetable = FALSE;
    }
    else
    {
        m_bTargetable = selectable;
    }
    Super.HandlePostBeginPlay();
}
public final native function bool IsEnglishBuild();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    selectable = TRUE
}