Class SFSBotLoadoutContainer extends SFSCore within SFSBotManager;

var BotTemplate assaultTemplate;
var SFXLoadoutData assaultLoadout;
var BotTemplate sniperTemplate;
var SFXLoadoutData sniperLoadout;
var BotTemplate AdeptTemplate;
var SFXLoadoutData AdeptLoadout;
var BotTemplate EngineerTemplate;
var SFXLoadoutData EngineerLoadout;
var BotTemplate VanguardTemplate;
var SFXLoadoutData VanguardLoadout;
var BotTemplate SentinelTemplate;
var SFXLoadoutData SentinelLoadout;

public function ModifyBotLoadout(SFXPawn_Player AIPawn)
{
    AIPawn.Loadout = AssignLoadout(AIPawn);
    AIPawn.GenerateInventoryFromLoadout(AIPawn.Loadout);
}
public function SFXLoadoutData AssignLoadout(SFXPawn_Player AIPawn)
{
    local ECharacterClass CharacterClass;
    local SFXLoadoutData Loadout;
    
    CharacterClass = AIPawn.PlayerClass.ClassType;
    switch (CharacterClass)
    {
        case ECharacterClass.ClassType_Adept:
            LoadAdeptLoadout();
            Loadout = AdeptLoadout;
            break;
        case ECharacterClass.ClassType_Soldier:
            LoadAssaultLoadout();
            Loadout = assaultLoadout;
            break;
        case ECharacterClass.ClassType_Sentinel:
            LoadSentinelLoadout();
            Loadout = SentinelLoadout;
            break;
        case ECharacterClass.ClassType_Engineer:
            LoadEngineerLoadout();
            Loadout = EngineerLoadout;
            break;
        case ECharacterClass.ClassType_Vanguard:
            LoadVanguardLoadout();
            Loadout = VanguardLoadout;
            break;
        case ECharacterClass.ClassType_Infiltrator:
            LoadSniperLoadout();
            Loadout = sniperLoadout;
            break;
        default:
            LoadAssaultLoadout();
            Loadout = assaultLoadout;
            break;
    }
    return Loadout;
}
public function LoadVanguardLoadout()
{
    local SFXPawn TemplatePawn;
    
    if (VanguardLoadout == None)
    {
        TemplatePawn = loadTemplatePawn(default.VanguardTemplate);
        VanguardLoadout = TemplatePawn.Loadout;
        TemplatePawn.Destroy();
    }
    log(Self.Name, "Vanguard Loadout is: " $ VanguardLoadout, SFXPawn(Outer.ModuleOwner));
}
public function LoadSentinelLoadout()
{
    local SFXPawn TemplatePawn;
    
    if (SentinelLoadout == None)
    {
        TemplatePawn = loadTemplatePawn(default.SentinelTemplate);
        SentinelLoadout = TemplatePawn.Loadout;
        TemplatePawn.Destroy();
    }
    log(Self.Name, "Sentinel Loadout is: " $ SentinelLoadout, SFXPawn(Outer.ModuleOwner));
}
public function LoadEngineerLoadout()
{
    local SFXPawn TemplatePawn;
    
    if (EngineerLoadout == None)
    {
        TemplatePawn = loadTemplatePawn(default.EngineerTemplate);
        EngineerLoadout = TemplatePawn.Loadout;
        TemplatePawn.Destroy();
    }
    log(Self.Name, "Engineer Loadout is: " $ EngineerLoadout, SFXPawn(Outer.ModuleOwner));
}
public function LoadAssaultLoadout()
{
    local SFXPawn TemplatePawn;
    
    if (assaultLoadout == None)
    {
        TemplatePawn = loadTemplatePawn(default.assaultTemplate);
        assaultLoadout = TemplatePawn.Loadout;
        TemplatePawn.Destroy();
    }
    log(Self.Name, "Assault Loadout is: " $ assaultLoadout, SFXPawn(Outer.ModuleOwner));
}
public function LoadSniperLoadout()
{
    local SFXPawn TemplatePawn;
    
    if (sniperLoadout == None)
    {
        TemplatePawn = loadTemplatePawn(default.sniperTemplate);
        sniperLoadout = TemplatePawn.Loadout;
        TemplatePawn.Destroy();
    }
    log(Self.Name, "Sniper Loadout is: " $ sniperLoadout, SFXPawn(Outer.ModuleOwner));
}
public function LoadAdeptLoadout()
{
    local SFXPawn TemplatePawn;
    
    if (AdeptLoadout == None)
    {
        TemplatePawn = loadTemplatePawn(default.AdeptTemplate);
        AdeptLoadout = TemplatePawn.Loadout;
        TemplatePawn.Destroy();
    }
    log(Self.Name, "Adept Loadout is: " $ AdeptLoadout, SFXPawn(Outer.ModuleOwner));
}
public function SFXPawn loadTemplatePawn(BotTemplate BotTemplate)
{
    local Actor PlayerArchetype;
    local SFXPawn TemplatePawn;
    local Vector location;
    
    PlayerArchetype = SFXPawn(Class'SFXEngine'.static.GetSeekFreeObject(BotTemplate.Archetype, Class'SFXPawn'));
    location.X = -10000.0;
    location.Y = -10000.0;
    location.Z = -10000.0;
    TemplatePawn.SetLocation(location, );
    return TemplatePawn;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    assaultTemplate = {Archetype = "Char_Enemies.Archetypes.Cerberus.Centurion"}
    sniperTemplate = {Archetype = "Char_Enemies.Archetypes.Cerberus.Nemesis"}
    AdeptTemplate = {Archetype = "char_enemies.Archetypes.Cerberus.Engineer"}
    SentinelTemplate = {Archetype = "char_enemies.Archetypes.Cerberus.Engineer"}
    VanguardTemplate = {Archetype = "Char_Enemies.Archetypes.Geth.GethTrooper"}
    EngineerTemplate = {Archetype = "Char_Enemies.Archetypes.Geth.GethTrooper"}
}