Class SFXSeqAct_LaunchWeaponSelection extends BioSequenceLatentAction
    native;

var Name TableSocket;
var SkeletalMeshActor TableSkelMesh;
var(WeaponSelect) int MaxWeapons;
var(Texture) TextureRenderTarget2D ModStatsRenderTexture;
var(Texture) TextureRenderTarget2D ModControlsRenderTexture;
var SFXGUI_WeaponSelection oMovie;
var bool bInitialized;
var(WeaponSelect) bool ShowAllWeapons;
var(WeaponSelect) bool ShowAllMods;
var(WeaponSelect) bool AutoEquipWhenDone;
var(SFXSeqAct_LaunchWeaponSelection) bool PauseGame;

public function Activated()
{
    local SFXGUIInteraction oGUI;
    
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    Super(SequenceOp).Activated();
    if (oMovie == None)
    {
        oMovie = SFXGUI_WeaponSelection(oGUI.OpenMovie(None, oGUI.MovieTag_WeaponSelect, FALSE));
        oMovie.ShowAllWeapons = ShowAllWeapons;
        oMovie.AutoEquipWhenDone = AutoEquipWhenDone;
        oMovie.LaunchOnStart = FALSE;
        oMovie.Start();
        oMovie.SetEnabled(FALSE);
    }
    if (oMovie != None)
    {
        if (InputLinks[0].bHasImpulse)
        {
            InputLinks[0].bHasImpulse = FALSE;
            if (!bInitialized)
            {
                Initialize();
            }
            oMovie.SetEnabled(TRUE);
            oMovie.Launch(PauseGame);
        }
        else if (InputLinks[1].bHasImpulse)
        {
            InputLinks[1].bHasImpulse = FALSE;
            Initialize();
            return;
        }
        else if (InputLinks[2].bHasImpulse)
        {
            InputLinks[2].bHasImpulse = FALSE;
            Prime();
            return;
        }
    }
}
public final event function Cleanup()
{
    if (oMovie != None)
    {
        oMovie.Close(TRUE);
    }
}
public function Deactivated()
{
    if (oMovie != None)
    {
        oMovie.Close();
    }
    oMovie = None;
    bInitialized = FALSE;
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 5;
}
public final function Initialize()
{
    if (oMovie != None && !bInitialized)
    {
        SetupModExtension();
        bInitialized = TRUE;
    }
}
public final function Prime()
{
    if (oMovie != None)
    {
        oMovie.PreLoadData(DataPrimed);
    }
}
public event function bool UpdateOp(float fDeltaTime)
{
    local bool bDone;
    
    bDone = FALSE;
    if (oMovie == None)
    {
        bDone = TRUE;
    }
    else if (oMovie.IsOpen() == FALSE)
    {
        bDone = TRUE;
    }
    if (bDone == FALSE && oMovie != None)
    {
        if (InputLinks[0].bHasImpulse)
        {
            InputLinks[0].bHasImpulse = FALSE;
            if (!bInitialized)
            {
                Initialize();
            }
            oMovie.SetEnabled(TRUE);
            oMovie.Launch(PauseGame);
        }
        else if (InputLinks[1].bHasImpulse)
        {
            InputLinks[1].bHasImpulse = FALSE;
            Initialize();
        }
    }
    if (bDone)
    {
        OutputLinks[0].bHasImpulse = TRUE;
    }
    return bDone;
}
public final function ChangeView()
{
    OutputLinks[5].bHasImpulse = TRUE;
}
public final function DataPrimed()
{
    OutputLinks[4].bHasImpulse = TRUE;
}
public final function ForcedShutDown()
{
    OutputLinks[0].bHasImpulse = TRUE;
}
public final function SetupModExtension()
{
    local SFXGUIExt_WeaponMods oModExtension;
    
    if (ModStatsRenderTexture == None || ModControlsRenderTexture == None)
    {
        return;
    }
    oModExtension = oMovie.AddExtension(Class'SFXGUIExt_WeaponMods');
    if (oModExtension != None)
    {
        oModExtension.Kismet = Self;
        oModExtension.ShowAllMods = ShowAllMods;
        oModExtension.Setup(ModStatsRenderTexture, ModControlsRenderTexture);
    }
}
public final function SwitchPawn(Pawn NewPawn)
{
    SetObjectVars("Current Pawn", NewPawn);
    OutputLinks[1].bHasImpulse = TRUE;
}
public final function TransitionToWeaponMod()
{
    OutputLinks[2].bHasImpulse = TRUE;
}
public final function TransitionToWeaponSel()
{
    OutputLinks[3].bHasImpulse = TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MaxWeapons = 4
    AutoEquipWhenDone = TRUE
    bHasTargets = FALSE
    bCallHandler = FALSE
    InputLinks = ({
                   LinkDesc = "In", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Initialize", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Prime Data", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Done", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Switch Pawn", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Weapon Select -> Mod", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Weapon Mod -> Select", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Data Primed", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Change View", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Current Pawn", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Table Skel Mesh", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'TableSkelMesh', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Table Socket", 
                      ExpectedType = Class'SeqVar_Name', 
                      LinkVar = 'None', 
                      PropertyName = 'TableSocket', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Max Weapons", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'MaxWeapons', 
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