Class UISafeRegionPanel extends UIContainer
    native
    placeable
    config(Game);

enum ESafeRegionType
{
    ESRT_FullRegion,
    ESRT_TextSafeRegion,
};

var(SafeRegion) config float RegionPercentages[2];
var(SafeRegion) bool bForce4x3AspectRatio;
var(SafeRegion) bool bUseFullRegionIn4x3;
var(SafeRegion) bool bPrimarySafeRegion;
var(SafeRegion) ESafeRegionType RegionType;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=UIComp_Event Name=WidgetEventComponent
    End Template
    RegionPercentages[0] = 0.899999976
    RegionPercentages[1] = 0.800000012
    bPrimarySafeRegion = TRUE
    EventProvider = WidgetEventComponent
}