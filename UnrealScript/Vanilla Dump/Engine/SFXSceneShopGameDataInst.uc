Class SFXSceneShopGameDataInst extends SFXSceneShopDataInstInterface
    native
    transient;

struct native SFXSSEventHelper 
{
    var Name nmEventName;
    var SFXSceneShopNode pNode;
    var float fEventTime;
};
struct native SFXScenePlayData 
{
    var float fScenePosition;
    var bool bSceneNeedsStartup;
    var bool bSceneNeedsSmallTick;
    var bool bSceneFinished;
    var bool bSceneActive;
};

var native MultiMap_Mirror m_mapSceneTree;
var native Map_Mirror m_mapPlayingScenes;
var native MultiMap_Mirror m_mapSceneGroups;
var bool m_bProcessingScenes;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}