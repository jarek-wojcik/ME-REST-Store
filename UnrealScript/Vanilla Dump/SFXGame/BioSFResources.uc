Class BioSFResources
    native;

struct native BioSFSoundAssetResource 
{
    var(BioSFSoundAssetResource) Name Tag;
    var(BioSFSoundAssetResource) WwiseEvent StartEvent;
    var(BioSFSoundAssetResource) WwiseEvent StopEvent;
};

var(Sound) array<BioSFSoundAssetResource> Sounds;
var(LoadScreen) const export array<BioSFScreenTip> LoadScreenTips;
var(SWFReferences) array<GFxMovieInfo> Movies;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}