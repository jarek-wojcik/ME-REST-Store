Class ZoneInfo extends Info
    native;

var(ZoneInfo) Class<KillZDamageType> KillZDamageType;
var(ZoneInfo) float KillZ;
var(ZoneInfo) float SoftKill;
var(ZoneInfo) bool bSoftKillZ;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    KillZDamageType = Class'KillZDamageType'
    KillZ = -262143.0
    SoftKill = 2500.0
    bStatic = TRUE
    bNoDelete = TRUE
    bGameRelevant = TRUE
}