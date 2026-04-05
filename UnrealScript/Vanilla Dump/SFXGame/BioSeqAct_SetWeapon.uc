Class BioSeqAct_SetWeapon extends SequenceAction
    native;

enum EBioSeqActSetWeaponLinks
{
    EBioSeqActSetWeaponLinks_Success,
    EBioSeqActSetWeaponLinks_Failure,
};

var(BioSeqAct_SetWeapon) Class<SFXWeapon> cWeapon;
var(BioSeqAct_SetWeapon) BioPawn oPawn;
var int nWeapon;

public function Activated()
{
    OutputLinks[0].bHasImpulse = FALSE;
    OutputLinks[1].bHasImpulse = FALSE;
    if (oPawn != None && oPawn.SetWeaponImmediatelyByClass(cWeapon))
    {
        OutputLinks[0].bHasImpulse = TRUE;
    }
    else
    {
        OutputLinks[1].bHasImpulse = TRUE;
    }
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 3;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Success", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Failed", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Pawn", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'oPawn', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
    bManualHandleOutputs = TRUE
}