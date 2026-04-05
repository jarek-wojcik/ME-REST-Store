Class SFXDamageType_Power_Freeze extends SFXDamageType_Power
    config(Weapon);

public static final function EAICustomAction PickFreezeReaction(BioPawn Target)
{
    local array<EAICustomAction> Actions;
    
    if (Target.CustomActionClasses[107] != None)
    {
        Actions.AddItem(107);
    }
    if (Target.CustomActionClasses[108] != None)
    {
        Actions.AddItem(108);
    }
    if (Target.CustomActionClasses[109] != None)
    {
        Actions.AddItem(109);
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
    FracturedMeshDamage = 20.0
}