Class SFXDamageType_Carnage extends SFXDamageType_Power
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    Discipline = EBioCapMode.BIO_CAPMODE_COMBAT
    Resistance = {Shield = 0.5, Armour = 1.5, Biotic = 0.5}
    ShieldHitFFWaveform = DamagedFFWave
    SourceDisplayName = $668831
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
    FracturedMeshDamage = 20.0
}