Class SFXSeqAct_LookAtPOI extends SeqAct_Latent
    native;

var(SFXSeqAct_LookAtPOI) Vector m_vTargetOffset;
var(SFXSeqAct_LookAtPOI) Vector m_vExploreModeOffset;
var(SFXSeqAct_LookAtPOI) Name m_nmTargetBoneName;
var(SFXSeqAct_LookAtPOI) float m_fFov;
var(SFXSeqAct_LookAtPOI) float m_fTransitionTime;
var(SFXSeqAct_LookAtPOI) float m_fDuration;
var transient Actor m_pTarget;
var transient float m_fDurationRemaining;
var(SFXSeqAct_LookAtPOI) bool m_bAutoActivate;
var(SFXSeqAct_LookAtPOI) bool m_bDisableOtherPOIs;
var(SFXSeqAct_LookAtPOI) bool m_bDisableMovementInput;
var transient bool m_bPOIActive;
var transient bool m_bDurationUpdating;

public event function ActivatePOI(BioPlayerController pBPC)
{
    local SFXCameraTransition_FaceTarget FaceTarget;
    local SFXCameraAction_FollowTarget FollowTarget;
    local SFXPlayerCamera Camera;
    local SFXPlayerController pSPC;
    
    pSPC = SFXPlayerController(pBPC);
    if (pSPC != None && pSPC.m_pActivePOI != Self && (pSPC.m_pActivePOI == None || !pSPC.m_pActivePOI.m_bDisableOtherPOIs))
    {
        if (pSPC.m_pActivePOI != None)
        {
            pSPC.m_pActivePOI.DeactivatePOI(pBPC, FALSE);
        }
        Camera = SFXPlayerCamera(pSPC.PlayerCamera);
        FaceTarget = new (pSPC.GetGameModeDefault()) Class'SFXCameraTransition_FaceTarget';
        CalcTargetLocation(FaceTarget.TargetLocation);
        FollowTarget = new (pSPC.GetGameModeDefault()) Class'SFXCameraAction_FollowTarget';
        Camera.PlayCameraTransition(FaceTarget, m_fTransitionTime, FollowTarget);
        m_bPOIActive = TRUE;
        pSPC.m_pActivePOI = Self;
        if (!m_bDurationUpdating && m_fDuration > 0.0)
        {
            m_fDurationRemaining = m_fDuration;
            m_bDurationUpdating = TRUE;
        }
        pSPC.IgnoreLookInput(TRUE);
        if (m_bDisableMovementInput)
        {
            pSPC.IgnoreMoveInput(TRUE);
        }
        OutputLinks[1].bHasImpulse = TRUE;
    }
}
public event function AddPOITarget(BioPlayerController pBPC)
{
    local SFXPlayerController pSPC;
    
    pSPC = SFXPlayerController(pBPC);
    if (pSPC != None)
    {
        if (m_bDisableOtherPOIs)
        {
            pSPC.m_aPOIKismet.InsertItem(0, Self);
        }
        else
        {
            pSPC.m_aPOIKismet.AddItem(Self);
        }
        pSPC.UpdateHUDPOIIcon();
    }
    OutputLinks[0].bHasImpulse = TRUE;
}
public native function CalcCameraPosition(out Vector vCameraLocation, const out Vector vUnderneathCamLoc, const out Vector vTargetLocation, float fTimeDelta);

public native function CalcTargetLocation(out Vector vLocation);

public event function DeactivatePOI(BioPlayerController pBPC, bool bPlayerInputRequest)
{
    local SFXPlayerController pSPC;
    
    if (bPlayerInputRequest && m_bAutoActivate)
    {
        return;
    }
    pSPC = SFXPlayerController(pBPC);
    if (pSPC != None && m_bPOIActive)
    {
        SFXPlayerCamera(pSPC.PlayerCamera).CurrentModalAction = None;
        pSPC.m_pActivePOI = None;
        m_bPOIActive = FALSE;
        pSPC.IgnoreLookInput(FALSE);
        if (m_bDisableMovementInput)
        {
            pSPC.IgnoreMoveInput(FALSE);
        }
        OutputLinks[2].bHasImpulse = TRUE;
    }
}
public event function RemovePOITarget(BioPlayerController pBPC)
{
    local int nIndex;
    local SFXPlayerController pSPC;
    
    nIndex = -1;
    pSPC = SFXPlayerController(pBPC);
    if (pSPC != None)
    {
        nIndex = pSPC.m_aPOIKismet.RemoveItem(Self);
        pSPC.UpdateHUDPOIIcon();
    }
    if (nIndex > -1)
    {
        OutputLinks[3].bHasImpulse = TRUE;
    }
}
public function UpdateCamPOV(SFXCameraAction_FollowTarget pCamMode, float fTimeDelta)
{
    local CameraActor pMatineeCam;
    
    if (m_pTarget != None && pCamMode != None)
    {
        pMatineeCam = CameraActor(m_pTarget);
        if (pMatineeCam == None)
        {
            CalcTargetLocation(pCamMode.TargetLocation);
            CalcCameraPosition(pCamMode.m_pov.location, pCamMode.UnderneathMode.m_pov.location, pCamMode.TargetLocation, fTimeDelta);
            pCamMode.m_pov.Rotation = Rotator(pCamMode.TargetLocation - pCamMode.m_pov.location);
            if (m_fFov == 0.0)
            {
                pCamMode.m_pov.FOV = pCamMode.UnderneathMode.m_pov.FOV;
            }
            else
            {
                pCamMode.m_pov.FOV = m_fFov;
            }
        }
        else
        {
            pCamMode.m_pov.location = pMatineeCam.location;
            pCamMode.m_pov.Rotation = pMatineeCam.Rotation;
            pCamMode.m_pov.FOV = pMatineeCam.FOVAngle;
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_vExploreModeOffset = {X = -150.0, Y = 100.0, Z = 100.0}
    m_nmTargetBoneName = 'Head'
    m_fTransitionTime = 0.5
    InputLinks = ({
                   LinkDesc = "Enable", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Disable", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Enabled", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Activated", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Deactivated", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Disabled", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Target", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'm_pTarget', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
    bManualHandleOutputs = TRUE
}