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
    
    log(Self.Name, "Beginning Transfer Powers", Outer);
    replacementIndex = Powers[0];
    originalIndex = Powers[1];
    //Get the class of the kit from which we will transfer the power
    SaveManager.GetMPCharacterRecord(KitName, kitSave);
    fromCharacterClass = SaveManager.getKitClass(kitSave);
    //Creates a new PowerSaveInfo array and reloads powers through the PowerManager;
    log(Self.Name, "Character Class" $ fromCharacterClass $ " Kit: " $ KitName $ " Power from: " $ replacementIndex $ " Power to: " $ originalIndex, Outer);
    createPowerSaveInfoAndReload(fromCharacterClass, kitSave, replacementIndex, originalIndex);
    printArrayContents(Self.Name, Outer, Outer.PowerCustomActionClasses, "Power Custom Action Classes");
    printArrayContents(Self.Name, Outer, Outer.PowerCustomActions, "Power Custom Actions");
    LogPowerManagerPowers();
    LogMappedPowers();
}
public function createPowerSaveInfoAndReload(Class<SFXCharacterClass> fromCharacterClass, SFXMPCharacterRecord kitSave, int replacementIndex, int originalIndex)
{
    local PowerSaveInfo replacementPowerSaveInfo;
    local SFXPowerCustomActionBase originalPower;
    local bool b_hasReplacementInfo;
    local bool b_hasEvolvedChoices;
    local int idx;
    local PowerSaveInfo it;
    local Name originalPowerName;
    local Class<SFXPowerCustomActionBase> NewPowerClass;
    local SFXPawn_PlayerMP Player;
    
    log(Self.Name, "createPowerSaveInfoAndReload----", Outer);
    Player = SFXPawn_PlayerMP(Outer);
    b_hasReplacementInfo = getReplacementPowerSaveInfo(fromCharacterClass, kitSave, replacementIndex, replacementPowerSaveInfo, b_hasEvolvedChoices);
    originalPower = Outer.PowerManager.GetPowerByClass(Player.PlayerClass.SquadScreenPowerOrder[originalIndex]);
    if (b_hasReplacementInfo)
    {
        log(Self.Name, "Has Replacement Info, Creating replacement save", Outer);
        if (!b_hasEvolvedChoices)
        {
            log(Self.Name, "No Evolved Choices for replacement save, will use all 0s", Outer);
            for (idx = 0; idx < 6; idx++)
            {
                replacementPowerSaveInfo.EvolvedChoices[idx] = originalPower.EvolvedChoices[idx];
                log(Self.Name, "Adding power save evolution data at choice " $ idx $ " and value " $ replacementPowerSaveInfo.EvolvedChoices[idx], Outer);
            }
        }
        else
        {
            log(Self.Name, "Has Evolved choices in replacement save", Outer);
        }
        replacementPowerSaveInfo.WheelDisplayIndex = originalPower.WheelDisplayIndex;
        Outer.PowerManager.RemovePower(originalPower.Class);
    }
    //NewPowerClass is assigned in the LoadPower function.
    LoadPower(replacementPowerSaveInfo, originalIndex, NewPowerClass);
    //Update Player Class to redraw the UI
    Player.PlayerClass.SquadScreenPowerOrder.Remove(originalIndex, 1);
    Player.PlayerClass.SquadScreenPowerOrder.InsertItem(originalIndex, NewPowerClass);
    //We need to update mapped powers for gamepad users.
    Player.PlayerClass.MappedPowers.Remove(originalIndex, 1);
    Player.PlayerClass.MappedPowers.InsertItem(originalIndex, NewPowerClass.Name);
    //This will update the HUD and allow us to use the new power.
    if (BPI.bUsingGamepad)
    {
        log(Self.Name, "Using a Gamepad", Outer);
        Class'SFSInputUtility'.static.AutoMapXbox(BPI, Player);
    }
    else
    {
        log(Self.Name, "Using KB/M", Outer);
        Player.AutoMapPC();
    }
}
public function LoadPower(PowerSaveInfo PowerSave, int originalIndex, out Class<SFXPowerCustomActionBase> powerClass)
{
    local int nIndex;
    local int nIndex2;
    local SFXPowerCustomActionBase Power;
    local SFXPowerCustomActionBase powerIterator;
    local int EvolveChoice;
    
    log(Self.Name, "LoadPowers----", Outer);
    if (SFXPawn_Player(Outer) != None)
    {
        powerClass = Class<SFXPowerCustomActionBase>(Class'SFXEngine'.static.LoadSeekFreeObjectBlocking(string(PowerSave.PowerClassName), Class'Class'));
        log(Self.Name, "PowerClass " $ powerClass, Outer);
        Power = AddPower(powerClass, originalIndex);
    }
    if (Power != None)
    {
        Power.ResetPower();
        Power.Rank = PowerSave.CurrentRank;
        Power.WheelDisplayIndex = PowerSave.WheelDisplayIndex;
        for (EvolveChoice = 1; EvolveChoice <= 3; EvolveChoice++)
        {
            for (nIndex2 = 0; nIndex2 < 6; nIndex2++)
            {
                if (PowerSave.EvolvedChoices[nIndex2] == EvolveChoice)
                {
                    log(Self.Name, "Evolving the power " $ Power $ " at choice " $ EvolveChoice $ " to " $ nIndex, Outer);
                    Power.EvolvePower(byte(nIndex2));
                    break;
                }
            }
        }
        Power.RecalculateAllPowerInfo(TRUE);
        SFXPawn_PlayerMP(Outer).ApplyWeaponEncumbrance();
    }
}
public function SFXPowerCustomActionBase AddPower(Class<SFXPowerCustomActionBase> PowerClassCast, int originalIndex)
{
    local SFXPowerCustomActionBase Power;
    local SFXPowerCustomActionBase PowerInList;
    local int nIndex;
    local int PowerID;
    
    if (PowerClassCast == None)
    {
        return Power;
    }
    log(Self.Name, "AddPower----", Outer);
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
        Outer.PowerManager.Powers.InsertItem(originalIndex, Power);
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
    local Class<SFXPowerCustomActionBase> NewPowerClass;
    local PowerRecord retrievedPowerRecord;
    local bool b_powerInSave;
    local bool b_result;
    local int idx;
    
    log(Self.Name, "getReplacementPowerSaveInfo----", Outer);
    //Find the power at the replacement index
    NewPowerClass = getPowerCustomActionAtIndex(fromCharacterClass, replacementIndex);
    b_powerInSave = SaveManager.getPowerRecordForClass(kitSave, NewPowerClass.Name, retrievedPowerRecord);
    log(Self.Name, "b_powerInSave " $ b_powerInSave, Outer);
    if (b_powerInSave)
    {
        for (idx = 0; idx < 6; idx++)
        {
            replacementPowerSave.EvolvedChoices[idx] = retrievedPowerRecord.EvolvedChoices[idx];
            log(Self.Name, "Adding power save evolution data at choice " $ idx $ " and value " $ replacementPowerSave.EvolvedChoices[idx], Outer);
        }
        replacementPowerSave.PowerName = retrievedPowerRecord.PowerName;
        replacementPowerSave.PowerClassName = retrievedPowerRecord.PowerClassName;
        replacementPowerSave.CurrentRank = retrievedPowerRecord.CurrentRank;
        hasEvolvedChoices = TRUE;
    }
    else
    {
        replacementPowerSave.PowerName = NewPowerClass.default.PowerName;
        replacementPowerSave.PowerClassName = NewPowerClass.Name;
        replacementPowerSave.CurrentRank = 6.0;
        hasEvolvedChoices = FALSE;
    }
    log(Self.Name, "PowerSaveInfo.PowerName " $ replacementPowerSave.PowerName, Outer);
    log(Self.Name, "PowerSaveInfo.PowerClassName " $ replacementPowerSave.PowerClassName, Outer);
    log(Self.Name, "PowerSaveInfo.CurrentRank " $ replacementPowerSave.CurrentRank, Outer);
    log(Self.Name, "PowerSaveInfo.WheelDisplayIndex " $ replacementPowerSave.WheelDisplayIndex, Outer);
    return TRUE;
}
public function Class<SFXPowerCustomActionBase> getPowerCustomActionAtIndex(Class<SFXCharacterClass> CharacterClass, int Index)
{
    return CharacterClass.default.SquadScreenPowerOrder[Index];
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