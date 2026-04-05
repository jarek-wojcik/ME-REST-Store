Class RvrSeqAct_StoppableClientEffect extends SequenceAction
    native;

var transient Guid m_LastStarted;
var(RvrSeqAct_StoppableClientEffect) Vector m_vSpawnParameters;
var(RvrSeqAct_StoppableClientEffect) RvrClientEffectInterface m_pEffect;
var(RvrSeqAct_StoppableClientEffect) bool m_bAllowCooldown;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_bAllowCooldown = TRUE
    InputLinks = ({
                   LinkDesc = "Start", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Stop", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
}