Class SFXSkelControlLimb extends SkelControlLimb
    native;

struct native SkelControlProfile 
{
    var(SkelControlProfile) Vector EffectorLocation;
    var(SkelControlProfile) Vector JointTargetLocation;
    var(SkelControlProfile) Name EffectorSpaceBoneName;
    var(SkelControlProfile) Name JointTargetSpaceBoneName;
    var(SkelControlProfile) EBoneControlSpace EffectorLocationSpace;
    var(SkelControlProfile) EBoneControlSpace JointTargetLocationSpace;
};

var(Profiles) array<SkelControlProfile> SkelControlProfiles;
var(Profiles) int CurrentProfile;

public function SetSkelControlProfile(int idx)
{
    if (idx < SkelControlProfiles.Length && idx >= 0)
    {
        CurrentProfile = idx;
        EffectorLocation = SkelControlProfiles[idx].EffectorLocation;
        EffectorLocationSpace = SkelControlProfiles[idx].EffectorLocationSpace;
        EffectorSpaceBoneName = SkelControlProfiles[idx].EffectorSpaceBoneName;
        JointTargetLocation = SkelControlProfiles[idx].JointTargetLocation;
        JointTargetLocationSpace = SkelControlProfiles[idx].JointTargetLocationSpace;
        JointTargetSpaceBoneName = SkelControlProfiles[idx].JointTargetSpaceBoneName;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}