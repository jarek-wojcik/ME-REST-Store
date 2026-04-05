Class SFXDamageType_Power_Electrocute extends SFXDamageType_Power
    config(Weapon);

public static final function EAICustomAction PickElectrocuteReaction(BioPawn Target)
{
    local array<EAICustomAction> Actions;
    
    if (Target.CustomActionClasses[105] != None)
    {
        Actions.AddItem(105);
    }
    if (Target.CustomActionClasses[106] != None)
    {
        Actions.AddItem(106);
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
}