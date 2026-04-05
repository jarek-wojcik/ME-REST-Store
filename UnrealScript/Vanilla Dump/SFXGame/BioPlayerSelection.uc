Class BioPlayerSelection within BioPlayerController
    native
    config(Game);

var array<Actor> m_lSelectionsInRange;
var Actor m_oCurrentSelectionTarget;
var Actor m_oLastSelectionTarget;
var transient float TargetSelectionTime;
var editinline export LensFlareComponent SelectionFlareComp;
var config float SelectionMaxRange;
var config float SelectionFarRange;
var config float SelectionFarAngle;
var config float SelectionCloseRange;
var config float SelectionCloseAngle;
var config float MaxHighlightRange;
var transient bool m_bCurrentSelectionIsCombatTarget;

private final native function FindCurrentSelectionTarget();

public function bool IsSelectable(Actor oTarget)
{
    if (oTarget == None)
    {
        return FALSE;
    }
    return Outer.IsCombatTargetable(oTarget) || Outer.IsExploreTargetable(oTarget);
}
public final native function SetSelectionIconMaterialParam(Name Param, int Value);

public final native function UpdateSelection();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SFXSelectionLensFlareComponent Name=SelectionFlare0
        Template = LensFlare'BioVFX_Z_GLOBAL.Flares.Hud_PointofInterest_Flare_03_Select'
        ReplacementPrimitive = None
    End Object
    SelectionFlareComp = SelectionFlare0
    SelectionMaxRange = 4000.0
    SelectionFarRange = 3000.0
    SelectionFarAngle = 2.0
    SelectionCloseRange = 1500.0
    SelectionCloseAngle = 12.0
    MaxHighlightRange = 800.0
}