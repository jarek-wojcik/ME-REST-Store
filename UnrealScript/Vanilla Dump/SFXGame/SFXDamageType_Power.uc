Class SFXDamageType_Power extends SFXDamageType_Default
    config(Weapon);

var float PowerReactionChance;
var EBioCapMode Discipline;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    PowerReactionChance = 1.0
    ShieldHitFFWaveform = DamagedFFWave
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
}