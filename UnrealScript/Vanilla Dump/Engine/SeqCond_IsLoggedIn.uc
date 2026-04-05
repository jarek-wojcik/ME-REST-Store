Class SeqCond_IsLoggedIn extends SequenceCondition
    native;

var(SeqCond_IsLoggedIn) int NumNeededLoggedIn;

public event function bool CheckLogins()
{
    local int LoggedInCount;
    local int Count;
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInt;
    
    OnlineSub = Class'GameEngine'.static.GetOnlineSubsystem();
    if (OnlineSub != None)
    {
        PlayerInt = OnlineSub.PlayerInterface;
        if (PlayerInt != None)
        {
            for (Count = 0; Count < NumNeededLoggedIn; Count++)
            {
                if (int(PlayerInt.GetLoginStatus(byte(Count))) >= 1)
                {
                    LoggedInCount++;
                }
            }
        }
    }
    return LoggedInCount >= NumNeededLoggedIn;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "True", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "False", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "NeededLoggedIn", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'NumNeededLoggedIn', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}