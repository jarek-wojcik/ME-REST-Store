Class SFXSeqAct_AwardGAWAsset_Silent extends SequenceAction;

var(SFXSeqAct_AwardGAWAsset_Silent) string AssetName;
var(SFXSeqAct_AwardGAWAsset_Silent) int Id;

public function Activated()
{
    local SFXGAWAssetsHandler GAWHandler;
    local bool bSuccess;
    
    OutputLinks[0].bHasImpulse = TRUE;
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return;
    }
    if (AssetName != "")
    {
        bSuccess = GAWHandler.UnlockGAWAssetByAssetName(AssetName);
    }
    else if (Id >= 0)
    {
        bSuccess = GAWHandler.UnlockGAWAsset(Id);
    }
    if (bSuccess)
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
    Id = -1
    bCallHandler = FALSE
    VariableLinks = ()
    bManualHandleOutputs = TRUE
}