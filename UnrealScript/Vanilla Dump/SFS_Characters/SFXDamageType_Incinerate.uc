Class SFXDamageType_Incinerate extends SFXDamageType_Power_Fire
    config(Weapon);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    Discipline = EBioCapMode.BIO_CAPMODE_TECH
    Resistance = {Shield = 0.5, Armour = 1.5, Biotic = 0.5}
    ShieldHitFFWaveform = DamagedFFWave
    CE_DeathEffect = RvrClientEffect'biovfx_c_fire.VCFX.Fire_Death_VCFX'
    SourceDisplayName = $244472
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
}