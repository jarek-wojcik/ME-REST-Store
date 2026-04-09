Class SFXDamageType_BioticExplosion extends SFXDamageType_Power
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    Discipline = EBioCapMode.BIO_CAPMODE_BIOTICS
    Resistance = {Armour = 2.0, Biotic = 2.0}
    ShieldHitFFWaveform = DamagedFFWave
    SourceDisplayName = $687770
    bCausesNormalizedDamage = TRUE
    bCausesRagdoll = TRUE
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
}