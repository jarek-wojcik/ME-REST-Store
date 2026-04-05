Class SFXAICmd_WaitForAnimatedTransition extends SFXAICommand within SFXAI_Core;

auto state WaitingForAnimatedTransition extends DebugState 
{
    
Begin:
    while (Outer.MyBP != None && Outer.MyBP.IsInAnimatedTransition())
    {
        Outer.Sleep(0.0500000007);
    }
    Outer.PopCommand(Self);
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}