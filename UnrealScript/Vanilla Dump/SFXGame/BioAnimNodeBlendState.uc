Class BioAnimNodeBlendState extends BioAnimNodeBlendBase
    native;

struct native BioAnimBlendParams 
{
    var(BioAnimBlendParams) array<float> BlendToChildTimes;
    var(BioAnimBlendParams) EBioBlendStatePlayMode PlayMode;
};
enum EBioBlendStatePlayAction
{
    eBioBlendStatePlayAction_NoAction,
    eBioBlendStatePlayAction_Play,
    eBioBlendStatePlayAction_Stop,
    eBioBlendStatePlayAction_Reset,
    eBioBlendStatePlayAction_PlayFromStart,
    eBioBlendStatePlayAction_PlayFromTime,
};
enum EBioBlendStatePlayMode
{
    eBioBlendStatePlayMode_None,
    eBioBlendStatePlayMode_OneShot,
    eBioBlendStatePlayMode_Looping,
    eBioBlendStatePlayMode_Query,
};

var(BioAnimNodeBlendState) editconst array<BioAnimBlendParams> m_aChildBlendParams;
var int m_nActiveChild;
var transient BioAnimCheckBlendOut m_oBlendOut;
var(Behavior) export BioAnimNodeBlendStateBehavior m_oBehavior;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_aChildBlendParams = ({
                            BlendToChildTimes = (0.0, 0.0), 
                            PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                           }, 
                           {
                            BlendToChildTimes = (0.0, 0.0), 
                            PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                           }
                          )
    m_bShowSlider = TRUE
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Child1', 
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
                 Name = 'Child2', 
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