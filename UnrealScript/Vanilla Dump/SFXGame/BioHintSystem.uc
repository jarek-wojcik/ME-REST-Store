Class BioHintSystem extends BioHintSystemBase
    config(Game);

enum SFXPowerTutorialType
{
    PowerTutorial_Singularity,
};
const UUToM = 0.01;

var transient Name m_nmCurrentWeapon;
var transient Name m_nmLastUsedPower;
var transient Name m_nmMappedPower;
var transient Name m_nmLeftMappedPower;
var transient Name m_nmRightMappedPower;
var transient Name m_nmClassMappedPower;
var transient Name m_nmNearestEnemy;
var transient Name m_nmTutorialSelectHint;
var transient Name m_nmTutorialHighlightHint;
var transient float m_fAmmoPercent;
var transient float m_fShieldsPercent;
var transient float m_fNearestEnemyDistance;
var transient int m_nMedigel;
var transient int m_nMostUnspentTalentPoints;
var transient float m_fRealTimeSeconds;
var transient bool m_bInCombat;
var transient bool m_bOutOfAmmo;
var transient bool m_bUsingHeavyWeapon;
var transient bool m_bUsingTurret;
var transient bool m_bAllowedToLeaveTurret;
var transient bool m_bUsingSniperRifle;
var transient bool m_bUsingShotgun;
var transient bool m_bUsingAmmoPower;
var transient bool m_bHasAnyAmmoPowers;
var transient bool m_bNearestEnemyCanBeMeleed;
var transient bool m_bAnyHenchmenDead;
var transient bool m_bPowerWheelTutorialEnabled;
var transient bool m_bWeaponWheelTutorialEnabled;
var transient bool m_bShowingSelectHint;
var transient SFXPowerTutorialType m_ePowerTutorialType;

public function AddNotification_BonusPower(int PlotStateID)
{
    local SFXNotificationData NoteData;
    local string DisplayTitle;
    local BioWorldInfo WI;
    local BioPlayerController PC;
    local SFXProfileSettings Profile;
    local int idx;
    local array<BonusPowerUnlockData> BonusPowers;
    
    WI = BioWorldInfo(Class'WorldInfo'.static.GetWorldInfo());
    if (WI == None)
    {
        return;
    }
    PC = BioPlayerController(WI.GetALocalPlayerController());
    if (PC == None)
    {
        return;
    }
    Profile = PC.ProfileSettings;
    if (Profile == None)
    {
        return;
    }
    Profile.GetBonusPowerArray(BonusPowers);
    if (BonusPowers.Length <= 0)
    {
        return;
    }
    NoteData = GetNotificationData('BonusPower');
    for (idx = 0; idx < BonusPowers.Length; idx++)
    {
        if (PlotStateID == BonusPowers[idx].PlotStateID)
        {
            if (Profile.IsBonusPowerUnlocked(BonusPowers[idx].BonusPowerID) == FALSE)
            {
                Profile.UnlockBonusPower(BonusPowers[idx].BonusPowerID);
            }
            ClearCustomTokens();
            SetCustomToken(0, string(BonusPowers[idx].srTitle));
            SetCustomToken(1, string(NoteData.srTitle));
            DisplayTitle = Class'SFXGame'.static.GetSimpleString(NoteData.srAltSubtitle, TRUE);
            ClearCustomTokens();
            AddNotification_Custom(NoteData.DisplayTime, DisplayTitle, string(NoteData.srSubTitle), string(NoteData.srBody), NoteData.sImageResource, NoteData.nmRemoteEvent, NoteData.nmType, NoteData.nmSound, NoteData.Priority, NoteData.nFlourishID);
        }
    }
}
public event function CacheCurrentState()
{
    local BioWorldInfo oWorldInfo;
    local BioPlayerController oController;
    local BioPawn oPawn;
    local BioBaseSquad oSquad;
    local BioPlayerInput oInput;
    local SFXInventoryManager oInvManager;
    local SFXWeapon oWeapon;
    local LocalEnemy oEnemy;
    local float fDist;
    local int nSquadIndex;
    local SFXPawn_Henchman oHenchman;
    local int AutoLevel;
    
    m_bInCombat = FALSE;
    m_fAmmoPercent = 100.0;
    m_fShieldsPercent = 100.0;
    m_fNearestEnemyDistance = -1.0;
    m_nmCurrentWeapon = 'None';
    m_nmMappedPower = 'None';
    m_nmLeftMappedPower = 'None';
    m_nmRightMappedPower = 'None';
    m_nmClassMappedPower = 'None';
    m_nmNearestEnemy = 'None';
    m_nMedigel = 0;
    m_bAnyHenchmenDead = FALSE;
    m_bOutOfAmmo = FALSE;
    m_bNearestEnemyCanBeMeleed = FALSE;
    m_bUsingTurret = FALSE;
    m_bAllowedToLeaveTurret = FALSE;
    oWorldInfo = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    m_fRealTimeSeconds = oWorldInfo.RealTimeSeconds;
    oController = oWorldInfo.GetLocalPlayerController();
    if (oController != None)
    {
        oPawn = BioPawn(oController.Pawn);
        if (oPawn != None)
        {
            m_bInCombat = oPawn.InCombat();
            m_fShieldsPercent = 100.0 * oPawn.GetShieldPct();
            m_bHasAnyAmmoPowers = FALSE;
            if (oPawn.IsA('SFXPawn_PlayerSoldier') || oPawn.IsA('SFXPawn_PlayerVanguard') || oPawn.IsA('SFXPawn_PlayerInfiltrator'))
            {
                m_bHasAnyAmmoPowers = TRUE;
            }
            foreach oController.EnemyList(oEnemy, )
            {
                if (oEnemy.Enemy != None)
                {
                    fDist = 0.00999999978 * VSize(oEnemy.Enemy.location - oPawn.location);
                    if (m_fNearestEnemyDistance < float(0) || fDist < m_fNearestEnemyDistance)
                    {
                        m_fNearestEnemyDistance = fDist;
                        m_nmNearestEnemy = oEnemy.Enemy.Class.Name;
                        if (SFXPawn(oEnemy.Enemy) != None)
                        {
                            m_bNearestEnemyCanBeMeleed = SFXPawn(oEnemy.Enemy).bCanBeMeleed;
                        }
                    }
                }
            }
            oWeapon = SFXWeapon(oPawn.Weapon);
            if (oWeapon != None)
            {
                m_nmCurrentWeapon = oWeapon.Class.Name;
                m_fAmmoPercent = 100.0 * float(oWeapon.GetAmmoCountInMagazine()) / float(oWeapon.GetMagazineSize());
                m_bOutOfAmmo = !oWeapon.HasAnyAmmo();
            }
            m_bUsingAmmoPower = FALSE;
            if (oWeapon != None && oWeapon.AmmoPowerName != 'None')
            {
                m_bUsingAmmoPower = TRUE;
            }
            m_bUsingSniperRifle = FALSE;
            if (SFXWeapon_SniperRifle_Base(oWeapon) != None)
            {
                m_bUsingSniperRifle = TRUE;
            }
            m_bUsingShotgun = FALSE;
            if (SFXWeapon_Shotgun_Base(oWeapon) != None)
            {
                m_bUsingShotgun = TRUE;
            }
            if (SFXHeavyWeapon(oWeapon) != None)
            {
                m_bUsingHeavyWeapon = TRUE;
            }
            else
            {
                m_bUsingHeavyWeapon = FALSE;
            }
            oInput = BioPlayerInput(oController.PlayerInput);
            if (oInput != None)
            {
                m_nmMappedPower = oInput.m_nmMappedPower;
                m_nmLeftMappedPower = oInput.m_nmMappedPower;
                m_nmRightMappedPower = oInput.m_nmMappedPower2;
                m_nmClassMappedPower = oInput.m_nmMappedPower3;
            }
            oInvManager = SFXInventoryManager(oPawn.InvManager);
            if (oInvManager != None)
            {
                m_nMedigel = oInvManager.GetResource(1);
            }
            m_nMostUnspentTalentPoints = 0;
            AutoLevel = 0;
            oController.ProfileSettings.GetProfileSettingValueId(34, AutoLevel);
            oSquad = oPawn.Squad;
            if (oSquad != None)
            {
                for (nSquadIndex = 0; nSquadIndex < oSquad.Members.Length; nSquadIndex++)
                {
                    oHenchman = SFXPawn_Henchman(oSquad.Members[nSquadIndex]);
                    if (oHenchman != None)
                    {
                        if (oHenchman.IsDead())
                        {
                            m_bAnyHenchmenDead = TRUE;
                        }
                        if (AutoLevel == 0 || AutoLevel == 1 && oHenchman == oPawn)
                        {
                            if (oHenchman.TalentPoints > m_nMostUnspentTalentPoints)
                            {
                                m_nMostUnspentTalentPoints = oHenchman.TalentPoints;
                            }
                        }
                    }
                }
            }
        }
        else if (oController.Pawn != None && oController.Pawn.IsA('SFXVehicle_MountedGun'))
        {
            m_bUsingTurret = TRUE;
            m_bAllowedToLeaveTurret = SFXVehicle_MountedGun(oController.Pawn).bAllowedToLeave;
        }
    }
}
public event function CodexUpdate(stringref srTitle, stringref srDescription)
{
    local SFXNotificationData oNoteData;
    
    oNoteData = GetNotificationData('CodexChange');
    if (Len(string(srTitle)) > 0 && Len(string(srDescription)) > 0)
    {
        oNoteData.srSubTitle = srTitle;
        oNoteData.srBody = srDescription;
        AddNotificationOneParameter(oNoteData, 0);
    }
}
public event function JournalUpdate(stringref srTitle, stringref srDescription)
{
    local SFXNotificationData oNoteData;
    
    oNoteData = GetNotificationData('JournalChange');
    if (Len(string(srTitle)) > 0 && Len(string(srDescription)) > 0)
    {
        oNoteData.srSubTitle = srTitle;
        oNoteData.srBody = srDescription;
        AddNotificationOneParameter(oNoteData, 0);
    }
}
public function bool PowerCast(out Name nmContext)
{
    m_nmLastUsedPower = nmContext;
    return TRUE;
}
public function AddNotification_AllianceCredits(int Credits)
{
    local SFXNotificationData oNotificationData;
    local string sTitle;
    local string sSubtitle;
    local string sBody;
    
    oNotificationData = GetNotificationData('AllianceCredits');
    sTitle = string(oNotificationData.srTitle);
    sBody = string(oNotificationData.srBody);
    ClearCustomTokens();
    SetCustomToken(0, string(Credits));
    sSubtitle = Class'SFXGame'.static.GetSimpleString(oNotificationData.srSubTitle, TRUE);
    ClearCustomTokens();
    AddNotification_Custom(oNotificationData.DisplayTime, sTitle, sSubtitle, sBody, oNotificationData.sImageResource, 'None', oNotificationData.nmType, oNotificationData.nmSound, oNotificationData.Priority, oNotificationData.nFlourishID);
}
public function AddNotification_ArmorTreasureUnlocked(string sSubtitle)
{
    local SFXNotificationData oNotificationData;
    local string sTitle;
    local string sBody;
    
    oNotificationData = GetNotificationData('ArmorTreasure');
    sTitle = string(oNotificationData.srTitle);
    sBody = string(oNotificationData.srBody);
    AddNotification_Custom(oNotificationData.DisplayTime, sTitle, sSubtitle, sBody, oNotificationData.sImageResource, 'None', oNotificationData.nmType, oNotificationData.nmSound, oNotificationData.Priority, oNotificationData.nFlourishID);
}
public function AddNotification_GalaxyAtWarArtifact(stringref srTitle)
{
    local SFXNotificationData GAWData;
    
    GAWData = GetNotificationData('GAWArtifact');
    GAWData.srSubTitle = srTitle;
    AddNotificationOneParameter(GAWData, 0);
}
public function AddNotification_GalaxyAtWarArtifactCredits()
{
    local SFXNotificationData GAWData;
    
    GAWData = GetNotificationData('GAWArtifactCredits');
    AddNotificationOneParameter(GAWData, 0);
}
public function AddNotification_GalaxyAtWarAsset(stringref srTitle)
{
    local SFXNotificationData GAWData;
    
    GAWData = GetNotificationData('GAWAsset');
    GAWData.srSubTitle = srTitle;
    AddNotificationOneParameter(GAWData, 0);
}
public function AddNotification_GalaxyAtWarIntel(stringref srTitle)
{
    local SFXNotificationData GAWData;
    
    GAWData = GetNotificationData('GAWIntel');
    GAWData.srSubTitle = srTitle;
    AddNotificationOneParameter(GAWData, 0);
}
public function AddNotification_GalaxyAtWarModifier(stringref srTitle)
{
    local SFXNotificationData GAWData;
    
    GAWData = GetNotificationData('GAWModifier');
    GAWData.srSubTitle = srTitle;
    AddNotificationOneParameter(GAWData, 0);
}
public function AddNotification_GalaxyAtWarSalvage()
{
    local SFXNotificationData GAWData;
    
    GAWData = GetNotificationData('GAWSalvage');
    AddNotificationOneParameter(GAWData, 0);
}
public function AddNotification_HeavyAmmoFull()
{
    AddNotificationOneParameter(GetNotificationData('HeavyAmmoFull'), 0);
}
public function AddNotification_LevelUp(int Level)
{
    local SFXNotification N;
    
    foreach m_aNotifications(N, )
    {
        if (N.nmType == 'LevelUp')
        {
            Level = Level > N.Data1 ? Level : N.Data1;
            m_aNotifications.RemoveItem(N);
        }
    }
    AddNotificationOneParameter(GetNotificationData('LevelUp'), Level);
}
public function AddNotification_MediGelFull()
{
    AddNotificationOneParameter(GetNotificationData('MediGelFull'), 0);
}
public function AddNotification_MPMedalGranted(string sName, int nScoreBonus, optional string sImage)
{
    local SFXNotificationData oNotificationData;
    local SFXNotification oNotification;
    
    oNotificationData = GetNotificationData('MPMedalUnlocked');
    oNotification.sImageResource = sImage;
    oNotification.eLoadStatus = EAsyncLoadStatus.ASYNC_LOAD_STARTED;
    oNotification.nPriority = oNotificationData.Priority;
    oNotification.fDisplayTime = oNotificationData.DisplayTime;
    oNotification.sTitle = sName;
    oNotification.sSubtitle = "+" $ nScoreBonus;
    oNotification.nmRemoteEvent = oNotificationData.nmRemoteEvent;
    oNotification.nmSound = oNotificationData.nmSound;
    oNotification.nFlourishID = oNotificationData.nFlourishID;
    oNotification.nmType = oNotificationData.nmType;
    oNotification.nBarPercent = -1;
    oNotification.nmIcon = oNotificationData.nmIcon;
    oNotification.bIsMini = oNotificationData.bIsMini;
    AddNotification(oNotification);
}
public function AddNotification_ResearchRecovered(string sName, string sMessage, optional string sImagePath)
{
    local SFXNotificationData oNotificationData;
    local string sTitle;
    
    oNotificationData = GetNotificationData('ResearchRecovered');
    sTitle = string(oNotificationData.srTitle);
    AddNotification_Custom(oNotificationData.DisplayTime, sTitle, sName, sMessage, sImagePath, 'None', oNotificationData.nmType, oNotificationData.nmSound, oNotificationData.Priority, oNotificationData.nFlourishID);
}
public function AddNotification_SalvageRecovery(int Amount)
{
    AddNotificationOneParameter(GetNotificationData('SalvageRecovery'), Amount);
}
public function AddNotification_StorePurchase(string sName, string sMessage, optional string sImagePath)
{
    local SFXNotificationData oNotificationData;
    local string sTitle;
    
    oNotificationData = GetNotificationData('StoreItemPurchased');
    sTitle = string(oNotificationData.srTitle);
    AddNotification_Custom(oNotificationData.DisplayTime, sTitle, sName, sMessage, sImagePath, 'None', oNotificationData.nmType, oNotificationData.nmSound, oNotificationData.Priority, oNotificationData.nFlourishID);
}
public function AddNotification_Tech(string sTitle, string sName, string sMessage, optional string sImagePath)
{
    local SFXNotificationData oNotificationData;
    
    oNotificationData = GetNotificationData('TechRecovered');
    AddNotification_Custom(oNotificationData.DisplayTime, sName, sTitle, sMessage, sImagePath, 'None', oNotificationData.nmType, oNotificationData.nmSound, oNotificationData.Priority, oNotificationData.nFlourishID);
}
public function AddNotification_TechUnlocked(string sTitle, string sName, string sMessage, optional string sImagePath)
{
    local SFXNotificationData oNotificationData;
    
    oNotificationData = GetNotificationData('TechUnlocked');
    AddNotification_Custom(oNotificationData.DisplayTime, sName, sTitle, sMessage, sImagePath, 'None', oNotificationData.nmType, oNotificationData.nmSound, oNotificationData.Priority, oNotificationData.nFlourishID);
}
public function AddNotification_TreasureError(string sTitle, string sName, string sMessage, optional string sImagePath)
{
    local SFXNotificationData oNotificationData;
    
    oNotificationData = GetNotificationData('TreasureError');
    AddNotification_Custom(oNotificationData.DisplayTime, sName, sTitle, sMessage, sImagePath, 'None', oNotificationData.nmType, oNotificationData.nmSound, oNotificationData.Priority, oNotificationData.nFlourishID);
}
public function AddNotification_Weapon(string sTitle, string sName, string sMessage, optional string sImagePath)
{
    local SFXNotificationData oNotificationData;
    
    oNotificationData = GetNotificationData('WeaponRecovered');
    AddNotification_Custom(oNotificationData.DisplayTime, sName, sTitle, sMessage, sImagePath, 'None', oNotificationData.nmType, oNotificationData.nmSound, oNotificationData.Priority, oNotificationData.nFlourishID);
}
public function AddNotification_WeaponMod(string sTitle, string sName, string sMessage, optional string sImagePath)
{
    local SFXNotificationData oNotificationData;
    
    oNotificationData = GetNotificationData('WeaponModRecovered');
    AddNotification_Custom(oNotificationData.DisplayTime, sName, sTitle, sMessage, sImagePath, 'None', oNotificationData.nmType, oNotificationData.nmSound, oNotificationData.Priority, oNotificationData.nFlourishID);
}
public function AddNotification_XP(int Amount)
{
    AddNotificationOneParameter(GetNotificationData('XpReceived'), Amount);
}
protected function AddNotificationOneParameter(SFXNotificationData oNoteData, int nParam1)
{
    local SFXNotification oNotification;
    
    PopulateNotificationOneParameter(oNoteData, oNotification, nParam1);
    AddNotification(oNotification);
}
public function bool BypassGameHint()
{
    local HintTrackingData oStartedBypass;
    local HintTrackingData oClearEvent;
    local float TimeSinceStart;
    local float TimeSinceClear;
    
    oStartedBypass = GetTrackingData('StartBypassGame');
    oClearEvent = GetTrackingData('ClearMinigameHint');
    TimeSinceStart = TimeSince(oStartedBypass.LastTime);
    TimeSinceClear = TimeSince(oClearEvent.LastTime);
    if (oStartedBypass.Num >= 1 && oStartedBypass.Num <= 2 && TimeSinceStart < 1.0 && TimeSinceClear > 10.0)
    {
        return TRUE;
    }
    return FALSE;
}
public function bool ChargedWeaponHint()
{
    local HintTrackingData oFired;
    local HintTrackingData oCharged;
    
    oFired = GetTrackingData('Fire', m_nmCurrentWeapon);
    oCharged = GetTrackingData('StartWeaponCharge', m_nmCurrentWeapon);
    if (m_bInCombat && oFired.Num >= 5 && oCharged.Num == 0 && (m_nmCurrentWeapon == 'SFXWeapon_Shotgun_Graal' || m_nmCurrentWeapon == 'SFXWeapon_Shotgun_Geth' || m_nmCurrentWeapon == 'SFXWeapon_Heavy_ArcProjector' || m_nmCurrentWeapon == 'SFXWeapon_Heavy_Blackstar' || m_nmCurrentWeapon == 'SFXWeapon_Heavy_TitanMissileLauncher' || m_nmCurrentWeapon == 'SFXWeapon_AssaultRifle_Reckoning' || m_nmCurrentWeapon == 'SFXWeapon_Pistol_Thor'))
    {
        return TRUE;
    }
    return FALSE;
}
public function bool ClassMappedPowerHint()
{
    local HintTrackingData oCast;
    local HintTrackingData oUseMapped;
    local float fLastCastTime;
    local float fDelta;
    
    if (m_nmClassMappedPower != 'None' && m_nmLastUsedPower == m_nmClassMappedPower)
    {
        oCast = GetTrackingData('PowerCast', m_nmLastUsedPower);
        oUseMapped = GetTrackingData('UseMappedPower', m_nmClassMappedPower);
        fLastCastTime = TimeSince(oCast.LastTime);
        fDelta = Abs(fLastCastTime - TimeSince(oUseMapped.LastTime));
        if (fLastCastTime < 1.0 && fDelta > 0.25)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function bool CooldownHint()
{
    local HintTrackingData oHintData;
    
    oHintData = GetTrackingData('PowerOnCooldown');
    if (oHintData.Num >= 1 && TimeSince(oHintData.LastTime) < 1.0)
    {
        return TRUE;
    }
    return FALSE;
}
public function EnablePowerTutorialHint(bool bOn, SFXPowerTutorialType eTutType)
{
    m_bPowerWheelTutorialEnabled = bOn;
    m_ePowerTutorialType = eTutType;
}
public function EnableWeaponTutorialHint(bool bOn)
{
    m_bWeaponWheelTutorialEnabled = bOn;
}
public function bool ExitTurretHint()
{
    local HintTrackingData oFired;
    local HintTrackingData oEnterTurret;
    
    oFired = GetTrackingData('Fire');
    oEnterTurret = GetTrackingData('EnterTurret');
    if (m_bUsingTurret && m_bAllowedToLeaveTurret && TimeSince(oFired.LastTime) >= 8.0 && TimeSince(oEnterTurret.LastTime) >= 8.0)
    {
        return TRUE;
    }
    return FALSE;
}
public function bool FindHintDefinition(Name nmHint, out HintDefinition oHint)
{
    local bool bFound;
    local int i;
    
    bFound = FALSE;
    for (i = 0; i < m_aHints.Length; i++)
    {
        if (m_aHints[i].HintName == nmHint)
        {
            oHint = m_aHints[i];
            bFound = TRUE;
            break;
        }
    }
    return bFound;
}
public function bool FindLandingSite()
{
    local HintTrackingData oOpenScanner;
    local HintTrackingData oCloseScanner;
    local HintTrackingData oStartScanning;
    local HintTrackingData oAnomaly;
    local HintTrackingData oFireProbe;
    local float fOpenScanner;
    local float fCloseScanner;
    local float fStartScanning;
    local float fAnomaly;
    local float fFireProbe;
    
    oOpenScanner = GetTrackingData('StartPlanetScanner');
    fOpenScanner = TimeSince(oOpenScanner.LastTime);
    oCloseScanner = GetTrackingData('ClosePlanetScanner');
    fCloseScanner = TimeSince(oCloseScanner.LastTime);
    oStartScanning = GetTrackingData('StartScanning');
    fStartScanning = TimeSince(oStartScanning.LastTime);
    oAnomaly = GetTrackingData('PlanetScanAnomaly');
    fAnomaly = TimeSince(oAnomaly.LastTime);
    oFireProbe = GetTrackingData('LaunchProbe');
    fFireProbe = TimeSince(oFireProbe.LastTime);
    if (fOpenScanner < fCloseScanner && fStartScanning < fOpenScanner && fAnomaly <= fStartScanning && fFireProbe > fOpenScanner && fOpenScanner > 15.0)
    {
        return TRUE;
    }
    return FALSE;
}
public function GeneratePowerWheelTutorialHint(bool bPowerWheel, bool bWeaponWheel)
{
    local SFXGUIInteraction Manager;
    local HintDefinition oHint;
    local bool bShowHint;
    
    Manager = Class'SFXGUIInteraction'.static.GetInstance();
    bShowHint = FALSE;
    if (m_bPowerWheelTutorialEnabled && bPowerWheel)
    {
        if (m_ePowerTutorialType == SFXPowerTutorialType.PowerTutorial_Singularity)
        {
            m_nmTutorialSelectHint = 'TutorialSingularitySelectHint';
            m_nmTutorialHighlightHint = 'TutorialSingularityHighlightHint';
        }
        m_bShowingSelectHint = TRUE;
        bShowHint = TRUE;
    }
    else if (m_bWeaponWheelTutorialEnabled && bWeaponWheel)
    {
        m_nmTutorialSelectHint = 'TutorialWeaponWheelHint';
        m_nmTutorialHighlightHint = 'TutorialWeaponEquipHint';
        m_bShowingSelectHint = TRUE;
        bShowHint = TRUE;
    }
    if (bShowHint && m_nmTutorialSelectHint != 'None')
    {
        if (FindHintDefinition(m_nmTutorialSelectHint, oHint))
        {
            Manager.ShowPlatformSpecificHint(oHint.DefaultText, oHint.PS3Text, oHint.PCText, oHint.DisplayDuration, oHint.HintPosition);
        }
    }
}
public function bool GrenadeHint()
{
    local HintTrackingData oUsedGrenade;
    local WorldInfo WI;
    local PlayerController PC;
    local SFXPawn_Player pPawn;
    local SFXInventoryManager InvManager;
    local SFXPowerManager PowerManager;
    local SFXPowerCustomActionBase Power;
    local SFXEngine Engine;
    
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine == None)
    {
        return FALSE;
    }
    if (Engine.GetPlayerVariable('GrenadeHintDisplayed') != 0)
    {
        return FALSE;
    }
    oUsedGrenade = GetTrackingData('UsedGrenade');
    WI = Class'WorldInfo'.static.GetWorldInfo();
    if (WI == None)
    {
        return FALSE;
    }
    if (WI.GRI.IsMultiplayerGame())
    {
        return FALSE;
    }
    PC = WI.GetALocalPlayerController();
    if (PC == None)
    {
        return FALSE;
    }
    pPawn = SFXPawn_Player(PC.Pawn);
    if (pPawn == None)
    {
        return FALSE;
    }
    InvManager = SFXInventoryManager(pPawn.InvManager);
    if (InvManager == None)
    {
        return FALSE;
    }
    if (oUsedGrenade.Num == 0 && InvManager.bCanPickUpGrenades == TRUE && InvManager.Grenades > 0)
    {
        PowerManager = pPawn.PowerManager;
        if (PowerManager != None)
        {
            foreach PowerManager.Powers(Power, )
            {
                if (Power.IsA('SFXPowerCustomAction_GrenadeBase') && Power.Rank > float(0))
                {
                    Engine.SetPlayerVariable('GrenadeHintDisplayed', 1);
                    return TRUE;
                }
            }
        }
    }
    return FALSE;
}
public function bool HackGameHint()
{
    local HintTrackingData oStartedHack;
    local HintTrackingData oClearEvent;
    local float TimeSinceStart;
    local float TimeSinceClear;
    
    oStartedHack = GetTrackingData('StartHackGame');
    oClearEvent = GetTrackingData('ClearMinigameHint');
    TimeSinceStart = TimeSince(oStartedHack.LastTime);
    TimeSinceClear = TimeSince(oClearEvent.LastTime);
    if (oStartedHack.Num >= 1 && oStartedHack.Num <= 2 && TimeSinceStart < 1.0 && TimeSinceClear > 10.0)
    {
        return TRUE;
    }
    return FALSE;
}
public function bool LaunchProbeHint()
{
    local HintTrackingData oOpenScanner;
    local HintTrackingData oCloseScanner;
    local HintTrackingData oStartScanning;
    local HintTrackingData oFireProbe;
    local HintTrackingData oAnomaly;
    local float fOpenScanner;
    local float fCloseScanner;
    local float fStartScanning;
    local float fFireProbe;
    local float fAnomaly;
    
    oOpenScanner = GetTrackingData('StartPlanetScanner');
    fOpenScanner = TimeSince(oOpenScanner.LastTime);
    oCloseScanner = GetTrackingData('ClosePlanetScanner');
    fCloseScanner = TimeSince(oCloseScanner.LastTime);
    oStartScanning = GetTrackingData('StartScanning');
    fStartScanning = TimeSince(oStartScanning.LastTime);
    oFireProbe = GetTrackingData('LaunchProbe');
    fFireProbe = TimeSince(oFireProbe.LastTime);
    oAnomaly = GetTrackingData('PlanetScanAnomaly');
    fAnomaly = TimeSince(oAnomaly.LastTime);
    if (fOpenScanner < fCloseScanner && fStartScanning < fOpenScanner && fFireProbe > fOpenScanner && fAnomaly > fStartScanning && fOpenScanner > 15.0)
    {
        return TRUE;
    }
    return FALSE;
}
public function bool LeftMappedPowerHint()
{
    local HintTrackingData oCast;
    local HintTrackingData oUseMapped;
    local float fLastCastTime;
    local float fDelta;
    
    if (m_nmLeftMappedPower != 'None' && m_nmLastUsedPower == m_nmLeftMappedPower)
    {
        oCast = GetTrackingData('PowerCast', m_nmLastUsedPower);
        oUseMapped = GetTrackingData('UseMappedPower', m_nmLeftMappedPower);
        fLastCastTime = TimeSince(oCast.LastTime);
        fDelta = Abs(fLastCastTime - TimeSince(oUseMapped.LastTime));
        if (fLastCastTime < 1.0 && fDelta > 0.25)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function bool LevelUpHint()
{
    if (m_nMostUnspentTalentPoints >= 4 && m_fRealTimeSeconds > 5.0 && m_fRealTimeSeconds < 10.0)
    {
        return TRUE;
    }
    return FALSE;
}
public function bool ManualReloadHint()
{
    local HintTrackingData oManual;
    local HintTrackingData oFast;
    local HintTrackingData oReload;
    
    if (m_fAmmoPercent <= float(25) && m_fAmmoPercent > float(0) && m_bUsingHeavyWeapon == FALSE)
    {
        oManual = GetTrackingData('ManualReload');
        oFast = GetTrackingData('FastReload');
        oReload = GetTrackingData('RELOAD');
        if (oReload.Num >= 3 && (oManual.Num == 0 || oManual.LastTime < GetPreviousTime(oReload, 2)) && (oFast.Num == 0 || oFast.LastTime < GetPreviousTime(oReload, 2)))
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function bool MedigelHint()
{
    local HintTrackingData oRecdMedigel;
    local HintTrackingData oUsedMedigel;
    
    oRecdMedigel = GetTrackingData('ReceivedFirstMedigel');
    oUsedMedigel = GetTrackingData('PowerCast', 'SFXPowerCustomAction_Unity');
    if (m_fRealTimeSeconds > 10.0 && oRecdMedigel.Num > 0 && TimeSince(oRecdMedigel.LastTime) < 1.0 && oUsedMedigel.Num == 0)
    {
        return TRUE;
    }
    return FALSE;
}
public function bool MeleeHint()
{
    local HintTrackingData oMelee;
    local HintTrackingData oMeleeDamaged;
    
    if (m_bInCombat && m_fNearestEnemyDistance < 3.0 && m_bNearestEnemyCanBeMeleed)
    {
        oMelee = GetTrackingData('Melee');
        oMeleeDamaged = GetTrackingData('Damaged', 'SFXDamageType_Melee');
        if ((oMelee.Num == 0 || TimeSince(oMelee.LastTime) > float(300)) && (oMeleeDamaged.Num >= 2 && TimeSince(GetPreviousTime(oMeleeDamaged, 2)) < float(10)))
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function bool PCMappedPowerHint()
{
    local HintTrackingData oCast;
    local HintTrackingData oUseMapped;
    
    if (m_nmMappedPower != 'None' && m_nmLastUsedPower == m_nmMappedPower && !Class'WorldInfo'.static.IsConsoleBuild(0))
    {
        oCast = GetTrackingData('PowerCast', m_nmLastUsedPower);
        oUseMapped = GetTrackingData('UseMappedPower');
        if (TimeSince(oCast.LastTime) < TimeSince(oUseMapped.LastTime))
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function bool PlanetScanHint()
{
    local HintTrackingData oOpenScanner;
    local HintTrackingData oCloseScanner;
    local HintTrackingData oStartScanning;
    local float fOpenScanner;
    local float fCloseScanner;
    local float fStartScanning;
    
    oOpenScanner = GetTrackingData('StartPlanetScanner');
    fOpenScanner = TimeSince(oOpenScanner.LastTime);
    oCloseScanner = GetTrackingData('ClosePlanetScanner');
    fCloseScanner = TimeSince(oCloseScanner.LastTime);
    oStartScanning = GetTrackingData('StartScanning');
    fStartScanning = TimeSince(oStartScanning.LastTime);
    if (fOpenScanner < fCloseScanner && fOpenScanner < fStartScanning && fOpenScanner >= 8.0)
    {
        return TRUE;
    }
    return FALSE;
}
public function bool ResurrectHint()
{
    if (m_bInCombat && m_bAnyHenchmenDead && m_nMedigel > 2)
    {
        return TRUE;
    }
    return FALSE;
}
public function bool RightMappedPowerHint()
{
    local HintTrackingData oCast;
    local HintTrackingData oUseMapped;
    local float fLastCastTime;
    local float fDelta;
    
    if (m_nmRightMappedPower != 'None' && m_nmLastUsedPower == m_nmRightMappedPower)
    {
        oCast = GetTrackingData('PowerCast', m_nmLastUsedPower);
        oUseMapped = GetTrackingData('UseMappedPower', m_nmRightMappedPower);
        fLastCastTime = TimeSince(oCast.LastTime);
        fDelta = Abs(fLastCastTime - TimeSince(oUseMapped.LastTime));
        if (fLastCastTime < 1.0 && fDelta > 0.25)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function bool SyncMeleeHint()
{
    local HintTrackingData oSyncMeleeDamaged;
    local HintTrackingData oBrokeMelee;
    
    if (m_bInCombat)
    {
        oSyncMeleeDamaged = GetTrackingData('Damaged', 'SFXDamageType_SyncMelee');
        oBrokeMelee = GetTrackingData('BrokeMelee');
        if (oSyncMeleeDamaged.Num > 0 && TimeSince(oSyncMeleeDamaged.LastTime) < float(10) && (oBrokeMelee.Num == 0 || oBrokeMelee.LastTime < oSyncMeleeDamaged.LastTime))
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function bool TakeCoverHint()
{
    local HintTrackingData oTakeCover;
    local HintTrackingData oLeaveCover;
    
    if (m_fShieldsPercent == float(0) && m_fNearestEnemyDistance > float(10))
    {
        oTakeCover = GetTrackingData('EnterCover');
        oLeaveCover = GetTrackingData('LeaveCover');
        if (oTakeCover.Num == 0 || oLeaveCover.Num > 0 && oLeaveCover.LastTime < oTakeCover.LastTime && TimeSince(oLeaveCover.LastTime) > float(60))
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function UpdatePowerWheelTutorialHint(Name nmPower)
{
    local SFXGUIInteraction Manager;
    local Name nmHint;
    local Name nmMatchingPowerName;
    local HintDefinition oHint;
    
    if (m_bPowerWheelTutorialEnabled)
    {
        switch (m_ePowerTutorialType)
        {
            case SFXPowerTutorialType.PowerTutorial_Singularity:
                nmMatchingPowerName = 'Singularity';
                break;
            default:
        }
        if (nmPower == nmMatchingPowerName)
        {
            if (m_bShowingSelectHint)
            {
                nmHint = m_nmTutorialHighlightHint;
                m_bShowingSelectHint = FALSE;
            }
        }
        else if (!m_bShowingSelectHint)
        {
            nmHint = m_nmTutorialSelectHint;
            m_bShowingSelectHint = TRUE;
        }
        if (nmHint != 'None')
        {
            Manager = Class'SFXGUIInteraction'.static.GetInstance();
            if (FindHintDefinition(nmHint, oHint))
            {
                Manager.ShowPlatformSpecificHint(oHint.DefaultText, oHint.PS3Text, oHint.PCText, oHint.DisplayDuration, oHint.HintPosition);
            }
        }
    }
}
public function UpdateWeaponWheelTutorialHint(int nWeaponType)
{
    local SFXGUIInteraction Manager;
    local HintDefinition oHint;
    local Name nmHint;
    
    if (m_bWeaponWheelTutorialEnabled)
    {
        if (nWeaponType == 15)
        {
            if (m_bShowingSelectHint)
            {
                nmHint = m_nmTutorialHighlightHint;
                m_bShowingSelectHint = FALSE;
            }
        }
        else if (!m_bShowingSelectHint)
        {
            nmHint = m_nmTutorialSelectHint;
            m_bShowingSelectHint = TRUE;
        }
        if (nmHint != 'None')
        {
            Manager = Class'SFXGUIInteraction'.static.GetInstance();
            if (FindHintDefinition(nmHint, oHint))
            {
                Manager.ShowPlatformSpecificHint(oHint.DefaultText, oHint.PS3Text, oHint.PCText, oHint.DisplayDuration, oHint.HintPosition);
            }
        }
    }
}
public function bool UseAmmoPowerHint()
{
    local int nReloadLimit;
    local HintTrackingData oHintData;
    local HintTrackingData oReloadData;
    local HintTrackingData oSwitchWeaponData;
    local float fReloadTime;
    local BioPlayerController PC;
    
    oHintData = GetTrackingData('Hint', 'UseAmmoPowerHint');
    oReloadData = GetTrackingData('RELOAD');
    oSwitchWeaponData = GetTrackingData('ChangeWeapon');
    nReloadLimit = 2;
    if (m_bUsingSniperRifle)
    {
        nReloadLimit = 5;
    }
    fReloadTime = TimeSince(GetPreviousTime(oReloadData, nReloadLimit));
    PC = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController();
    if (!PC.GameModeManager2.IsActive(7) && !PC.GameModeManager2.IsActive(8) && m_bInCombat && !m_bUsingHeavyWeapon && !m_bUsingAmmoPower && m_bHasAnyAmmoPowers && oHintData.Num == 0 && oReloadData.Num >= nReloadLimit && (oSwitchWeaponData.Num == 0 || fReloadTime < TimeSince(oSwitchWeaponData.LastTime)))
    {
        return TRUE;
    }
    return FALSE;
}
public function bool ZoomHint()
{
    local HintTrackingData oFired;
    local HintTrackingData oZoomed;
    local HintTrackingData oSwitchWeaponData;
    local float TimeSince10thLastShot;
    
    if (m_bInCombat && !m_bUsingShotgun)
    {
        oFired = GetTrackingData('Fire');
        oZoomed = GetTrackingData('Zoom');
        oSwitchWeaponData = GetTrackingData('ChangeWeapon');
        TimeSince10thLastShot = TimeSince(GetPreviousTime(oFired, 9));
        if (!m_bUsingHeavyWeapon && oFired.Num > 10 && TimeSince(oFired.LastTime) < float(5) && TimeSince(oSwitchWeaponData.LastTime) > TimeSince10thLastShot && (oZoomed.Num == 0 || TimeSince(oZoomed.LastTime) > float(300)))
        {
            return TRUE;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}