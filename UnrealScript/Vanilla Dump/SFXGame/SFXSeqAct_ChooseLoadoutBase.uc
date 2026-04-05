Class SFXSeqAct_ChooseLoadoutBase extends SeqAct_Latent;

var transient array<BioSFHandler_ChoiceGUI> MenuStack;
var array<Class<SFXWeaponMod>> ModMenu_ModClasses;
var string ShepardImage;
var transient array<Class<SFXWeapon>> LoadoutWeapons;
var transient array<LoadoutWeaponInfo> SubMenuEnabledWeapons;
var transient array<Name> AvailableHenchmen;
var transient array<int> WeaponMenuEnabledWeaponIDs;
var delegate<OnFinished> __OnFinished__Delegate;
var Class<SFXWeapon> ModMenu_WeaponClass;
var transient int SubMenuWeaponIdx;
var stringref srButtonText_Choose;
var stringref srButtonText_Exit;
var stringref srButtonText_SquadWeapons;
var stringref srButtonText_CustomizeSquadWeapons;
var stringref srButtonText_CustomizeWeapons;
var stringref srButtonText_Accept;
var stringref srButtonText_Back;
var stringref srWeaponMenuSubHeading;
var stringref srLeftBracketToken;
var stringref srRightBracketToken;
var stringref srWeaponClassTokenString;
var stringref srClassDescriptionTokenString;
var stringref srPawnActiveWeaponsString;
var stringref srShepardNameString;
var stringref srSingleCustomToken;
var stringref srWeaponDescriptionTokenString;
var stringref srModsEntryName;
var stringref srModsEntryDescription;
var stringref srModsMenuSubTitle;
var stringref srModsSubMenuSubTitle;
var stringref srSingleCustomToken_0;
var stringref srSingleCustomToken_1;
var stringref srSingleCustomToken_2;
var stringref srModTokenizedName;
var stringref srModAttachDetach;
var stringref srModInstalled;
var int ModsTopMenuIndex;
var int ModsSelectedWeapon;
var stringref srWeaponGroupEntryName;
var stringref srWeaponGroupEntryDescription;
var stringref srWeaponGroupTokenizedName;
var stringref srWeaponGroupActive;
var stringref srWeaponGroupRequired;
var stringref srWeaponGroupSubTitle;
var int WeaponGroupSelection;
var WwiseEvent WeaponEquipSound;
var transient int CurrentPawn;
var transient bool m_bFinished;
var transient bool m_bAllHenchmen;

public function Activated()
{
    local int idx;
    local BioGlobalVariableTable VarTable;
    local BioPlayerController PC;
    local SFXEngine Engine;
    local HenchmanInfoStruct HenchInfo;
    
    PC = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController();
    if (PC != None)
    {
        PC.GameModeManager2.EnableMode(9, 'ChoiceGUI');
    }
    Engine = SFXEngine(PC.Player.Outer);
    RefillAmmo();
    VarTable = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetGlobalVariables();
    m_bFinished = FALSE;
    OutputLinks[0].bHasImpulse = FALSE;
    AvailableHenchmen.Length = 0;
    AvailableHenchmen.AddItem('None');
    for (idx = 0; idx < Class'SFXPawn_Henchman'.default.HenchmenInfo.Length; idx++)
    {
        HenchInfo = Class'SFXPawn_Henchman'.default.HenchmenInfo[idx];
        if (m_bAllHenchmen)
        {
            if (!VarTable.GetBool(HenchInfo.HenchAcquiredPlotID))
            {
                continue;
            }
        }
        else if (!VarTable.GetBool(HenchInfo.HenchInSquadPlotID))
        {
            continue;
        }
        PrepareHenchmanRecords(HenchInfo.Tag);
        AvailableHenchmen.AddItem(HenchInfo.className);
    }
    Engine.CurrentSaveGame.SaveHenchmen(LocalPlayer(PC.Player).ControllerId);
    ShowCharacterMenu();
}
public event function Deactivated()
{
    local BioPlayerController PC;
    local BioWorldInfo WorldInfo;
    
    WorldInfo = BioWorldInfo(GetWorldInfo());
    if (WorldInfo != None)
    {
        PC = WorldInfo.GetLocalPlayerController();
        if (PC != None)
        {
            PC.GameModeManager2.DisableMode(9, 'ChoiceGUI');
        }
    }
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 2;
}
public delegate function OnFinished();

public event function bool Update(float DeltaTime)
{
    if (m_bFinished)
    {
        m_bFinished = FALSE;
        while (PopChoiceGUI() != None)
        {
        }
        OutputLinks[0].bHasImpulse = TRUE;
        return FALSE;
    }
    return TRUE;
}
public function ApplyHenchmanLoadout(int HenchIdx)
{
    local BioPlayerController PC;
    local SFXEngine Engine;
    local int idx;
    
    PC = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
    Engine = SFXEngine(PC.Player.Outer);
    for (idx = 0; idx < 6; idx++)
    {
        Engine.HenchmanRecords[HenchIdx].LoadoutWeapons[idx] = Name(PathName(LoadoutWeapons[idx]));
    }
}
public function ApplyPlayerLoadout()
{
    local BioPlayerController PC;
    local SFXEngine Engine;
    local int idx;
    local Name LOWName;
    
    PC = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
    Engine = SFXEngine(PC.Player.Outer);
    for (idx = 0; idx < 6; idx++)
    {
        LOWName = Name(PathName(LoadoutWeapons[idx]));
        if (Engine.PlayerLoadoutWeapons[idx] != LOWName)
        {
            Engine.PlayerLoadoutWeapons[idx] = LOWName;
        }
    }
}
public final function ApplyPlayerWeaponMods()
{
    local SFXInventoryManager InvManager;
    local SFXWeapon Weapon;
    local int idx;
    local SFXModule_WeaponModManager Manager;
    local Class<SFXWeaponMod> ModClass;
    local Name ModClassName;
    local BioPawn oPawn;
    local BioPlayerController PC;
    local SFXEngine Engine;
    local int ModLevel;
    
    PC = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
    if (PC == None)
    {
        return;
    }
    oPawn = BioPawn(PC.Pawn);
    if (oPawn == None)
    {
        return;
    }
    Engine = SFXEngine(PC.Player.Outer);
    if (Engine == None)
    {
        return;
    }
    InvManager = SFXInventoryManager(oPawn.InvManager);
    if (InvManager != None)
    {
        foreach InvManager.InventoryActors(Class'SFXWeapon', Weapon)
        {
            for (idx = 0; idx < Engine.PlayerWeaponMods.Length; idx++)
            {
                if (PathName(Weapon.Class) == string(Engine.PlayerWeaponMods[idx].WeaponClassName))
                {
                    Manager = Weapon.GetModule(Class'SFXModule_WeaponModManager');
                    if (Manager != None)
                    {
                        Manager.RemoveAllMods();
                        foreach Engine.PlayerWeaponMods[idx].WeaponModClassNames(ModClassName, )
                        {
                            ModClass = Class'SFXWeaponMod'.static.LoadModClass(string(ModClassName));
                            if (ModClass != None && ModClass.static.IsUnlocked(ModLevel))
                            {
                                Manager.AddMod(ModClass, ModLevel);
                            }
                        }
                    }
                }
            }
        }
    }
}
public function BuildPawnWeaponList(int PawnID, out SFXChoiceEntry Entry)
{
    local SFXTokenMapping TokenMapping;
    local int idx;
    local int ListIndex;
    local Class<SFXWeapon> WClass;
    local BioPlayerController PC;
    local SFXEngine Engine;
    
    PC = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController();
    Engine = SFXEngine(PC.Player.Outer);
    if (PawnID == 0)
    {
        PreparePlayerLoadout();
    }
    else
    {
        for (idx = 0; idx < Engine.HenchmanRecords.Length; idx++)
        {
            if (GetHenchmanInfo(AvailableHenchmen[PawnID]).Tag == Engine.HenchmanRecords[idx].Tag)
            {
                PrepareHenchmanLoadout(idx);
            }
        }
    }
    for (idx = 0; idx < 6; idx++)
    {
        if (IsPawnUsingWeaponGroup(PawnID, byte(idx)))
        {
            WClass = LoadoutWeapons[idx];
            TokenMapping.TokenId = ListIndex++;
            TokenMapping.Data = "" $ WClass.static.GetPrettyName();
            Entry.m_mapTokenIDToActual.AddItem(TokenMapping);
        }
    }
    for (idx = ListIndex; idx < 6; idx++)
    {
        TokenMapping.TokenId = idx;
        TokenMapping.Data = "";
        Entry.m_mapTokenIDToActual.AddItem(TokenMapping);
    }
}
public function CharacterMenuHandler(bool bAPressed, int nContext)
{
    local BioPlayerController PC;
    local SFXEngine Engine;
    local int idx;
    
    PC = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController();
    Engine = SFXEngine(PC.Player.Outer);
    if (bAPressed)
    {
        if (nContext == 0)
        {
            PreparePlayerLoadout();
        }
        else
        {
            for (idx = 0; idx < Engine.HenchmanRecords.Length; idx++)
            {
                if (GetHenchmanInfo(AvailableHenchmen[nContext]).Tag == Engine.HenchmanRecords[idx].Tag)
                {
                    PrepareHenchmanLoadout(idx);
                }
            }
        }
        CurrentPawn = nContext;
        ShowWeaponsTopMenu();
    }
    else
    {
        m_bFinished = TRUE;
        __OnFinished__Delegate();
    }
}
private final function Texture2D FindImage(string Path)
{
    return Texture2D(Class'SFXEngine'.static.GetSeekFreeObject(Path, Class'Texture2D'));
}
public function HenchmanInfoStruct GetHenchmanInfo(Name HenchClassName)
{
    local HenchmanInfoStruct HenchInfo;
    
    foreach Class'SFXPawn_Henchman'.default.HenchmenInfo(HenchInfo, )
    {
        if (HenchInfo.className == HenchClassName)
        {
            return HenchInfo;
        }
    }
    return HenchInfo;
}
public function int GetWeaponClassUnlockedCount(int GroupIdx)
{
    local int idx;
    local array<LoadoutWeaponInfo> WeaponGroup;
    local int Count;
    local Class<SFXWeapon> WClass;
    local SFXEngine Eng;
    
    WeaponGroup = Class'SFXPlayerSquadLoadoutData'.static.GetWeaponGroup(GroupIdx);
    Count = 0;
    Eng = SFXEngine(Class'Engine'.static.GetEngine());
    for (idx = 0; idx < WeaponGroup.Length; idx++)
    {
        if (WeaponGroup[idx].bStartsUnlocked == FALSE)
        {
            WClass = Class'SFXPlayerSquadLoadoutData'.static.FindWeaponClass(WeaponGroup[idx].className);
            if (WClass == None || Eng.GetPlayerVariable(WClass.Name) == 0)
            {
                continue;
            }
        }
        Count++;
    }
    return Count;
}
public function bool IsPawnUsingWeaponGroup(int PawnID, ELoadoutWeapons WeaponGroupID)
{
    if (PawnID == 0)
    {
        return Class'SFXPlayerSquadLoadoutData'.static.IsPlayerUsingWeaponGroup(WeaponGroupID);
    }
    else
    {
        return Class'SFXPlayerSquadLoadoutData'.static.CanHenchmanUseWeaponGroup(GetHenchmanInfo(AvailableHenchmen[PawnID]).Tag, WeaponGroupID);
    }
    return FALSE;
}
public function ModsSubMenuHandler(bool bAPressed, int nContext)
{
    local int idx;
    local int ModID;
    local BioPlayerController PC;
    local SFXEngine Engine;
    local Name ModClassPath;
    local Name WeaponClassPath;
    local bool bWeaponExists;
    local WeaponModSaveRecord ModSaveRecord;
    
    if (bAPressed)
    {
        PC = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
        Engine = SFXEngine(PC.Player.Outer);
        if (Engine != None)
        {
            WeaponClassPath = Name(PathName(ModMenu_WeaponClass));
            ModClassPath = Name(PathName(ModMenu_ModClasses[nContext]));
            for (idx = 0; idx < Engine.PlayerWeaponMods.Length; idx++)
            {
                if (Engine.PlayerWeaponMods[idx].WeaponClassName == WeaponClassPath)
                {
                    bWeaponExists = TRUE;
                    ModID = Engine.PlayerWeaponMods[idx].WeaponModClassNames.Find(ModClassPath);
                    if (ModID != -1)
                    {
                        Engine.PlayerWeaponMods[idx].WeaponModClassNames.Remove(ModID, 1);
                    }
                    else
                    {
                        if (Engine.PlayerWeaponMods[idx].WeaponModClassNames.Length >= ModMenu_WeaponClass.default.MaxWeaponMods)
                        {
                            return;
                        }
                        Engine.PlayerWeaponMods[idx].WeaponModClassNames.AddItem(ModClassPath);
                    }
                    break;
                }
            }
            if (!bWeaponExists)
            {
                ModSaveRecord.WeaponClassName = WeaponClassPath;
                ModSaveRecord.WeaponModClassNames.AddItem(ModClassPath);
                Engine.PlayerWeaponMods.AddItem(ModSaveRecord);
            }
        }
        PopChoiceGUI();
        ShowModsSubMenu(ModsSelectedWeapon, nContext);
    }
    else
    {
        PopChoiceGUI();
    }
}
public function ModsTopMenuHandler(bool bAPressed, int nContext)
{
    if (bAPressed)
    {
        ModsSelectedWeapon = nContext;
        ShowModsSubMenu(nContext, 0);
    }
    else
    {
        PopChoiceGUI();
    }
}
public function PlayEquipSound()
{
    local BioPlayerController PC;
    
    PC = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController();
    PC.PlaySound(WeaponEquipSound);
}
public function BioSFHandler_ChoiceGUI PopChoiceGUI()
{
    local BioSFHandler_ChoiceGUI oCurrentGUI;
    
    if (MenuStack.Length > 0)
    {
        oCurrentGUI = MenuStack[MenuStack.Length - 1];
    }
    if (oCurrentGUI != None)
    {
        oCurrentGUI.HideChoiceGUI(TRUE);
        oCurrentGUI = None;
        MenuStack[MenuStack.Length - 1] = None;
        MenuStack.Length = MenuStack.Length - 1;
    }
    if (MenuStack.Length > 0)
    {
        oCurrentGUI = MenuStack[MenuStack.Length - 1];
    }
    if (oCurrentGUI != None && oCurrentGUI.GetEnabled() == FALSE)
    {
        oCurrentGUI.SetEnabled(TRUE);
    }
    return oCurrentGUI;
}
public function PrepareHenchmanLoadout(int HenchIdx)
{
    local int idx;
    local Class<SFXWeapon> WClass;
    local BioPlayerController PC;
    local SFXEngine Eng;
    
    PC = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController();
    Eng = SFXEngine(PC.Player.Outer);
    for (idx = 0; idx < 6; idx++)
    {
        WClass = Class'SFXPlayerSquadLoadoutData'.static.FindWeaponClass(Eng.HenchmanRecords[HenchIdx].LoadoutWeapons[idx]);
        if (WClass == None || Eng.GetPlayerVariable(WClass.Name) == 0)
        {
            WClass = Class'SFXPlayerSquadLoadoutData'.static.FindWeaponClass(Class'SFXPlayerSquadLoadoutData'.static.GetWeaponGroup(idx)[0].className);
        }
        LoadoutWeapons[idx] = WClass;
    }
}
public function PrepareHenchmanRecords(Name Tag)
{
    local int HenchIdx;
    local BioPlayerController PC;
    local SFXEngine Engine;
    local HenchmanSaveRecord SaveInfo;
    
    PC = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController();
    Engine = SFXEngine(PC.Player.Outer);
    HenchIdx = Engine.HenchmanRecords.Find('Tag', Tag);
    if (HenchIdx == -1)
    {
        SaveInfo.Tag = Tag;
        SaveInfo.TalentPoints = 0;
        SaveInfo.CharacterLevel = 0;
        Class'SFXPawn_Henchman'.static.GetDefaultLoadout(Tag, SaveInfo.LoadoutWeapons);
        Engine.HenchmanRecords.AddItem(SaveInfo);
    }
}
public function PreparePlayerLoadout()
{
    local int idx;
    local Class<SFXWeapon> WClass;
    local BioPlayerController PC;
    local SFXEngine Eng;
    
    PC = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController();
    Eng = SFXEngine(PC.Player.Outer);
    for (idx = 0; idx < 6; idx++)
    {
        WClass = Class'SFXPlayerSquadLoadoutData'.static.FindWeaponClass(Eng.PlayerLoadoutWeapons[idx]);
        if (WClass == None || Eng.GetPlayerVariable(WClass.Name) == 0)
        {
            WClass = Class'SFXPlayerSquadLoadoutData'.static.FindWeaponClass(Class'SFXPlayerSquadLoadoutData'.static.GetWeaponGroup(idx)[0].className);
        }
        LoadoutWeapons[idx] = WClass;
    }
}
public function BioSFHandler_ChoiceGUI PushChoiceGUI()
{
    local BioPlayerController PC;
    local BioSFHandler_ChoiceGUI oCurrentGUI;
    
    PC = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController();
    if (MenuStack.Length > 0)
    {
        oCurrentGUI = MenuStack[MenuStack.Length - 1];
    }
    if (oCurrentGUI != None)
    {
        oCurrentGUI.SetEnabled(FALSE);
    }
    oCurrentGUI = Class'SFXGUIInteraction'.static.GetInstance().CreateChoiceGUI('None', PC, TRUE);
    MenuStack.AddItem(oCurrentGUI);
    return oCurrentGUI;
}
public function RefillAmmo()
{
    local SFXInventoryManager InvManager;
    local BioPlayerController Controller;
    local SFXWeapon Weapon;
    
    Controller = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController();
    InvManager = SFXInventoryManager(Controller.Pawn.InvManager);
    foreach InvManager.InventoryActors(Class'SFXWeapon', Weapon)
    {
        if (SFXHeavyWeapon(Weapon) != None)
        {
            SFXHeavyWeapon(Weapon).AddHeavyAmmo(1000);
        }
        else
        {
            Weapon.AddAmmo(1000);
        }
    }
}
public function ShowCharacterMenu()
{
    local SFXGameChoiceGUIData Data;
    local SFXChoiceEntry Entry;
    local int idx;
    local BioGlobalVariableTable VarTable;
    local HenchmanInfoStruct HenchInfo;
    local BioSFHandler_ChoiceGUI Menu;
    
    Menu = PushChoiceGUI();
    VarTable = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetGlobalVariables();
    Data = new (Menu) Class'SFXGameChoiceGUIData';
    Entry.srChoiceName = srShepardNameString;
    Entry.srChoiceTitle = srShepardNameString;
    BuildPawnWeaponList(0, Entry);
    Entry.srChoiceDescription = srPawnActiveWeaponsString;
    Entry.bDefaultSelection = CurrentPawn == 0;
    Entry.oChoiceImage = FindImage(ShepardImage);
    Data.AddChoice(Entry);
    for (idx = 1; idx < AvailableHenchmen.Length; idx++)
    {
        HenchInfo = GetHenchmanInfo(AvailableHenchmen[idx]);
        if (HenchInfo.AlternateHenchNamePlotFlag != 'None' && VarTable.GetBoolByName(HenchInfo.AlternateHenchNamePlotFlag))
        {
            Entry.srChoiceName = HenchInfo.AlternatePrettyName;
            Entry.srChoiceTitle = HenchInfo.AlternatePrettyName;
        }
        else
        {
            Entry.srChoiceName = HenchInfo.PrettyName;
            Entry.srChoiceTitle = HenchInfo.PrettyName;
        }
        BuildPawnWeaponList(idx, Entry);
        Entry.srChoiceDescription = srPawnActiveWeaponsString;
        Entry.bDefaultSelection = CurrentPawn == idx;
        Entry.oChoiceImage = FindImage(HenchInfo.HenchmanImage);
        Data.AddChoice(Entry);
    }
    Data.m_srAText = srButtonText_Choose;
    Data.m_srBText = srButtonText_Exit;
    Data.m_srTitle = srButtonText_SquadWeapons;
    Data.m_srSubTitle = srButtonText_CustomizeSquadWeapons;
    Menu.__InputCallback__Delegate = CharacterMenuHandler;
    Menu.Initialize(Data);
    Menu.ShowChoiceGUI();
}
public function ShowModsSubMenu(int GroupIdx, int DefaultSelectionIndex)
{
    local SFXGameChoiceGUIData Data;
    local SFXChoiceEntry Entry;
    local Class<SFXWeapon> WClass;
    local int idx;
    local BioSFHandler_ChoiceGUI Menu;
    local Class<SFXWeaponMod> ModClass;
    local SFXTokenMapping TokenMapping;
    local bool bModAttached;
    local int nLevel;
    local BioPlayerController PC;
    local SFXEngine Engine;
    local WeaponModSaveRecord ModRecord;
    
    WClass = LoadoutWeapons[WeaponMenuEnabledWeaponIDs[GroupIdx]];
    if (WClass == None)
    {
        return;
    }
    PC = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
    Engine = SFXEngine(PC.Player.Outer);
    if (Engine == None)
    {
        return;
    }
    for (idx = 0; idx < Engine.PlayerWeaponMods.Length; idx++)
    {
        if (string(Engine.PlayerWeaponMods[idx].WeaponClassName) == PathName(WClass))
        {
            ModRecord = Engine.PlayerWeaponMods[idx];
            break;
        }
    }
    Menu = PushChoiceGUI();
    Data = new (Menu) Class'SFXGameChoiceGUIData';
    ModMenu_ModClasses.Length = 0;
    for (idx = 0; idx < WClass.default.AllowableWeaponMods.Length; idx++)
    {
        ModClass = Class'SFXWeaponMod'.static.LoadModClass(WClass.default.AllowableWeaponMods[idx]);
        if (ModClass != None)
        {
            if (ModClass.static.IsUnlocked(nLevel) == FALSE)
            {
                continue;
            }
            bModAttached = ModRecord.WeaponModClassNames.Find(Name(PathName(ModClass))) != -1;
            TokenMapping.TokenId = 0;
            TokenMapping.Data = ModClass.static.GetModName(nLevel);
            Entry.m_mapTokenIDToActual.AddItem(TokenMapping);
            TokenMapping.TokenId = 1;
            TokenMapping.Data = bModAttached ? string(srModInstalled) : "";
            Entry.m_mapTokenIDToActual.AddItem(TokenMapping);
            TokenMapping.TokenId = 2;
            TokenMapping.Data = ModClass.static.GetModDescription(nLevel);
            Entry.m_mapTokenIDToActual.AddItem(TokenMapping);
            Entry.srChoiceName = srModTokenizedName;
            Entry.srChoiceTitle = srModTokenizedName;
            Entry.srChoiceDescription = srSingleCustomToken_2;
            Entry.bDefaultSelection = idx == DefaultSelectionIndex;
            Entry.oChoiceImage = FindImage(WClass.default.GUIImage);
            Data.AddChoice(Entry);
            ModMenu_ModClasses.AddItem(ModClass);
        }
    }
    Data.m_srAText = srModAttachDetach;
    Data.m_srBText = srButtonText_Back;
    Data.m_srSubTitle = srModsSubMenuSubTitle;
    Data.m_srTitle = WClass.default.PrettyName;
    Menu.__InputCallback__Delegate = ModsSubMenuHandler;
    ModMenu_WeaponClass = WClass;
    Menu.Initialize(Data);
    Menu.ShowChoiceGUI();
}
public function ShowModsTopMenu()
{
    local SFXGameChoiceGUIData Data;
    local SFXChoiceEntry Entry;
    local int idx;
    local Class<SFXWeapon> WClass;
    local BioSFHandler_ChoiceGUI Menu;
    local SFXTokenMapping TokenMapping;
    
    Menu = PushChoiceGUI();
    Data = new (Menu) Class'SFXGameChoiceGUIData';
    for (idx = 0; idx < 6; idx++)
    {
        if (IsPawnUsingWeaponGroup(CurrentPawn, byte(idx)))
        {
            WClass = LoadoutWeapons[idx];
            if (ClassIsChildOf(WClass, Class'SFXHeavyWeapon'))
            {
                continue;
            }
            TokenMapping.TokenId = 0;
            TokenMapping.Data = "" $ WClass.static.GetPrettyName();
            Entry.m_mapTokenIDToActual.AddItem(TokenMapping);
            TokenMapping.TokenId = 1;
            TokenMapping.Data = "" $ WClass.static.GetGeneralDescription();
            Entry.m_mapTokenIDToActual.AddItem(TokenMapping);
            Entry.srChoiceName = srSingleCustomToken_0;
            Entry.srChoiceTitle = srSingleCustomToken_0;
            Entry.srChoiceDescription = srSingleCustomToken_1;
            Entry.bDefaultSelection = ModsTopMenuIndex == Data.lstChoices.Length;
            Entry.oChoiceImage = FindImage(WClass.default.GUIImage);
            Data.AddChoice(Entry);
        }
    }
    Data.m_srAText = srButtonText_Choose;
    Data.m_srBText = srButtonText_Back;
    Data.m_srTitle = CurrentPawn == 0 ? srShepardNameString : GetHenchmanInfo(AvailableHenchmen[CurrentPawn]).PrettyName;
    Data.m_srSubTitle = srModsMenuSubTitle;
    Menu.__InputCallback__Delegate = ModsTopMenuHandler;
    Menu.Initialize(Data);
    Menu.ShowChoiceGUI();
}
public function ShowWeaponGroupMenu(int nSelection)
{
    local SFXGameChoiceGUIData Data;
    local SFXChoiceEntry Entry;
    local int idx;
    local Class<SFXWeapon> WClass;
    local BioSFHandler_ChoiceGUI Menu;
    local SFXTokenMapping TokenMapping;
    local BioPlayerController PC;
    local SFXEngine Engine;
    local PlayerLoadoutInfoStruct PlayerData;
    local bool bRequiredWeapon;
    
    Menu = PushChoiceGUI();
    Data = new (Menu) Class'SFXGameChoiceGUIData';
    PC = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
    Engine = SFXEngine(PC.Player.Outer);
    Class'SFXPlayerSquadLoadoutData'.static.GetPlayerLoadoutData(SFXPawn_Player(PC.Pawn).PlayerClassName, PlayerData);
    for (idx = 0; idx < 6; idx++)
    {
        WClass = LoadoutWeapons[idx];
        if (int(byte(idx)) == 5)
        {
            continue;
        }
        bRequiredWeapon = PlayerData.RequiredWeaponClasses.Find(byte(idx)) != -1;
        TokenMapping.TokenId = 0;
        TokenMapping.Data = "" $ stringref(Class'SFXPlayerSquadLoadoutData'.static.GetPluralPrettyName(idx));
        Entry.m_mapTokenIDToActual.AddItem(TokenMapping);
        TokenMapping.TokenId = 1;
        if (bRequiredWeapon)
        {
            TokenMapping.Data = string(srWeaponGroupRequired);
        }
        else
        {
            TokenMapping.Data = Engine.PlayerLoadoutGroups.Find(byte(idx)) != -1 ? string(srWeaponGroupActive) : "";
        }
        Entry.m_mapTokenIDToActual.AddItem(TokenMapping);
        TokenMapping.TokenId = 2;
        TokenMapping.Data = "" $ WClass.static.GetGeneralDescription();
        Entry.m_mapTokenIDToActual.AddItem(TokenMapping);
        Entry.srChoiceName = srWeaponGroupTokenizedName;
        Entry.srChoiceTitle = srWeaponGroupTokenizedName;
        Entry.srChoiceDescription = srSingleCustomToken_2;
        Entry.bDefaultSelection = idx == nSelection;
        Entry.oChoiceImage = FindImage(WClass.default.GUIImage);
        Entry.bDisabled = bRequiredWeapon;
        Data.AddChoice(Entry);
    }
    Data.m_srAText = srButtonText_Choose;
    Data.m_srBText = srButtonText_Back;
    Data.m_srTitle = srShepardNameString;
    Data.m_srSubTitle = srWeaponGroupSubTitle;
    Menu.__InputCallback__Delegate = WeaponGroupInputHandler;
    Menu.Initialize(Data);
    Menu.ShowChoiceGUI();
}
public function ShowWeaponsTopMenu()
{
    local SFXGameChoiceGUIData Data;
    local SFXChoiceEntry Entry;
    local int idx;
    local Class<SFXWeapon> WClass;
    local SFXTokenMapping TokenMapping;
    local int WeaponClassUnlockCount;
    local BioSFHandler_ChoiceGUI Menu;
    
    Menu = PushChoiceGUI();
    Data = new (Menu) Class'SFXGameChoiceGUIData';
    WeaponMenuEnabledWeaponIDs.Length = 0;
    if (CurrentPawn == 0)
    {
        Entry.srChoiceName = srModsEntryName;
        Entry.srChoiceTitle = srModsEntryName;
        Entry.srChoiceDescription = srModsEntryDescription;
        Entry.bDefaultSelection = SubMenuWeaponIdx == 0;
        Data.AddChoice(Entry);
        Entry.srChoiceName = srWeaponGroupEntryName;
        Entry.srChoiceTitle = srWeaponGroupEntryName;
        Entry.srChoiceDescription = srWeaponGroupEntryDescription;
        Entry.bDefaultSelection = SubMenuWeaponIdx == 0;
        Data.AddChoice(Entry);
    }
    for (idx = 0; idx < 6; idx++)
    {
        if (IsPawnUsingWeaponGroup(CurrentPawn, byte(idx)) == FALSE)
        {
            continue;
        }
        WClass = LoadoutWeapons[idx];
        WeaponClassUnlockCount = GetWeaponClassUnlockedCount(idx);
        TokenMapping.TokenId = 0;
        TokenMapping.Data = "" $ WClass.static.GetPrettyName();
        Entry.m_mapTokenIDToActual.AddItem(TokenMapping);
        TokenMapping.TokenId = 1;
        TokenMapping.Data = "" $ (WeaponClassUnlockCount > 1 ? string(srLeftBracketToken) : "");
        Entry.m_mapTokenIDToActual.AddItem(TokenMapping);
        TokenMapping.TokenId = 2;
        TokenMapping.Data = "" $ (WeaponClassUnlockCount > 1 ? string(WeaponClassUnlockCount) : "");
        Entry.m_mapTokenIDToActual.AddItem(TokenMapping);
        TokenMapping.TokenId = 3;
        TokenMapping.Data = "" $ (WeaponClassUnlockCount > 1 ? string(srRightBracketToken) : "");
        Entry.m_mapTokenIDToActual.AddItem(TokenMapping);
        Entry.bDisabled = WeaponClassUnlockCount <= 1;
        TokenMapping.TokenId = 4;
        TokenMapping.Data = "" $ WClass.static.GetPrettyName();
        Entry.m_mapTokenIDToActual.AddItem(TokenMapping);
        TokenMapping.TokenId = 6;
        TokenMapping.Data = "" $ WClass.default.GeneralDescription;
        Entry.m_mapTokenIDToActual.AddItem(TokenMapping);
        Entry.srChoiceName = srWeaponClassTokenString;
        Entry.srChoiceTitle = srWeaponClassTokenString;
        Entry.srChoiceDescription = srClassDescriptionTokenString;
        Entry.bDefaultSelection = Data.lstChoices.Length == SubMenuWeaponIdx;
        Entry.oChoiceImage = FindImage(WClass.default.GUIImage);
        Data.AddChoice(Entry);
        WeaponMenuEnabledWeaponIDs.AddItem(idx);
    }
    Data.m_srAText = srButtonText_Choose;
    Data.m_srBText = srButtonText_Back;
    Data.m_srTitle = CurrentPawn == 0 ? srShepardNameString : GetHenchmanInfo(AvailableHenchmen[CurrentPawn]).PrettyName;
    Data.m_srSubTitle = srButtonText_CustomizeWeapons;
    Menu.__InputCallback__Delegate = TopMenuHandler;
    Menu.Initialize(Data);
    Menu.ShowChoiceGUI();
}
public function ShowWeaponSubMenu(int GroupIdx)
{
    local SFXGameChoiceGUIData Data;
    local SFXChoiceEntry Entry;
    local Class<SFXWeapon> WClass;
    local int idx;
    local array<LoadoutWeaponInfo> WeaponGroup;
    local SFXTokenMapping TokenMapping;
    local string WeaponPrettyName;
    local int WeaponGroupID;
    local int WeaponID;
    local BioSFHandler_ChoiceGUI Menu;
    local SFXEngine Eng;
    
    Menu = PushChoiceGUI();
    WeaponGroup = Class'SFXPlayerSquadLoadoutData'.static.GetWeaponGroup(GroupIdx);
    Data = new (Menu) Class'SFXGameChoiceGUIData';
    SubMenuEnabledWeapons.Length = 0;
    Eng = SFXEngine(Class'Engine'.static.GetEngine());
    for (idx = 0; idx < WeaponGroup.Length; idx++)
    {
        WClass = Class'SFXPlayerSquadLoadoutData'.static.FindWeaponClass(WeaponGroup[idx].className);
        if (WClass == None || Eng.GetPlayerVariable(WClass.Name) == 0)
        {
            continue;
        }
        Class'SFXPlayerSquadLoadoutData'.static.GetWeaponCategory(WClass, WeaponGroupID, WeaponID);
        WeaponPrettyName = WClass.static.GetPrettyName();
        TokenMapping.TokenId = 0;
        TokenMapping.Data = "" $ WeaponPrettyName;
        Entry.m_mapTokenIDToActual.AddItem(TokenMapping);
        TokenMapping.TokenId = 2;
        TokenMapping.Data = "" $ WClass.default.GeneralDescription;
        Entry.m_mapTokenIDToActual.AddItem(TokenMapping);
        TokenMapping.TokenId = 9;
        TokenMapping.Data = "" $ WeaponPrettyName;
        Entry.m_mapTokenIDToActual.AddItem(TokenMapping);
        Entry.srChoiceName = srSingleCustomToken;
        Entry.srChoiceTitle = srSingleCustomToken;
        Entry.srChoiceDescription = srWeaponDescriptionTokenString;
        Entry.bDefaultSelection = WClass == LoadoutWeapons[GroupIdx];
        Entry.oChoiceImage = FindImage(WClass.default.GUIImage);
        Data.AddChoice(Entry);
        SubMenuEnabledWeapons.AddItem(WeaponGroup[idx]);
    }
    Data.m_srAText = srButtonText_Accept;
    Data.m_srBText = srButtonText_Back;
    Data.m_srSubTitle = srWeaponMenuSubHeading;
    Data.m_srTitle = CurrentPawn == 0 ? srShepardNameString : GetHenchmanInfo(AvailableHenchmen[CurrentPawn]).PrettyName;
    Menu.__InputCallback__Delegate = SubMenuHandler;
    Menu.Initialize(Data);
    Menu.ShowChoiceGUI();
}
public function SubMenuHandler(bool bAPressed, int nContext)
{
    if (bAPressed)
    {
        LoadoutWeapons[SubMenuWeaponIdx] = Class'SFXPlayerSquadLoadoutData'.static.FindWeaponClass(SubMenuEnabledWeapons[nContext].className);
        PlayEquipSound();
    }
    PopChoiceGUI();
    PopChoiceGUI();
    ShowWeaponsTopMenu();
}
public function TopMenuHandler(bool bAPressed, int nContext)
{
    local BioPlayerController PC;
    local SFXEngine Engine;
    local int idx;
    local BioBaseSquad Squad;
    local BioPawn SquadMember;
    local SFXWeapon Weapon;
    
    if (bAPressed)
    {
        if (CurrentPawn == 0)
        {
            if (nContext == 0)
            {
                ShowModsTopMenu();
                return;
            }
            else if (nContext == 1)
            {
                ShowWeaponGroupMenu(0);
                return;
            }
            else
            {
                nContext -= 2;
            }
        }
        SubMenuWeaponIdx = WeaponMenuEnabledWeaponIDs[nContext];
        ShowWeaponSubMenu(WeaponMenuEnabledWeaponIDs[nContext]);
    }
    else
    {
        PC = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
        Engine = SFXEngine(PC.Player.Outer);
        if (CurrentPawn == 0)
        {
            ApplyPlayerLoadout();
        }
        else
        {
            for (idx = 0; idx < Engine.HenchmanRecords.Length; idx++)
            {
                if (GetHenchmanInfo(AvailableHenchmen[CurrentPawn]).Tag == Engine.HenchmanRecords[idx].Tag)
                {
                    ApplyHenchmanLoadout(idx);
                    break;
                }
            }
        }
        if (!SFXGRI(BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GRI).bIsMultiplayerCharacter)
        {
            Squad = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).m_playerSquad;
            for (idx = 0; idx < Squad.Members.Length; idx++)
            {
                SquadMember = BioPawn(Squad.Members[idx]);
                SquadMember.CreateWeapons(SquadMember.Loadout);
                if (SFXPawn_Player(SquadMember) != None)
                {
                    SFXPawn_Player(SquadMember).UpdateWeaponVisibility_DEPRECATED();
                }
                if (SquadMember.Weapon == None)
                {
                    foreach SquadMember.InvManager.InventoryActors(Class'SFXWeapon', Weapon)
                    {
                        SquadMember.SetWeaponImmediately(Weapon);
                        break;
                    }
                }
            }
            ApplyPlayerWeaponMods();
        }
        PopChoiceGUI();
    }
}
public function WeaponGroupInputHandler(bool bAPressed, int nContext)
{
    local int idx;
    local BioPlayerController PC;
    local SFXEngine Engine;
    local PlayerLoadoutInfoStruct PlayerData;
    
    if (bAPressed)
    {
        PC = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
        Engine = SFXEngine(PC.Player.Outer);
        if (Engine == None)
        {
            return;
        }
        Class'SFXPlayerSquadLoadoutData'.static.GetPlayerLoadoutData(SFXPawn_Player(PC.Pawn).PlayerClassName, PlayerData);
        if (Engine.PlayerLoadoutGroups.Find(byte(nContext)) == -1)
        {
            for (idx = 0; idx < Engine.PlayerLoadoutGroups.Length; idx++)
            {
                if (PlayerData.RequiredWeaponClasses.Find(Engine.PlayerLoadoutGroups[idx]) == -1)
                {
                    Engine.PlayerLoadoutGroups.Remove(idx, 1);
                    break;
                }
            }
            Engine.PlayerLoadoutGroups.AddItem(byte(nContext));
        }
        else
        {
            return;
        }
        PopChoiceGUI();
        ShowWeaponGroupMenu(nContext);
    }
    else
    {
        PopChoiceGUI();
        PopChoiceGUI();
        ShowWeaponsTopMenu();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ShepardImage = "GUI_Codex_Images.TalentPoints_512"
    srButtonText_Choose = $325667
    srButtonText_Exit = $325666
    srButtonText_SquadWeapons = $338196
    srButtonText_CustomizeSquadWeapons = $338197
    srButtonText_CustomizeWeapons = $347489
    srButtonText_Accept = $338242
    srButtonText_Back = $325668
    srWeaponMenuSubHeading = $350658
    srLeftBracketToken = $339206
    srRightBracketToken = $339207
    srWeaponClassTokenString = $340856
    srClassDescriptionTokenString = $340868
    srPawnActiveWeaponsString = $347490
    srShepardNameString = $125303
    srSingleCustomToken = $342663
    srWeaponDescriptionTokenString = $342559
    srModsEntryName = $518493
    srModsEntryDescription = $518494
    srModsMenuSubTitle = $518495
    srModsSubMenuSubTitle = $518496
    srSingleCustomToken_0 = $518478
    srSingleCustomToken_1 = $519184
    srSingleCustomToken_2 = $519188
    srModTokenizedName = $518994
    srModAttachDetach = $518989
    srModInstalled = $518995
    srWeaponGroupEntryName = $524833
    srWeaponGroupEntryDescription = $524834
    srWeaponGroupTokenizedName = $524835
    srWeaponGroupActive = $524836
    srWeaponGroupRequired = $524841
    srWeaponGroupSubTitle = $524839
    WeaponEquipSound = None
    bCallHandler = FALSE
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Out", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "AllHenchmen", 
                      ExpectedType = Class'SeqVar_Bool', 
                      LinkVar = 'None', 
                      PropertyName = 'm_bAllHenchmen', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
    bManualHandleOutputs = TRUE
}