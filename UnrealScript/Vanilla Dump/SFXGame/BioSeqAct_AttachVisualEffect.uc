Class BioSeqAct_AttachVisualEffect extends SequenceAction;

var(BioSeqAct_AttachVisualEffect) array<Actor> m_oAttachTo;
var(BioSeqAct_AttachVisualEffect) Vector m_vOffset;
var(BioSeqAct_AttachVisualEffect) Name m_nmSocketOrBone;
var(BioSeqAct_AttachVisualEffect) Object m_oEffect;

public function Activated()
{
    local int i;
    
    if (m_nmSocketOrBone == 'None')
    {
        m_nmSocketOrBone = 'Root';
    }
    for (i = 0; i < m_oAttachTo.Length; i++)
    {
    }
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 1;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "AttachTo", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'm_oAttachTo', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Socket", 
                      ExpectedType = Class'SeqVar_Name', 
                      LinkVar = 'None', 
                      PropertyName = 'm_nmSocketOrBone', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Offset", 
                      ExpectedType = Class'SeqVar_Vector', 
                      LinkVar = 'None', 
                      PropertyName = 'm_vOffset', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}