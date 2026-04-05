Class BioSeqAct_RemoveFromParty extends SequenceAction;

public function Activated()
{
    local array<Object> aPawnObjects;
    local BioPawn objPawn;
    local int i;
    local BioWorldInfo BWI;
    
    GetObjectVars(aPawnObjects, "Pawns");
    BWI = BioWorldInfo(GetWorldInfo());
    for (i = 0; i < aPawnObjects.Length; ++i)
    {
        objPawn = BioPawn(aPawnObjects[i]);
        if (objPawn != None && objPawn.Squad != None)
        {
            if (SFXGRI(BWI.GRI).bPlayerCanChangeSquad == TRUE || BioPlayerController(objPawn.Controller) == None)
            {
                objPawn.Squad.RemoveMember(objPawn);
            }
        }
    }
    OutputLinks[0].bHasImpulse = TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Pawns", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'Targets', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}