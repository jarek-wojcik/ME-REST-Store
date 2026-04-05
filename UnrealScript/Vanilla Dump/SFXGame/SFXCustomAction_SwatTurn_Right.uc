Class SFXCustomAction_SwatTurn_Right extends SFXCustomAction_SwatTurn
    config(Game);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_Start_Mid = {
                    AnimName = ('CB_CvrMidSwat_R_Begin')
                   }
    BS_Loop_Mid = {
                   AnimName = ('CB_CoverRun')
                  }
    BS_End_Mid = {
                  AnimName = ('CB_CvrMidSwat_R_End')
                 }
    BS_ShortStart = {
                     AnimName = ('CB_CoverRun_Short')
                    }
    bRightSwatTurn = TRUE
    BS_Start = {
                AnimName = ('CB_CvrStdSwat_R_Begin')
               }
    BS_Loop = {
               AnimName = ('CB_CoverRun')
              }
    BS_End = {
              AnimName = ('CB_CvrStdSwat_R_End')
             }
}