Class SFXNuiSpeech_Combat
    native
    transient;

const SWITCH_WEAPON_STRREF = 680987;

var Vector TargetLocation;
var Actor SelectionTarget;
var Actor Target;

public static final event function CollectWeapons(BioPawn Pawn, out array<stringref> WeaponNames)
{
    local SFXInventoryManager Inv;
    local SFXWeapon Weap;
    
    Inv = SFXInventoryManager(Pawn.InvManager);
    if (Inv != None)
    {
        foreach Inv.InventoryActors(Class'SFXWeapon', Weap)
        {
            WeaponNames.AddItem(Weap.NuiSpeechName);
        }
    }
}
public static event function string GetPlayerClassName(BioPawn member)
{
    local SFXPawn_Player PlayerPawn;
    
    PlayerPawn = SFXPawn_Player(member);
    if (PlayerPawn == None || PlayerPawn.PlayerClass == None)
    {
        return "";
    }
    return PlayerPawn.PlayerClass.className;
}
public static event function stringref GetPlayerClassStringRef(BioPawn member)
{
    local SFXPawn_Player PlayerPawn;
    
    PlayerPawn = SFXPawn_Player(member);
    if (PlayerPawn == None || PlayerPawn.PlayerClass == None)
    {
        return $0;
    }
    return stringref(PlayerPawn.PlayerClass.srClassName);
}
public event function stringref GetSWITCH_WEAPON_STRREF()
{
    return $680987;
}
public static final event function HenchmanCleared();

public static final event function HenchmanSelected(SFXGRI GRI, out array<BioPawn> Pawns)
{
    local int i;
    
    for (i = 0; i < Pawns.Length; ++i)
    {
        GRI.VocManager.TriggerVocalizationEvent(8, Pawns[i]);
    }
}
public static final event function SetWeapon(BioPlayerController Controller, BioPawn TargetPawn, stringref WeaponName)
{
    local SFXInventoryManager Inv;
    local SFXWeapon Weap;
    
    Inv = SFXInventoryManager(TargetPawn.InvManager);
    if (Inv != None)
    {
        foreach Inv.InventoryActors(Class'SFXWeapon', Weap)
        {
            if (Weap.PrettyName == WeaponName || Weap.NuiSpeechName == WeaponName)
            {
                Controller.OrderWeaponSwitch(TargetPawn, Weap, 1);
                return;
            }
            else if (WeaponName == 680987 && !ClassIsChildOf(Weap.Class, Inv.CurrentWeaponSelection))
            {
                Controller.OrderWeaponSwitch(TargetPawn, Weap, 1);
                return;
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}