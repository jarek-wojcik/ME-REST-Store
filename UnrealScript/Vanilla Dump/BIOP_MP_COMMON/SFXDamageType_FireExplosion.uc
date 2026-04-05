Class SFXDamageType_FireExplosion extends SFXDamageType_Power_Fire
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    Discipline = EBioCapMode.BIO_CAPMODE_TECH
    Resistance = {Armour = 2.0}
    ShieldHitFFWaveform = DamagedFFWave
    CE_DeathEffect = RvrClientEffect'biovfx_c_fire.VCFX.Fire_Death_VCFX'
    SourceDisplayName = $692226
    bCausesNormalizedDamage = TRUE
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
}