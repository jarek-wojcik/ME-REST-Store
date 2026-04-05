Class SFXDamageType_InfernoGrenade extends SFXDamageType_Power_Fire
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    PowerReactionChance = 0.25
    Discipline = EBioCapMode.BIO_CAPMODE_COMBAT
    Resistance = {Armour = 1.5}
    ShieldHitFFWaveform = DamagedFFWave
    SourceDisplayName = $349055
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
    FracturedMeshDamage = 20.0
}