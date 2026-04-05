Class BioAnimNodeBlendByIncline extends BioAnimNodeBlendBase
    native;

enum EBioAnimIncline
{
    eBioAnimIncline_Up,
    eBioAnimIncline_Level,
    eBioAnimIncline_Down,
};

var(BioAnimNodeBlendByIncline) float BlendDuration;
var(BioAnimNodeBlendByIncline) float MaxInclineUpAngle;
var(BioAnimNodeBlendByIncline) float MaxInclineDownAngle;
var float m_fInclineAngle;
var(BioAnimNodeBlendByIncline) bool bForceLevelReferenceAngle;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BlendDuration = 0.200000003
    MaxInclineUpAngle = 30.0
    MaxInclineDownAngle = -30.0
    m_nLastChild = 0
    m_nTargetChild = 1
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'InclineUp', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }, 
                {
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'LevelMove', 
                 Weight = 1.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }, 
                {
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'InclineDown', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
    bFixNumChildren = TRUE
}