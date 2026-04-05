Class SFXSFHandler_PCHUD extends SFXSFHandler_HUD
    transient
    config(UI);

var config stringref m_srPOIAction;

public function string GetActionIconString(ESFXHUDActionIcon eActionIcon)
{
    local stringref sr;
    
    ClearCustomTokens();
    switch (eActionIcon)
    {
        case ESFXHUDActionIcon.SFXHUD_Cover_Mantle:
            sr = m_srCoverMantleAction;
            SetCustomToken(0, GetBoundKeyString("PC_MoveForward"));
            SetCustomToken(1, GetBoundKeyString("Shared_Action"));
            break;
        case ESFXHUDActionIcon.SFXHUD_Cover_Climb:
            sr = m_srCoverClimbAction;
            SetCustomToken(0, GetBoundKeyString("PC_MoveForward"));
            SetCustomToken(1, GetBoundKeyString("Shared_Action"));
            break;
        case ESFXHUDActionIcon.SFXHUD_Cover_SlipRight:
            sr = m_srCoverSlipRightAction;
            SetCustomToken(0, GetBoundKeyString("PC_MoveForward"));
            SetCustomToken(1, GetBoundKeyString("Shared_Action"));
            break;
        case ESFXHUDActionIcon.SFXHUD_Cover_SlipLeft:
            sr = m_srCoverSlipLeftAction;
            SetCustomToken(0, GetBoundKeyString("PC_MoveForward"));
            SetCustomToken(1, GetBoundKeyString("Shared_Action"));
            break;
        case ESFXHUDActionIcon.SFXHUD_Cover_SwatTurnRight:
            sr = m_srCoverSwatRightAction;
            SetCustomToken(0, GetBoundKeyString("PC_StrafeRight"));
            SetCustomToken(1, GetBoundKeyString("Shared_Action"));
            break;
        case ESFXHUDActionIcon.SFXHUD_Cover_SwatTurnLeft:
            sr = m_srCoverSwatLeftAction;
            SetCustomToken(0, GetBoundKeyString("PC_StrafeLeft"));
            SetCustomToken(1, GetBoundKeyString("Shared_Action"));
            break;
        case ESFXHUDActionIcon.SFXHUD_GapJump:
            sr = m_srGapJumpAction;
            SetCustomToken(0, GetBoundKeyString("PC_MoveForward"));
            SetCustomToken(1, GetBoundKeyString("Shared_Action"));
            break;
        default:
            return Super.GetActionIconString(eActionIcon);
    }
    return GetUIString(sr, TRUE);
}
public function SetTargetStatus(string sStatus, optional bool bInteractive = FALSE, optional bool bInRange = TRUE)
{
    Super.SetTargetStatus(sStatus, FALSE, bInRange);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_srPOIAction = $560698
    ScreenLayout = GUILayout.GUILayout_PC
}