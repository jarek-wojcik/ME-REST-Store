Class BioMapNote extends Actor
    native
    placeable
    config(Game);

var(Radar) float m_fVisibleRange;
var(Areamap) GFxMovieInfo m_oAreaMap;
var(Areamap) stringref m_sMapNoteName;
var transient int m_nLinkedQuest;
var transient stringref m_sJournalTask;
var(Plot) int Argument;
var int m_nIndex;
var config float m_fUpdateDelay;
var transient float m_fUpdateTimer;
var(Radar) bool m_bReducedVisibility;
var(Radar) bool m_bShowOnRadar;
var(Areamap) bool m_bShowOnAreamap;
var(Areamap) bool m_bLinkedToJournal;
var transient bool m_bSeen;
var(World) bool m_bRenderInWorld;
var transient bool m_bRenderInWorld_LastTick;
var(Plot) EBioRegionAutoSet Region;
var(Plot) EBioPlotAutoSet Plot;
var(Plot) EBioAutoSet Conditional;

public native function bool ShowMapNote(bool bAreaMap);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SFXModule_Radar Name=RadarModule
        RadarType = EBioRadarType.BRT_Point_Of_Interest
    End Object
    m_fVisibleRange = 1000.0
    m_nIndex = -1
    m_fUpdateDelay = 1.0
    m_bShowOnRadar = TRUE
    m_bShowOnAreamap = TRUE
    Components = (None)
    Modules = (RadarModule)
}