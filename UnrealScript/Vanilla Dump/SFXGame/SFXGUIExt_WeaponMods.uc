Class SFXGUIExt_WeaponMods extends SFXGUIMovieExtension within SFXGUIMovie
    config(UI);

struct ModAttachSoundInfo 
{
    var Name location;
    var Name Sound;
};
enum WeaponUIModSlot
{
    UIModSlot_1,
    UIModSlot_2,
};

var transient array<int> CurrentAllowedMods;
var config transient array<ModAttachSoundInfo> ModAttachSounds;
var transient LinearColor WeaponModBaseGripColor;
var transient LinearColor WeaponModBaseBodyColor;
var transient LinearColor WeaponModBaseEmissiveColor;
var transient int CurrentChosenMods[2];
var transient DynamicSMActor_Spawnable ModMeshActors[2];
var transient int CurrentMods[2];
var config transient Name ModifyColorSound;
var config transient Name DefaultAttachSound;
var GFxMovieInfo m_oModControlMovieInfo;
var GFxMovieInfo m_oModStatsMovieInfo;
var transient SFXGUI_WeaponSelection WeaponSelect;
var transient SFXWeaponUIDataManager DataManager;
var transient SFXSeqAct_LaunchWeaponSelection Kismet;
var transient SkeletalMeshActorSpawnable WeaponMeshActor;
var transient int CurrentModifyWeaponID;
var(WeaponSelect) SFXGUIMovie ModStatsDisplay;
var(WeaponSelect) SFXGUIMovie ModModsDisplay;
var transient float m_fPreviousMipLevelFadingValue;
var config transient stringref ModLeftButtonText;
var config transient stringref ModRightButtonText;
var config transient stringref ModifyWeaponText;
var config transient float MinDisplayBonus;
var config transient int MipFadingRestoreFrameDelay;
var transient int NumRemainingFramesToMipFadingRestore;
var transient bool ShowAllMods;
var transient bool m_bMonitorWeaponLoadIn;

public event function OnAdded()
{
    Super.OnAdded();
    WeaponSelect = SFXGUI_WeaponSelection(Outer);
    DataManager = WeaponSelect.DataManager;
    m_fPreviousMipLevelFadingValue = Class'SFXGame'.static.GetMipFadingValue();
}
public event function OnRemoved()
{
    ClearModVisualization(0);
    ClearModVisualization(1);
    if (ModStatsDisplay != None)
    {
        ModStatsDisplay.Close();
    }
    if (ModModsDisplay != None)
    {
        ModModsDisplay.Close();
    }
    if (WeaponMeshActor != None)
    {
        WeaponMeshActor.Destroy();
        WeaponMeshActor = None;
    }
    if (ModMeshActors[0] != None)
    {
        ModMeshActors[0].Destroy();
        ModMeshActors[0] = None;
    }
    if (ModMeshActors[1] != None)
    {
        ModMeshActors[1].Destroy();
        ModMeshActors[1] = None;
    }
    WeaponSelect.oWorldInfo.ForceGarbageCollection();
    Class'SFXGame'.static.SetMipFadingValue(m_fPreviousMipLevelFadingValue);
    Super.OnRemoved();
}
public final function Setup(TextureRenderTarget2D modStatsRT, TextureRenderTarget2D modControlRT)
{
    ModStatsDisplay = new (Self) Class'SFXGUIMovie';
    ModModsDisplay = new (Self) Class'SFXGUIMovie';
    if (ModStatsDisplay == None || ModModsDisplay == None)
    {
        return;
    }
    ModStatsDisplay.MovieInfo = m_oModStatsMovieInfo;
    ModStatsDisplay.RenderTexture = modStatsRT;
    ModStatsDisplay.m_bFocusOnStart = FALSE;
    ModStatsDisplay.bDisplayWithHudOff = TRUE;
    ModStatsDisplay.SetExternalInterface(Self);
    ModStatsDisplay.nZOrder = WeaponSelect.nZOrder - 2;
    ModStatsDisplay.Start(FALSE);
    ModStatsDisplay.SetFocus(FALSE);
    ModModsDisplay.MovieInfo = m_oModControlMovieInfo;
    ModModsDisplay.RenderTexture = modControlRT;
    ModModsDisplay.m_bFocusOnStart = FALSE;
    ModModsDisplay.m_bHandleKeyPresses = TRUE;
    ModModsDisplay.bDisplayWithHudOff = TRUE;
    ModModsDisplay.SetExternalInterface(Self);
    ModModsDisplay.nZOrder = WeaponSelect.nZOrder - 1;
    ModModsDisplay.Start(FALSE);
    ModModsDisplay.SetFocus(FALSE);
    AS_SetScreensVisible(FALSE);
    WeaponSelect.AS_SetWeaponAction(Outer.UIStrRef(ModifyWeaponText), "OpenModifyUIForWeapon");
}
public event function Update(float fDeltaT)
{
    if (m_bMonitorWeaponLoadIn)
    {
        MonitorWeaponLoadIn();
    }
    Super.Update(fDeltaT);
}
public final function ApplyCurrentWeaponMod()
{
    local Name nmWeaponClass;
    local Name nmModClass;
    local Name nmModClass1;
    local Name nmModClass2;
    local int nModLevel;
    local BioPawn oPawn;
    local SFXModule_WeaponModManager oModManager;
    local SFXInventoryManager oInvManager;
    local SFXWeapon oWeapon;
    local Class<SFXWeaponMod> oModClass;
    
    if (DataManager.WeaponIndexIsValid(CurrentModifyWeaponID) == FALSE)
    {
        return;
    }
    nmWeaponClass = Name(DataManager.WeaponUIData[CurrentModifyWeaponID].ClassPath);
    if (DataManager.ModIndexIsValid(CurrentChosenMods[0]))
    {
        nmModClass1 = Name(DataManager.ModUIData[CurrentChosenMods[0]].ClassPath);
    }
    if (DataManager.ModIndexIsValid(CurrentChosenMods[1]))
    {
        nmModClass2 = Name(DataManager.ModUIData[CurrentChosenMods[1]].ClassPath);
    }
    SaveWeaponMods(nmWeaponClass, nmModClass1, nmModClass2);
    oPawn = WeaponSelect.GetBioPawn(WeaponSelect.CurrentPawnID);
    oInvManager = oPawn == None ? None : SFXInventoryManager(oPawn.InvManager);
    if (oInvManager != None)
    {
        foreach oInvManager.InventoryActors(Class'SFXWeapon', oWeapon)
        {
            if (PathName(oWeapon.Class) != string(nmWeaponClass))
            {
                continue;
            }
            oModManager = oWeapon.GetModule(Class'SFXModule_WeaponModManager');
            if (oModManager != None)
            {
                oModManager.RemoveAllMods();
                if (DataManager.ModIndexIsValid(CurrentChosenMods[0]))
                {
                    nmModClass = Name(DataManager.ModUIData[CurrentChosenMods[0]].ClassPath);
                    oModClass = Class'SFXWeaponMod'.static.LoadModClass(string(nmModClass));
                    if (oModClass != None && oModClass.static.IsUnlocked(nModLevel))
                    {
                        oModManager.AddMod(oModClass, nModLevel);
                    }
                }
                if (DataManager.ModIndexIsValid(CurrentChosenMods[1]))
                {
                    nmModClass = Name(DataManager.ModUIData[CurrentChosenMods[1]].ClassPath);
                    oModClass = Class'SFXWeaponMod'.static.LoadModClass(string(nmModClass));
                    if (oModClass != None && oModClass.static.IsUnlocked(nModLevel))
                    {
                        oModManager.AddMod(oModClass, nModLevel);
                        continue;
                    }
                }
            }
        }
    }
    if (CurrentMods[0] != CurrentChosenMods[0] || CurrentMods[1] != CurrentChosenMods[1])
    {
        if (CurrentMods[0] != CurrentChosenMods[1] || CurrentMods[1] != CurrentChosenMods[0])
        {
            if (BioPlayerController(Outer.GetPC()) != None)
            {
                BioPlayerController(Outer.GetPC()).UnlockAccomplishment('WEAPONMOD');
            }
        }
    }
    CurrentMods[0] = CurrentChosenMods[0];
    CurrentMods[1] = CurrentChosenMods[1];
    WeaponSelect.SetWeaponModsDisplay(CurrentModifyWeaponID);
    WeaponSelect.SetWeaponStatsDisplay(CurrentModifyWeaponID);
    Outer.PlayGuiSound('WeaponGUIApply');
}
public final function AS_Mod_SetWeaponName(string sName)
{
    ModStatsDisplay.ActionScriptVoid("Main.SetName");
}
public final function AS_ModAddWeaponStat(string sName, float fValue, float fBonus, float fCompare)
{
    ModStatsDisplay.ActionScriptVoid("Main.AddWeaponStat");
}
public final function AS_ModClearWeaponStatsDisplay()
{
    ModStatsDisplay.ActionScriptVoid("Main.ClearWeaponStatsDisplay");
}
public final function AS_ModInitModDisplay()
{
    ModModsDisplay.ActionScriptVoid("Main.Initialize");
}
public final function AS_ModSetModDisplay(int nDisplay, string sName, string sImgPath, int nModIndex, int nLeftOption, int nRightOption, int nNumOptions)
{
    ModModsDisplay.ActionScriptVoid("Main.SetModDisplay");
}
public final function AS_ModSetModText(string sName, string sDesc)
{
    ModModsDisplay.ActionScriptVoid("Main.SetNameAndDescription");
}
public final function AS_SetScreensVisible(bool bVisible)
{
    ModStatsDisplay.ActionScriptVoid("Main.SetVisible");
    ModModsDisplay.ActionScriptVoid("Main.SetVisible");
}
public final function AttachModToWeapon(WeaponUIModSlot eModSlot)
{
    local SFXWeaponModData modData;
    
    if (WeaponMeshActor == None || WeaponMeshActor.SkeletalMeshComponent.SkeletalMesh == None)
    {
        return;
    }
    if (DataManager.ModIndexIsValid(CurrentChosenMods[int(eModSlot)]) == FALSE)
    {
        return;
    }
    modData = DataManager.ModUIData[CurrentChosenMods[int(eModSlot)]];
    ModMeshActors[int(eModSlot)].StaticMeshComponent.SetShadowParent(WeaponMeshActor.SkeletalMeshComponent);
    ModMeshActors[int(eModSlot)].StaticMeshComponent.SetLightEnvironment(WeaponMeshActor.SkeletalMeshComponent.LightEnvironment);
    ModMeshActors[int(eModSlot)].StaticMeshComponent.SetDepthPriorityGroup(WeaponMeshActor.SkeletalMeshComponent.DepthPriorityGroup);
    if (WeaponMeshActor.SkeletalMeshComponent.GetSocketByName(modData.SocketName) != None)
    {
        WeaponMeshActor.SkeletalMeshComponent.AttachComponentToSocket(ModMeshActors[int(eModSlot)].StaticMeshComponent, modData.SocketName);
        ModMeshActors[int(eModSlot)].StaticMeshComponent.SetHidden(FALSE);
    }
    else
    {
        ModMeshActors[int(eModSlot)].StaticMeshComponent.SetHidden(TRUE);
    }
    Outer.PlayGuiSound(GetModAttachSound(CurrentChosenMods[int(eModSlot)]));
}
public final function ChangeView()
{
    if (Kismet != None)
    {
        Outer.PlayGuiSound('WeaponMod-ChangeWeaponView');
        Kismet.ChangeView();
    }
}
public final function ClearModVisualization(WeaponUIModSlot eSlot)
{
    local SFXWeaponModData modData;
    local int nModIndex;
    
    nModIndex = CurrentChosenMods[int(eSlot)];
    if (DataManager.ModIndexIsValid(nModIndex) == FALSE)
    {
        return;
    }
    modData = DataManager.ModUIData[nModIndex];
    if (modData.MaterialEmissiveChange)
    {
        SetWeaponModEmissiveColor(-1);
    }
    if (modData.MaterialGripColorChange)
    {
        SetWeaponModGripColor(-1);
    }
    if (modData.MaterialBodyColorChange)
    {
        SetWeaponModBodyColor(-1);
    }
    if (ModMeshActors[int(eSlot)] != None)
    {
        WeaponMeshActor.SkeletalMeshComponent.DetachComponent(ModMeshActors[int(eSlot)].StaticMeshComponent);
    }
}
public final function ExitWeaponModUI(optional bool bForce, optional bool bFullShutdown = FALSE)
{
    ApplyCurrentWeaponMod();
    Outer.PlayGuiSound('WeaponGUIDone');
    AS_SetScreensVisible(FALSE);
    ModStatsDisplay.SetFocus(FALSE);
    ModModsDisplay.SetFocus(FALSE);
    if (Kismet != None)
    {
        if (!bFullShutdown)
        {
            Kismet.TransitionToWeaponSel();
        }
        else
        {
            WeaponSelect.Close();
        }
        if (Kismet.TableSkelMesh != None)
        {
            Kismet.TableSkelMesh.SkeletalMeshComponent.DetachComponent(WeaponMeshActor.SkeletalMeshComponent);
        }
    }
    if (!bFullShutdown)
    {
        WeaponSelect.UpdateWeaponEncumbranceDisplay();
        WeaponSelect.SetVisible(TRUE);
    }
    WeaponSelect.oWorldInfo.ForceGarbageCollection();
}
public final function Name GetModAttachSound(int nModIndex)
{
    local int nAttachSound;
    local SFXWeaponModData modData;
    
    if (DataManager.ModIndexIsValid(nModIndex))
    {
        modData = DataManager.ModUIData[nModIndex];
        for (nAttachSound = 0; nAttachSound < ModAttachSounds.Length; ++nAttachSound)
        {
            if (ModAttachSounds[nAttachSound].location == modData.SocketName)
            {
                return ModAttachSounds[nAttachSound].Sound;
            }
        }
    }
    return 'None';
}
public final function InitializeModModsDisplay()
{
    local array<Name> WeaponMods;
    local int nMod;
    local int nModDataIndex;
    
    if (ModModsDisplay == None)
    {
        return;
    }
    ModModsDisplay.SetMouseVisible(TRUE);
    ModModsDisplay.SetFocus(TRUE);
    if (DataManager.WeaponIndexIsValid(CurrentModifyWeaponID) == FALSE)
    {
        return;
    }
    CurrentAllowedMods = DataManager.GetModsForWeapon(CurrentModifyWeaponID, ShowAllMods);
    AS_ModSetModDisplay(1, Outer.UIStrRef(WeaponSelect.EmptyModSlotText), "", -1, -1, -1, CurrentAllowedMods.Length);
    AS_ModSetModDisplay(2, Outer.UIStrRef(WeaponSelect.EmptyModSlotText), "", -1, -1, -1, CurrentAllowedMods.Length);
    AS_ModSetModText("", "");
    WeaponMods = DataManager.GetCurrentWeaponMods(CurrentModifyWeaponID, WeaponSelect.GetCurrentHenchTag());
    for (nMod = 0; nMod < 2; ++nMod)
    {
        CurrentMods[nMod] = -1;
        CurrentChosenMods[nMod] = -1;
    }
    for (nMod = 0; nMod < WeaponMods.Length && nMod < 2; ++nMod)
    {
        DataManager.GetWeaponModUIDataFromClassName(WeaponMods[nMod], nModDataIndex);
        if (nModDataIndex != -1)
        {
            CurrentMods[nMod] = nModDataIndex;
            CurrentChosenMods[nMod] = nModDataIndex;
        }
    }
    UpdateModUIModsDisplays();
    AS_ModInitModDisplay();
    if (CurrentChosenMods[0] != -1)
    {
        ModUIDisplayModInfoFromModIndex(CurrentChosenMods[0]);
    }
    else if (CurrentChosenMods[1] != -1)
    {
        ModUIDisplayModInfoFromModIndex(CurrentChosenMods[1]);
    }
}
public final function InitializeModStatsDisplay()
{
    local string PrettyWeaponName;
    
    if (ModStatsDisplay == None)
    {
        return;
    }
    if (DataManager.WeaponIndexIsValid(CurrentModifyWeaponID) == FALSE)
    {
        return;
    }
    SetCustomToken(0, Class'SFXWeaponUIDataManager'.static.GetRomanNumeral(DataManager.WeaponUIData[CurrentModifyWeaponID].Level));
    PrettyWeaponName = Outer.GetUIString(DataManager.WeaponUIData[CurrentModifyWeaponID].Name, TRUE);
    ClearCustomTokens();
    AS_Mod_SetWeaponName(PrettyWeaponName);
    UpdateWeaponModStatsDisplay(CurrentModifyWeaponID);
    ModStatsDisplay.SetFocus(TRUE);
}
public final function ModMeshLoaded(WeaponUIModSlot eModSlot)
{
    local Name nmLoadRequestName;
    local SFXEngine oEngine;
    local array<Object> aAssets;
    local StaticMesh oMesh;
    local int nIndex;
    
    oEngine = SFXEngine(Class'Engine'.static.GetEngine());
    if (oEngine == None)
    {
        return;
    }
    if (WeaponMeshActor == None)
    {
        return;
    }
    if (DataManager.ModIndexIsValid(CurrentChosenMods[int(eModSlot)]) == FALSE)
    {
        return;
    }
    nmLoadRequestName = eModSlot == WeaponUIModSlot.UIModSlot_1 ? 'WeaponModSlot1MeshData' : 'WeaponModSlot2MeshData';
    if (oEngine.AsyncAssetLoader.IsAsyncGroupLoaded(nmLoadRequestName) == FALSE)
    {
        return;
    }
    if (ModMeshActors[int(eModSlot)] == None)
    {
        ModMeshActors[int(eModSlot)] = Outer.GetPC().Spawn(Class'DynamicSMActor_Spawnable', Outer.GetPC());
        if (ModMeshActors[int(eModSlot)] == None)
        {
            return;
        }
    }
    oEngine.AsyncAssetLoader.GetAssetsForGroup(nmLoadRequestName, aAssets);
    for (nIndex = 0; nIndex < aAssets.Length; ++nIndex)
    {
        oMesh = StaticMesh(aAssets[nIndex]);
        if (oMesh != None)
        {
            break;
        }
    }
    if (oMesh == None)
    {
        return;
    }
    ModMeshActors[int(eModSlot)].StaticMeshComponent.SetStaticMesh(oMesh);
    ModMeshActors[int(eModSlot)].PrestreamTextures(0.0, TRUE, 0);
    AttachModToWeapon(eModSlot);
    oEngine.AsyncAssetLoader.ClearAsyncGroup(nmLoadRequestName);
}
public final function ModUIDisplayModInfo(int nCurrentModIndex)
{
    if (nCurrentModIndex >= 0 && nCurrentModIndex < CurrentAllowedMods.Length)
    {
        ModUIDisplayModInfoFromModIndex(CurrentAllowedMods[nCurrentModIndex]);
    }
    else
    {
        ModUIDisplayModInfoFromModIndex(-1);
    }
}
public final function ModUIDisplayModInfoFromModIndex(int nModIndex)
{
    if (DataManager.ModIndexIsValid(nModIndex))
    {
        AS_ModSetModText(DataManager.GetModDisplayName(nModIndex), DataManager.GetModDescription(nModIndex));
    }
    else
    {
        AS_ModSetModText("", "");
    }
}
public final function ModUISelectMod(int nDisplay, int nDesiredModIndex)
{
    local WeaponUIModSlot eModSlot;
    
    if (nDisplay < 0 || nDisplay > 2)
    {
        return;
    }
    eModSlot = byte(nDisplay - 1);
    if (nDesiredModIndex != -1)
    {
        if (nDesiredModIndex < 0 || nDesiredModIndex >= CurrentAllowedMods.Length)
        {
            return;
        }
    }
    ClearModVisualization(eModSlot);
    CurrentChosenMods[int(eModSlot)] = nDesiredModIndex != -1 ? CurrentAllowedMods[nDesiredModIndex] : -1;
    UpdateModUIModsDisplays();
    ModUIDisplayModInfo(nDesiredModIndex);
    UpdateWeaponModStatsDisplay(CurrentModifyWeaponID);
    UpdateModVisualization(eModSlot);
    Outer.PlayGuiSound('WeaponGUIModSelectAcross');
}
public final function MonitorWeaponLoadIn()
{
    if (WeaponMeshActor != None)
    {
        --NumRemainingFramesToMipFadingRestore;
        if (NumRemainingFramesToMipFadingRestore > 0)
        {
            return;
        }
        WeaponMeshActor.SkeletalMeshComponent.SetHidden(FALSE);
        m_bMonitorWeaponLoadIn = FALSE;
        Outer.PlayGuiSound('WeaponMod-WeaponVisible');
    }
}
public final function OnWeaponMeshLoaded()
{
    local Vector vSpawnLocation;
    local array<Object> aAssets;
    local SFXEngine oEngine;
    local int nAsset;
    local AnimTree oAnimTree;
    local SkeletalMesh oSkelMesh;
    local SkeletalMeshComponent oTableMesh;
    local MaterialInstance MatInst;
    
    oEngine = SFXEngine(Class'Engine'.static.GetEngine());
    if (oEngine == None)
    {
        return;
    }
    if (Kismet == None || Kismet.TableSkelMesh == None || Kismet.TableSocket == 'None')
    {
        return;
    }
    if (WeaponMeshActor == None)
    {
        if (Kismet != None)
        {
            vSpawnLocation = Kismet.TableSkelMesh.location;
        }
        else
        {
            vSpawnLocation = Outer.GetPC().Pawn.location;
        }
        WeaponMeshActor = Outer.GetPC().Spawn(Class'SkeletalMeshActorSpawnable', Outer.GetPC(), 'WeaponMeshActor', vSpawnLocation);
    }
    if (WeaponMeshActor == None)
    {
        return;
    }
    oEngine.AsyncAssetLoader.GetAssetsForGroup('WeaponUIMeshData', aAssets);
    if (aAssets.Length == 0)
    {
        return;
    }
    for (nAsset = 0; nAsset < aAssets.Length; ++nAsset)
    {
        if (oSkelMesh == None)
        {
            oSkelMesh = SkeletalMesh(aAssets[nAsset]);
            if (oSkelMesh != None)
            {
                continue;
            }
        }
        if (oAnimTree == None)
        {
            oAnimTree = AnimTree(aAssets[nAsset]);
            if (oAnimTree != None)
            {
                continue;
            }
        }
        if (AnimSet(aAssets[nAsset]) != None)
        {
            continue;
        }
    }
    oTableMesh = Kismet.TableSkelMesh.SkeletalMeshComponent;
    WeaponMeshActor.SkeletalMeshComponent.SetHidden(TRUE);
    WeaponMeshActor.SkeletalMeshComponent.SetSkeletalMesh(oSkelMesh);
    WeaponMeshActor.SkeletalMeshComponent.SetShadowParent(oTableMesh);
    WeaponMeshActor.SkeletalMeshComponent.SetLightEnvironment(oTableMesh.LightEnvironment);
    WeaponMeshActor.SkeletalMeshComponent.SetDepthPriorityGroup(oTableMesh.DepthPriorityGroup);
    if (oTableMesh.GetSocketByName(Kismet.TableSocket) != None)
    {
        oTableMesh.AttachComponentToSocket(WeaponMeshActor.SkeletalMeshComponent, Kismet.TableSocket);
    }
    else
    {
        WeaponMeshActor.SetLocation(Kismet.TableSkelMesh.location, );
        WeaponMeshActor.SetRotation(Kismet.TableSkelMesh.Rotation);
    }
    m_bMonitorWeaponLoadIn = TRUE;
    NumRemainingFramesToMipFadingRestore = MipFadingRestoreFrameDelay;
    Class'SFXGame'.static.SetMipFadingValue(-1.0);
    WeaponMeshActor.PrestreamTextures(5.0, TRUE, 0);
    Class'SFXGame'.static.UpdateResourceStreaming(0.100000001);
    oEngine.AsyncAssetLoader.ClearAsyncGroup('WeaponUIMeshData');
    if (WeaponMeshActor.SkeletalMeshComponent != None)
    {
        MatInst = None;
        if (WeaponMeshActor.SkeletalMeshComponent.Materials.Length > 0)
        {
            MatInst = MaterialInstance(WeaponMeshActor.SkeletalMeshComponent.Materials[0]);
        }
        if (MatInst != None)
        {
            MatInst.SetParent(oSkelMesh.Materials[0]);
            MatInst = MaterialInstance(oSkelMesh.Materials[0]);
        }
        else
        {
            MatInst = WeaponMeshActor.SkeletalMeshComponent.CreateAndSetMaterialInstanceConstant(0);
        }
        if (MatInst != None)
        {
            MatInst.GetVectorParameterValue('Grip_Colour', WeaponModBaseGripColor);
            MatInst.GetVectorParameterValue('Body_Colour', WeaponModBaseBodyColor);
            MatInst.GetVectorParameterValue('Light_Colour', WeaponModBaseEmissiveColor);
            SetWeaponMaterialColorParameter('Grip_Colour', WeaponModBaseGripColor);
            SetWeaponMaterialColorParameter('Body_Colour', WeaponModBaseBodyColor);
            SetWeaponMaterialColorParameter('Light_Colour', WeaponModBaseEmissiveColor);
        }
    }
    ClearModVisualization(0);
    ClearModVisualization(1);
    UpdateModVisualization(0);
    UpdateModVisualization(1);
}
public final function OnWeaponModSlot1MeshLoaded()
{
    ModMeshLoaded(0);
}
public final function OnWeaponModSlot2MeshLoaded()
{
    ModMeshLoaded(1);
}
public final function OpenModifyUIForWeapon()
{
    CurrentModifyWeaponID = WeaponSelect.InWeaponSelection == TRUE ? WeaponSelect.CurrentlySelectedSelectionWeapon : WeaponSelect.CurrentlySelectedLoadoutWeapon;
    if (WeaponSelect.DataManager.WeaponIndexIsValid(CurrentModifyWeaponID) == FALSE)
    {
        Outer.PlayGuiError();
        return;
    }
    InitializeModModsDisplay();
    InitializeModStatsDisplay();
    AS_SetScreensVisible(TRUE);
    UpdateWeaponMeshDisplay(CurrentModifyWeaponID);
    WeaponSelect.SetVisible(FALSE);
    if (Kismet != None)
    {
        Kismet.TransitionToWeaponMod();
    }
    Outer.PlayGuiSound('WeaponGUIModify');
}
public final function SaveWeaponMods(Name nmWeaponClass, Name nmModClass1, Name nmModClass2)
{
    local SFXEngine oEngine;
    local int nHenchIndex;
    local int nWeapMod;
    local BioPawn pPawn;
    local int nIndex;
    
    oEngine = SFXEngine(Class'Engine'.static.GetEngine());
    if (oEngine == None)
    {
        return;
    }
    if (WeaponSelect.CurrentPawnID == -1)
    {
        for (nWeapMod = 0; nWeapMod < oEngine.PlayerWeaponMods.Length; ++nWeapMod)
        {
            if (oEngine.PlayerWeaponMods[nWeapMod].WeaponClassName == nmWeaponClass)
            {
                break;
            }
        }
        if (nWeapMod == oEngine.PlayerWeaponMods.Length)
        {
            oEngine.PlayerWeaponMods.Length = oEngine.PlayerWeaponMods.Length + 1;
            oEngine.PlayerWeaponMods[nWeapMod].WeaponClassName = nmWeaponClass;
        }
        oEngine.PlayerWeaponMods[nWeapMod].WeaponModClassNames.Length = 0;
        if (nmModClass1 != 'None')
        {
            oEngine.PlayerWeaponMods[nWeapMod].WeaponModClassNames.AddItem(nmModClass1);
        }
        if (nmModClass2 != 'None')
        {
            oEngine.PlayerWeaponMods[nWeapMod].WeaponModClassNames.AddItem(nmModClass2);
        }
    }
    else
    {
        pPawn = WeaponSelect.GetBioPawn(WeaponSelect.CurrentPawnID);
        if (pPawn == None)
        {
            return;
        }
        nHenchIndex = -1;
        oEngine.CurrentSaveGame.EnsureHenchmanRecordExists(SFXPawn_Henchman(pPawn));
        for (nIndex = 0; nIndex < oEngine.HenchmanRecords.Length; nIndex++)
        {
            if (pPawn.Tag == oEngine.HenchmanRecords[nIndex].Tag)
            {
                nHenchIndex = nIndex;
                break;
            }
        }
        if (nHenchIndex == -1)
        {
            return;
        }
        for (nWeapMod = 0; nWeapMod < oEngine.HenchmanRecords[nHenchIndex].WeaponMods.Length; ++nWeapMod)
        {
            if (oEngine.HenchmanRecords[nHenchIndex].WeaponMods[nWeapMod].WeaponClassName == nmWeaponClass)
            {
                break;
            }
        }
        if (nWeapMod == oEngine.HenchmanRecords[nHenchIndex].WeaponMods.Length)
        {
            oEngine.HenchmanRecords[nHenchIndex].WeaponMods.Length = oEngine.HenchmanRecords[nHenchIndex].WeaponMods.Length + 1;
            oEngine.HenchmanRecords[nHenchIndex].WeaponMods[nWeapMod].WeaponClassName = nmWeaponClass;
        }
        oEngine.HenchmanRecords[nHenchIndex].WeaponMods[nWeapMod].WeaponModClassNames.Length = 0;
        if (nmModClass1 != 'None')
        {
            oEngine.HenchmanRecords[nHenchIndex].WeaponMods[nWeapMod].WeaponModClassNames.AddItem(nmModClass1);
        }
        if (nmModClass2 != 'None')
        {
            oEngine.HenchmanRecords[nHenchIndex].WeaponMods[nWeapMod].WeaponModClassNames.AddItem(nmModClass2);
        }
    }
}
public final function SetWeaponMaterialColorParameter(Name nmParam, LinearColor Clr)
{
    local MaterialInterface MatInt;
    local MaterialInstance MatInstance;
    
    foreach WeaponMeshActor.SkeletalMeshComponent.Materials(MatInt, )
    {
        MatInstance = MaterialInstance(MatInt);
        if (MatInstance != None)
        {
            MatInstance.SetVectorParameterValue(nmParam, Clr);
        }
    }
}
public final function SetWeaponModBodyColor(int nLevel)
{
    local LinearColor clrBody;
    local SFXWeaponSelectWeaponData oWeapData;
    
    if (DataManager.WeaponIndexIsValid(CurrentModifyWeaponID) == FALSE)
    {
        return;
    }
    oWeapData = DataManager.WeaponUIData[CurrentModifyWeaponID];
    clrBody = WeaponModBaseBodyColor;
    nLevel = Clamp(nLevel, 0, oWeapData.WeaponModBodyColors.Length);
    if (nLevel > 0)
    {
        --nLevel;
        clrBody = oWeapData.WeaponModBodyColors[nLevel];
    }
    SetWeaponMaterialColorParameter('Body_Colour', clrBody);
}
public final function SetWeaponModEmissiveColor(int nLevel)
{
    local LinearColor clrEmissive;
    local SFXWeaponSelectWeaponData oWeapData;
    
    if (DataManager.WeaponIndexIsValid(CurrentModifyWeaponID) == FALSE)
    {
        return;
    }
    oWeapData = DataManager.WeaponUIData[CurrentModifyWeaponID];
    clrEmissive = WeaponModBaseEmissiveColor;
    nLevel = Clamp(nLevel, 0, oWeapData.WeaponModEmissiveValues.Length);
    if (nLevel > 0)
    {
        --nLevel;
        clrEmissive = oWeapData.WeaponModEmissiveValues[nLevel];
    }
    SetWeaponMaterialColorParameter('Light_Colour', clrEmissive);
}
public final function SetWeaponModGripColor(int nLevel)
{
    local LinearColor clrGrip;
    local SFXWeaponSelectWeaponData oWeapData;
    
    if (DataManager.WeaponIndexIsValid(CurrentModifyWeaponID) == FALSE)
    {
        return;
    }
    oWeapData = DataManager.WeaponUIData[CurrentModifyWeaponID];
    clrGrip = WeaponModBaseGripColor;
    nLevel = Clamp(nLevel, 0, oWeapData.WeaponModGripColors.Length);
    if (nLevel > 0)
    {
        --nLevel;
        clrGrip = oWeapData.WeaponModGripColors[nLevel];
    }
    SetWeaponMaterialColorParameter('Grip_Colour', clrGrip);
}
public final function UpdateModMeshDisplay(WeaponUIModSlot eModSlot, optional int nLevel)
{
    local SFXEngine oEngine;
    local SFXAsyncAssetRequest request;
    local array<SFXAsyncAssetRequest> aRequests;
    local int nModIndex;
    local Name nmLoadRequestName;
    local SFXWeaponModData modData;
    local int nIndex;
    
    nmLoadRequestName = eModSlot == WeaponUIModSlot.UIModSlot_1 ? 'WeaponModSlot1MeshData' : 'WeaponModSlot2MeshData';
    oEngine = SFXEngine(Class'Engine'.static.GetEngine());
    if (oEngine == None)
    {
        return;
    }
    oEngine.AsyncAssetLoader.ClearAsyncGroup(nmLoadRequestName);
    if (WeaponMeshActor == None)
    {
        return;
    }
    if (ModMeshActors[int(eModSlot)] != None)
    {
        WeaponMeshActor.SkeletalMeshComponent.DetachComponent(ModMeshActors[int(eModSlot)].StaticMeshComponent);
    }
    nModIndex = CurrentChosenMods[int(eModSlot)];
    if (DataManager.ModIndexIsValid(nModIndex) == FALSE)
    {
        return;
    }
    modData = DataManager.ModUIData[nModIndex];
    if (modData.Meshes.Length == 0)
    {
        return;
    }
    if (nLevel == 0)
    {
        nLevel = modData.Level;
    }
    if (nLevel == 0)
    {
        nLevel = 1;
    }
    for (nIndex = nLevel - 1; nIndex >= 0 && nIndex < modData.Meshes.Length; --nIndex)
    {
        if (modData.Meshes[nIndex] != "")
        {
            break;
        }
    }
    if (nIndex < 0)
    {
        return;
    }
    if (ModMeshActors[int(eModSlot)] != None && PathName(ModMeshActors[int(eModSlot)].StaticMeshComponent.StaticMesh) == modData.Meshes[nIndex])
    {
        AttachModToWeapon(eModSlot);
        return;
    }
    request.AltCookedPackageName = Name(modData.CookedPackage);
    request.FullAssetPath = modData.Meshes[nIndex];
    request.AssetClass = Class'StaticMesh';
    aRequests.AddItem(request);
    oEngine.AsyncAssetLoader.AsyncLoadAssets(nmLoadRequestName, aRequests, eModSlot == WeaponUIModSlot.UIModSlot_1 ? OnWeaponModSlot1MeshLoaded : OnWeaponModSlot2MeshLoaded);
}
public final function UpdateModUIModsDisplay(int nDisplay, int nOtherIndex)
{
    local int nIndex;
    local int nModIndex;
    local string sImagePath;
    local Texture2D Image;
    local string sName;
    local int nLeftOption;
    local int nRightOption;
    local int nIdx;
    local EWeaponModCategory eModCategory;
    local EWeaponModCategory eOtherModCategory;
    
    if (nDisplay < 0 || nDisplay >= 2)
    {
        return;
    }
    nIndex = CurrentChosenMods[nDisplay];
    nIndex = nIndex != -1 ? CurrentAllowedMods.Find(nIndex) : -1;
    nOtherIndex = nOtherIndex != -1 ? CurrentAllowedMods.Find(nOtherIndex) : -1;
    sImagePath = "";
    sName = Outer.UIStrRef(WeaponSelect.EmptyModSlotText);
    nLeftOption = -1;
    nRightOption = -1;
    eModCategory = EWeaponModCategory.WModCategory_Uncategorized;
    eOtherModCategory = EWeaponModCategory.WModCategory_Uncategorized;
    if (nIndex != -1)
    {
        nModIndex = CurrentAllowedMods[nIndex];
        Image = DataManager.ModUIData[nModIndex].Image;
        sImagePath = Image == None ? "" : PathName(Image);
        sName = DataManager.GetModDisplayName(nModIndex);
    }
    if (nOtherIndex != -1 && DataManager.ModIndexIsValid(CurrentAllowedMods[nOtherIndex]))
    {
        eOtherModCategory = DataManager.ModUIData[CurrentAllowedMods[nOtherIndex]].ModCategory;
    }
    for (nIdx = nIndex + 1; nIdx < CurrentAllowedMods.Length; ++nIdx)
    {
        eModCategory = DataManager.ModUIData[CurrentAllowedMods[nIdx]].ModCategory;
        if (nIdx != nOtherIndex && (eModCategory == EWeaponModCategory.WModCategory_Uncategorized || int(eModCategory) != int(eOtherModCategory)))
        {
            nRightOption = nIdx;
            break;
        }
    }
    if (nIndex != -1)
    {
        for (nIdx = nIndex - 1; nIdx >= 0; --nIdx)
        {
            eModCategory = DataManager.ModUIData[CurrentAllowedMods[nIdx]].ModCategory;
            if (nIdx != nOtherIndex && (eModCategory == EWeaponModCategory.WModCategory_Uncategorized || int(eModCategory) != int(eOtherModCategory)))
            {
                nLeftOption = nIdx;
                break;
            }
        }
    }
    AS_ModSetModDisplay(nDisplay + 1, sName, sImagePath, nIndex, nLeftOption, nRightOption, CurrentAllowedMods.Length);
}
public final function UpdateModUIModsDisplays()
{
    UpdateModUIModsDisplay(0, CurrentChosenMods[1]);
    UpdateModUIModsDisplay(1, CurrentChosenMods[0]);
}
public final function UpdateModVisualization(WeaponUIModSlot eSlot)
{
    local SFXWeaponModData modData;
    local int nModIndex;
    local bool bMaterialParamChanged;
    local int nLevel;
    
    nModIndex = CurrentChosenMods[int(eSlot)];
    if (DataManager.ModIndexIsValid(nModIndex) == FALSE)
    {
        return;
    }
    modData = DataManager.ModUIData[nModIndex];
    nLevel = modData.Level;
    if (nLevel == 0)
    {
        nLevel = 1;
    }
    UpdateModMeshDisplay(eSlot, nLevel);
    if (modData.MaterialEmissiveChange)
    {
        SetWeaponModEmissiveColor(nLevel);
        bMaterialParamChanged = TRUE;
    }
    if (modData.MaterialGripColorChange)
    {
        SetWeaponModGripColor(nLevel);
        bMaterialParamChanged = TRUE;
    }
    if (modData.MaterialBodyColorChange)
    {
        SetWeaponModBodyColor(nLevel);
        bMaterialParamChanged = TRUE;
    }
    if (bMaterialParamChanged)
    {
        Outer.PlayGuiSound(ModifyColorSound);
    }
    if (GetModAttachSound(nModIndex) == 'None')
    {
        Outer.PlayGuiSound(DefaultAttachSound);
    }
}
public final function UpdateWeaponMeshDisplay(int nWeapIndex)
{
    local SFXEngine oEngine;
    local SFXAsyncAssetRequest request;
    local array<SFXAsyncAssetRequest> aRequests;
    local SFXWeaponSelectWeaponData weapData;
    local int nAnimSet;
    
    oEngine = SFXEngine(Class'Engine'.static.GetEngine());
    if (oEngine == None)
    {
        return;
    }
    if (DataManager.WeaponIndexIsValid(nWeapIndex) == FALSE)
    {
        return;
    }
    weapData = DataManager.WeaponUIData[nWeapIndex];
    request.AltCookedPackageName = Name(weapData.CookData.CookedPackage);
    request.FullAssetPath = weapData.CookData.Mesh;
    request.AssetClass = Class'SkeletalMesh';
    aRequests.AddItem(request);
    request.FullAssetPath = weapData.CookData.AnimTree;
    request.AssetClass = Class'AnimTree';
    aRequests.AddItem(request);
    for (nAnimSet = 0; nAnimSet < weapData.CookData.AnimSets.Length; ++nAnimSet)
    {
        request.FullAssetPath = weapData.CookData.AnimSets[nAnimSet];
        request.AssetClass = Class'AnimSet';
        aRequests.AddItem(request);
    }
    oEngine.AsyncAssetLoader.AsyncLoadAssets('WeaponUIMeshData', aRequests, OnWeaponMeshLoaded);
}
public final function UpdateWeaponModStatsDisplay(int nWeapIndex)
{
    local SFXWeaponUIStats oModValues;
    local SFXWeaponUIStats oTempModValues;
    local SFXWeaponUIStats oBaseWeaponModValues;
    local SFXWeaponUIStats oBaseWeaponDisplayValues;
    local bool bHaveModValues;
    local float fValue;
    local float fBonus;
    
    AS_ModClearWeaponStatsDisplay();
    if (DataManager.WeaponIndexIsValid(nWeapIndex) == FALSE)
    {
        return;
    }
    oBaseWeaponModValues = DataManager.GetWeaponModValues(nWeapIndex, WeaponSelect.GetCurrentHenchTag());
    oBaseWeaponDisplayValues.Accuracy = DataManager.GetWeaponUIStatValue(nWeapIndex, 0, oBaseWeaponModValues, FALSE);
    oBaseWeaponDisplayValues.Damage = DataManager.GetWeaponUIStatValue(nWeapIndex, 1, oBaseWeaponModValues, FALSE);
    oBaseWeaponDisplayValues.FireRate = DataManager.GetWeaponUIStatValue(nWeapIndex, 2, oBaseWeaponModValues, FALSE);
    oBaseWeaponDisplayValues.Magazine = DataManager.GetWeaponUIStatValue(nWeapIndex, 3, oBaseWeaponModValues, FALSE);
    oBaseWeaponDisplayValues.Weight = DataManager.GetWeaponUIStatValue(nWeapIndex, 4, oBaseWeaponModValues, FALSE);
    if (CurrentChosenMods[0] != -1 && DataManager.ModIndexIsValid(CurrentChosenMods[0]))
    {
        oModValues = DataManager.GetModStatsForLevel(DataManager.ModUIData[CurrentChosenMods[0]]);
        bHaveModValues = TRUE;
    }
    if (CurrentChosenMods[1] != -1 && DataManager.ModIndexIsValid(CurrentChosenMods[1]))
    {
        oTempModValues = DataManager.GetModStatsForLevel(DataManager.ModUIData[CurrentChosenMods[1]]);
        if (bHaveModValues)
        {
            oModValues.Accuracy += oTempModValues.Accuracy;
            oModValues.Damage += oTempModValues.Damage;
            oModValues.FireRate += oTempModValues.FireRate;
            oModValues.Magazine += oTempModValues.Magazine;
            oModValues.Weight += oTempModValues.Weight;
        }
        else
        {
            oModValues = oTempModValues;
            bHaveModValues = TRUE;
        }
    }
    if (!bHaveModValues)
    {
        AS_ModAddWeaponStat(Outer.UIStrRef(DataManager.StatNameAccuracy), oBaseWeaponDisplayValues.Accuracy, -1.0, oBaseWeaponDisplayValues.Accuracy);
        AS_ModAddWeaponStat(Outer.UIStrRef(DataManager.StatNameDamage), oBaseWeaponDisplayValues.Damage, -1.0, oBaseWeaponDisplayValues.Damage);
        AS_ModAddWeaponStat(Outer.UIStrRef(DataManager.StatNameFireRate), oBaseWeaponDisplayValues.FireRate, -1.0, oBaseWeaponDisplayValues.FireRate);
        AS_ModAddWeaponStat(Outer.UIStrRef(DataManager.StatNameMagSize), oBaseWeaponDisplayValues.Magazine, -1.0, oBaseWeaponDisplayValues.Magazine);
        AS_ModAddWeaponStat(Outer.UIStrRef(DataManager.StatNameWeight), oBaseWeaponDisplayValues.Weight, -1.0, oBaseWeaponDisplayValues.Weight);
    }
    else
    {
        fValue = DataManager.GetWeaponUIStatValue(nWeapIndex, 0, oModValues, FALSE, fBonus);
        AS_ModAddWeaponStat(Outer.UIStrRef(DataManager.StatNameAccuracy), fValue, fBonus > 0.0 ? FMax(fBonus, MinDisplayBonus) : 0.0, oBaseWeaponDisplayValues.Accuracy);
        fValue = DataManager.GetWeaponUIStatValue(nWeapIndex, 1, oModValues, FALSE, fBonus);
        AS_ModAddWeaponStat(Outer.UIStrRef(DataManager.StatNameDamage), fValue, fBonus > 0.0 ? FMax(fBonus, MinDisplayBonus) : 0.0, oBaseWeaponDisplayValues.Damage);
        fValue = DataManager.GetWeaponUIStatValue(nWeapIndex, 2, oModValues, FALSE, fBonus);
        AS_ModAddWeaponStat(Outer.UIStrRef(DataManager.StatNameFireRate), fValue, fBonus > 0.0 ? FMax(fBonus, MinDisplayBonus) : 0.0, oBaseWeaponDisplayValues.FireRate);
        fValue = DataManager.GetWeaponUIStatValue(nWeapIndex, 3, oModValues, FALSE, fBonus);
        AS_ModAddWeaponStat(Outer.UIStrRef(DataManager.StatNameMagSize), fValue, fBonus > 0.0 ? FMax(fBonus, MinDisplayBonus) : 0.0, oBaseWeaponDisplayValues.Magazine);
        fValue = DataManager.GetWeaponUIStatValue(nWeapIndex, 4, oModValues, FALSE, fBonus);
        AS_ModAddWeaponStat(Outer.UIStrRef(DataManager.StatNameWeight), fValue, fBonus > 0.0 ? FMax(fBonus, MinDisplayBonus) : 0.0, oBaseWeaponDisplayValues.Weight);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ModAttachSounds = ({location = 'Scope', Sound = 'WeaponGUIMod-Attach-Scope'}, 
                       {location = 'Barrel', Sound = 'WeaponGUIMod-Attach-Barrel'}, 
                       {location = 'Laser', Sound = 'WeaponGUIMod-Attach-Laser'}, 
                       {location = 'Blade', Sound = 'WeaponGUIMod-Attach-Blade'}
                      )
    WeaponModBaseGripColor = {R = 0.0, G = 0.0, B = 0.0, A = 1.0}
    WeaponModBaseBodyColor = {R = 0.0, G = 0.0, B = 0.0, A = 1.0}
    WeaponModBaseEmissiveColor = {R = 0.0, G = 0.0, B = 0.0, A = 1.0}
    ModifyColorSound = 'WeaponGUIMod-ModifyColor'
    DefaultAttachSound = 'WeaponGUIMod-DefaultAttach'
    m_oModControlMovieInfo = GFxMovieInfo'GUI_SF_WeaponModMods.WeaponModMods'
    m_oModStatsMovieInfo = GFxMovieInfo'GUI_SF_WeaponModStats.WeaponModStats'
    ModLeftButtonText = $724574
    ModRightButtonText = $328909
    ModifyWeaponText = $600213
    MinDisplayBonus = 3.0
    MipFadingRestoreFrameDelay = 10
}