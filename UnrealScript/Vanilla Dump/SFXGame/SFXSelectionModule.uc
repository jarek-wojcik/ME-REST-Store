Class SFXSelectionModule extends SFXModule
    native
    editinlinenew;

var transient string m_GameName;
var(SFXSelectionModule) export Vector m_TargetOffset;
var(SFXSelectionModule) export Name m_nmNonPawnBoneName;
var(SFXSelectionModule) export stringref m_srGameName;
var(SFXSelectionModule) export float m_fSelectionRadius;
var(SFXSelectionModule) export float m_fMaxSelectionRangeSqr;
var editinline export SFXSelectionLensFlareComponent LensFlareComp;
var LensFlare LensFlareTemplate;
var transient SeqVar_Bool TargetSaveBool;
var transient SeqVar_Bool CombatTargetSaveBool;
var(SFXSelectionModule) export bool m_bTargetable;
var(SFXSelectionModule) export bool m_bCombatTargetable;
var transient bool OldCombatTargetable;
var transient bool OldTargeTable;
var(SFXSelectionModule) bool bIgnoreFacing;
var(SFXSelectionModule) bool bHighPriority;
var(SFXSelectionModule) export ETargetTipText m_TargetTipText;

public native function Vector GetSelectionPoint();

public event simulated function HandlePostBeginPlay()
{
    local BioWorldInfo BWI;
    
    Super.HandlePostBeginPlay();
    BWI = BioWorldInfo(ModuleOwner.WorldInfo);
    if (BWI.SelectableActors.Find(ModuleOwner) == -1)
    {
        BWI.SelectableActors.AddItem(ModuleOwner);
    }
}
public simulated function DisableSelection()
{
    if (m_bCombatTargetable || m_bTargetable)
    {
        OldCombatTargetable = m_bCombatTargetable;
        OldTargeTable = m_bTargetable;
        m_bCombatTargetable = FALSE;
        m_bTargetable = FALSE;
    }
}
public simulated function RestoreSelection()
{
    m_bCombatTargetable = OldCombatTargetable;
    m_bTargetable = OldTargeTable;
    OldCombatTargetable = FALSE;
    OldTargeTable = FALSE;
}
public simulated function SetCombatTargetable(bool bTargetable, optional bool bSetTargetSave = TRUE)
{
    m_bCombatTargetable = bTargetable;
    if (CombatTargetSaveBool != None && bSetTargetSave != FALSE)
    {
        CombatTargetSaveBool.bValue = bTargetable ? 1 : 0;
    }
}
public function SetTargetable(bool bTargetable, optional bool bSetTargetSave = TRUE)
{
    m_bTargetable = bTargetable;
    if (LensFlareComp != None)
    {
        LensFlareComp.SetHidden(!bTargetable);
    }
    if (TargetSaveBool != None && bSetTargetSave != FALSE)
    {
        TargetSaveBool.bValue = bTargetable ? 1 : 0;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_nmNonPawnBoneName = 'Chest2'
    m_fSelectionRadius = 50.0
    LensFlareTemplate = LensFlare'BioVFX_Z_GLOBAL.Flares.Hud_PointofInterest_Flare_02'
}