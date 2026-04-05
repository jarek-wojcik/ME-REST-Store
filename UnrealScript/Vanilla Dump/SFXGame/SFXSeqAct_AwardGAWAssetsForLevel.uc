Class SFXSeqAct_AwardGAWAssetsForLevel extends SequenceAction;

public function Activated()
{
    local WorldInfo WI;
    local SFXGame Game;
    local TD LevelTreasure;
    local string MissionName;
    local SFXGAWAssetsHandler GAWHandler;
    local int idx;
    
    WI = Class'WorldInfo'.static.GetWorldInfo();
    if (WI == None)
    {
        return;
    }
    Game = SFXGame(WI.Game);
    if (Game == None)
    {
        return;
    }
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return;
    }
    MissionName = WI.GetMapName();
    foreach Game.TREASURE.LevelTreasure(LevelTreasure, )
    {
        if (Locs(LevelTreasure.Level) == Locs(MissionName))
        {
            for (idx = 0; idx < LevelTreasure.TREASURE.Length; idx++)
            {
                if (Split(LevelTreasure.TREASURE[idx], "GAWAsset", TRUE) != LevelTreasure.TREASURE[idx])
                {
                    GAWHandler.UnlockGAWAssetByAssetName(LevelTreasure.TREASURE[idx]);
                }
            }
            return;
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    VariableLinks = ()
}