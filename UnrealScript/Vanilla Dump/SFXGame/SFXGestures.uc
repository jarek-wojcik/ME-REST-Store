Class SFXGestures
    native
    config(Game);

var config string GesturesPackageName;
var transient BioGestureRuntimeData m_pRuntimeData;

public static native function LoadRuntimeData();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    GesturesPackageName = "BIOG_GesturesConfig"
}