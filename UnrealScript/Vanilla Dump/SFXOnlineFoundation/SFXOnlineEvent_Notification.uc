Class SFXOnlineEvent_Notification extends SFXOnlineEvent_String
    native;

var string m_sImageName;
var int m_nPriority;

public final native function string GetImageName();

public final native function int GetPriority();

public final native function SetImageName(string sImageName);

public final native function SetPriority(int nPriority);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_nPriority = 3
    IsUnique = FALSE
}