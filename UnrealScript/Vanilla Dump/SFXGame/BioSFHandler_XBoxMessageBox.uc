Class BioSFHandler_XBoxMessageBox extends SFXGUIMovieLegacyAdapter
    native
    config(UI);

enum MessageBoxIcon
{
    MBI_None,
    MBI_Error,
    MBI_Warning,
    MBI_Alert,
};

var int nSelectedButton;
var bool bMessageBoxVisible;

public final native function DisplayMessageBox(stringref srTitle, stringref srMessage, const out array<stringref> srButtons, optional MessageBoxIcon nIcon = 0, optional int nDefaultButton = 0);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}