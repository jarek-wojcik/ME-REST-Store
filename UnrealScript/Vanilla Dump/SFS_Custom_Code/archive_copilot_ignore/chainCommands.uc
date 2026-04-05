Class SFSChainConsoleCommand extends SFSConsoleCommand within SFXPawn;

var array<string> timedCommandArray;
var int currentCommandIndex;

public function Execute(string Arguments)
{
    executeCommandChain(Arguments);
    Super.Execute(Arguments);
}
public function executeCommandChain(string Arguments)
{
    local array<string> commandArray;
    local string Command;
    local Console Console;
    
    Console = Class'SFSCore'.static.getConsole();
    if (Console == None)
    {
        return;
    }
    ParseStringIntoArray(Arguments, commandArray, ";", TRUE);
    foreach commandArray(Command, )
    {
        Console.ConsoleCommand(Command);
    }
}

public function StartTimedCommandExecution(string Arguments, optional float Interval = 3.0)
{
    ParseStringIntoArray(Arguments, timedCommandArray, ";", TRUE);
    currentCommandIndex = 0;
    
    if (timedCommandArray.Length > 0)
    {
        SetTimer(Interval, true, 'ExecuteNextCommand');
    }
}

public function ExecuteNextCommand()
{
    local Console Console;
    
    if (currentCommandIndex >= timedCommandArray.Length)
    {
        ClearTimer('ExecuteNextCommand');
        timedCommandArray.Length = 0;
        currentCommandIndex = 0;
        return;
    }
    
    Console = Class'SFSCore'.static.getConsole();
    if (Console != None && currentCommandIndex < timedCommandArray.Length)
    {
        Console.ConsoleCommand(timedCommandArray[currentCommandIndex]);
        currentCommandIndex++;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bEnabled = TRUE
    sCommand = "chain"
    Description = "Allows you to chain multiple commands, delimited by ';'.\n\t For example 'chain transferPowers sentineln7 0-0;transferPowers engineern7 0-1;changeSkin 41'"
}