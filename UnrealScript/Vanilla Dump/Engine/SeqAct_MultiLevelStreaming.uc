Class SeqAct_MultiLevelStreaming extends SeqAct_LevelStreamingBase
    native;

struct native LevelStreamingNameCombo 
{
    var(LevelStreamingNameCombo) const Name LevelName;
    var const LevelStreaming Level;
};

var(SeqAct_MultiLevelStreaming) array<LevelStreamingNameCombo> Levels;
var(SeqAct_MultiLevelStreaming) bool bUnloadAllOtherLevels;
var transient bool bStatusIsOk;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}