Class SFXCustomAction_HvyStdCoverMeleeLeft extends SFXCustomAction_HvyCoverMeleeLeft
    config(Game);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=ForceFeedbackWaveform Name=HitShake0
    End Template
    Begin Template Class=SFXTimelineData Name=Timeline2
    End Template
    ForceFeedback = HitShake0
    BS_Anim = {
               AnimName = ('CB_StdCoverMeleeLeft')
              }
    TimelineTemplate = Timeline2
}