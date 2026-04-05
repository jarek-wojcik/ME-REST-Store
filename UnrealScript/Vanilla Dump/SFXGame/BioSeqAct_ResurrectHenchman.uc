Class BioSeqAct_ResurrectHenchman extends SequenceAction;

var(BioSeqAct_ResurrectHenchman) float PctHealthRegained;

public function Activated()
{
    local WorldInfo WorldInfo;
    local PlayerController PC;
    local BioBaseSquad Squad;
    local Actor member;
    local int idx;
    
    WorldInfo = Class'Engine'.static.GetCurrentWorldInfo();
    if (WorldInfo != None)
    {
        foreach WorldInfo.LocalPlayerControllers(Class'PlayerController', PC)
        {
            if (PC != None && BioPawn(PC.Pawn) != None)
            {
                Squad = BioPawn(PC.Pawn).Squad;
                if (Squad != None)
                {
                    for (idx = 0; idx < Squad.Members.Length; idx++)
                    {
                        member = Squad.Members[idx];
                        if (member != PC.Pawn && BioPawn(member) != None)
                        {
                            BioPawn(member).Resurrect(PctHealthRegained, TRUE);
                        }
                    }
                }
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    PctHealthRegained = 0.200000003
}