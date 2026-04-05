Class SFXSeqAct_StoreGUI extends BioSequenceLatentAction;

var(SFXSeqAct_StoreGUI) Class<SFXGUIData_Store> StorefrontClass;
var transient SFXGUI_Store m_StoreGUIHandler;
var transient SFXGUIData_Store m_StoreStockData;
var GFxMovieInfo m_StoreGUIResource;
var transient bool m_bFinished;
var transient bool m_bAborted;
var transient bool m_bWasPaused;

public event function Activated()
{
    m_bFinished = FALSE;
    m_bAborted = FALSE;
    OutputLinks[0].bHasImpulse = FALSE;
    ResetStorefront();
}
public event function Deactivated();

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 1;
}
public function bool UpdateOp(float fDeltaT)
{
    if (m_bAborted)
    {
        OutputLinks[0].bHasImpulse = TRUE;
    }
    if (m_bFinished)
    {
        OutputLinks[0].bHasImpulse = TRUE;
    }
    if (m_bAborted || m_bFinished)
    {
        if (m_StoreGUIHandler != None)
        {
            m_StoreGUIHandler.ShutDown();
            m_StoreGUIHandler = None;
        }
        return TRUE;
    }
    return FALSE;
}
public function ExitStore()
{
    m_bFinished = TRUE;
}
public function ResetStorefront()
{
    local BioWorldInfo WorldInfo;
    local BioPlayerController CustomerPC;
    local BioPawn CustomerPawn;
    local SFXGUIInteraction Manager;
    
    WorldInfo = BioWorldInfo(GetWorldInfo());
    if (WorldInfo == None)
    {
        m_bAborted = TRUE;
        return;
    }
    CustomerPC = WorldInfo.GetLocalPlayerController();
    if (CustomerPC == None)
    {
        m_bAborted = TRUE;
        return;
    }
    CustomerPawn = BioPawn(CustomerPC.Pawn);
    if (CustomerPawn == None)
    {
        m_bAborted = TRUE;
        return;
    }
    Manager = Class'SFXGUIInteraction'.static.GetInstance();
    if (Manager == None)
    {
        m_bAborted = TRUE;
        return;
    }
    m_StoreGUIHandler = Manager.CreateStoreGUI('None', CustomerPC);
    if (m_StoreGUIHandler == None)
    {
        m_bAborted = TRUE;
        return;
    }
    m_StoreGUIHandler.SetOnCloseCallback(ExitStore);
    SetupStock();
    if (m_bAborted == FALSE && m_bFinished == FALSE)
    {
        m_StoreGUIHandler.Initialize(m_StoreStockData, 'None', CustomerPawn);
    }
}
public function SetupStock()
{
    m_StoreStockData = new (Self) StorefrontClass;
    if (m_StoreStockData == None)
    {
        m_bAborted = TRUE;
        return;
    }
    m_StoreStockData.m_srTitle = m_StoreStockData.default.m_srTitle;
    m_StoreStockData.m_srSubTitle = m_StoreStockData.default.m_srSubTitle;
    m_StoreStockData.m_srAText = m_StoreStockData.default.m_srAText;
    m_StoreStockData.m_srBText = m_StoreStockData.default.m_srBText;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=SFXGUIData_Store Name=StoreStockData
    End Object
    m_StoreStockData = StoreStockData
    m_StoreGUIResource = GFxMovieInfo'GUI_SF_Store.Store'
    bHasTargets = FALSE
    bCallHandler = FALSE
    InputLinks = ({
                   LinkDesc = "EnterStore", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "ExitStore", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ()
    bManualHandleOutputs = TRUE
}