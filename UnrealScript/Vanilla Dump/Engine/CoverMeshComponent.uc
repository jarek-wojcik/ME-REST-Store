Class CoverMeshComponent extends StaticMeshComponent
    native
    editinlinenew;

struct native CoverMeshes 
{
    var StaticMesh Base;
    var StaticMesh LeanLeft;
    var StaticMesh LeanRight;
    var StaticMesh Climb;
    var StaticMesh Mantle;
    var StaticMesh SlipLeft;
    var StaticMesh SlipRight;
    var StaticMesh SwatLeft;
    var StaticMesh SwatRight;
    var StaticMesh PopUp;
    var StaticMesh PlayerOnly;
};

var array<CoverMeshes> Meshes;
var Vector LocationOffset;
var StaticMesh AutoAdjustOn;
var StaticMesh AutoAdjustOff;
var StaticMesh Disabled;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Meshes = ({
               Base = StaticMesh'NodeBuddies.3D_Icons.NodeBuddy__BASE_TALL', 
               LeanLeft = None, 
               LeanRight = None, 
               Climb = None, 
               Mantle = None, 
               SlipLeft = None, 
               SlipRight = None, 
               SwatLeft = None, 
               SwatRight = None, 
               PopUp = None, 
               PlayerOnly = None
              }, 
              {
               Base = StaticMesh'NodeBuddies.3D_Icons.NodeBuddy__BASE_TALL', 
               LeanLeft = StaticMesh'NodeBuddies.3D_Icons.NodeBuddy_LeanLeftS', 
               LeanRight = StaticMesh'NodeBuddies.3D_Icons.NodeBuddy_LeanRightS', 
               Climb = None, 
               Mantle = None, 
               SlipLeft = StaticMesh'NodeBuddies.3D_Icons.NodeBuddy_CoverSlipLeft', 
               SlipRight = StaticMesh'NodeBuddies.3D_Icons.NodeBuddy_CoverSlipRight', 
               SwatLeft = StaticMesh'NodeBuddies.3D_Icons.NodeBuddy_SwatLeft', 
               SwatRight = StaticMesh'NodeBuddies.3D_Icons.NodeBuddy_SwatRight', 
               PopUp = None, 
               PlayerOnly = StaticMesh'NodeBuddies.3D_Icons.NodeBuddy_PlayerOnlyS'
              }, 
              {
               Base = StaticMesh'NodeBuddies.3D_Icons.NodeBuddy__BASE_SHORT', 
               LeanLeft = StaticMesh'NodeBuddies.3D_Icons.NodeBuddy_LeanLeftM', 
               LeanRight = StaticMesh'NodeBuddies.3D_Icons.NodeBuddy_LeanRightM', 
               Climb = StaticMesh'NodeBuddies.3D_Icons.NodeBuddy_Climb', 
               Mantle = StaticMesh'NodeBuddies.3D_Icons.NodeBuddy_Mantle', 
               SlipLeft = StaticMesh'NodeBuddies.3D_Icons.NodeBuddy_CoverSlipLeft', 
               SlipRight = StaticMesh'NodeBuddies.3D_Icons.NodeBuddy_CoverSlipRight', 
               SwatLeft = StaticMesh'NodeBuddies.3D_Icons.NodeBuddy_SwatLeft', 
               SwatRight = StaticMesh'NodeBuddies.3D_Icons.NodeBuddy_SwatRight', 
               PopUp = StaticMesh'NodeBuddies.3D_Icons.NodeBuddy_PopUp', 
               PlayerOnly = StaticMesh'NodeBuddies.3D_Icons.NodeBuddy_PlayerOnlyM'
              }
             )
    LocationOffset = {X = 0.0, Y = 0.0, Z = -60.0}
    AutoAdjustOn = StaticMesh'NodeBuddies.3D_Icons.NodeBuddy_AutoAdjust'
    AutoAdjustOff = StaticMesh'NodeBuddies.3D_Icons.NodeBuddy_AutoAdjustOff'
    Disabled = StaticMesh'NodeBuddies.3D_Icons.NodeBuddy_Enabled'
    StaticMesh = StaticMesh'NodeBuddies.3D_Icons.NodeBuddy__BASE_TALL'
    ReplacementPrimitive = None
    HiddenGame = TRUE
    bAcceptsStaticDecals = FALSE
    bAcceptsDynamicDecals = FALSE
    CastShadow = FALSE
    bAcceptsLights = FALSE
    CollideActors = FALSE
    BlockActors = FALSE
    BlockZeroExtent = FALSE
    BlockNonZeroExtent = FALSE
    BlockRigidBody = FALSE
    AlwaysLoadOnClient = FALSE
    AlwaysLoadOnServer = FALSE
}