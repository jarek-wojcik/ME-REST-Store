Class BioAnimNodeBlendStateActionBehavior extends BioAnimNodeBlendStateBehavior
    native
    editinlinenew;

enum EBioArtPlaceableActionStates
{
    APAS_Default,
    APAS_Matinee,
};
enum EBioPawnAnimActiveStates
{
    PAActiveS_Active,
    PAActiveS_ActiveToInactive,
    PAActiveS_InactiveToActive,
    PAActiveS_Inactive,
};
enum EBioPawnAnimActionStates
{
    PAAS_Posture,
    PAAS_Dying,
    PAAS_Death,
    PAAS_Matinee,
    PAAS_Recover,
    PAAS_Gestures,
};
enum EBioAnimNodeBlendStateActionBehavior
{
    BSAct_None,
    BSAct_PawnState,
    BSAct_PawnGesturesState,
    BSAct_ActiveState,
    BSAct_Posture,
    BSAct_ArtPlaceable,
    BSAct_IdleState,
};

var bool m_bPlayedRecoverAnim;
var(Action) EBioAnimNodeBlendStateActionBehavior ActionBehavior;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_aNodeDefinitions = ({
                           Children = ()
                          }, 
                          {
                           Children = ({
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Posture', 
                                        DefaultWeight = 1.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Dying', 
                                        DefaultWeight = 0.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Death', 
                                        DefaultWeight = 0.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Matinee', 
                                        DefaultWeight = 0.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_Query
                                                      }, 
                                        Name = 'Recover', 
                                        DefaultWeight = 0.0
                                       }
                                      )
                          }, 
                          {
                           Children = ({
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Posture', 
                                        DefaultWeight = 1.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Dying', 
                                        DefaultWeight = 0.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Death', 
                                        DefaultWeight = 0.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Matinee', 
                                        DefaultWeight = 0.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_Query
                                                      }, 
                                        Name = 'Recover', 
                                        DefaultWeight = 0.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Gestures', 
                                        DefaultWeight = 0.0
                                       }
                                      )
                          }, 
                          {
                           Children = ({
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Active', 
                                        DefaultWeight = 1.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'ActiveToInactive', 
                                        DefaultWeight = 0.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'InactiveToActive', 
                                        DefaultWeight = 0.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Inactive', 
                                        DefaultWeight = 0.0
                                       }
                                      )
                          }, 
                          {
                           Children = ({
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Standing', 
                                        DefaultWeight = 1.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Crouching', 
                                        DefaultWeight = 0.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Storm', 
                                        DefaultWeight = 0.0
                                       }
                                      )
                          }, 
                          {
                           Children = ({
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Default', 
                                        DefaultWeight = 1.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Matinee', 
                                        DefaultWeight = 0.0
                                       }
                                      )
                          }, 
                          {
                           Children = ({
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Idle', 
                                        DefaultWeight = 1.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Busy', 
                                        DefaultWeight = 0.0
                                       }
                                      )
                          }
                         )
}