Class SFXCustomAction_SwatTurn_Left extends SFXCustomAction_SwatTurn
    config(Game);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_Start_Mid = {
                    AnimName = ('CB_CvrMidSwat_L_Begin')
                   }
    BS_Loop_Mid = {
                   AnimName = ('CB_CoverRunMirrored')
                  }
    BS_End_Mid = {
                  AnimName = ('CB_CvrMidSwat_L_End')
                 }
    BS_ShortStart = {
                     AnimName = ('CB_CoverRun_Short_Mirrored')
                    }
    BS_Start = {
                AnimName = ('CB_CvrStdSwat_L_Begin')
               }
    BS_Loop = {
               AnimName = ('CB_CoverRunMirrored')
              }
    BS_End = {
              AnimName = ('CB_CvrStdSwat_L_End')
             }
}