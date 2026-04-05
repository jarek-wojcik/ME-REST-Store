Class BioPlayerSquad extends BioBaseSquad
    native
    placeable;

enum EExperienceSourceType
{
    EXPSourceType_SimpleDeath,
    EXPSourceType_SkillUse,
    EXPSourceType_QuestCompletion,
    EXPSourceType_Generic,
};

var BioTacticalMoveToIndicator MoveIndicators[3];
var transient BioPawn m_playerPawn;
var transient BioPawn m_InitialPlayerPawn;
var const float m_fRevivalRange;
var const float m_fPercentHealthOnResurrection;
var bool m_bEngagedHostileAction;

public event function int AddMember(Pawn Pawn, optional bool bCheckPlaypens = TRUE)
{
    local int idx;
    local int MemberIdx;
    local SFXAI_Henchman oController;
    local BioPawn oSquadMember;
    local BioPawn BP;
    
    MemberIdx = Super.AddMember(Pawn, bCheckPlaypens);
    if (MemberIdx == -1)
    {
        return MemberIdx;
    }
    WorldInfo.Game.ChangeTeam(Pawn.Controller, 0, TRUE);
    if (Members.Length >= 3)
    {
        oController = Pawn != None ? SFXAI_Henchman(Pawn.Controller) : None;
        if (oController != None)
        {
            oController.NotifyHenchmenLoaded();
        }
    }
    for (idx = 0; idx < Members.Length; idx++)
    {
        oSquadMember = BioPawn(Members[idx]);
        if (oSquadMember != None && oSquadMember != Pawn)
        {
            oSquadMember.OnSquadMemberAdded(Pawn);
        }
    }
    BP = BioPawn(Pawn);
    if (BP != None)
    {
        BP.ScaleEquipment(BP.GetScaledLevel());
    }
    BP.TryLoadCombatGrammar();
    return MemberIdx;
}
public event function CombatEnded()
{
    local Pawn P;
    
    foreach Members(P, )
    {
        if (BioPawn(P).PowerManager != None)
        {
            BioPawn(P).PowerManager.CombatEnded();
        }
    }
    SquadExitCombatMode();
    SFXGame(WorldInfo.Game).CombatEnded();
}
public native function BioTacticalMoveToIndicator GetMemberMoveIndicator(int nIndex);

public final native function bool IsFieldingInitialPlayerPawn();

public event function MemberRemoved(Pawn oPawn)
{
    local BioPawn Pawn;
    local BioWorldInfo oWorldInfo;
    local SFXSFHandler_PowerWheel oPowerWheel;
    local SFXSFHandler_HUD oHud;
    local BioPlayerController oPlayerController;
    local SFXGUIInteraction oGUI;
    
    Pawn = BioPawn(oPawn);
    oWorldInfo = BioWorldInfo(WorldInfo);
    oPlayerController = oWorldInfo.GetLocalPlayerController();
    if (oPlayerController != None)
    {
        oGUI = Class'SFXGUIInteraction'.static.GetInstance();
        oPowerWheel = oGUI.CastGetMovie(Class'SFXSFHandler_PowerWheel', oPlayerController, oGUI.MovieTag_PowerWheel);
        if (oPowerWheel != None)
        {
            oPowerWheel.RemoveHenchman(Pawn);
        }
        oHud = oGUI.CastGetMovie(Class'SFXSFHandler_HUD', oPlayerController, oGUI.MovieTag_HUD);
        if (oHud != None)
        {
            oHud.RemoveHenchman(Pawn);
        }
    }
    Pawn.TryUnLoadCombatGrammar();
    Super.MemberRemoved(oPawn);
}
public function NotifyEnemyPerceived()
{
    SquadEnterCombatMode();
    SFXGame(WorldInfo.Game).CombatStarted();
}
public function NotifyNoEnemiesPerceived()
{
    local Pawn P;
    local BioAiController AI;
    local BioPlayerController PC;
    
    foreach Members(P, )
    {
        if (P != None)
        {
            AI = BioAiController(P.Controller);
            if (AI != None && AI.EnemyList.Length > 0)
            {
                return;
            }
            PC = BioPlayerController(P.Controller);
            if (PC != None && PC.EnemyList.Length > 0)
            {
                return;
            }
        }
    }
    CombatEnded();
}
public event function PostBeginPlay()
{
    Super(Actor).PostBeginPlay();
    TargetData = new Class'BioSquadTargetData';
}
public function bool RemoveMember(Pawn pPawn)
{
    local int idx;
    
    idx = Members.Find(pPawn);
    if (idx != -1)
    {
        MoveIndicators[idx] = None;
    }
    return Super.RemoveMember(pPawn);
}
public native function SetMemberMoveIndicator(int nIndex, BioTacticalMoveToIndicator oIndicator);

public event function SetPlayerPawn(BioPawn PlayerPawn)
{
    m_playerPawn = PlayerPawn;
    CachedPlayerPawn = PlayerPawn;
}
public function bool Died(Pawn pPawn, Controller Killer)
{
    Super.Died(pPawn, Killer);
    SFXGame(WorldInfo.Game).OnPlayerSquadDeath();
    return TRUE;
}
public function RemoveDyingMember(Pawn oPawn)
{
    if (oPawn != Members[0])
    {
        RemoveMember(oPawn);
    }
}
public function SquadEnterCombatMode(optional bool bEngageEnemy = TRUE)
{
    if (bEngageEnemy)
    {
        m_bEngagedHostileAction = bEngageEnemy;
    }
}
public function SquadExitCombatMode()
{
    local BioAiController oMember;
    local BioPawn oMemberPawn;
    local SFXGRI GRI;
    
    GRI = SFXGRI(WorldInfo.GRI);
    if (GRI != None && GRI.InCombat())
    {
        return;
    }
    foreach SquadMembers(oMember)
    {
        oMemberPawn = BioPawn(oMember.Pawn);
        if (oMemberPawn != None)
        {
            oMemberPawn.ShouldCrouch(FALSE);
            GRI.TriggerVocalizationEvent(30, oMemberPawn, None);
        }
    }
    m_bEngagedHostileAction = FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BioSquadLinesComponent Name=SquadLines
        ReplacementPrimitive = None
    End Template
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    m_fRevivalRange = 2500.0
    m_fPercentHealthOnResurrection = 0.200000003
    bIsPlayerSquad = TRUE
    m_bCombatEnabled = TRUE
    Components = (None, SquadLines)
}