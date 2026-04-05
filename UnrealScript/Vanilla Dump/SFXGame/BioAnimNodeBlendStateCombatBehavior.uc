Class BioAnimNodeBlendStateCombatBehavior extends BioAnimNodeBlendStateBehavior
    native
    editinlinenew;

enum EBioAnimNodeBlendStateCombatBehavior
{
    BSCbt_None,
    BSCbt_CoverSwitch,
    BSCbt_CoverDirection,
    BSCbt_CoverState,
    BSCbt_CoverBlocked,
    BSCbt_CombatSwitch,
    BSCbt_CoverPredictDirection,
    BSCbt_CoverBlockType,
};

var(Cover) bool bUseCoverAnimState;
var(Cover) bool bOnlyDuringWeaponSwitch;
var(Cover) bool bOnlyDuringNoOffensiveAction;
var(Combat) EBioAnimNodeBlendStateCombatBehavior CombatBehavior;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bUseCoverAnimState = TRUE
    m_aNodeDefinitions = ({
                           Children = ()
                          }, 
                          {
                           Children = ({
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'NoCover', 
                                        DefaultWeight = 1.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Cover', 
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
                                        Name = 'Left', 
                                        DefaultWeight = 0.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Right', 
                                        DefaultWeight = 0.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Up', 
                                        DefaultWeight = 0.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'None', 
                                        DefaultWeight = 1.0
                                       }
                                      )
                          }, 
                          {
                           Children = ({
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Enter', 
                                        DefaultWeight = 1.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Loop', 
                                        DefaultWeight = 0.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Exit', 
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
                                        Name = 'PortArms', 
                                        DefaultWeight = 1.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'bLocked', 
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
                                        Name = 'NonCombat', 
                                        DefaultWeight = 1.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Combat', 
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
                                        Name = 'Left', 
                                        DefaultWeight = 0.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Right', 
                                        DefaultWeight = 0.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'Up', 
                                        DefaultWeight = 0.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0, 0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'None', 
                                        DefaultWeight = 1.0
                                       }
                                      )
                          }, 
                          {
                           Children = ({
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'BlockedByOther', 
                                        DefaultWeight = 1.0
                                       }, 
                                       {
                                        BlendParams = {
                                                       BlendToChildTimes = (0.0, 0.0), 
                                                       PlayMode = EBioBlendStatePlayMode.eBioBlendStatePlayMode_None
                                                      }, 
                                        Name = 'BlockedByCover', 
                                        DefaultWeight = 0.0
                                       }
                                      )
                          }
                         )
}