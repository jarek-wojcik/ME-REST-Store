Class SFXCustomAction_CustomLoopingInteraction extends SFXCustomAction_LoopingInteraction
    config(Game);

public function StartCustomAction()
{
    local SFXNav_InteractionHenchCustom CustomInteractionPoint;
    
    CustomInteractionPoint = SFXNav_InteractionHenchCustom(m_oPawn.Anchor);
    if (CustomInteractionPoint != None)
    {
        BS_InteractionStart.AnimName[0] = CustomInteractionPoint.StartAnim;
        BS_InteractionLoop.AnimName[0] = CustomInteractionPoint.LoopAnim;
        BS_InteractionEnd.AnimName[0] = CustomInteractionPoint.EndAnim;
        Super.StartCustomAction();
    }
    else
    {
        EndThisCustomAction();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}