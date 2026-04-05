Class Scene
    native;

const SDPG_NumBits = 3;
enum EDetailMode
{
    DM_Low,
    DM_Medium,
    DM_High,
};
enum ESceneDepthPriorityGroup
{
    SDPG_UnrealEdBackground,
    SDPG_World,
    SDPG_Foreground,
    SDPG_UnrealEdForeground,
    SDPG_PostProcess,
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}