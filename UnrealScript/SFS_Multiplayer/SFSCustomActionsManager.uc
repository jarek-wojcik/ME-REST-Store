Class SFSCustomActionsManager extends SFSManager within SFXPawn;

const EvadeRangeStart = 54;
const EvadeRangeEnd = 57;
const HeavyMeleeIndex = 58;
const OptionalHeavyMeleeIndex = 73;
const LightMeleeRangeStart = 75;
const LightMeleeRangeEnd = 80;

var SFSPortalAsyncLoader asyncLoader;

public event simulated function HandlePostAdd()
{
    asyncLoader = Outer.GetModule(Class'SFSPortalAsyncLoader');
    default.bDebug = TRUE;
}
public function MigrateCustomActions(SFSCharacterModelStruct Character, SFXPawn Pawn)
{
    if (asyncLoader == None)
    {
        log(Self.Name, "MigrateCustomActions: asyncLoader is None", Outer);
        return;
    }
    if (Character.DodgeCharId != "")
    {
        log(Self.Name, "MigrateCustomActions: Loading dodge pawn: " $ Character.DodgeCharId, Outer);
        asyncLoader.LoadAsync(Character.DodgeCharId, 0, OnDodgePawnLoaded);
    }
    if (Character.HeavyMeleeCharId != "")
    {
        log(Self.Name, "MigrateCustomActions: Loading heavy melee pawn: " $ Character.HeavyMeleeCharId, Outer);
        asyncLoader.LoadAsync(Character.HeavyMeleeCharId, 0, OnHeavyMeleePawnLoaded);
    }
    if (Character.LightMeleeCharId != "")
    {
        log(Self.Name, "MigrateCustomActions: Loading light melee pawn: " $ Character.LightMeleeCharId, Outer);
        asyncLoader.LoadAsync(Character.LightMeleeCharId, 0, OnLightMeleePawnLoaded);
    }
}
function OnDodgePawnLoaded(SFSGenericAsyncLoad load, SFXPawn Owner)
{
    local SFXPawn_PlayerMP TargetMP;
    local SFXPawn_PlayerMP SourceMP;
    local int i;
    
    TargetMP = SFXPawn_PlayerMP(Owner);
    if (TargetMP == None || load.LoadedPlayerMP == None)
    {
        log(Self.Name, "OnDodgePawnLoaded: invalid inputs", Outer);
        return;
    }
    SourceMP = load.LoadedPlayerMP;
    if (SourceMP.PlayerClass == None)
    {
        log(Self.Name, "OnDodgePawnLoaded: source PlayerClass is None", Outer);
        return;
    }
    log(Self.Name, "OnDodgePawnLoaded: Migrating dodge CAs from " $ SourceMP, Outer);
    for (i = 54; i <= 57; i++)
    {
        if (i < SourceMP.PlayerClass.CustomActionClasses.Length && SourceMP.PlayerClass.CustomActionClasses[i] != None)
        {
            log(Self.Name, "  Slot " $ i $ " <- " $ SourceMP.PlayerClass.CustomActionClasses[i], Outer);
            TargetMP.CustomActionClasses[i] = SourceMP.PlayerClass.CustomActionClasses[i];
            HandleVorchaDodge(TargetMP.CustomActionClasses[i]);
            TargetMP.VerifyCAHasBeenInstanced(i);
        }
    }
    log(Self.Name, "OnDodgePawnLoaded: Done", Outer);
}
function OnHeavyMeleePawnLoaded(SFSGenericAsyncLoad load, SFXPawn Owner)
{
    local SFXPawn_PlayerMP TargetMP;
    local SFXPawn_PlayerMP SourceMP;
    
    TargetMP = SFXPawn_PlayerMP(Owner);
    if (TargetMP == None || load.LoadedPlayerMP == None)
    {
        log(Self.Name, "OnHeavyMeleePawnLoaded: invalid inputs", Outer);
        return;
    }
    SourceMP = load.LoadedPlayerMP;
    if (SourceMP.PlayerClass == None)
    {
        log(Self.Name, "OnHeavyMeleePawnLoaded: source PlayerClass is None", Outer);
        return;
    }
    log(Self.Name, "OnHeavyMeleePawnLoaded: Migrating heavy melee CAs from " $ SourceMP, Outer);
    if (58 < SourceMP.PlayerClass.CustomActionClasses.Length && SourceMP.PlayerClass.CustomActionClasses[58] != None)
    {
        log(Self.Name, "  Slot " $ 58 $ " <- " $ SourceMP.PlayerClass.CustomActionClasses[58], Outer);
        TargetMP.CustomActionClasses[58] = SourceMP.PlayerClass.CustomActionClasses[58];
        TargetMP.VerifyCAHasBeenInstanced(58);
    }
    if (73 < SourceMP.PlayerClass.CustomActionClasses.Length && SourceMP.PlayerClass.CustomActionClasses[73] != None)
    {
        log(Self.Name, "  Slot " $ 73 $ " <- " $ SourceMP.PlayerClass.CustomActionClasses[73], Outer);
        TargetMP.CustomActionClasses[73] = SourceMP.PlayerClass.CustomActionClasses[73];
        TargetMP.VerifyCAHasBeenInstanced(73);
    }
    log(Self.Name, "OnHeavyMeleePawnLoaded: Done", Outer);
    // TODO: After migrating the heavy melee CA, swap the cast sounds to preserve correct gender voicing.
    // Both source and target CAs have a SFXTimelineData object named Timeline0 which contains an array of
    // TimelineEffect structs in its Timeline array. Iterate over them on both old and new CA instances to
    // find entries where Sound or PlayerSound contains "cast", then copy the sounds from the original
    // target CA into the newly loaded one. Otherwise a female character will play male cast sounds and
    // vice versa.
}
function OnLightMeleePawnLoaded(SFSGenericAsyncLoad load, SFXPawn Owner)
{
    local SFXPawn_PlayerMP TargetMP;
    local SFXPawn_PlayerMP SourceMP;
    local int i;
    
    TargetMP = SFXPawn_PlayerMP(Owner);
    if (TargetMP == None || load.LoadedPlayerMP == None)
    {
        log(Self.Name, "OnLightMeleePawnLoaded: invalid inputs", Outer);
        return;
    }
    SourceMP = load.LoadedPlayerMP;
    if (SourceMP.PlayerClass == None)
    {
        log(Self.Name, "OnLightMeleePawnLoaded: source PlayerClass is None", Outer);
        return;
    }
    log(Self.Name, "OnLightMeleePawnLoaded: Migrating light melee CAs from " $ SourceMP, Outer);
    for (i = 75; i <= 80; i++)
    {
        if (i < SourceMP.PlayerClass.CustomActionClasses.Length && SourceMP.PlayerClass.CustomActionClasses[i] != None)
        {
            log(Self.Name, "  Slot " $ i $ " <- " $ SourceMP.PlayerClass.CustomActionClasses[i], Outer);
            TargetMP.CustomActionClasses[i] = SourceMP.PlayerClass.CustomActionClasses[i];
            TargetMP.VerifyCAHasBeenInstanced(i);
        }
    }
    log(Self.Name, "OnLightMeleePawnLoaded: Done", Outer);
}
public function HandleVorchaDodge(Class<BioCustomAction> vorchaDodge)
{
    local Class<SFXCustomAction_VorchaEvadeBackwards_Shared> vorchaBackwards;
    local Class<SFXCustomAction_VorchaEvadeForward_Shared> vorchaForward;
    local Class<SFXCustomAction_VorchaEvadeLeft_Shared> vorchaLeft;
    local Class<SFXCustomAction_VorchaEvadeRight_Shared> vorchaRight;
    local SFXAnimSetCookSpec AnimInfo;
    
    if (Class<SFXCustomAction_VorchaEvadeBackwards_Shared>(vorchaDodge) != None)
    {
        AnimInfo = Class<SFXCustomAction_VorchaEvadeBackwards_Shared>(vorchaDodge).default.AnimInfo;
    }
    else if (Class<SFXCustomAction_VorchaEvadeForward_Shared>(vorchaDodge) != None)
    {
        AnimInfo = Class<SFXCustomAction_VorchaEvadeForward_Shared>(vorchaDodge).default.AnimInfo;
    }
    else if (Class<SFXCustomAction_VorchaEvadeLeft_Shared>(vorchaDodge) != None)
    {
        AnimInfo = Class<SFXCustomAction_VorchaEvadeLeft_Shared>(vorchaDodge).default.AnimInfo;
    }
    else if (Class<SFXCustomAction_VorchaEvadeRight_Shared>(vorchaDodge) != None)
    {
        AnimInfo = Class<SFXCustomAction_VorchaEvadeRight_Shared>(vorchaDodge).default.AnimInfo;
    }
    if (AnimInfo != None && AnimInfo.AnimSet.Sequences.Length > 0)
    {
        log(Self.Name, "Handling a Vorcha Dodge", Outer);
        AnimInfo.AnimSet.Sequences[0].Notifies.Remove(0, AnimInfo.AnimSet.Sequences[0].Notifies.Length);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}