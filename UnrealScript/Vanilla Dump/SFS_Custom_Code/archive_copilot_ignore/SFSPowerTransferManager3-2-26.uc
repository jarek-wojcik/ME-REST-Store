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
    local SFXPawn_PlayerMP Player;
    local Class<SFXCharacterClass> fromCharacterClass;
    local Class<SFXCharacterClass> toCharacterClass;
    local SFXMPCharacterRecord kitSave;
    local Class<BioCustomAction> fromPowerClass;
    local Class<BioCustomAction> toPowerClass;
    local int fromIndex;
    local int toIndex;
    local int MappedPowerIndex;
    local int oldPowerIndex;
    local SFXPowerCustomActionBase NewPower;
    
    Player = SFXPawn_PlayerMP(Outer);
    toCharacterClass = Player.PlayerClass.Class;
    fromIndex = Powers[0];
    toIndex = Powers[1];
    log(Self.Name, "Kit: " $ KitName $ " Power from: " $ fromIndex $ " Power to: " $ toIndex, Outer);
    SaveManager.GetMPCharacterRecord(KitName, kitSave);
    fromCharacterClass = SaveManager.getKitClass(kitSave);
    log(Self.Name, "Kit Character Class" $ fromCharacterClass, Outer);
    fromPowerClass = getPowerCustomActionAtIndex(fromCharacterClass, fromIndex);
    toPowerClass = getPowerCustomActionAtIndex(toCharacterClass, toIndex);
    log(Self.Name, "From Power Class " $ fromPowerClass, Outer);
    log(Self.Name, "To Power Class " $ toPowerClass, Outer);
    NewPower = replacePower(toPowerClass, fromPowerClass, MappedPowerIndex, oldPowerIndex);
    EvolvePower(NewPower);
    LogMappedPowers();
    replaceBindings(toPowerClass, fromPowerClass, MappedPowerIndex, oldPowerIndex);
    LogMappedPowers();
}
public function Class<BioCustomAction> getPowerCustomActionAtIndex(Class<SFXCharacterClass> CharacterClass, int Index)
{
    local Name mappedName;
    local Class<BioCustomAction> powerClass;
    
    mappedName = CharacterClass.default.MappedPowers[Index];
    foreach CharacterClass.default.PowerCustomActionClasses(powerClass, )
    {
        if (powerClass.Name == mappedName)
        {
            break;
        }
    }
    return powerClass;
}
public function SFXPowerCustomActionBase replacePower(Class<BioCustomAction> OldPowerClass, Class<BioCustomAction> NewPowerClass, out int MappedPowerIndex, out int PowerIndex)
{
    local SFXPowerCustomActionBase OldPower;
    local SFXPowerCustomActionBase NewPower;
    local Class<SFXPowerCustomActionBase> OldPowerClassCast;
    local Class<SFXPowerCustomActionBase> NewPowerClassCast;
    local int OldPowerID;
    local int NewPowerID;
    local int i;
    local SFXPowerManager PowerManager;
    
    PowerManager = Outer.PowerManager;
    OldPowerClassCast = Class<SFXPowerCustomActionBase>(OldPowerClass);
    NewPowerClassCast = Class<SFXPowerCustomActionBase>(NewPowerClass);
    if (OldPowerClassCast == None || NewPowerClassCast == None)
    {
        return None;
    }
    // Find the old power
    OldPower = PowerManager.GetPowerByClass(OldPowerClass);
    if (OldPower == None)
    {
        return None;
    }
    // Get the index and ID of the old power
    PowerIndex = PowerManager.Powers.Find(OldPower);
    OldPowerID = OldPower.PowerCustomActionID;
    // Update the MappedPowers array to point to the new power name
    MappedPowerIndex = SFXPawn_Player(Outer).PlayerClass.MappedPowers.Find(OldPowerClass.Name);
    if (MappedPowerIndex != -1)
    {
        log(Self.Name, "Updating MappedPowers[" $ MappedPowerIndex $ "] from " $ SFXPawn_Player(Outer).PlayerClass.MappedPowers[MappedPowerIndex] $ " to " $ NewPowerClass.Name, Outer);
        SFXPawn_Player(Outer).PlayerClass.MappedPowers[MappedPowerIndex] = NewPowerClass.Name;
    }
    // Remove old power from array
    PowerManager.Powers.Remove(PowerIndex, 1);
    // Get the new power's ID
    NewPowerID = NewPowerClassCast.default.PowerCustomActionID;
    if (NewPowerID == 0)
    {
        return None;
    }
    // Clear old power references
    Outer.PowerCustomActionClasses[OldPowerID] = None;
    Outer.PowerCustomActions[OldPowerID] = None;
    // Assign new power class and instance it
    Outer.PowerCustomActionClasses[NewPowerID] = NewPowerClassCast;
    Outer.VerifyCAHasBeenInstanced(132, NewPowerID);
    // Get the new power instance
    NewPower = SFXPowerCustomActionBase(Outer.PowerCustomActions[NewPowerID]);
    if (NewPower != None)
    {
        // Insert at the same index as the old power
        PowerManager.Powers.InsertItem(PowerIndex, NewPower);
        // Notify other powers about the new addition
        for (i = 0; i < PowerManager.Powers.Length; ++i)
        {
            if (PowerManager.Powers[i] != None && PowerManager.Powers[i] != NewPower)
            {
                PowerManager.Powers[i].OnPowerAdded(NewPower);
            }
        }
        return NewPower;
    }
    return NewPower;
}
public function EvolvePower(SFXPowerCustomActionBase NewPower)
{
    NewPower.Rank = 1.0;
    NewPower.OnPowerRankIncreased();
}
public function replaceBindings(Class<BioCustomAction> OldPowerClass, Class<BioCustomAction> NewPowerClass, int MappedPowerIndex, int oldPowerIndex)
{
    log(Self.Name, "MappedPowerIndex:" $ MappedPowerIndex $ " OldPowerIndex: " $ oldPowerIndex, Outer);
    if (BPI.m_nmMappedPower == OldPowerClass.Name)
    {
        BPI.m_nmMappedPower = NewPowerClass.Name;
        SetKeyBindInternal(PC, keys[0], oldPowerIndex, FALSE, FALSE, FALSE);
    }
    else if (BPI.m_nmMappedPower2 == OldPowerClass.Name)
    {
        BPI.m_nmMappedPower2 = NewPowerClass.Name;
        SetKeyBindInternal(PC, keys[1], oldPowerIndex, FALSE, FALSE, FALSE);
    }
    else if (BPI.m_nmMappedPower3 == OldPowerClass.Name)
    {
        BPI.m_nmMappedPower3 = NewPowerClass.Name;
        SetKeyBindInternal(PC, keys[2], oldPowerIndex, FALSE, FALSE, FALSE);
    }
    else
    {
        log(Self.Name, "Didn't find a matching old power on BioPlayerInput", Outer);
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