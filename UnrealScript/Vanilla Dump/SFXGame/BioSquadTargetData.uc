Class BioSquadTargetData
    native;

struct native SquadTargetData 
{
    var Vector vLocation;
    var Actor oTarget;
    var int nActionIcon;
    var int nSquadIcon;
    var float fTimeOut;
    var bool bHidden;
    var bool bActive;
};

var transient SquadTargetData m_aSimpleSquadTargets[3];

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}