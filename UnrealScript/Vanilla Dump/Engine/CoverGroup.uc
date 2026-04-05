Class CoverGroup extends Info
    native
    placeable;

enum ECoverGroupFillAction
{
    CGFA_Overwrite,
    CGFA_Add,
    CGFA_Remove,
    CGFA_Clear,
    CGFA_Cylinder,
};

var(CoverGroup) array<ActorReference> CoverLinkRefs;
var(CoverGroup) float AutoSelectRadius;
var(CoverGroup) float AutoSelectHeight;

public native function DisableGroup();

public native function EnableGroup();

public simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        EnableGroup();
    }
    if (Action.InputLinks[1].bHasImpulse)
    {
        DisableGroup();
    }
    if (Action.InputLinks[2].bHasImpulse)
    {
        ToggleGroup();
    }
}
public native function ToggleGroup();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Components = (None, None)
    bStatic = TRUE
}