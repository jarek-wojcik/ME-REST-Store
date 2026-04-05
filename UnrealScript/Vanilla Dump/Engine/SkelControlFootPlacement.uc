Class SkelControlFootPlacement extends SkelControlLimb
    native;

var(FootPlacement) Rotator FootRotOffset;
var(FootPlacement) float FootOffset;
var(FootPlacement) float MaxUpAdjustment;
var(FootPlacement) float MaxDownAdjustment;
var(FootPlacement) float MaxFootOrientAdjust;
var(FootPlacement) bool bInvertFootUpAxis;
var(FootPlacement) bool bOrientFootToGround;
var(FootPlacement) bool bOnlyEnableForUpAdjustment;
var(FootPlacement) EAxis FootUpAxis;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxUpAdjustment = 50.0
    MaxFootOrientAdjust = 45.0
    bOrientFootToGround = TRUE
    FootUpAxis = EAxis.AXIS_X
}