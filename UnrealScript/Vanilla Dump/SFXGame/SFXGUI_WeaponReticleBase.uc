Class SFXGUI_WeaponReticleBase extends GFxValue within SFXSFHandler_Reticle
    native
    abstract
    config(UI);

var(SFXGUI_WeaponReticleBase) GFxMovieInfo m_oMovieResource;
var(SFXGUI_WeaponReticleBase) float m_fCachedDistance;
var(SFXGUI_WeaponReticleBase) int m_nCachedAmmo;
var(SFXGUI_WeaponReticleBase) int m_nCachedZoom;
var config stringref m_srWeaponDistanceUnit;
var SFXWeapon m_oWeapon;
var float m_fWeaponRange;
var(SFXGUI_WeaponReticleBase) bool m_bIsVisible;
var(SFXGUI_WeaponReticleBase) bool m_bInShowTransition;
var(SFXGUI_WeaponReticleBase) bool m_bInHideTransition;
var(SFXGUI_WeaponReticleBase) bool m_bMonitorDistance;
var(SFXGUI_WeaponReticleBase) bool m_bMonitorAmmo;
var(SFXGUI_WeaponReticleBase) bool m_bMonitorZoom;
var(SFXGUI_WeaponReticleBase) bool m_bMonitorCanHitTarget;
var(SFXGUI_WeaponReticleBase) bool m_bCachedCanHitTarget;
var(SFXGUI_WeaponReticleBase) bool m_bScriptUpdate;
var(SFXGUI_WeaponReticleBase) bool m_bSubscribeToImpacts;

public event function DistanceToTargetChanged(float fDistance);

public event function PerformReticleHide(bool bInstant)
{
    if (m_bSubscribeToImpacts && m_oWeapon != None)
    {
        m_oWeapon.UnsubscribeFromImpactNotifications(ProcessWeaponImpact);
    }
}
public event function PerformReticleShow(bool bInstant)
{
    if (m_bSubscribeToImpacts && m_oWeapon != None)
    {
        m_oWeapon.SubscribeToImpactNotifications(ProcessWeaponImpact);
    }
}
public event function ResetReticle(optional bool bUnsubscribe = FALSE)
{
    if (m_oWeapon != None && bUnsubscribe)
    {
        m_oWeapon.UnsubscribeFromImpactNotifications(ProcessWeaponImpact);
    }
    m_nCachedAmmo = -999;
    m_nCachedZoom = -999;
    m_fCachedDistance = -999.0;
    m_bCachedCanHitTarget = FALSE;
    TargetCanHitChanged(FALSE);
}
public final native function SetReticleVisible(bool bVisible, optional bool bInstant = FALSE);

public final event function SetWeapon(BioPawn aPawn)
{
    if (m_oWeapon != None)
    {
        m_oWeapon.UnsubscribeFromImpactNotifications(ProcessWeaponImpact);
    }
    m_oWeapon = SFXWeapon(aPawn.Weapon);
    if (m_oWeapon != None)
    {
        m_oWeapon.SubscribeToImpactNotifications(ProcessWeaponImpact);
    }
    if (m_oWeapon != None && int(m_oWeapon.GetWeaponFireType()) < 3)
    {
        m_fWeaponRange = m_oWeapon.GetTraceRange();
    }
    else
    {
        m_fWeaponRange = -1.0;
    }
}
public event function TargetCanHitChanged(bool bInSights);

public event function Update(float fDeltaT);

public event function WeaponAmmoChanged(int nAmmo);

public event function ZoomChanged(int nZoom);

public function OnReticleLoaded();

public function OnWeaponImpact();

public final function ProcessWeaponImpact(SFXWeapon oWeap, ImpactInfo HitInfo)
{
    local SFXPawn oHitPawn;
    
    if (!m_bSubscribeToImpacts)
    {
        return;
    }
    if (oWeap == None || oWeap != m_oWeapon)
    {
        return;
    }
    oHitPawn = SFXPawn(HitInfo.HitActor);
    if (oHitPawn != None && oHitPawn.IsDead() == FALSE && !Outer.GetPC().Pawn.IsFriendly(oHitPawn))
    {
        OnWeaponImpact();
        Outer.OnTargetImpact();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_srWeaponDistanceUnit = $165335
    m_bSubscribeToImpacts = TRUE
}