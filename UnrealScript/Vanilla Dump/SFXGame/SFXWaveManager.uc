Class SFXWaveManager extends Actor
    abstract
    transient;

var protectedwrite transient array<SFXWave> PotentialWaves;
var protectedwrite Class<SFXWave> PotentialWavesType;
var BioWorldInfo BioWorldInfo;

public event simulated function PostBeginPlay()
{
    BioWorldInfo = BioWorldInfo(WorldInfo);
}
public simulated function GeneratePotentialWaveList(optional Class<SFXWave> SpecifiedWaveType);

public simulated function SFXWave GetNewWave(int WaveIndex, Class<SFXWave> WaveType)
{
    local SFXWave NewWave;
    local SFXWave PotentialWave;
    
    if (WaveType != PotentialWavesType)
    {
        GeneratePotentialWaveList(WaveType);
    }
    PotentialWave = PotentialWaves[WaveIndex];
    if (PotentialWave != None)
    {
        NewWave = new PotentialWave.Class (PotentialWave);
        NewWave.InitializeWave(Self);
        return NewWave;
    }
    else
    {
        return None;
    }
}
public function int GetWaveIndex(optional int DesiredWaveIndex = -1, optional string WaveString = "");


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bAlwaysRelevant = TRUE
    RemoteRole = ENetRole.ROLE_SimulatedProxy
}