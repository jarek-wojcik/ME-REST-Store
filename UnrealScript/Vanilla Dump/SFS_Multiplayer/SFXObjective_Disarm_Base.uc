Class SFXObjective_Disarm_Base extends SFXOperationObjective
    placeable
    config(Game);

var repnotify BioPawn DisarmedBy;
var SFXEngagement_Disarm DisarmWave;

public simulated function PostBeginPlay()
{
    local SFXModule_MarkerObjective ObjectiveModule;
    
    Super.PostBeginPlay();
    ObjectiveModule = GetModule(Class'SFXModule_MarkerObjective');
    ObjectiveModule.MarkerType = "Disarm";
}
public event simulated function ReplicatedEvent(Name VarName)
{
    Super.ReplicatedEvent(VarName);
    if (VarName == 'DisarmedBy' && DisarmedBy != None)
    {
        DisarmBomb(DisarmedBy);
    }
}
public simulated function Deactivate()
{
    local SFXSimpleUseModule UseModule;
    
    Super.Deactivate();
    SetHidden(TRUE);
    UseModule = GetModule(Class'SFXSimpleUseModule');
    if (UseModule != None)
    {
        UseModule.m_bTargetable = FALSE;
    }
}
public function Used(Actor User)
{
    local SFXPawn_Player Player;
    local BioCustomAction CustomAction;
    local SFXCustomAction_DisarmObject DisarmCustomAction;
    
    Player = SFXPawn_Player(User);
    if (Player == None)
    {
        return;
    }
    if (DisarmWave != None)
    {
        Player.StartCustomAction(26);
        if (Player.GetCurrentCustomAction(CustomAction))
        {
            DisarmCustomAction = SFXCustomAction_DisarmObject(CustomAction);
            if (DisarmCustomAction != None)
            {
                DisarmCustomAction.DisarmObject = Self;
            }
        }
    }
}
public simulated function DisarmBomb(BioPawn oPawn)
{
    if (Role == ENetRole.ROLE_Authority)
    {
        if (DisarmedBy != None)
        {
            return;
        }
        Deactivate();
        DisarmedBy = oPawn;
        bForceNetUpdate = TRUE;
    }
    if (DisarmWave == None)
    {
        SetTimer(0.00999999978, FALSE, 'DisarmBomb', );
        return;
    }
    DisarmWave.OnBombDisarmed(Self, DisarmedBy);
}
public simulated function SetOwningWave(SFXWave_Operation NewOwner)
{
    Super.SetOwningWave(NewOwner);
    DisarmWave = SFXEngagement_Disarm(NewOwner);
}
public simulated function ActivateObjective()
{
    local SFXSimpleUseModule UseModule;
    
    Super.ActivateObjective();
    SetHidden(FALSE);
    UseModule = GetModule(Class'SFXSimpleUseModule');
    if (UseModule != None)
    {
        UseModule.m_bTargetable = TRUE;
    }
}

replication
{
    if (bNetDirty && Role == ENetRole.ROLE_Authority)
        DisarmedBy;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
    End Template
    Begin Template Class=StaticMeshComponent Name=MeshComp0
        ReplacementPrimitive = None
        LightEnvironment = MyLightEnvironment
    End Template
    Begin Object Class=SFXSimpleUseModule Name=SelMod01
        __OnUsed__Delegate = class'SFXObjective_Disarm_Base'.Used
        fUseRange = 325.0
        m_TargetOffset = {X = 0.0, Y = 0.0, Z = 25.0}
        m_bTargetable = TRUE
        bIgnoreFacing = TRUE
    End Object
    Begin Object Class=SFXModule_MarkerObjective Name=ObjectiveModule0
        MarkerOffset = {X = 0.0, Y = 0.0, Z = 100.0}
    End Object
    OwnerWaveClassName = 'SFXEngagement_Disarm'
    WaveInstructionVODelay = 4.0
    Mesh = MeshComp0
    LightEnvironment = MyLightEnvironment
    bEnableCombatZone = TRUE
    Components = (None, MyLightEnvironment, MeshComp0)
    Modules = (SelMod01, ObjectiveModule0)
    bAlwaysRelevant = TRUE
    bOnlyDirtyReplication = TRUE
    RemoteRole = ENetRole.ROLE_SimulatedProxy
}