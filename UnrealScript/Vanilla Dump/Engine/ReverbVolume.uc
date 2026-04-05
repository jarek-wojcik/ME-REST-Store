Class ReverbVolume extends Volume
    native
    placeable;

struct native InteriorSettings 
{
    var(InteriorSettings) float ExteriorVolume;
    var(InteriorSettings) float ExteriorTime;
    var(InteriorSettings) float ExteriorLPF;
    var(InteriorSettings) float ExteriorLPFTime;
    var(InteriorSettings) float InteriorVolume;
    var(InteriorSettings) float InteriorTime;
    var(InteriorSettings) float InteriorLPF;
    var(InteriorSettings) float InteriorLPFTime;
    var bool bIsWorldInfo;
    
    structdefaultproperties
    {
        ExteriorVolume = 1.0
        ExteriorTime = 0.5
        ExteriorLPF = 1.0
        ExteriorLPFTime = 0.5
        InteriorVolume = 1.0
        InteriorTime = 0.5
        InteriorLPF = 1.0
        InteriorLPFTime = 0.5
    }
};
struct native ReverbSettings 
{
    var(ReverbSettings) float Volume;
    var(ReverbSettings) float FadeTime;
    var(ReverbSettings) bool bApplyReverb;
    var(ReverbSettings) ReverbPreset ReverbType;
    
    structdefaultproperties
    {
        Volume = 0.5
        FadeTime = 2.0
        bApplyReverb = TRUE
    }
};
enum ReverbPreset
{
    REVERB_Default,
    REVERB_Bathroom,
    REVERB_StoneRoom,
    REVERB_Auditorium,
    REVERB_ConcertHall,
    REVERB_Cave,
    REVERB_Hallway,
    REVERB_StoneCorridor,
    REVERB_Alley,
    REVERB_Forest,
    REVERB_City,
    REVERB_Mountains,
    REVERB_Quarry,
    REVERB_Plain,
    REVERB_ParkingLot,
    REVERB_SewerPipe,
    REVERB_Underwater,
    REVERB_SmallRoom,
    REVERB_MediumRoom,
    REVERB_LargeRoom,
    REVERB_MediumHall,
    REVERB_LargeHall,
    REVERB_Plate,
};

var(ReverbVolume) InteriorSettings AmbientZoneSettings;
var(ReverbVolume) ReverbSettings Settings;
var(ReverbVolume) float Priority;
var const transient noimport ReverbVolume NextLowerPriorityVolume;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
        CollideActors = FALSE
        BlockNonZeroExtent = FALSE
    End Template
    AmbientZoneSettings = {
                           ExteriorVolume = 1.0, 
                           ExteriorTime = 0.5, 
                           ExteriorLPF = 1.0, 
                           ExteriorLPFTime = 0.5, 
                           InteriorVolume = 1.0, 
                           InteriorTime = 0.5, 
                           InteriorLPF = 1.0, 
                           InteriorLPFTime = 0.5, 
                           bIsWorldInfo = FALSE
                          }
    Settings = {Volume = 0.5, FadeTime = 2.0, bApplyReverb = TRUE, ReverbType = ReverbPreset.REVERB_Default}
    BrushColor = {B = 15, G = 75, R = 255, A = 255}
    BrushComponent = BrushComponent0
    bColored = TRUE
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
    bCollideActors = FALSE
}