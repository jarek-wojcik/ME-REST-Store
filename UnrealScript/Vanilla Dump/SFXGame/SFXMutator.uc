Class SFXMutator extends Mutator
    abstract;

public function SetGameSpeed(out float NewSpeed)
{
    local SFXMutator NextMut;
    
    NextMut = SFXMutator(NextMutator);
    if (NextMut != None)
    {
        NextMut.SetGameSpeed(NewSpeed);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}