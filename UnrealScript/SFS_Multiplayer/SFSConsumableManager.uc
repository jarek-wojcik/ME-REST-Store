Class SFSConsumableManager extends SFSManager within SFXPawn;

const MAX_CHECK_ATTEMPTS = 40;

var SFSCharacterModelStruct PendingCharacter;
var SFXPawn PendingPawn;
var int CheckAttempts;

public function ApplyConsumables(SFSCharacterModelStruct Character, SFXPawn Pawn)
{
    PendingCharacter = Character;
    PendingPawn = Pawn;
    // If the character carries no weapons there is nothing to wait for.
    if (Character.WeaponCount == 0)
    {
        DoApplyConsumables();
        return;
    }
    CheckAttempts = 0;
    // Poll every 0.25 s until all async weapon loads have settled in InvManager.
    Outer.SetTimer(0.25, TRUE, 'CheckWeaponsLoaded', Self);
}
function CheckWeaponsLoaded()
{
    local SFXWeapon Weapon;
    local int LoadedCount;
    
    CheckAttempts++;
    if (PendingPawn == None || PendingPawn.InvManager == None)
    {
        Outer.ClearTimer('CheckWeaponsLoaded', Self);
        return;
    }
    foreach PendingPawn.InvManager.InventoryActors(Class'SFXWeapon', Weapon)
    {
        if (SFXHeavyWeapon(Weapon) == None)
        {
            LoadedCount++;
        }
    }
    if (LoadedCount >= PendingCharacter.WeaponCount)
    {
        log(Self.Name, "All " $ LoadedCount $ " weapons loaded after " $ CheckAttempts $ " tick(s), applying consumables", Outer);
        Outer.ClearTimer('CheckWeaponsLoaded', Self);
        DoApplyConsumables();
        return;
    }
    if (CheckAttempts >= 40)
    {
        log(Self.Name, "Warning: Timed out waiting for weapons (" $ LoadedCount $ "/" $ PendingCharacter.WeaponCount $ "), applying consumables anyway", Outer);
        Outer.ClearTimer('CheckWeaponsLoaded', Self);
        DoApplyConsumables();
    }
}
private final function DoApplyConsumables()
{
    local SFXModule_GameEffectManager GEManager;
    
    if (PendingPawn == None)
    {
        log(Self.Name, "Error: Pawn is None, cannot apply consumables", Outer);
        return;
    }
    GEManager = PendingPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (GEManager == None)
    {
        log(Self.Name, "Error: GEManager is None, cannot apply consumables", Outer);
        return;
    }
    // Remove any previously applied match consumable effects before reapplying.
    GEManager.RemoveEffectsByCategory('MatchConsumableGameEffect');
    ApplyConsumableSlot(PendingCharacter.Inventory.ArmorConsumableID, GEManager, PendingPawn, 2.0);
    // Tier 3 (index 2)
    ApplyConsumableSlot(PendingCharacter.Inventory.WeaponConsumableID, GEManager, PendingPawn, 2.0);
    // Tier 3 (index 2)
    ApplyConsumableSlot(PendingCharacter.Inventory.AmmoConsumableID, GEManager, PendingPawn, 2.0);
    // Tier 3 (index 2)
    ApplyConsumableSlot(PendingCharacter.Inventory.GearConsumableID, GEManager, PendingPawn, 4.0);
    // Tier 5 (index 4)
}
public function RemoveConsumables(SFXPawn Pawn)
{
    local SFXModule_GameEffectManager GEManager;
    
    if (Pawn == None)
    {
        return;
    }
    GEManager = Pawn.GetModule(Class'SFXModule_GameEffectManager');
    if (GEManager != None)
    {
        GEManager.RemoveEffectsByCategory('MatchConsumableGameEffect');
        log(Self.Name, "Removed all match consumable effects", Outer);
    }
}
private final function ApplyConsumableSlot(string EffectClassPath, SFXModule_GameEffectManager GEManager, SFXPawn Pawn, float Tier)
{
    local Class<SFXGameEffect> EffectClass;
    
    if (EffectClassPath == "")
    {
        return;
    }
    EffectClass = Class'SFXGameEffect'.static.LoadGameEffectClass(EffectClassPath);
    if (EffectClass == None)
    {
        log(Self.Name, "Could not load effect class: " $ EffectClassPath, Outer);
        return;
    }
    // DurationType 2 = permanent-for-match; Duration 0.0.
    // Tier is the 0-based VersionIdx read by SFXGameEffect_MatchConsumableBase.OnApplied().
    // We do NOT call Consume() so we do not decrement the player's inventory stock.
    GEManager.CreateAndApplyEffect(EffectClass, 'MatchConsumableGameEffect', 0.0, 2, Tier, Pawn.Controller);
    log(Self.Name, "Applied consumable effect: " $ EffectClassPath $ " (tier " $ int(Tier) + 1 $ ")", Outer);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}