Class SFXGUIHelper_ConsoleKeyboard
    native
    transient;

enum Keyboard_Options
{
    KEYBOARD_STANDARD,
    KEYBOARD_EMAIL,
    KEYBOARD_PASSWORD,
    KEYBOARD_CODE,
};

var const native noexport Pointer VfTable_FTickableObject;
var string sTitle;
var string sDescription;
var string sInputValue;
var delegate<OnKeyboardEntryComplete> __OnKeyboardEntryComplete__Delegate;
var bool bKeyboardVisible;

public final native function DisplayKeyboard(stringref srTitle, stringref srDescription, Keyboard_Options nOptions, int nMaxLength, optional string sDefault);

private final event function KeyboardEntryComplete(bool EntryOK, const string EntryText)
{
    if (__OnKeyboardEntryComplete__Delegate != None)
    {
        __OnKeyboardEntryComplete__Delegate(EntryOK, EntryText);
    }
    bKeyboardVisible = FALSE;
}
public delegate function OnKeyboardEntryComplete(bool EntryOK, const string EntryText);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}