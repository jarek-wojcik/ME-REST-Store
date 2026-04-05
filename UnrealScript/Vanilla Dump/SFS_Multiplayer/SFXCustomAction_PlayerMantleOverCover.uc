Class SFXCustomAction_PlayerMantleOverCover extends SFXCustomAction_MantleOverCoverBase
    config(Game);

var(SFXCustomAction_PlayerMantleOverCover) BodyStance BS_CoverStart;
var(SFXCustomAction_PlayerMantleOverCover) BodyStance BS_StandingStart;
var(SFXCustomAction_PlayerMantleOverCover) BodyStance BS_QuickStandingStart;
var(SFXCustomAction_PlayerMantleOverCover) BodyStance BS_CoverLoop;
var(SFXCustomAction_PlayerMantleOverCover) BodyStance BS_StandingLoop;
var(SFXCustomAction_PlayerMantleOverCover) BodyStance BS_QuickStandingLoop;
var(SFXCustomAction_PlayerMantleOverCover) BodyStance BS_CoverEnd;
var(SFXCustomAction_PlayerMantleOverCover) BodyStance BS_StandingEnd;
var(SFXCustomAction_PlayerMantleOverCover) BodyStance BS_QuickStandingEnd;
var(SFXCustomAction_PlayerMantleOverCover) bool bStartFromCover;
var(SFXCustomAction_PlayerMantleOverCover) bool bStartFromStorm;

public static event function GetUsedAnimNames(out array<Name> UsedAnims)
{
    GetAnimsUsedByBodyStance(default.BS_CoverStart, UsedAnims);
    GetAnimsUsedByBodyStance(default.BS_StandingStart, UsedAnims);
    GetAnimsUsedByBodyStance(default.BS_QuickStandingStart, UsedAnims);
    GetAnimsUsedByBodyStance(default.BS_CoverLoop, UsedAnims);
    GetAnimsUsedByBodyStance(default.BS_StandingLoop, UsedAnims);
    GetAnimsUsedByBodyStance(default.BS_QuickStandingLoop, UsedAnims);
    GetAnimsUsedByBodyStance(default.BS_CoverEnd, UsedAnims);
    GetAnimsUsedByBodyStance(default.BS_StandingEnd, UsedAnims);
    GetAnimsUsedByBodyStance(default.BS_QuickStandingEnd, UsedAnims);
    Super(SFXCustomAction_ProceduralMoveBase).GetUsedAnimNames(UsedAnims);
}
public function StartCustomAction()
{
    local bool bWasStorming;
    
    bStartFromCover = m_oPawn.IsInCover();
    if (BioPlayerController(m_oPawn.Controller) != None)
    {
        bWasStorming = int(BioPlayerController(m_oPawn.Controller).bWantsToStorm) == 1;
    }
    else
    {
        bWasStorming = m_oPawn.bReplicatedWantsToStorm;
    }
    if (m_oPawn.bRecentlyTookCover && bWasStorming)
    {
        bStartFromStorm = TRUE;
    }
    if (m_oPawn.bRecentlyTookCover && m_oPawn.bStorming == FALSE)
    {
        bStartFromCover = FALSE;
    }
    Super.StartCustomAction();
}
public event function TickCustomAction(float DeltaTime)
{
    local Rotator PawnRotation;
    
    PawnRotation = m_oPawn.Rotation;
    PawnRotation.Pitch = 0;
    m_oPawn.SetRotation(PawnRotation);
}
public function BodyStanceAnimEndNotification(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    if (MoveStage == EMoveStage.EMS_Loop)
    {
        PlayEndAnimation();
    }
    else
    {
        Super.BodyStanceAnimEndNotification(SeqNode, PlayedTime, ExcessTime);
    }
}
public function GetEndAnim(out BodyStance Stance)
{
    if (bStartFromStorm)
    {
        Stance = BS_QuickStandingEnd;
    }
    else if (bStartFromCover)
    {
        Stance = BS_CoverEnd;
    }
    else
    {
        Stance = BS_StandingEnd;
    }
}
public function GetLoopAnim(out BodyStance Stance)
{
    if (bStartFromStorm)
    {
        Stance = BS_QuickStandingLoop;
    }
    else if (bStartFromCover)
    {
        Stance = BS_CoverLoop;
    }
    else
    {
        Stance = BS_StandingLoop;
    }
}
public function GetStartAnim(out BodyStance Stance)
{
    if (bStartFromStorm)
    {
        Stance = BS_QuickStandingStart;
    }
    else if (bStartFromCover)
    {
        Stance = BS_CoverStart;
    }
    else
    {
        Stance = BS_StandingStart;
    }
}
public function StopCustomAction()
{
    Super.StopCustomAction();
    bStartFromCover = FALSE;
    bStartFromStorm = FALSE;
    m_oPawn.Velocity += Vector(m_oPawn.Rotation) * float(500);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_CoverStart = {
                     AnimName = ('CB_Mantle_Cover_Start')
                    }
    BS_StandingStart = {
                        AnimName = ('CB_Mantle_Start')
                       }
    BS_QuickStandingStart = {
                             AnimName = ('CB_Mantle_Slide_Start')
                            }
    BS_CoverLoop = {
                    AnimName = ('CB_Mantle_Cover_Loop')
                   }
    BS_StandingLoop = {
                       AnimName = ('CB_Mantle_Loop')
                      }
    BS_QuickStandingLoop = {
                            AnimName = ('CB_Mantle_Slide_Loop')
                           }
    BS_CoverEnd = {
                   AnimName = ('CB_Mantle_Cover_End')
                  }
    BS_StandingEnd = {
                      AnimName = ('CB_Mantle_End')
                     }
    BS_QuickStandingEnd = {
                           AnimName = ('CB_Mantle_Slide_End')
                          }
    fStartBlendOutTime = 0.0599999987
    fLoopBlendInTime = 0.0599999987
    fEndBlendOutTime = 0.600000024
    bAlignPawnBeforeMove = FALSE
    StartRMM = ERootMotionMode.RMM_Translate
    GravityScale = 3.0
}