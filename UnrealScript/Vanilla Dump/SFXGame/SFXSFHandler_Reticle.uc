Class SFXSFHandler_Reticle extends SFXGUIMovieLegacyAdapter
    native
    transient
    config(UI);

var array<Actor> m_aTargets;
var array<SFXSF_ReticleBase> m_aReticles;
var array<SFXGUI_WeaponReticleBase> m_aWeaponReticles;
var array<Class<SFXGUI_WeaponReticleBase>> m_aLoadingReticles;
var SFXCameraNativeBase m_pCameraManager;
var BioPlayerController m_pPlayerController;
var BioPlayerInput m_pPlayerInput;
var BioBaseSquad m_pPlayerSquad;
var float m_fTargetHitIndicatorCooldown;
var float m_fRemainingTargetHitIndicatorCooldownTime;
var float m_fSFWidth;
var float m_fSFHeight;
var float m_fScrn2SF_YOffset;
var float m_fScrn2SF_YScale;
var float m_fScrn2SF_XScale;
var SFXGUI_WeaponReticleBase m_oCurrentWeaponReticle;
var config float m_fUpdateInterval;
var config float m_fScreenChangeDelta;
var bool m_bSelectionInvalidated;
var bool m_bReticleVisible;

public function GameSessionEnded()
{
    CleanupReferences();
    Super.GameSessionEnded();
}
public event function int GetWeaponAmmo(optional bool bClipOnly = TRUE)
{
    local SFXWeapon oWeapon;
    
    if (m_pPlayerController.Pawn == None)
    {
        return -1;
    }
    oWeapon = SFXWeapon(m_pPlayerController.Pawn.Weapon);
    if (oWeapon != None)
    {
        if (!oWeapon.bInfiniteAmmo)
        {
            if (bClipOnly)
            {
                return oWeapon.GetAmmoCountInMagazine();
            }
            else
            {
                return oWeapon.GetCurrentTotalAmmo();
            }
        }
    }
    return -1;
}
public final event function Class<SFXGUI_WeaponReticleBase> GetWeaponReticleClass()
{
    local BioPlayerController oPC;
    local SFXWeapon oWeapon;
    
    oPC = BioPlayerController(GetPC());
    if (oPC == None || oPC.Pawn == None)
    {
        return None;
    }
    oWeapon = SFXWeapon(oPC.Pawn.Weapon);
    if (oWeapon != None)
    {
        if (oPC.IsZoomed())
        {
            return oWeapon.GUIZoomReticleClass;
        }
        return oWeapon.GUIReticleClass;
    }
    return None;
}
public final event function LoadWeaponReticle(Class<SFXGUI_WeaponReticleBase> oReticleClass)
{
    if (m_aLoadingReticles.Find(oReticleClass) >= 0)
    {
        return;
    }
    m_aLoadingReticles.AddItem(oReticleClass);
    AS_LoadWeaponReticle(PathName(oReticleClass), PathName(oReticleClass.default.m_oMovieResource));
}
public event function OnPanelRemoved()
{
    CleanupReferences();
    Super.OnPanelRemoved();
}
public final function AS_CleanupReferences()
{
    ActionScriptVoid("CleanUp");
}
public final function AS_LoadWeaponReticle(string sID, string sResource)
{
    ActionScriptVoid("LoadWeaponReticle");
}
public final function AS_PlayTargetImpact()
{
    ActionScriptVoid("PlayTargetImpact");
}
public function CleanupReferences()
{
    local SFXGUI_WeaponReticleBase aReticle;
    
    m_pCameraManager = None;
    m_pPlayerController = None;
    m_pPlayerInput = None;
    m_aReticles.Length = 0;
    m_aTargets.Length = 0;
    m_pPlayerSquad = None;
    foreach m_aWeaponReticles(aReticle, )
    {
        aReticle.ResetReticle(TRUE);
    }
    m_aWeaponReticles.Length = 0;
    m_aLoadingReticles.Length = 0;
    m_oCurrentWeaponReticle = None;
    AS_CleanupReferences();
}
public function ExInt_InTransitionComplete(string sPath);

public function ExInt_OutTransitionComplete(string sPath)
{
    local int nReticle;
    
    for (nReticle = 0; nReticle < m_aReticles.Length; ++nReticle)
    {
        if (m_aReticles[nReticle].m_sSFPath == sPath)
        {
            m_aReticles[nReticle].ClearReticle(FALSE);
        }
    }
}
public function ExInt_ReticleVisible()
{
    m_bReticleVisible = TRUE;
}
public final function OnTargetImpact()
{
    if (m_fRemainingTargetHitIndicatorCooldownTime <= 0.0)
    {
        AS_PlayTargetImpact();
        m_fRemainingTargetHitIndicatorCooldownTime = m_fTargetHitIndicatorCooldown;
    }
}
public final function WeaponReticleHasLoaded(GFxValue oReticleMC, string sClass)
{
    local Class<SFXGUI_WeaponReticleBase> oNewReticleClass;
    local SFXGUI_WeaponReticleBase oNewReticle;
    local int nLoadingReticle;
    
    for (nLoadingReticle = 0; nLoadingReticle < m_aLoadingReticles.Length; ++nLoadingReticle)
    {
        if (PathName(m_aLoadingReticles[nLoadingReticle]) == sClass)
        {
            oNewReticleClass = m_aLoadingReticles[nLoadingReticle];
            break;
        }
    }
    if (oNewReticleClass == None)
    {
        return;
    }
    oNewReticle = oReticleMC.CastTo(oNewReticleClass);
    if (oNewReticle != None)
    {
        m_aWeaponReticles.AddItem(oNewReticle);
        m_aLoadingReticles.RemoveItem(oNewReticle.Class);
        oNewReticle.OnReticleLoaded();
        oNewReticle.ResetReticle();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_fTargetHitIndicatorCooldown = 0.25
    m_fScreenChangeDelta = 0.5
    bSetGameMode = FALSE
    bOnlyOwnerFocusable = TRUE
    bDiscardNonOwnerInput = TRUE
}