Class BioSeqAct_AddPlaypenVolume extends SequenceAction;

var(BioSeqAct_AddPlaypenVolume) array<Actor> Volumes;
var(BioSeqAct_AddPlaypenVolume) Actor Squad;

public function Activated()
{
    local int Index;
    local int SquadVolumesIndex;
    local BioBaseSquad TestSquad;
    local BioPlaypenVolume TestVolume;
    local bool bSubtractiveVolumeAdded;
    local bool bExistingPlaypen;
    local int nOriginalCount;
    
    TestSquad = BioBaseSquad(Squad);
    if (TestSquad == None)
    {
        return;
    }
    nOriginalCount = TestSquad.PlaypenVolumes.Length;
    for (Index = 0; Index < Volumes.Length; Index++)
    {
        TestVolume = BioPlaypenVolume(Volumes[Index]);
        if (TestVolume != None)
        {
            bExistingPlaypen = FALSE;
            for (SquadVolumesIndex = 0; SquadVolumesIndex < TestSquad.PlaypenVolumes.Length; SquadVolumesIndex++)
            {
                if (TestSquad.PlaypenVolumes[SquadVolumesIndex] == TestVolume)
                {
                    bExistingPlaypen = TRUE;
                    break;
                }
            }
            if (!bExistingPlaypen)
            {
                TestSquad.PlaypenVolumes.AddItem(TestVolume);
                if (TestVolume.bSubtractive)
                {
                    bSubtractiveVolumeAdded = TRUE;
                }
            }
        }
    }
    if (nOriginalCount == 0 && TestSquad.PlaypenVolumes.Length > 0 || bSubtractiveVolumeAdded)
    {
        TestSquad.UpdatePlaypen();
        TestSquad.NotifyPlaypenChanged();
    }
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 2;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Volumes", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'Volumes', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Squad", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'Squad', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}