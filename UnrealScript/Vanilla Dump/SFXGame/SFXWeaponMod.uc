Class SFXWeaponMod extends SFXWeaponMod_NativeBase
    abstract
    config(Weapon);

struct WeaponModStatConversion 
{
    var Name ModEffectClass;
    var float ConversionMultiplier;
};
struct WeaponModEffect 
{
    var Name EffectClassName;
    var int Level;
    var float EffectValue;
};
enum EWeaponModCategory
{
    WModCategory_Uncategorized,
    WModCategory_Barrel,
    WModCategory_Scope,
    WModCategory_Body,
    WModCategory_Grip,
    WModCategory_Emissive,
    WModCategory_Blade,
    WModCategory_DLC1,
    WModCategory_DLC2,
    WModCategory_DLC3,
    WModCategory_DLC4,
    WModCategory_DLC5,
    WModCategory_DLC6,
    WModCategory_DLC7,
    WModCategory_DLC8,
    WModCategory_DLC9,
    WModCategory_DLC10,
};

var(SFXWeaponMod) editinline export array<MeshComponent> Meshes;
var array<Class<SFXGameEffect>> GameEffectClasses;
var config array<WeaponModEffect> GameEffects;
var array<Class<SFXGUI_WeaponReticleBase>> Reticules;
var config array<SFXWeaponAimMode> AimModes;
var config array<stringref> ModLevelTokens;
var config biodynamicload string NotificationImage;
var config biodynamicload string LargeNotificationImage;
var string RTPCName;
var config array<WeaponModStatConversion> WeaponModConversions;
var(SFXWeaponMod) Name SocketName;
var(SFXWeaponMod) int Level;
var(SFXWeaponMod) stringref DisplayName;
var(SFXWeaponMod) stringref FormattedName_ModName;
var(SFXWeaponMod) stringref FormattedName_ModCategory;
var(SFXWeaponMod) stringref Description;
var const config stringref NotificationTitle;
var const config stringref NotificationDescription;
var(SFXWeaponMod) SFXCameraSetup Camera;
var SFXWeapon MyWeapon;
var const config int MAX_RANK;
var(SFXWeaponMod) bool bMaterialEmissiveChange;
var(SFXWeaponMod) bool bMaterialGripColorChange;
var(SFXWeaponMod) bool bMaterialBodyColorChange;
var bool bIsScoped;
var config EWeaponModCategory WeaponModCategory;
var const config ETargetTipText ToolTipText;

public function float GetGameEffectDisplayValue(int GameEffectIdx)
{
    local int idx;
    
    if (GameEffectIdx >= GameEffects.Length)
    {
        return 0.0;
    }
    for (idx = 0; idx < WeaponModConversions.Length; idx++)
    {
        if (WeaponModConversions[idx].ModEffectClass == GameEffects[GameEffectIdx].EffectClassName)
        {
            return GameEffects[GameEffectIdx].EffectValue * WeaponModConversions[idx].ConversionMultiplier;
        }
    }
    return GameEffects[GameEffectIdx].EffectValue;
}
public static function string GetModName(int nLevel, optional bool bShortForm = FALSE)
{
    local string sFinalString;
    local string Custom0;
    local string Custom1;
    
    ClearCustomTokens();
    if (bShortForm)
    {
        if (nLevel > 0 && nLevel <= default.ModLevelTokens.Length)
        {
            Custom0 = string(default.ModLevelTokens[nLevel - 1]);
        }
        SetCustomToken(0, Custom0);
        sFinalString = string(default.FormattedName_ModName);
    }
    else
    {
        if (nLevel > 0 && nLevel <= default.ModLevelTokens.Length)
        {
            Custom0 = string(default.ModLevelTokens[nLevel - 1]);
        }
        SetCustomToken(0, Custom0);
        Custom1 = string(default.FormattedName_ModName);
        SetCustomToken(1, Custom1);
        sFinalString = string(default.FormattedName_ModCategory);
    }
    ClearCustomTokens();
    return sFinalString;
}
public function ApplyEffects()
{
    if (RTPCName != "")
    {
        Class'WwiseAudioComponent'.static.SetGlobalRTPCFromScript(RTPCName, float(Level));
    }
}
public function Class<SFXGameEffect> GetGameEffectClass(Name EffectClassName)
{
    local int idx;
    
    for (idx = 0; idx < GameEffectClasses.Length; idx++)
    {
        if (GameEffectClasses[idx].Name == EffectClassName)
        {
            return GameEffectClasses[idx];
        }
    }
    return None;
}
public static function int GetMaxRank()
{
    return default.MAX_RANK;
}
public static function string GetModDescription(int nLevel)
{
    local int idx;
    local int nToken;
    local string sFinalString;
    local string sTokenString;
    
    ClearCustomTokens();
    for (idx = 0; idx < default.GameEffects.Length; idx++)
    {
        if (nLevel == default.GameEffects[idx].Level)
        {
            sTokenString = string(default.GameEffects[idx].EffectValue * 100.0);
            if (Len(sTokenString) > 2)
            {
                sTokenString = Left(sTokenString, Len(sTokenString) - 2);
            }
            SetCustomToken(nToken++, sTokenString);
        }
    }
    sFinalString = string(default.Description);
    ClearCustomTokens();
    return sFinalString;
}
public static function bool IsUnlocked(out int nUnlockLevel)
{
    local SFXEngine Engine;
    
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    nUnlockLevel = 0;
    nUnlockLevel = Engine.GetPlayerVariable(Name(PathName(default.Class)));
    return nUnlockLevel > 0;
}
public static final function Class<SFXWeaponMod> LoadModClass(string ModClassName)
{
    return Class<SFXWeaponMod>(Class'SFXEngine'.static.GetSeekFreeObject(ModClassName, Class'Class'));
}
public function OnVisibilityChanged(bool bHidden);

public function RemoveEffects()
{
    if (RTPCName != "")
    {
        Class'WwiseAudioComponent'.static.SetGlobalRTPCFromScript(RTPCName, 0.0);
    }
}
public static function bool Upgrade(optional BioPawn Instigator, optional bool bNoNotification = FALSE)
{
    local SFXEngine Eng;
    local int nRank;
    local BioPlayerController oController;
    local Name PlayerVariable;
    
    Eng = SFXEngine(Class'Engine'.static.GetEngine());
    nRank = Eng.GetPlayerVariable(Name(PathName(default.Class)));
    if (nRank >= default.MAX_RANK)
    {
        Eng.BioShowDebugMessageBox("Error: Could not Upgrade Mod, already Max Rank " $ default.Class.Name);
        return FALSE;
    }
    PlayerVariable = Name(PathName(default.Class));
    Eng.SetPlayerVariable(PlayerVariable, nRank + 1);
    if (bNoNotification == FALSE && !SFXGRI(Class'Engine'.static.GetCurrentWorldInfo().GRI).bIsMultiplayerCharacter && Instigator != None)
    {
        oController = BioPlayerController(Instigator.Controller);
        BioHintSystem(oController.HintSystem).AddNotification_WeaponMod(GetModName(nRank + 1), Class'SFXGame'.static.GetSimpleString(default.NotificationTitle), Class'SFXGame'.static.GetSimpleString(default.NotificationDescription), default.NotificationImage);
    }
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=StaticMeshComponent Name=PickupMesh
        ReplacementPrimitive = None
    End Template
    ModLevelTokens = ($519242, $519243, $519244, $519245, $519246)
    NotificationImage = "GUI_GlobalIcons.Notifications.NewTech_256"
    WeaponModConversions = ({ModEffectClass = 'SFXGameEffect_WeaponMod_PenetrationBonus', ConversionMultiplier = 0.00999999978}, 
                            {ModEffectClass = 'SFXGameEffect_WeaponMod_PenetrationDamageBonus', ConversionMultiplier = -1.0}, 
                            {ModEffectClass = 'SFXGameEffect_WeaponMod_WeightBonus', ConversionMultiplier = -1.0}, 
                            {ModEffectClass = 'SFXGameEffect_WeaponMod_StabilityBonus', ConversionMultiplier = -1.0}
                           )
    Level = 1
    NotificationTitle = $546864
    NotificationDescription = $546865
    MAX_RANK = 5
    ToolTipText = ETargetTipText.TargetTipText_PickUp
    PickupFactoryMesh = PickupMesh
}