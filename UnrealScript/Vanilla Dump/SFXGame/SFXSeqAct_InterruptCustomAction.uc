Class SFXSeqAct_InterruptCustomAction extends SequenceAction;

public function Activated()
{
    local Object pCurObject;
    local BioPawn pCurPawn;
    local Controller pCurController;
    
    foreach Targets(pCurObject, )
    {
        pCurPawn = BioPawn(pCurObject);
        if (pCurPawn == None)
        {
            pCurController = Controller(pCurObject);
            if (pCurController != None)
            {
                pCurPawn = BioPawn(pCurController.Pawn);
            }
        }
        if (pCurPawn != None)
        {
            pCurPawn.bHACKStopCustomActionInstantly = TRUE;
            pCurPawn.InterruptCustomAction();
            pCurPawn.bHACKStopCustomActionInstantly = FALSE;
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
}