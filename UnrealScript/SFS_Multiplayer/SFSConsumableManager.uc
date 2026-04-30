Class SFSConsumableManager extends SFSManager within SFXPawn;

public function ApplyConsumables(SFSCharacterModelStruct Character, SFXPawn Pawn)
{
    local SFXModule_GameEffectManager GEManager;
    local SFSEvent ConsumablesLoadedEvent;
    
    GEManager = Pawn.GetModule(Class'SFXModule_GameEffectManager');
    if (GEManager == None)
    {
        log(Self.Name, "Error: GEManager is None, cannot apply consumables", Outer);
        return;
    }
    // Remove any previously applied match consumable effects before reapplying.
    GEManager.RemoveEffectsByCategory('MatchConsumableGameEffect');
    ApplyConsumableSlot(Character.Inventory.ArmorConsumableID, GEManager, Pawn, 2.0);
    // Tier 3 (index 2)
    ApplyConsumableSlot(Character.Inventory.WeaponConsumableID, GEManager, Pawn, 2.0);
    // Tier 3 (index 2)
    ApplyConsumableSlot(Character.Inventory.AmmoConsumableID, GEManager, Pawn, 2.0);
    // Tier 3 (index 2)
    ApplyConsumableSlot(Character.Inventory.GearConsumableID, GEManager, Pawn, 4.0);
    // Tier 5 (index 4)
    ConsumablesLoadedEvent = new (Outer) Class'SFSEvent';
    ConsumablesLoadedEvent.sValue = Class'SFSGenericEventConstants'.default.ConsumablesLoaded_Event;
    AddSFSEvent(ConsumablesLoadedEvent, Outer);
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