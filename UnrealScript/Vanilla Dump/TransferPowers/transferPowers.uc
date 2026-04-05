Class SFSPowerTransferManager extends SFSManager within SFXPawn;

var SFSSaveManager SaveManager;
var BioPlayerInput BPI;
var BioPlayerController PC;
var array<Name> keys;

public event simulated function HandlePostAdd()
{
    SaveManager = Outer.GetModule(Class'SFSSaveManager');
    PC = BioPlayerController(Outer.Controller);
    if (PC == None)
    {
        log(Self.Name, "LogMappedPowers: No PlayerController found", Outer);
        return;
    }
    BPI = BioPlayerInput(PC.PlayerInput);
    if (BPI == None)
    {
        log(Self.Name, "LogMappedPowers: No BioPlayerInput found", Outer);
        return;
    }
}
function HandleEvent(SFSEvent E)
{
    switch (E.eType)
    {
        case SFSEventType.EVT_TRansferPowers:
            TransferPowers(E.nValue, E.powersToTransfer);
            break;
        default:
    }
}
public function TransferPowers(Name KitName, int Powers[2])
{
    local Class<SFXCharacterClass> fromCharacterClass;
    local SFXMPCharacterRecord kitSave;
    local int replacementIndex;
    local int originalIndex;
    local SFXPowerCustomActionBase NewPower;
    
    replacementIndex = Powers[0];
    originalIndex = Powers[1];
    //Get the class of the kit from which we will transfer the power
    SaveManager.GetMPCharacterRecord(KitName, kitSave);
    fromCharacterClass = SaveManager.getKitClass(kitSave);
    //Creates a new PowerSaveInfo array and reloads powers through the PowerManager;
    log(Self.Name, "Character Class" $ fromCharacterClass $ " Kit: " $ KitName $ " Power from: " $ replacementIndex $ " Power to: " $ originalIndex, Outer);
    createPowerSaveInfoAndReload(fromCharacterClass, kitSave, replacementIndex, originalIndex);
    //replaceBindings(fromPowerClass, originalIndex); // might not be necessary now that we use LoadPowers;
    LogPowerManagerPowers();
    LogMappedPowers();
}
public function createPowerSaveInfoAndReload(Class<SFXCharacterClass> fromCharacterClass, SFXMPCharacterRecord kitSave, int replacementIndex, int originalIndex)
{
    local array<PowerSaveInfo> powerSaves;
    local SFXPowerCustomActionBase powerIterator;
    local int iteratorInt;
    local PowerSaveInfo replacementPowerSaveInfo;
    local PowerSaveInfo currentPowerSaveInfo;
    local bool b_hasReplacementInfo;
    local bool b_hasEvolvedChoices;
    local int idx;
    local PowerSaveInfo it;
    
    log(Self.Name, "createPowerSaveInfoAndReload----", Outer);
    b_hasReplacementInfo = getReplacementPowerSaveInfo(fromCharacterClass, kitSave, replacementIndex, replacementPowerSaveInfo, b_hasEvolvedChoices);
    foreach Outer.PowerManager.Powers(powerIterator, iteratorInt)
    {
        log(Self.Name, "Processing Power:  " $ powerIterator.Class, Outer);
        if (iteratorInt == originalIndex && b_hasReplacementInfo)
        {
            log(Self.Name, "Has Replacement Info, Creating replacement save", Outer);
            if (!b_hasEvolvedChoices)
            {
                log(Self.Name, "No Evolved Choices for replacement save", Outer);
                for (idx = 0; idx < 6; idx++)
                {
                    replacementPowerSaveInfo.EvolvedChoices[idx] = powerIterator.EvolvedChoices[idx];
                }
            }
            replacementPowerSaveInfo.WheelDisplayIndex = powerIterator.WheelDisplayIndex;
            log(Self.Name, "PowerSaveInfo.PowerName " $ replacementPowerSaveInfo.PowerName, Outer);
            log(Self.Name, "PowerSaveInfo.PowerClassName " $ replacementPowerSaveInfo.PowerClassName, Outer);
            log(Self.Name, "PowerSaveInfo.CurrentRank " $ replacementPowerSaveInfo.CurrentRank, Outer);
            log(Self.Name, "PowerSaveInfo.WheelDisplayIndex " $ replacementPowerSaveInfo.WheelDisplayIndex, Outer);
            powerSaves.AddItem(replacementPowerSaveInfo);
            log(Self.Name, "Removing Power" $ powerIterator.Class, Outer);
            Outer.PowerManager.RemovePower(powerIterator.Class);
            printArrayContents(Self.Name, Outer, Outer.PowerCustomActionClasses, "Power Custom Action Classes");
            printArrayContents(Self.Name, Outer, Outer.PowerCustomActions, "Power Custom Actions");
        }
        else
        {
            currentPowerSaveInfo.EvolvedChoices = powerIterator.EvolvedChoices;
            currentPowerSaveInfo.PowerName = powerIterator.PowerName;
            currentPowerSaveInfo.PowerClassName = powerIterator.Class.Name;
            currentPowerSaveInfo.CurrentRank = powerIterator.Rank;
            currentPowerSaveInfo.WheelDisplayIndex = powerIterator.WheelDisplayIndex;
            powerSaves.AddItem(currentPowerSaveInfo);
        }
    }
    log(Self.Name, " ----------: POWER SAVES :--------", Outer);
    for (idx = 0; idx < powerSaves.Length; idx++)
    {
        log(Self.Name, " * " $ powerSaves[idx].PowerClassName, Outer);
    }
    LoadPowers(powerSaves);
    foreach Outer.PowerManager.Powers(powerIterator, )
    {
        powerIterator.RecalculateAllPowerInfo(TRUE);
    }
}
public function LoadPowers(out array<PowerSaveInfo> PowerList)
{
    local int nIndex;
    local int nIndex2;
    local SFXPowerCustomActionBase Power;
    local Class<SFXPowerCustomActionBase> powerClass;
    local int EvolveChoice;
    local string PowerClassString;
    
    log(Self.Name, "LoadPowers----", Outer);
    for (nIndex = 0; nIndex < PowerList.Length; nIndex++)
    {
        Power = None;
        powerClass = None;
        PowerClassString = string(PowerList[nIndex].PowerClassName);
        powerClass = Class<SFXPowerCustomActionBase>(FindObject(PowerClassString, Class'Class'));
        if (powerClass != None)
        {
            Power = Outer.PowerManager.GetPowerByClass(powerClass);
        }
        if (Power == None)
        {
            if (SFXPawn_Player(Outer) != None)
            {
                if (powerClass == None)
                {
                    powerClass = Class<SFXPowerCustomActionBase>(Class'SFXEngine'.static.LoadSeekFreeObjectBlocking(PowerClassString, Class'Class'));
                }
                log(Self.Name, "PowerClass " $ powerClass, Outer);
                if (powerClass != None)
                {
                    Power = AddPower(powerClass);
                }
            }
        }
        if (Power != None)
        {
            log(Self.Name, "Evolving the power " $ Power, Outer);
            Power.ResetPower();
            Power.Rank = PowerList[nIndex].CurrentRank;
            Power.WheelDisplayIndex = PowerList[nIndex].WheelDisplayIndex;
            for (EvolveChoice = 1; EvolveChoice <= 3; EvolveChoice++)
            {
                for (nIndex2 = 0; nIndex2 < 6; nIndex2++)
                {
                    if (PowerList[nIndex].EvolvedChoices[nIndex2] == EvolveChoice)
                    {
                        Power.EvolvePower(byte(nIndex2));
                        break;
                    }
                }
            }
            Power.OnPowerRankIncreased();
        }
    }
    if (Outer != None)
    {
        Outer.OnPowersLoaded();
    }
}
public function SFXPowerCustomActionBase AddPower(Class<Object> powerClass)
{
    local SFXPowerCustomActionBase Power;
    local SFXPowerCustomActionBase PowerInList;
    local int nIndex;
    local Class<SFXPowerCustomActionBase> PowerClassCast;
    local int PowerID;
    
    log(Self.Name, "AddPower----", Outer);
    PowerClassCast = Class<SFXPowerCustomActionBase>(powerClass);
    if (PowerClassCast == None)
    {
        log(Self.Name, "Cast of class to SFXPowerCustomActionBase is none: " $ powerClass, Outer);
        return None;
    }
    PowerID = PowerClassCast.default.PowerCustomActionID;
    if (PowerID == 0)
    {
        log(Self.Name, "Power ID is 0", Outer);
        return None;
    }
    for (nIndex = 0; nIndex < Outer.PowerManager.Powers.Length; nIndex++)
    {
        PowerInList = Outer.PowerManager.Powers[nIndex];
        if (PowerInList != None && PowerInList.Class == PowerClassCast)
        {
            log(Self.Name, "PowerInList != None && PowerInList.Class == PowerClassCast", Outer);
            return None;
        }
    }
    if (Outer != None)
    {
        log(Self.Name, "Updating PowerCUstomActionClasses at ID " $ PowerID, Outer);
        Outer.PowerCustomActionClasses[PowerID] = PowerClassCast;
        Outer.VerifyCAHasBeenInstanced(132, PowerID);
    }
    Power = SFXPowerCustomActionBase(Outer.PowerCustomActions[PowerID]);
    log(Self.Name, "Power is " $ Power, Outer);
    if (Power != None)
    {
        Outer.PowerManager.Powers.AddItem(Power);
        for (nIndex = 0; nIndex < Outer.PowerManager.Powers.Length; nIndex++)
        {
            PowerInList = Outer.PowerManager.Powers[nIndex];
            if (PowerInList != None)
            {
                PowerInList.OnPowerAdded(Power);
            }
        }
    }
    return Power;
}
public function bool getReplacementPowerSaveInfo(Class<SFXCharacterClass> fromCharacterClass, SFXMPCharacterRecord kitSave, int replacementIndex, out PowerSaveInfo replacementPowerSave, out bool hasEvolvedChoices)
{
    local Class<BioCustomAction> NewPowerClass;
    local Class<SFXPowerCustomActionBase> NewPowerClassCast;
    local PowerRecord retrievedPowerRecord;
    local bool b_powerInSave;
    local bool b_result;
    local int idx;
    
    log(Self.Name, "getReplacementPowerSaveInfo-----------------------", Outer);
    //Find the power at the replacement index
    NewPowerClass = getPowerCustomActionAtIndex(fromCharacterClass, replacementIndex);
    NewPowerClassCast = Class<SFXPowerCustomActionBase>(NewPowerClass);
    b_powerInSave = SaveManager.getPowerRecordForClass(kitSave, NewPowerClassCast.Name, retrievedPowerRecord);
    log(Self.Name, "b_powerInSave " $ b_powerInSave, Outer);
    if (b_powerInSave)
    {
        for (idx = 0; idx < 6; idx++)
        {
            replacementPowerSave.EvolvedChoices[idx] = retrievedPowerRecord.EvolvedChoices[idx];
        }
        replacementPowerSave.PowerName = retrievedPowerRecord.PowerName;
        replacementPowerSave.PowerClassName = retrievedPowerRecord.PowerClassName;
        replacementPowerSave.CurrentRank = retrievedPowerRecord.CurrentRank;
        hasEvolvedChoices = TRUE;
    }
    else
    {
        replacementPowerSave.PowerName = NewPowerClassCast.default.PowerName;
        replacementPowerSave.PowerClassName = NewPowerClassCast.Name;
        replacementPowerSave.CurrentRank = 6.0;
        hasEvolvedChoices = FALSE;
    }
    log(Self.Name, "PowerSaveInfo.PowerName " $ replacementPowerSave.PowerName, Outer);
    log(Self.Name, "PowerSaveInfo.PowerClassName " $ replacementPowerSave.PowerClassName, Outer);
    log(Self.Name, "PowerSaveInfo.CurrentRank " $ replacementPowerSave.CurrentRank, Outer);
    log(Self.Name, "PowerSaveInfo.WheelDisplayIndex " $ replacementPowerSave.WheelDisplayIndex, Outer);
    return TRUE;
}
public function Class<BioCustomAction> getPowerCustomActionAtIndex(Class<SFXCharacterClass> CharacterClass, int Index)
{
    local array<Class<BioCustomAction>> powersOnly;
    local Class<BioCustomAction> powerClass;
    
    foreach CharacterClass.default.PowerCustomActionClasses(powerClass, )
    {
        if (powerClass != None)
        {
            powersOnly.AddItem(powerClass);
        }
    }
    return powersOnly[Index];
}
public function replaceBindings(Class<BioCustomAction> NewPowerClass, int PowerIndex)
{
    switch (PowerIndex)
    {
        case 0:
            BPI.m_nmMappedPower = NewPowerClass.Name;
            SetKeyBindInternal(PC, keys[0], PowerIndex, FALSE, FALSE, FALSE);
            break;
        case 1:
            BPI.m_nmMappedPower2 = NewPowerClass.Name;
            SetKeyBindInternal(PC, keys[1], PowerIndex, FALSE, FALSE, FALSE);
            break;
        case 2:
            BPI.m_nmMappedPower3 = NewPowerClass.Name;
            SetKeyBindInternal(PC, keys[2], PowerIndex, FALSE, FALSE, FALSE);
            break;
        default:
    }
}
public final function SetKeyBindInternal(PlayerController PlayerController, Name keyName, int PowerIndex, bool Alt, bool Control, bool Shift)
{
    local StaticKeyBind PowerKeyBind;
    
    PowerKeyBind.command = "castpower " $ PowerIndex;
    PowerKeyBind.Name = keyName;
    PowerKeyBind.Control = Control;
    PowerKeyBind.Alt = Alt;
    PowerKeyBind.Shift = Shift;
    log(Self.Name, "Adding bind " $ keyName $ " for " $ PowerIndex, Outer);
    BioPlayerInput(PlayerController.PlayerInput).StaticPCBinds.AddItem(PowerKeyBind);
}
private final function redrawHud()
{
    local SFXGUI_MPHUD oMPHUD;
    
    // Get reference to the MP HUD
    oMPHUD = SFXPlayerControllerMP(PC).GetMPHUD();
    if (oMPHUD != None)
    {
        oMPHUD.InitializeCenterPowerIcons();
        // This redraws the HUD power icons!
    }
}
public function LogPowerManagerPowers()
{
    local SFXPowerCustomActionBase iterator;
    
    log(Self.Name, "========== Power Manager Powers ====", Outer);
    foreach Outer.PowerManager.Powers(iterator, )
    {
        log(Self.Name, iterator.Name $ " : " $ iterator.PowerCustomActionID, Outer);
    }
}
public function LogMappedPowers()
{
    log(Self.Name, "========== Mapped Powers ==========", Outer);
    log(Self.Name, "m_nmMappedPower:  " $ BPI.m_nmMappedPower, Outer);
    log(Self.Name, "m_nmMappedPower2: " $ BPI.m_nmMappedPower2, Outer);
    log(Self.Name, "m_nmMappedPower3: " $ BPI.m_nmMappedPower3, Outer);
    log(Self.Name, "m_nmMappedPower4: " $ BPI.m_nmMappedPower4, Outer);
    log(Self.Name, "m_nmMappedPower5: " $ BPI.m_nmMappedPower5, Outer);
    log(Self.Name, "m_nmMappedPower6: " $ BPI.m_nmMappedPower6, Outer);
    log(Self.Name, "m_nmMappedPower7: " $ BPI.m_nmMappedPower7, Outer);
    log(Self.Name, "===================================", Outer);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ListenedEventTypes = (SFSEventType.EVT_TRansferPowers)
    bDebug = TRUE
    keys = ('One', 'Two', 'Three')
}