Class SFXCustomAction_AIMantleOverCover extends SFXCustomAction_MantleOverCoverBase
    config(Game);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_Start = {
                AnimName = ('CB_Mantle_Enter')
               }
    BS_Loop = {
               AnimName = ('CB_Mantle_Loop')
              }
    BS_End = {
              AnimName = ('CB_Mantle_Exit')
             }
    fStartBlendOutTime = 0.0599999987
    fLoopBlendInTime = 0.0599999987
    StartRMM = ERootMotionMode.RMM_Translate
}