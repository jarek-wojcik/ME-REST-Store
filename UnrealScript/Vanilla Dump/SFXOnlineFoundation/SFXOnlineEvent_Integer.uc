Class SFXOnlineEvent_Integer extends SFXOnlineEvent
    native;

var int m_nInteger;

public final native function int GetInteger();

public final native function SetInteger(int nInteger);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_nInteger = -1
}