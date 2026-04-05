Class SFXSceneGroup extends InterpGroup
    native
    collapsecategories;

var array<BioResourcePreloadItem> m_aBioPreloadData;
var(SFXSceneGroup) float m_fSceneLength;
var(SFXSceneGroup) float m_fPlayRate;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_fSceneLength = 5.0
    m_fPlayRate = 1.0
    GroupName = 'SFXScene'
    GroupColor = {B = 0, G = 255, R = 255, A = 255}
    bIsFolder = TRUE
}