Class SFXSeqAct_GivePlotWeapon extends SeqAct_Latent
    deprecated;

var(SFXSeqAct_GivePlotWeapon) Class<SFXWeapon> WeaponClass;
var stringref srText;
var stringref srAButton;
var stringref srNoSquadMembers;
var stringref ShepardName;
var stringref srSquadListTokens;
var(SFXSeqAct_GivePlotWeapon) bool bAutoEquip;
var(SFXSeqAct_GivePlotWeapon) bool bShowPopup;
var bool m_bFinished;
var bool m_bWasPaused;
var SFX_MB_Skin m_Skin;
var SFX_MB_TextAlign m_TextAlign;

public function Activated()
{
    m_bFinished = TRUE;
    OutputLinks[0].bHasImpulse = FALSE;
    OutputLinks[1].bHasImpulse = FALSE;
    OutputLinks[2].bHasImpulse = FALSE;
}
public function DisplayMessageBox()
{
    local BioSFHandler_MessageBox oMsgBox;
    local BioMessageBoxOptionalParams stParams;
    local string WeaponName;
    local string SquadList;
    local BioPlayerController oPC;
    
    oPC = BioWorldInfo(GetWorldInfo()).GetLocalPlayerController();
    oMsgBox = Class'SFXGUIInteraction'.static.GetInstance().CreateMessageBox(oPC);
    oMsgBox.SetInputDelegate(MessageInputPressed);
    stParams.srAText = $0;
    if (srAButton != 0)
    {
        stParams.srAText = srAButton;
    }
    stParams.bModal = TRUE;
    stParams.m_SkinType = m_Skin;
    stParams.m_TextAlign = m_TextAlign;
    WeaponName = WeaponClass.static.GetPrettyName();
    SquadList = BuildSquadMemberList(WeaponClass);
    ClearCustomTokens();
    SetCustomToken(0, WeaponName);
    SetCustomToken(1, SquadList);
    oMsgBox.DisplayMessageBoxEx(Class'SFXGame'.static.GetSimpleString(srText, TRUE), stParams);
    ClearCustomTokens();
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 4;
}
public event function PreVersionUpdated(int OldVersion, int NewVersion)
{
    if (ObjInstanceVersion < 5 && OutputLinks.Length > 0 && OutputLinks[0].LinkDesc == "Out")
    {
        OutputLinks[0].LinkDesc = "Finished";
    }
}
public event function bool Update(float DeltaTime)
{
    if (m_bFinished)
    {
        OutputLinks[0].bHasImpulse = TRUE;
        return FALSE;
    }
    return TRUE;
}
public function string BuildSquadMemberList(Class<SFXWeapon> WClass)
{
    local BioGlobalVariableTable VarTable;
    local bool bWeaponIsUsed;
    local int TokenIndex;
    local int Index;
    local HenchmanInfoStruct HenchInfo;
    
    VarTable = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetGlobalVariables();
    ClearCustomTokens();
    if (Class'SFXPlayerSquadLoadoutData'.static.CanPlayerUseWeaponClass(WClass))
    {
        bWeaponIsUsed = TRUE;
        SetCustomToken(TokenIndex++, string(ShepardName));
    }
    foreach Class'SFXPawn_Henchman'.default.HenchmenInfo(HenchInfo, )
    {
        if (VarTable.GetBool(HenchInfo.HenchAcquiredPlotID))
        {
            if (Class'SFXPlayerSquadLoadoutData'.static.CanHenchmanUseWeaponClass(HenchInfo.Tag, WClass))
            {
                bWeaponIsUsed = TRUE;
                if (HenchInfo.AlternateHenchNamePlotFlag != 'None' && VarTable.GetBoolByName(HenchInfo.AlternateHenchNamePlotFlag))
                {
                    SetCustomToken(TokenIndex++, string(HenchInfo.AlternatePrettyName));
                }
                else
                {
                    SetCustomToken(TokenIndex++, string(HenchInfo.PrettyName));
                }
            }
        }
    }
    if (!bWeaponIsUsed)
    {
        SetCustomToken(TokenIndex++, string(srNoSquadMembers));
    }
    for (Index = TokenIndex; Index < 14; Index++)
    {
        SetCustomToken(Index, "");
    }
    return Class'SFXGame'.static.GetSimpleString(srSquadListTokens, TRUE);
}
public final function MessageInputPressed(bool bAPressed, int nContext)
{
    m_bFinished = TRUE;
    GetWorldInfo().bPlayersOnly = m_bWasPaused;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    srText = $348630
    srAButton = $348631
    srNoSquadMembers = $348637
    ShepardName = $125303
    srSquadListTokens = $348639
    bAutoEquip = TRUE
    bShowPopup = TRUE
    m_Skin = SFX_MB_Skin.SFX_MB_Skin_Shepard
    bCallHandler = FALSE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "ShowPopup", 
                      ExpectedType = Class'SeqVar_Bool', 
                      LinkVar = 'None', 
                      PropertyName = 'bShowPopup', 
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