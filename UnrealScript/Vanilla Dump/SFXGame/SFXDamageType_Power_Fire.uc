Class SFXDamageType_Power_Fire extends SFXDamageType_Power
    config(Weapon);

public static final function EAICustomAction PickFireReaction(BioPawn Target)
{
    local array<EAICustomAction> Actions;
    
    if (FRand() >= default.PowerReactionChance)
    {
        return EAICustomAction.CA_None;
    }
    if (Target.CustomActionClasses[103] != None)
    {
        Actions.AddItem(103);
    }
    if (Target.CustomActionClasses[104] != None)
    {
        Actions.AddItem(104);
    }
    if (Actions.Length > 0)
    {
        return Actions[Rand(Actions.Length)];
    }
    return EAICustomAction.CA_None;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=DamagedFFWave
    End Template
    ShieldHitFFWaveform = DamagedFFWave
    DamagedFFWaveform = DamagedFFWave
    KilledFFWaveform = DamagedFFWave
    FracturedMeshDamage = 10.0
}