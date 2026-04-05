Class SFXTreasureUseModule extends SFXModule_SavedUse
    editinlinenew;

enum ETreasureType
{
    AMMO_TREASURE,
    MEDIGEL_TREASURE,
    CREDITS_TREASURE,
    GRENADE_TREASURE,
};

var(SFXTreasureUseModule) int ResourcePercent;
var(SFXTreasureUseModule) bool bUseAbsuluteAmount;
var(SFXTreasureUseModule) ETreasureType TreasureType;

public event simulated function HandlePostBeginPlay()
{
    Super(SFXSimpleUseModule).HandlePostBeginPlay();
    if (ResourcePercent <= 0 || HasBeenUsed())
    {
        SetTargetable(FALSE);
    }
}
public event function bool IsDefaultActionPossible()
{
    return m_TargetTipText != ETargetTipText.TargetTipText_None && ResourcePercent > 0;
}
public function OnUsed(Actor User)
{
    local bool bGaveResources;
    local SFXPawn_Player pPawn;
    local SFXInventoryManager InvManager;
    
    pPawn = SFXPawn_Player(User);
    if (pPawn == None)
    {
        return;
    }
    InvManager = SFXInventoryManager(pPawn.InvManager);
    if (InvManager == None)
    {
        return;
    }
    bGaveResources = InvManager.AwardResource(TreasureType, ResourcePercent, bUseAbsuluteAmount);
    if (!bGaveResources)
    {
        return;
    }
    ResourcePercent = 0;
    SetTargetable(FALSE);
    Used(User);
}
public function SetTargetable(bool bTargetable, optional bool bSetTargetSave = FALSE)
{
    local ActorComponent Comp;
    local StaticMeshComponent oStaticMesh;
    local LinearColor EmissiveColor;
    local int nIndex;
    local MaterialInstanceConstant M;
    local MaterialInstanceConstant Instance;
    
    Super(SFXSelectionModule).SetTargetable(bTargetable);
    if (!bTargetable)
    {
        ResourcePercent = 0;
        foreach ModuleOwner.AllOwnedComponents(Class'ActorComponent', Comp)
        {
            oStaticMesh = StaticMeshComponent(Comp);
            if (oStaticMesh != None)
            {
                for (nIndex = 0; nIndex < oStaticMesh.Materials.Length; nIndex++)
                {
                    M = MaterialInstanceConstant(oStaticMesh.Materials[nIndex]);
                    if (M != None)
                    {
                        M.GetVectorParameterValue('Emissive_color', EmissiveColor);
                        if (M.Outer != ModuleOwner && EmissiveColor.A > 1.0)
                        {
                            Instance = new (ModuleOwner) Class'MaterialInstanceConstant';
                            Instance.SetParent(M);
                            EmissiveColor.A = EmissiveColor.A / float(10);
                            Instance.SetVectorParameterValue('Emissive_color', EmissiveColor);
                            oStaticMesh.SetMaterial(nIndex, Instance);
                        }
                    }
                }
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TreasureType = ETreasureType.MEDIGEL_TREASURE
    bPlayUseAnimation = TRUE
    m_fMaxSelectionRangeSqr = 640000.0
    m_TargetTipText = ETargetTipText.TargetTipText_Salvage
}