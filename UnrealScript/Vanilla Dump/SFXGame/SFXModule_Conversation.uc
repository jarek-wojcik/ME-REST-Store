Class SFXModule_Conversation extends SFXModule
    native
    editinlinenew;

var(SFXModule_Conversation) Vector m_vCameraFocusPoint;
var(SFXModule_Conversation) Vector m_vProceduralCameraPosition;
var(SFXModule_Conversation) Rotator m_rProceduralCameraRotation;
var(SFXModule_Conversation) float m_fFov;
var(SFXModule_Conversation) float m_fNearClip;
var(SFXModule_Conversation) float m_fDOFFocusInnerRadius;
var(SFXModule_Conversation) float m_fDOFFocusDistance;
var(FaceFX) FaceFXAsset m_pDefaultFaceFXAsset;
var(FaceFX) bool m_bDisableFacefx;
var transient bool m_bInConversation;

public static native function bool ScriptIsInConversation(Actor pActor);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_vCameraFocusPoint = {X = 0.0, Y = 0.0, Z = 167.859024}
    m_vProceduralCameraPosition = {X = -62.7560005, Y = -194.854004, Z = 152.07103}
    m_rProceduralCameraRotation = {Pitch = 17038, Yaw = -3472, Roll = 0}
    m_fFov = 15.1890001
    m_fNearClip = 170.0
    m_fDOFFocusInnerRadius = 300.0
    m_fDOFFocusDistance = 200.0
}