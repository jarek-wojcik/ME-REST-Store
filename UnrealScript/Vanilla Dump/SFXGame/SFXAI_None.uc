Class SFXAI_None extends SFXAI_Core
    placeable
    config(AI);

auto state Idle 
{
    
Begin:
    while (TRUE)
    {
        BeginDefaultCommand();
        Sleep(0.5);
    }
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DefaultCommand = Class'SFXAICmd_None'
}