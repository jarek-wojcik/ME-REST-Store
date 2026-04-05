Class Input extends Interaction
    native
    transient
    config(Input);

struct native KeyBind 
{
    var config string Command;
    var config Name Name;
    var config bool Control;
    var config bool Shift;
    var config bool Alt;
    var config bool bIgnoreCtrl;
    var config bool bIgnoreShift;
    var config bool bIgnoreAlt;
};

var const native init array<Pointer> AxisArray;
var config array<KeyBind> Bindings;
var const array<Name> PressedKeys;
var const native Object NameToPtr;
var const native Object KeyToModifiers;
var const float CurrentDelta;
var const float CurrentDeltaTime;
var const EInputEvent CurrentEvent;

public native function string GetBind(const out Name Key, bool Control, bool Shift, bool Alt);

public native function ResetInput();

public exec function SetBind(const out Name BindName, string Command)
{
    local KeyBind NewBind;
    local int BindIndex;
    
    if (Left(Command, 1) == "\"" && Right(Command, 1) == "\"")
    {
        Command = Mid(Command, 1, Len(Command) - 2);
    }
    for (BindIndex = Bindings.Length - 1; BindIndex >= 0; BindIndex--)
    {
        if (Bindings[BindIndex].Name == BindName)
        {
            Bindings[BindIndex].Command = Command;
            SaveConfig();
            return;
        }
    }
    NewBind.Name = BindName;
    NewBind.Command = Command;
    Bindings[Bindings.Length] = NewBind;
    SaveConfig();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}