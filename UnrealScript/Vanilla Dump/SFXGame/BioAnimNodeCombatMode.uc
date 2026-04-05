Class BioAnimNodeCombatMode extends BioAnimNodeBlendBase
    native;

enum EBioAnimNodeCombatModeState
{
    BIO_ANIM_NODE_COMBAT_MODE_STATE_NONCOMBAT,
    BIO_ANIM_NODE_COMBAT_MODE_STATE_COMBAT,
    BIO_ANIM_NODE_COMBAT_MODE_STATE_ANIMATING_TO_COMBAT,
    BIO_ANIM_NODE_COMBAT_MODE_STATE_ANIMATING_TO_NONCOMBAT,
    BIO_ANIM_NODE_COMBAT_MODE_STATE_BLENDING_TO_COMBAT,
    BIO_ANIM_NODE_COMBAT_MODE_STATE_BLENDING_TO_NONCOMBAT,
};
enum EBioAnimNodeCombatModeChild
{
    BIO_ANIM_NODE_COMBAT_MODE_CHILD_NONCOMBAT,
    BIO_ANIM_NODE_COMBAT_MODE_CHILD_COMBAT,
    BIO_ANIM_NODE_COMBAT_MODE_CHILD_ENTERCOMBAT,
    BIO_ANIM_NODE_COMBAT_MODE_CHILD_EXITCOMBAT,
};

var(BioAnimNodeCombatMode) float m_blendIntoTransitionDuration;
var(BioAnimNodeCombatMode) float m_blendOutOfTransitionDuration;
var(BioAnimNodeCombatMode) float m_blendFromNonCombatToCombatDuration;
var(BioAnimNodeCombatMode) float m_blendFromCombatToNonCombatDuration;
var bool m_isInitialStateDetermined;
var EBioAnimNodeCombatModeState m_currentState;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_blendIntoTransitionDuration = 0.200000003
    m_blendOutOfTransitionDuration = 0.200000003
    m_blendFromNonCombatToCombatDuration = 0.200000003
    m_blendFromCombatToNonCombatDuration = 0.200000003
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Non Combat', 
                 Weight = 1.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }, 
                {
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Combat', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }, 
                {
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Enter Combat', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }, 
                {
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Exit Combat', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
    bFixNumChildren = TRUE
}