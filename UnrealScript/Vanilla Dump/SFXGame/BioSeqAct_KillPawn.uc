Class BioSeqAct_KillPawn extends SequenceAction;

public function Activated()
{
    local BioPawn oPawn;
    local Controller oTargetController;
    local int i;
    
    for (i = 0; i != Targets.Length; ++i)
    {
        oTargetController = Controller(Targets[i]);
        oPawn = oTargetController != None ? BioPawn(oTargetController.Pawn) : BioPawn(Targets[i]);
        if (oPawn == None)
        {
            continue;
        }
        if (oPawn.IsDead())
        {
            continue;
        }
        if (oPawn.WorldInfo.Game.PreventDeath(oPawn, oPawn.Controller, Class'SFXDamageType_Suicide', oPawn.location))
        {
            return;
        }
        oPawn.Died(oPawn.Controller, Class'SFXDamageType_Suicide', oPawn.location);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}