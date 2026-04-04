Class SFXCustomAction_StdCoverMeleeRight extends SFXCustomAction_CoverMeleeRight
    config(Game);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=HitShake0
    End Template
    Begin Template Class=SFXTimelineData Name=Timeline1
    End Template
    ForceFeedback = HitShake0
    BS_Anim = {
               AnimName = ('CB_StdCoverMeleeRight')
              }
    TimelineTemplate = Timeline1
}