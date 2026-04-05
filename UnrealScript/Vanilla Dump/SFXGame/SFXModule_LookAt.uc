Class SFXModule_LookAt extends SFXModule
    native
    editinlinenew;

var array<BioActorLookAtController> m_Controllers;
var Actor m_pTarget;
var int m_nRank;
var float LookAtNoticeTimer;
var Actor LookAtNoticeActor;
var(SFXModule_LookAt) BioLookAtDefinition m_Definition;
var(Notice) float NoticeDuration;
var(Notice) float NoticeEnableDistance;
var(Notice) float NoticeDisableDistance;
var(Notice) int ReNoticeMinTime;
var(Notice) int ReNoticeMaxTime;
var transient bool bDisabling;
var transient bool bLookAtNotice;
var(SFXModule_LookAt) bool bEnableLookAtTargeting;
var(SFXModule_LookAt) bool bAutoLookAtPlayer;

public final native function ChangeTarget(Actor Target, optional ELookAtTransitionType a_eTransition = 0, optional int nRank = 99999);

public native function Cleanup();

public event simulated function HandlePostBeginPlay()
{
    Super.HandlePostBeginPlay();
    Setup();
}
public native function Setup();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioLookAtDefinition Name=LookAtDef01
    End Object
    m_Definition = LookAtDef01
    NoticeDuration = 6.0
    NoticeEnableDistance = 500.0
    NoticeDisableDistance = 600.0
    ReNoticeMinTime = 10
    ReNoticeMaxTime = 20
}