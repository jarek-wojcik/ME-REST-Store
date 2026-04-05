Class SFXSeqAct_WaitForPlayerSpawn extends SeqAct_Latent;

var transient bool bWaitForPlayerSpawn;

public event function bool Update(float DeltaTime)
{
    local Pawn PlayerPawn;
    local bool bDone;
    
    bDone = TRUE;
    if (InputLinks[0].bHasImpulse)
    {
        PlayerPawn = GetPlayerPawn();
        if (PlayerPawn != None)
        {
            bWaitForPlayerSpawn = FALSE;
        }
        else
        {
            bWaitForPlayerSpawn = TRUE;
        }
    }
    if (bWaitForPlayerSpawn)
    {
        PlayerPawn = GetPlayerPawn();
        if (PlayerPawn != None)
        {
            bWaitForPlayerSpawn = FALSE;
        }
        else
        {
            bDone = FALSE;
        }
    }
    if (bDone)
    {
        OutputLinks[0].bHasImpulse = TRUE;
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}
public final function BioPawn GetPlayerPawn()
{
    local BioWorldInfo BioWI;
    
    BioWI = BioWorldInfo(GetWorldInfo());
    if (BioWI != None && BioWI.m_playerSquad != None)
    {
        return BioWI.m_playerSquad.CachedPlayerPawn;
    }
    return None;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Out", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ()
}