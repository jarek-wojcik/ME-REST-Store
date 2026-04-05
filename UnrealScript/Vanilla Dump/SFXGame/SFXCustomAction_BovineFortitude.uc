Class SFXCustomAction_BovineFortitude extends SFXCustomAction_DamageReaction
    config(Game);

var float HealDuration;
var WwiseEvent Moo;

public function BodyStanceAnimEndNotification(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect Effect;
    
    Super.BodyStanceAnimEndNotification(SeqNode, PlayedTime, ExcessTime);
    Manager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        foreach Manager.GameEffects(Effect, )
        {
            if (Effect.Category == 'BovineFortitude')
            {
                Effect.CurrentTime = Effect.Duration - HealDuration;
            }
        }
    }
    m_oPawn.SetTimer(HealDuration, FALSE, 'DelayedSoundEffect', Self);
}
public function DelayedSoundEffect()
{
    SFXGRI(m_oPawn.WorldInfo.GRI).PlayTransientSound(Moo, m_oPawn.location);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    HealDuration = 1.0
    Moo = WwiseEvent'Wwise_VFX_Biotics.Play_vfx_bovine_fortitude'
    BS_Reaction = {
                   AnimName = ('DG_Impact_Staggering')
                  }
    fAnimPlayRate = 1.10000002
    fAnimBlendOutTime = 0.100000001
    bAllowAnimInterrupt = FALSE
    ERootMotionMode = ERootMotionMode.RMM_Translate
}