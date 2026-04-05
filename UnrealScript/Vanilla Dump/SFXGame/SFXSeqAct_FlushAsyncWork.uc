Class SFXSeqAct_FlushAsyncWork extends SequenceAction;

public function Activated()
{
    local Object pCurObject;
    local Actor pCurActor;
    local SkeletalMeshComponent pCurSMC;
    local Controller pCurController;
    
    foreach Targets(pCurObject, )
    {
        pCurActor = Actor(pCurObject);
        if (pCurActor == None)
        {
            pCurController = Controller(pCurObject);
            if (pCurController != None)
            {
                pCurActor = pCurController.Pawn;
            }
        }
        if (pCurActor != None)
        {
            foreach pCurActor.ComponentList(Class'SkeletalMeshComponent', pCurSMC)
            {
                pCurSMC.SFXFlushAsyncWork();
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
}