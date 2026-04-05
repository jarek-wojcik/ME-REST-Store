Class SFXGameModeAtlas extends SFXGameModeBase within BioPlayerController
    config(Input);

var float AtlasCamTransitionTime;
var(SFXGameModeAtlas) config float InputDelayTightAimExit;
var(SFXGameModeAtlas) export SFXCameraMode_Atlas AtlasCam;
var(SFXGameModeAtlas) export SFXCameraTransition_FaceTarget AtlasTrans;

public function Activated()
{
    Super.Activated();
    SetTimer(0.5, TRUE, 'TryAutoMantle', Self);
}
public function Deactivated()
{
    Super.Deactivated();
    ClearTimer('TryAutoMantle', Self);
}
public exec function EnterCommandMenu()
{
    local BioPawn P;
    
    if (!bAllowPowerWeaponUI)
    {
        return;
    }
    P = SFXPawn(Outer.Pawn).GetDriver();
    if (P.Squad.Members.Length == 1)
    {
        return;
    }
    Super.EnterCommandMenu();
}
public exec function EnterPowerWheel()
{
    local BioPawn P;
    
    P = SFXPawn(Outer.Pawn).GetDriver();
    if (P.Squad.Members.Length == 1)
    {
        return;
    }
    Super.EnterPowerWheel();
}
public exec function EnterWeaponWheel()
{
    local BioPawn P;
    
    P = SFXPawn(Outer.Pawn).GetDriver();
    if (P.Squad.Members.Length == 1)
    {
        return;
    }
    Super.EnterWeaponWheel();
}
public exec function ExitAtlas()
{
    local SFXPawn ChkPawn;
    
    ChkPawn = SFXPawn(Outer.Pawn);
    if (ChkPawn != None && ChkPawn.TryToExitMe() == FALSE)
    {
    }
}
public function SFXCameraMode GetCameraMode(SFXCameraMode OldCameraMode, out int PreserveTarget, out float TransitionTime, out SFXCameraMode_Interpolate Transition)
{
    Transition = AtlasTrans;
    AtlasTrans.TargetLocation = Outer.Pawn.GetPawnViewLocation() + Vector(Outer.Pawn.Rotation) * 1000.0;
    TransitionTime = AtlasCamTransitionTime;
    PreserveTarget = 0;
    return AtlasCam;
}
public exec function TightAim()
{
    local SFXPowerCustomActionBase oPower;
    
    if (SFXPlayerController(Outer).m_pActivePOI == None)
    {
        oPower = BioPawn(Outer.Pawn).PowerManager.GetPower('TitanRocket_Player');
        Outer.SquadOrderUsePower(oPower.PowerName, Outer.Pawn, 0, FALSE);
        Outer.ApplyTacticalOrders();
    }
}
public final function TryAutoMantle()
{
    local SFXNav_LargeClimbNode ClimbNode;
    local SFXNav_LargeMantleNode MantleNode;
    local PathNode Node;
    local PathNode ClosestNode;
    local float DistToNode;
    local float ClosestNodeDistSq;
    local BioPawn Atlas;
    local float GroundHeight;
    local ReachSpec Path;
    local ReachSpec BestPath;
    
    if (BioPlayerInput(Outer.PlayerInput).RawJoyUp < 0.5)
    {
        return;
    }
    Atlas = BioPawn(Outer.Pawn);
    if (Atlas == None || Atlas.CurrentCustomAction != 0)
    {
        return;
    }
    ClosestNodeDistSq = 250000.0;
    foreach Outer.WorldInfo.RadiusNavigationPoints(Class'PathNode', Node, Outer.Pawn.location, 200.0)
    {
        if (SFXNav_LargeMantleNode(Node) != None || SFXNav_LargeClimbNode(Node) != None)
        {
            GroundHeight = Node.location.Z - Node.CylinderComponent.CollisionHeight;
            if (Abs(Outer.Pawn.location.Z - Outer.Pawn.CylinderComponent.CollisionHeight - GroundHeight) < 10.0)
            {
                DistToNode = VSizeSq2D(Node.location - Outer.Pawn.location);
                if (BestPath == None || DistToNode < ClosestNodeDistSq)
                {
                    MantleNode = SFXNav_LargeMantleNode(Node);
                    ClimbNode = SFXNav_LargeClimbNode(Node);
                    if (MantleNode != None && MantleNode.MantleDest != None)
                    {
                        Path = MantleNode.GetReachSpecTo(MantleNode.MantleDest);
                    }
                    else if (ClimbNode != None && ClimbNode.ClimbDest != None)
                    {
                        Path = ClimbNode.GetReachSpecTo(ClimbNode.ClimbDest);
                    }
                    if (Path != None)
                    {
                        if (Path.GetDirection() Dot Vector(Outer.Pawn.Rotation) > 0.707000017)
                        {
                            ClosestNodeDistSq = DistToNode;
                            ClosestNode = Node;
                            BestPath = Path;
                        }
                    }
                }
            }
        }
    }
    MantleNode = SFXNav_LargeMantleNode(ClosestNode);
    ClimbNode = SFXNav_LargeClimbNode(ClosestNode);
    Outer.CurrentPath = BestPath;
    if (Outer.CurrentPath != None)
    {
        if (MantleNode != None)
        {
            Atlas.StartCustomAction(31);
        }
        else if (ClimbNode != None)
        {
            if (ClimbNode.bTopNode)
            {
                Atlas.StartCustomAction(34);
            }
            else
            {
                Atlas.StartCustomAction(33);
            }
        }
    }
}
public exec function TryHeavyMelee()
{
    local BioPlayerController PC;
    
    PC = BioPlayerController(Outer.Pawn.Controller);
    if (PC != None)
    {
        BioPawn(Outer.Pawn).StartCustomAction(134);
    }
}
public exec function TryMelee()
{
    local BioPlayerController PC;
    
    PC = BioPlayerController(Outer.Pawn.Controller);
    if (PC != None)
    {
        BioPawn(Outer.Pawn).StartCustomAction(133);
    }
}
public exec function TryReload()
{
    local SFXWeapon Weapon;
    
    if (Outer.Pawn != None)
    {
        Weapon = SFXWeapon(Outer.Pawn.Weapon);
        if (Weapon != None && Weapon.CanReload())
        {
            Weapon.TryReload();
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SFXCameraMode_Atlas Name=AtlasCam0
        CameraName = 'AtlasCam'
    End Object
    Begin Object Class=SFXCameraTransition_FaceTarget Name=AtlasTrans0
    End Object
    AtlasCam = AtlasCam0
    AtlasTrans = AtlasTrans0
    Bindings = ({
                 Command = "Shared_Shoot", 
                 Name = 'LeftMouseButton', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Shared_Aim", 
                 Name = 'RightMouseButton', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Shared_Action", 
                 Name = 'SpaceBar', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PC_LookX", 
                 Name = 'MouseX', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PC_LookY", 
                 Name = 'MouseY', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "Shared_Menu", 
                 Name = 'Escape', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }, 
                {
                 Command = "PC_EnterCommandMenu", 
                 Name = 'LeftShift', 
                 Control = FALSE, 
                 Shift = FALSE, 
                 Alt = FALSE, 
                 bIgnoreCtrl = FALSE, 
                 bIgnoreShift = FALSE, 
                 bIgnoreAlt = FALSE
                }
               )
    bShowHUD = TRUE
    bShowSelection = TRUE
    bShowExploreSelection = FALSE
    bShowDamageIndicators = TRUE
    bShowRadar = TRUE
    bShowWeapon = FALSE
    bAllowMovement = TRUE
    bAllowCamera = TRUE
    bAllowCameraMods = TRUE
    bAllowPauseMenu = TRUE
    bShowSubtitle = TRUE
    bMergeNotifications = TRUE
    bShowReticles = TRUE
    bPlayVocalizations = TRUE
    bNuiSpeechCombat = TRUE
}