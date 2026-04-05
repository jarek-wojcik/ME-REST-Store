Class SFXPlotTreasure extends BioPlotTreasure;

struct STech 
{
    var string sImage;
    var string sLargeImage;
    var Name nmTech;
    var Name nmResearch;
    var stringref srTitle;
    var stringref srName;
    var stringref srMessage;
    var stringref srDescription;
    var int nLevels;
    var int UnlockId;
};
struct STreasure 
{
    var Name nmLevel;
    var Name nmTreasure;
    var Name nmTech;
    var Name nmRequiredTech;
    var int nTreasureId;
    var int ResourcePrice;
    var int RequiredTechLevel;
    var int DiscoverTechLevel;
    var bool bNoAnimation;
    var bool bMultiLevel;
    var EInventoryResourceTypes Resource;
    
    structdefaultproperties
    {
        nTreasureId = -1
    }
};
struct SResourceBudget 
{
    var Name nmLevel;
    var int nCredits;
    var int nEezo;
    var int nIridium;
    var int nPlatinum;
    var int nPalladium;
    var int nID;
};

var const float fFullPriceMultiplier;
var const int nLastUnlockedTech;
var const stringref srMultiLevelUpgradeName;
var const int nProfessorInPartyId;
var const int nProfessorIsDeadId;
var const stringref srLabOpenResearchMessage;
var const stringref srLabClosedResearchMessage;
var const int StateNewResearchAvailable;
var const int StateNewUpgradesAvailable;
var const int srCanAffordResearch;

public function Name CurrentLevel()
{
    local string sMapName;
    
    if (GetMapName(sMapName))
    {
        return Name(sMapName);
    }
    return 'None';
}
public function float Price(int nTreasureId, optional bool bDiscount = FALSE)
{
    local STreasure stTreasure;
    local int nPrice;
    local int nLevel;
    local float fProfessorIsDeadPenalty;
    
    stTreasure = Self.TREASURE(nTreasureId);
    fProfessorIsDeadPenalty = 0.0;
    nPrice = 1;
    if (stTreasure.Resource != EInventoryResourceTypes.INV_RESOURCE_CREDITS)
    {
        if (BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetGlobalVariables().GetBool(nProfessorIsDeadId))
        {
            fProfessorIsDeadPenalty = 0.5;
        }
        nLevel = CalculateResearchLevelMultiplier(stTreasure.nmTech) + 1;
        nPrice *= float(nLevel);
    }
    if (bDiscount)
    {
        nPrice = int(float(nPrice * stTreasure.ResourcePrice) * (1.0 + fProfessorIsDeadPenalty));
    }
    else
    {
        nPrice = int(float(nPrice * stTreasure.ResourcePrice) * (fFullPriceMultiplier + fProfessorIsDeadPenalty));
    }
    return float(nPrice);
}
public function STreasure TREASURE(int nTreasureId)
{
    local STreasure stTreasure;
    local Name nmTreasureValue;
    local Name nmResource;
    local int ResourcePrice;
    local Name nmRequiredTech;
    local int RequiredTechLevel;
    local int DiscoverTechLevel;
    local int nNoAnimation;
    local int nMultiLevel;
    
    stTreasure.nTreasureId = nTreasureId;
    if (GetPlotTreasureTreasureName(nTreasureId, 'nmLevel', nmTreasureValue))
    {
        stTreasure.nmLevel = nmTreasureValue;
    }
    if (GetPlotTreasureTreasureName(nTreasureId, 'nmTreasure', nmTreasureValue))
    {
        stTreasure.nmTreasure = nmTreasureValue;
    }
    if (GetPlotTreasureTreasureName(nTreasureId, 'nmTech', nmTreasureValue))
    {
        stTreasure.nmTech = nmTreasureValue;
    }
    if (GetPlotTreasureTreasureName(nTreasureId, 'nmResource', nmResource))
    {
        if (nmResource == 'Credits')
        {
            stTreasure.Resource = EInventoryResourceTypes.INV_RESOURCE_CREDITS;
        }
        else if (nmResource == 'Iridium')
        {
            stTreasure.Resource = EInventoryResourceTypes.INV_RESOURCE_RARE2_IRIDIUM;
        }
        else if (nmResource == 'Palladium')
        {
            stTreasure.Resource = EInventoryResourceTypes.INV_RESOURCE_RARE3_PALLADIUM;
        }
        else if (nmResource == 'Platinum')
        {
            stTreasure.Resource = EInventoryResourceTypes.INV_RESOURCE_RARE4_PLATINUM;
        }
        else if (nmResource == 'Eezo')
        {
            stTreasure.Resource = EInventoryResourceTypes.INV_RESOURCE_RARE1_EEZO;
        }
        else if (nmResource == 'Probes')
        {
            stTreasure.Resource = EInventoryResourceTypes.INV_RESOURCE_PROBES;
        }
    }
    if (GetPlotTreasureTreasureInt(nTreasureId, 'nPrice', ResourcePrice))
    {
        stTreasure.ResourcePrice = ResourcePrice;
    }
    if (GetPlotTreasureTreasureName(nTreasureId, 'nmRequiredTech', nmRequiredTech))
    {
        stTreasure.nmRequiredTech = nmRequiredTech;
    }
    if (GetPlotTreasureTreasureInt(nTreasureId, 'nRequiredTechLevel', RequiredTechLevel))
    {
        stTreasure.RequiredTechLevel = RequiredTechLevel;
    }
    if (GetPlotTreasureTreasureInt(nTreasureId, 'nDiscoverTechLevel', DiscoverTechLevel))
    {
        stTreasure.DiscoverTechLevel = DiscoverTechLevel;
    }
    if (GetPlotTreasureTreasureInt(nTreasureId, 'nNoAnimation', nNoAnimation))
    {
        stTreasure.bNoAnimation = nNoAnimation > 0;
    }
    if (GetPlotTreasureTreasureInt(nTreasureId, 'nMultiLevel', nMultiLevel))
    {
        stTreasure.bMultiLevel = nMultiLevel > 0;
    }
    return stTreasure;
}
public function bool AwardTech(Name nmTech, optional bool bNoAnimation = FALSE, optional bool bStorePurchase = FALSE)
{
    local int nLevel;
    local int nResearchLevel;
    local string sMapName;
    local bool bFoundResearch;
    local bool bLabOpen;
    local bool bFoundWeapon;
    local string sName;
    local string sMessage;
    local STech stTech;
    local BioGlobalVariableTable oGV;
    local BioPlayerController oController;
    
    GetMapName(sMapName);
    stTech = Tech(nmTech);
    if (stTech.nmTech == 'None')
    {
        stTech = Tech(FindTechByResearch(nmTech));
        bFoundResearch = TRUE;
    }
    if (stTech.nmTech == 'None')
    {
        return FALSE;
    }
    nLevel = BioWorldInfo(Outer).GetGlobalVariables().GetIntByName(stTech.nmTech) + 1;
    if (nLevel > 10)
    {
        return FALSE;
    }
    sName = GetTechName(stTech, TRUE);
    ClearCustomTokens();
    SetCustomToken(0, string(nLevel));
    SetCustomToken(1, string(nLevel * 5));
    SetCustomToken(2, string(nLevel * 10));
    SetCustomToken(3, string(nLevel * 15));
    SetCustomToken(4, string(nLevel * 20));
    SetCustomToken(5, string(nLevel * 25));
    SetCustomToken(6, string(nLevel * 35));
    SetCustomToken(7, string(nLevel * 50));
    bFoundWeapon = Locs(Left(string(stTech.nmTech), 4)) == "wpn_";
    oGV = BioWorldInfo(Outer).GetGlobalVariables();
    if (bFoundResearch)
    {
        bLabOpen = oGV.GetBool(nProfessorInPartyId);
        nResearchLevel = oGV.GetIntByName(nmTech) + 1;
        nResearchLevel = nLevel > nResearchLevel ? nLevel : nResearchLevel;
        sMessage = bLabOpen ? string(srLabOpenResearchMessage) : string(srLabClosedResearchMessage);
        BioHintSystem(BioWorldInfo(Outer).GetLocalPlayerController().HintSystem).AddNotification_ResearchRecovered(string(stTech.srName), sMessage, stTech.sImage);
        BioWorldInfo(Outer).GetGlobalVariables().SetIntByName(nmTech, nResearchLevel);
        SetNewResearchAvailable(TRUE);
    }
    else
    {
        if (!bFoundWeapon)
        {
            BioHintSystem(BioWorldInfo(Outer).GetLocalPlayerController().HintSystem).AddNotification_Tech(sName, string(stTech.srTitle), string(stTech.srMessage), stTech.sImage);
        }
        else
        {
            BioHintSystem(BioWorldInfo(Outer).GetLocalPlayerController().HintSystem).AddNotification_Weapon(sName, string(stTech.srTitle), string(stTech.srMessage), stTech.sImage);
        }
        oGV.SetIntByName(stTech.nmTech, nLevel);
        SetNewUpgradesAvailable(TRUE);
    }
    if (bStorePurchase && stTech.nmResearch != 'None')
    {
        nResearchLevel = oGV.GetIntByName(stTech.nmResearch);
        oGV.SetIntByName(stTech.nmResearch, nResearchLevel + 1);
    }
    oController = BioWorldInfo(Outer).GetLocalPlayerController();
    if (!bNoAnimation)
    {
        SFXPawn(oController.Pawn).StartCustomAction(4);
    }
    if (!bFoundResearch)
    {
    }
    CheckForUpgradedWeaponAccomplishment();
    ReLockTech(stTech);
    return TRUE;
}
public function bool AwardTreasure(int nTreasureId, optional bool bDiscount = FALSE)
{
    local STreasure stTreasure;
    local bool bResult;
    local BioRemoteLogger GLogger;
    local string sMapName;
    local Pawn PlayerPawn;
    local bool bStorePurchase;
    
    GetMapName(sMapName);
    bResult = FALSE;
    stTreasure = Self.TREASURE(nTreasureId);
    if (stTreasure.nmTech == 'None')
    {
        LogWarning("Treasure: treasure_id=" $ nTreasureId $ " in " $ sMapName $ " -- does not exist");
        return FALSE;
    }
    if (BioWorldInfo(Outer).GetGlobalVariables().GetBool(nTreasureId) && stTreasure.bMultiLevel == FALSE)
    {
        LogWarning("Treasure: treasure_id=" $ nTreasureId $ " in " $ sMapName $ " -- attempted duplicate award");
        return FALSE;
    }
    if (!CanAffordTreasure(nTreasureId, bDiscount))
    {
        LogWarning("Treasure: treasure_id=" $ nTreasureId $ " player Can not afford");
        return FALSE;
    }
    if (!QualifiesForTreasure(nTreasureId))
    {
        LogWarning("Treasure: treasure_id=" $ nTreasureId $ " player does not qualify");
        return FALSE;
    }
    if (!ChargeForTreasure(nTreasureId, bDiscount))
    {
        LogWarning("Treasure: treasure_id=" $ nTreasureId $ " failed to charge player for treasure");
        return FALSE;
    }
    bStorePurchase = stTreasure.Resource == EInventoryResourceTypes.INV_RESOURCE_CREDITS && stTreasure.ResourcePrice > 0;
    bResult = AwardTech(stTreasure.nmTech, stTreasure.bNoAnimation, bStorePurchase);
    if (!bResult)
    {
        LogWarning("Treasure: treasure_id=" $ nTreasureId $ " failed to increase tech level");
        return FALSE;
    }
    GLogger = Class'BioRemoteLogger'.static.GetLogger();
    if (GLogger != None)
    {
        GLogger.SendPlayerEvent(38, "", "C", "Awarded Treasure", "nTreasureId=" $ nTreasureId, nTreasureId, -1, 6, 0);
    }
    if (stTreasure.bMultiLevel == FALSE)
    {
        BioWorldInfo(Outer).GetGlobalVariables().SetBool(nTreasureId, TRUE);
    }
    if (stTreasure.bNoAnimation == FALSE)
    {
        PlayerPawn = BioWorldInfo(Outer).GetLocalPlayerController().Pawn;
        SFXGRI(BioWorldInfo(Outer).GRI).TriggerVocalizationEvent(109, BioPawn(PlayerPawn));
    }
    return TRUE;
}
public function SResourceBudget Budget(optional Name nmLevel)
{
    local SResourceBudget stBudget;
    local int nBudgetValue;
    
    if (nmLevel == 'None')
    {
        nmLevel = CurrentLevel();
    }
    stBudget.nmLevel = nmLevel;
    stBudget.nCredits = 0;
    stBudget.nEezo = 0;
    stBudget.nIridium = 0;
    stBudget.nPalladium = 0;
    stBudget.nPlatinum = 0;
    stBudget.nmLevel = nmLevel;
    if (GetPlotTreasureResourcesInt(nmLevel, 'Id', nBudgetValue))
    {
        stBudget.nID = nBudgetValue;
    }
    if (GetPlotTreasureResourcesInt(nmLevel, 'Credits', nBudgetValue))
    {
        stBudget.nCredits = nBudgetValue;
    }
    if (GetPlotTreasureResourcesInt(nmLevel, 'Eezo', nBudgetValue))
    {
        stBudget.nEezo = nBudgetValue;
    }
    if (GetPlotTreasureResourcesInt(nmLevel, 'Iridium', nBudgetValue))
    {
        stBudget.nIridium = nBudgetValue;
    }
    if (GetPlotTreasureResourcesInt(nmLevel, 'Palladium', nBudgetValue))
    {
        stBudget.nPalladium = nBudgetValue;
    }
    if (GetPlotTreasureResourcesInt(nmLevel, 'Platinum', nBudgetValue))
    {
        stBudget.nPlatinum = nBudgetValue;
    }
    return stBudget;
}
public function SResourceBudget BudgetFromId(int nID)
{
    local SResourceBudget stResource;
    local Name nmLevel;
    local int i;
    local int nCredits;
    local int Eezo;
    local int Palladium;
    local int Platinum;
    local int Iridium;
    local int Id;
    
    for (i = 0; i != oPlotTreasureResources2DA.GetNumRows(); ++i)
    {
        oPlotTreasureResources2DA.GetIntEntryIN(i, 'Id', Id);
        if (Id == nID)
        {
            nmLevel = oPlotTreasureResources2DA.GetRowName(i);
            oPlotTreasureResources2DA.GetIntEntryIN(i, 'Credits', nCredits);
            oPlotTreasureResources2DA.GetIntEntryIN(i, 'Eezo', Eezo);
            oPlotTreasureResources2DA.GetIntEntryIN(i, 'Palladium', Palladium);
            oPlotTreasureResources2DA.GetIntEntryIN(i, 'Platinum', Platinum);
            oPlotTreasureResources2DA.GetIntEntryIN(i, 'Iridium', Iridium);
            stResource.nID = Id;
            stResource.nCredits = nCredits;
            stResource.nEezo = Eezo;
            stResource.nIridium = Iridium;
            stResource.nmLevel = nmLevel;
            stResource.nPalladium = Palladium;
            stResource.nPlatinum = Platinum;
            return stResource;
        }
    }
    return stResource;
}
public function int CalculateResearchLevelMultiplier(Name nmTech)
{
    local int i;
    local int nLevel;
    local BioGlobalVariableTable oGV;
    local Name nmTreasureTech;
    local Name nmTreasureResource;
    
    oGV = BioWorldInfo(Outer).GetGlobalVariables();
    nLevel = oGV.GetIntByName(nmTech);
    for (i = 0; i != default.oPlotTreasureTreasure2DA.GetNumRows(); ++i)
    {
        if (oGV.GetBool(oPlotTreasureTreasure2DA.GetRowNumber(i)))
        {
            default.oPlotTreasureTreasure2DA.GetNameEntryIN(i, 'nmTech', nmTreasureTech);
            if (nmTreasureTech == nmTech)
            {
                default.oPlotTreasureTreasure2DA.GetNameEntryIN(i, 'nmResource', nmTreasureResource);
                if (nmTreasureResource == 'Credits')
                {
                    nLevel--;
                }
            }
        }
    }
    return nLevel;
}
public function bool CanAffordTreasure(int nTreasureId, optional bool bDiscount = FALSE)
{
    local STreasure stTreasure;
    local SFXInventoryManager oInv;
    local bool bCanAfford;
    local int RealPrice;
    local int RealCredits;
    
    stTreasure = Self.TREASURE(nTreasureId);
    oInv = SFXInventoryManager(SFXPawn(BioWorldInfo(Outer).GetLocalPlayerController().Pawn).InvManager);
    RealPrice = int(Price(nTreasureId, bDiscount));
    RealCredits = oInv.GetResource(stTreasure.Resource);
    bCanAfford = RealCredits >= RealPrice;
    return bCanAfford;
}
public function bool ChargeForTreasure(int nTreasureId, optional bool bDiscount = FALSE)
{
    local STreasure stTreasure;
    local SFXInventoryManager oInv;
    
    if (!CanAffordTreasure(nTreasureId, bDiscount))
    {
        return FALSE;
    }
    stTreasure = Self.TREASURE(nTreasureId);
    oInv = SFXInventoryManager(BioWorldInfo(Outer).GetLocalPlayerController().Pawn.InvManager);
    oInv.AdjustResource(stTreasure.Resource, int(float(-1) * Price(nTreasureId, bDiscount)), FALSE);
    return TRUE;
}
public function CheckForUpgradedWeaponAccomplishment()
{
    local int ARpoints;
    local int APpoints;
    local int SGpoints;
    local int SRpoints;
    local int HPpoints;
    local int Points;
    local BioGlobalVariableTable oGV;
    local SFXAccomplishmentManager AccomplishmentManager;
    
    AccomplishmentManager = SFXEngine(Class'Engine'.static.GetEngine()).AccomplishmentManager;
    if (AccomplishmentManager == None)
    {
        return;
    }
    oGV = BioWorldInfo(Outer).GetGlobalVariables();
    ARpoints = oGV.GetInt(68) + oGV.GetInt(453) + oGV.GetInt(451);
    APpoints = oGV.GetInt(426) + oGV.GetInt(456) + oGV.GetInt(457);
    SGpoints = oGV.GetInt(71) + oGV.GetInt(470) + oGV.GetInt(471);
    SRpoints = oGV.GetInt(72) + oGV.GetInt(474) + oGV.GetInt(475);
    HPpoints = oGV.GetInt(69) + oGV.GetInt(462) + oGV.GetInt(463);
    Points = ARpoints;
    Points = Points < APpoints ? APpoints : Points;
    Points = Points < SGpoints ? SGpoints : Points;
    Points = Points < SRpoints ? SRpoints : Points;
    Points = Points < HPpoints ? HPpoints : Points;
}
public function bool DiscoveredResearch(int nTreasureId)
{
    local STreasure stTreasure;
    
    if (BioWorldInfo(Outer).GetGlobalVariables().GetBool(nTreasureId))
    {
        return TRUE;
    }
    stTreasure = Self.TREASURE(nTreasureId);
    if (stTreasure.DiscoverTechLevel <= 0 || BioWorldInfo(Outer).GetGlobalVariables().GetIntByName(stTreasure.nmRequiredTech) >= stTreasure.DiscoverTechLevel)
    {
        return TRUE;
    }
    return FALSE;
}
public static final function Texture2D FindImage(string Path)
{
    return Texture2D(Class'SFXEngine'.static.GetSeekFreeObject(Path, Class'Texture2D'));
}
public static function Name FindTechByResearch(Name nmTech)
{
    local Name nmRequiredTech;
    local int i;
    
    for (i = 0; i != default.oPlotTreasureTreasure2DA.GetNumRows(); ++i)
    {
        default.oPlotTreasureTreasure2DA.GetNameEntryIN(i, 'nmRequiredTech', nmRequiredTech);
        if (nmRequiredTech == nmTech)
        {
            default.oPlotTreasureTreasure2DA.GetNameEntryIN(i, 'nmTech', nmTech);
            return nmTech;
        }
    }
    return 'None';
}
public static function GetTechImageResourcePath(Name nmTech, out string sImagePath, out string sLargeImagePath, optional bool bNoLookup = FALSE)
{
    local int i;
    local Name nmTmp;
    
    for (i = 0; i != default.oPlotTreasureTech2DA.GetNumRows(); ++i)
    {
        default.oPlotTreasureTech2DA.GetNameEntryIN(i, 'nmTech', nmTmp);
        if (nmTech == nmTmp)
        {
            default.oPlotTreasureTech2DA.GetNameEntryIN(i, 'sImage', nmTmp);
            sImagePath = "" $ nmTmp;
            default.oPlotTreasureTech2DA.GetNameEntryIN(i, 'sLargeImage', nmTmp);
            sLargeImagePath = "" $ nmTmp;
        }
    }
    if (sImagePath == "" && bNoLookup == FALSE)
    {
        nmTech = FindTechByResearch(nmTech);
        if (nmTech != 'None')
        {
            GetTechImageResourcePath(nmTech, sImagePath, sLargeImagePath, TRUE);
        }
    }
}
public function string GetTechName(STech stTech, optional bool bAddOne = FALSE)
{
    local string sName;
    local int nLevel;
    local int nMaxLevel;
    
    if (stTech.nLevels > 1)
    {
        ClearCustomTokens();
        nLevel = BioWorldInfo(Outer).GetGlobalVariables().GetIntByName(stTech.nmTech) + (bAddOne ? 1 : 0);
        nMaxLevel = nLevel <= stTech.nLevels ? stTech.nLevels : nLevel;
        SetCustomToken(0, string(stTech.srName));
        SetCustomToken(1, "" $ nLevel);
        SetCustomToken(2, "" $ nMaxLevel);
        sName = string(srMultiLevelUpgradeName);
    }
    else
    {
        sName = string(stTech.srName);
    }
    return sName;
}
public static function string GetTreasureImageResourcePath(int nTreasureId)
{
    local int i;
    local int J;
    local Name nmTech;
    local string sImagePath;
    local string sLargeImagePath;
    
    for (i = 0; i != default.oPlotTreasureTreasure2DA.GetNumRows(); ++i)
    {
        J = default.oPlotTreasureTreasure2DA.GetRowNumber(i);
        if (nTreasureId == J)
        {
            default.oPlotTreasureTreasure2DA.GetNameEntryIN(i, 'nmTech', nmTech);
            break;
        }
    }
    if (nmTech == 'None')
    {
        return "";
    }
    GetTechImageResourcePath(nmTech, sImagePath, sLargeImagePath);
    return sImagePath;
}
public static function string GetTreasureLargeImageResourcePath(int nTreasureId)
{
    local int i;
    local int J;
    local Name nmTech;
    local string sImagePath;
    local string sLargeImagePath;
    
    for (i = 0; i != default.oPlotTreasureTreasure2DA.GetNumRows(); ++i)
    {
        J = default.oPlotTreasureTreasure2DA.GetRowNumber(i);
        if (nTreasureId == J)
        {
            default.oPlotTreasureTreasure2DA.GetNameEntryIN(i, 'nmTech', nmTech);
            break;
        }
    }
    if (nmTech == 'None')
    {
        return "";
    }
    GetTechImageResourcePath(nmTech, sImagePath, sLargeImagePath);
    return sLargeImagePath;
}
private final function LogWarning(string Msg)
{
}
public function bool QualifiesForTreasure(int nTreasureId)
{
    local STreasure stTreasure;
    local STech stTech;
    local int nRequiredTechLevel;
    local BioGlobalVariableTable oGV;
    
    stTreasure = Self.TREASURE(nTreasureId);
    stTech = Self.Tech(stTreasure.nmTech);
    nRequiredTechLevel = stTreasure.RequiredTechLevel;
    oGV = BioWorldInfo(Outer).GetGlobalVariables();
    if (stTech.nLevels <= 1 && oGV.GetBool(nTreasureId))
    {
        return FALSE;
    }
    if (stTreasure.bMultiLevel)
    {
        nRequiredTechLevel = oGV.GetIntByName(stTech.nmTech) + 1;
    }
    if (nRequiredTechLevel > 0 && oGV.GetIntByName(stTreasure.nmRequiredTech) < nRequiredTechLevel)
    {
        return FALSE;
    }
    return TRUE;
}
public function ReLockTech(STech stTech)
{
    if (stTech.nLevels <= 1)
    {
        return;
    }
    if (stTech.UnlockId <= 0)
    {
        return;
    }
    BioWorldInfo(Outer).GetGlobalVariables().SetBool(stTech.UnlockId, FALSE);
}
public function SetNewResearchAvailable(bool bResearchAvailable)
{
    BioWorldInfo(Outer).GetGlobalVariables().SetBool(StateNewResearchAvailable, bResearchAvailable);
}
public function SetNewUpgradesAvailable(bool bUpgadesAvailable)
{
    BioWorldInfo(Outer).GetGlobalVariables().SetBool(StateNewUpgradesAvailable, bUpgadesAvailable);
}
public function STech Tech(Name nmTech)
{
    local STech stTech;
    local int N;
    local Name nmTmp;
    
    if (nmTech == 'None')
    {
        return stTech;
    }
    GetPlotTreasureTechName(nmTech, 'nmTech', stTech.nmTech);
    GetPlotTreasureTechName(nmTech, 'nmResearch', stTech.nmResearch);
    GetPlotTreasureTechName(nmTech, 'sImage', nmTmp);
    stTech.sImage = string(nmTmp);
    GetPlotTreasureTechName(nmTech, 'sLargeImage', nmTmp);
    stTech.sLargeImage = string(nmTmp);
    GetPlotTreasureTechInt(nmTech, 'nmTech', 'srTitle', N);
    stTech.srTitle = stringref(N);
    GetPlotTreasureTechInt(nmTech, 'nmTech', 'srName', N);
    stTech.srName = stringref(N);
    GetPlotTreasureTechInt(nmTech, 'nmTech', 'srMessage', N);
    stTech.srMessage = stringref(N);
    GetPlotTreasureTechInt(nmTech, 'nmTech', 'srDescription', N);
    stTech.srDescription = stringref(N);
    GetPlotTreasureTechInt(nmTech, 'nmTech', 'nLevels', N);
    stTech.nLevels = N;
    GetPlotTreasureTechInt(nmTech, 'nmTech', 'UnlockId', N);
    stTech.UnlockId = N;
    return stTech;
}
public function TriggerResourceHint(EInventoryResourceTypes InvType, int nAmount)
{
    local Name nmTmp;
    local int i;
    local int nCurrentAmount;
    local int nNewAmount;
    local int nTmp;
    local BioPlayerController oController;
    local SFXInventoryManager oInventory;
    local STech stTech;
    
    if (InvType == EInventoryResourceTypes.INV_RESOURCE_CREDITS)
    {
        return;
    }
    oController = BioWorldInfo(Outer).GetLocalPlayerController();
    if (oController == None || oController.Pawn == None || oController.Pawn.InvManager == None)
    {
        return;
    }
    oInventory = SFXInventoryManager(oController.Pawn.InvManager);
    nCurrentAmount = oInventory.GetResource(InvType);
    nNewAmount = nCurrentAmount + nAmount;
    for (i = 0; i != default.oPlotTreasureTreasure2DA.GetNumRows(); ++i)
    {
        default.oPlotTreasureTreasure2DA.GetNameEntryIN(i, 'nmResource', nmTmp);
        if (nmTmp == 'None' || nmTmp == 'Credits')
        {
            continue;
        }
        if (InvType == EInventoryResourceTypes.INV_RESOURCE_RARE1_EEZO && nmTmp != 'Eezo' || InvType == EInventoryResourceTypes.INV_RESOURCE_RARE2_IRIDIUM && nmTmp != 'Iridium' || InvType == EInventoryResourceTypes.INV_RESOURCE_RARE3_PALLADIUM && nmTmp != 'Palladium' || InvType == EInventoryResourceTypes.INV_RESOURCE_RARE4_PLATINUM && nmTmp != 'Platinum')
        {
            continue;
        }
        default.oPlotTreasureTreasure2DA.GetIntEntryIN(i, 'nPrice', nTmp);
        if (nNewAmount < nTmp || nCurrentAmount > nTmp)
        {
            continue;
        }
        nTmp = default.oPlotTreasureTreasure2DA.GetRowNumber(i);
        if (QualifiesForTreasure(nTmp) == FALSE)
        {
            continue;
        }
        default.oPlotTreasureTreasure2DA.GetNameEntryIN(i, 'nmTech', nmTmp);
        stTech = Tech(nmTmp);
        ClearCustomTokens();
        SetCustomToken(0, string(stTech.srName));
        Class'SFXGUIInteraction'.static.GetInstance().ShowHint(stringref(srCanAffordResearch), 6.0, 0, 2, FALSE, FALSE, oController);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    fFullPriceMultiplier = 1.20000005
    nLastUnlockedTech = 580
    srMultiLevelUpgradeName = $349161
    nProfessorInPartyId = 790
    nProfessorIsDeadId = 203
    srLabOpenResearchMessage = $349317
    srLabClosedResearchMessage = $349318
    StateNewResearchAvailable = 6149
    StateNewUpgradesAvailable = 6150
    srCanAffordResearch = 346051
}