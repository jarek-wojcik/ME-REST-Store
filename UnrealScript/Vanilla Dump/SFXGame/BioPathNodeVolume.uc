Class BioPathNodeVolume extends Volume
    native
    placeable;

enum EBioPathNodeGenerators
{
    PATHNODE_SQUARE,
};
enum EBioPathNodeAlignment
{
    BIO_PATH_ALIGN_NONE,
    BIO_PATH_ALIGN_CENTER,
    BIO_PATH_ALIGN_JUSTIFY,
};

var(BioPathNodeVolume) float fMaxNodeSeparation;
var(BioPathNodeVolume) float fMargin;
var(BioPathNodeVolume) float fNodeTargetRadius;
var(BioPathNodeVolume) float fMaxSlope;
var(AirNodes) int nLevels;
var(AirNodes) float fLevelHeight;
var(BioPathNodeVolume) bool bDeleteNodesOnPopulate;
var(AirNodes) bool bDoNotGenerateGroundNodes;
var(BioPathNodeVolume) EBioPathNodeAlignment eAlignment;
var(BioPathNodeVolume) EBioPathNodeGenerators ePathNodeGenerator;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
    End Template
    fMaxNodeSeparation = 800.0
    fMargin = 50.0
    fNodeTargetRadius = 100.0
    fMaxSlope = 40.0
    fLevelHeight = 800.0
    bDeleteNodesOnPopulate = TRUE
    eAlignment = EBioPathNodeAlignment.BIO_PATH_ALIGN_JUSTIFY
    BrushColor = {B = 50, G = 180, R = 255, A = 255}
    BrushComponent = BrushComponent0
    bColored = TRUE
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
    bCollideActors = FALSE
}