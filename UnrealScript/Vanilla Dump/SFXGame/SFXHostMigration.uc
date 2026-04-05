Class SFXHostMigration
    abstract
    transient;

var bool bNeedRestoration;

public function bool CanRestoreWave();

public function EnableRestoration(bool bEnable)
{
    bNeedRestoration = bEnable;
    if (!bNeedRestoration)
    {
        InvalidateAll();
    }
}
public static function SFXHostMigration GetHostMigration()
{
    return SFXEngine(Class'SFXEngine'.static.GetEngine()).HostMigration;
}
public function WaveEventInfo GetWaveToRestore();

public function bool HasCompleteAndValidState(SFXGRI GRI);

public function InvalidateAll();

public function RestorePRI(SFXPRI PRI);

public function SaveGRI(SFXGRI GRI);

public function SetWaveToRestore(WaveEventInfo InWave);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}