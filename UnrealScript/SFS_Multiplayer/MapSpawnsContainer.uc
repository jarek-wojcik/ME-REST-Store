Class MapSpawnsContainer;

struct SpawnPoint 
{
    var Vector location;
    var Rotator Rotation;
};

var string MapName;
var string AlternativeName;
var array<SpawnPoint> spawnPoints;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}