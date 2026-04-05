Class SFXAICmd_CA_DamageReaction extends SFXAICmd_CustomAction within SFXAI_Core;

public function float GetPostCustomActionSleepTime()
{
    return 0.100000001;
}
public function bool ShouldFinishRotation()
{
    local BioCustomAction CurrentAction;
    
    Outer.MyBP.GetCurrentCustomAction(CurrentAction);
    return SFXCustomAction_DamageReaction(CurrentAction).bRotateOnHit;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}