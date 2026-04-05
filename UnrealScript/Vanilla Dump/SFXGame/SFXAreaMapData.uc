Class SFXAreaMapData
    config(UI);

var config array<SFXMapAssetData> MapAssetData;
var config array<SFXCharacterMapData> CharacterMapData;
var config array<SFXMapLocationData> MapLocationData;
var delegate<SortLocationMapData> __SortLocationMapData__Delegate;
var(SFXAreaMapData) Vector RefPoint1_Image_Px;
var Vector RefPoint1_Unreal_UU;
var(SFXAreaMapData) Vector RefPoint2_Image_Px;
var Vector RefPoint2_Unreal_UU;
var Vector UUCoorAtPxOrigin;
var int OverrideGroupID;
var float PxPerUU;
var(SFXAreaMapData) SFXAreaMapLayout Floor;

public function array<SFXMapAssetData> GetAssetPaths(SFXAreaMapLayout TargetFloor)
{
    local SFXMapAssetData MapAssetDataIter;
    local int GroupID;
    local array<SFXMapAssetData> ToRet;
    
    if (OverrideGroupID == -1)
    {
        GroupID = -1;
        foreach MapAssetData(MapAssetDataIter, )
        {
            if (int(MapAssetDataIter.Floor) == int(TargetFloor))
            {
                GroupID = MapAssetDataIter.GroupID;
                break;
            }
        }
    }
    else
    {
        GroupID = OverrideGroupID;
    }
    foreach MapAssetData(MapAssetDataIter, )
    {
        if (MapAssetDataIter.GroupID == GroupID)
        {
            ToRet.AddItem(MapAssetDataIter);
        }
    }
    return ToRet;
}
public function array<SFXCharacterMapData> GetCharacterData(SFXAreaMapLayout TargetFloor)
{
    local SFXCharacterMapData CharacterMapDataIter;
    local array<SFXCharacterMapData> ToRet;
    local BioGlobalVariableTable oGV;
    local BioWorldInfo oWI;
    
    oWI = BioWorldInfo(Class'WorldInfo'.static.GetWorldInfo());
    oGV = oWI.GetGlobalVariables();
    ToRet.Length = 0;
    foreach CharacterMapData(CharacterMapDataIter, )
    {
        if (int(CharacterMapDataIter.Floor) != int(TargetFloor))
        {
            continue;
        }
        if (CharacterMapDataIter.nConditional > 0)
        {
            if (!oWI.CheckConditional(CharacterMapDataIter.nConditional, CharacterMapDataIter.nConditionalParam))
            {
                continue;
            }
        }
        else
        {
            if (CharacterMapDataIter.PlotId.nType == SFXPlotType.SFXPlotType_Boolean && int(oGV.GetBool(CharacterMapDataIter.PlotId.nIndex)) != CharacterMapDataIter.nValue)
            {
                continue;
            }
            if (CharacterMapDataIter.PlotId.nType == SFXPlotType.SFXPlotType_Integer && oGV.GetInt(CharacterMapDataIter.PlotId.nIndex) != CharacterMapDataIter.nValue)
            {
                continue;
            }
        }
        if (ToRet.Find('srCharacter', CharacterMapDataIter.srCharacter) != -1)
        {
            continue;
        }
        ToRet.AddItem(CharacterMapDataIter);
    }
    return ToRet;
}
public function array<SFXMapLocationData> GetLocationData(SFXAreaMapLayout TargetFloor)
{
    local SFXMapLocationData MapLocationtDataIter;
    local array<SFXMapLocationData> ToRet;
    
    foreach MapLocationData(MapLocationtDataIter, )
    {
        if (int(MapLocationtDataIter.Floor) == int(TargetFloor))
        {
            ToRet.AddItem(MapLocationtDataIter);
        }
    }
    ToRet.Sort(SortLocationMapData);
    return ToRet;
}
public function GetPixelCoordinates(float UU_X, float UU_Y, out float Px, out float Py)
{
    Py = (UUCoorAtPxOrigin.X - UU_X) * PxPerUU;
    Px = (UU_Y - UUCoorAtPxOrigin.Y) * PxPerUU;
}
public function float GetPxPerUU()
{
    local Vector RefpxToRefpx;
    local Vector RefUToRefU;
    local float DistPx;
    local float DistUU;
    local float Scale;
    
    RefpxToRefpx = RefPoint1_Image_Px - RefPoint2_Image_Px;
    RefUToRefU = RefPoint1_Unreal_UU - RefPoint2_Unreal_UU;
    DistPx = VSize2D(RefpxToRefpx);
    DistUU = VSize2D(RefUToRefU);
    Scale = DistPx / DistUU;
    return Scale;
}
public function GetUUCordAtPxOrigin(out float UU_X, out float UU_Y)
{
    local float ScalePxPerUU;
    local float PxXAsUU;
    local float PxYAsUU;
    
    ScalePxPerUU = GetPxPerUU();
    PxXAsUU = RefPoint1_Image_Px.X / ScalePxPerUU;
    PxYAsUU = RefPoint1_Image_Px.Y / ScalePxPerUU;
    UU_Y = RefPoint1_Unreal_UU.Y - PxXAsUU;
    UU_X = RefPoint1_Unreal_UU.X + PxYAsUU;
}
public function ReCalculate()
{
    local float UUX_AtPxOrg;
    local float UUY_AtPxOrg;
    
    PxPerUU = GetPxPerUU();
    GetUUCordAtPxOrigin(UUX_AtPxOrg, UUY_AtPxOrg);
    UUCoorAtPxOrigin.X = UUX_AtPxOrg;
    UUCoorAtPxOrigin.Y = UUY_AtPxOrg;
    UUCoorAtPxOrigin.Z = 0.0;
}
public delegate function int SortLocationMapData(SFXMapLocationData A, SFXMapLocationData B)
{
    if (A.nIndex > B.nIndex)
    {
        return -1;
    }
    return 0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MapAssetData = ({Asset = "AreaMaps.Citadel.CitHub_Docks", GroupID = 2, Floor = SFXAreaMapLayout.AM_CitDock}, 
                    {Asset = "AreaMaps.Citadel.CitHub_Embassy", GroupID = 2, Floor = SFXAreaMapLayout.AM_CitEmb}, 
                    {Asset = "AreaMaps.Citadel.CitHub_Hospital", GroupID = 2, Floor = SFXAreaMapLayout.AM_CitHosp}, 
                    {Asset = "AreaMaps.Citadel.CitHub_Docks", GroupID = 0, Floor = SFXAreaMapLayout.AM_CitDock}, 
                    {Asset = "AreaMaps.Citadel.CitHub_Embassy", GroupID = 0, Floor = SFXAreaMapLayout.AM_CitEmb}, 
                    {Asset = "AreaMaps.Citadel.CitHub_Hospital", GroupID = 0, Floor = SFXAreaMapLayout.AM_CitHosp}, 
                    {Asset = "AreaMaps.Citadel.CitHub_Purgatory", GroupID = 0, Floor = SFXAreaMapLayout.AM_CitPurg}, 
                    {Asset = "AreaMaps.Citadel.CitHub_Commons", GroupID = 0, Floor = SFXAreaMapLayout.AM_CitCommons}, 
                    {Asset = "AreaMaps.Citadel.CitHub_Camps", GroupID = 0, Floor = SFXAreaMapLayout.AM_CitCamp}, 
                    {Asset = "AreaMaps.Normandy.NorCabin", GroupID = 1, Floor = SFXAreaMapLayout.AM_Biop_nor_1}, 
                    {Asset = "AreaMaps.Normandy.NorCIC", GroupID = 1, Floor = SFXAreaMapLayout.AM_Biop_nor_2}, 
                    {Asset = "AreaMaps.Normandy.NorCrew", GroupID = 1, Floor = SFXAreaMapLayout.AM_Biop_nor_3}, 
                    {Asset = "AreaMaps.Normandy.NorEng", GroupID = 1, Floor = SFXAreaMapLayout.AM_Biop_nor_4}, 
                    {Asset = "AreaMaps.Normandy.NorCargo", GroupID = 1, Floor = SFXAreaMapLayout.AM_Biop_nor_5}
                   )
    CharacterMapData = ({
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $567130, 
                         srLocation = $723571, 
                         nValue = 0, 
                         nConditional = 2480, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitDock
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $687343, 
                         srLocation = $723572, 
                         nValue = 0, 
                         nConditional = 2481, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitDock
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $349386, 
                         srLocation = $723571, 
                         nValue = 0, 
                         nConditional = 2482, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitDock
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $705023, 
                         srLocation = $723571, 
                         nValue = 0, 
                         nConditional = 2483, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitDock
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524656, 
                         srLocation = $362124, 
                         nValue = 0, 
                         nConditional = 2484, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitDock
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $322178, 
                         srLocation = $723572, 
                         nValue = 0, 
                         nConditional = 2582, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitDock
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $384935, 
                         srLocation = $723595, 
                         nValue = 0, 
                         nConditional = 2495, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitPurg
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $705020, 
                         srLocation = $723596, 
                         nValue = 0, 
                         nConditional = 2496, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitPurg
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524653, 
                         srLocation = $723596, 
                         nValue = 0, 
                         nConditional = 2497, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitPurg
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $705036, 
                         srLocation = $723593, 
                         nValue = 0, 
                         nConditional = 2498, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitPurg
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $705022, 
                         srLocation = $723593, 
                         nValue = 0, 
                         nConditional = 2499, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitPurg
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $705026, 
                         srLocation = $723594, 
                         nValue = 0, 
                         nConditional = 2500, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitPurg
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $349395, 
                         srLocation = $723594, 
                         nValue = 0, 
                         nConditional = 2501, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitPurg
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524657, 
                         srLocation = $723596, 
                         nValue = 0, 
                         nConditional = 2502, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitPurg
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $238360, 
                         srLocation = $723596, 
                         nValue = 0, 
                         nConditional = 2503, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitPurg
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $567130, 
                         srLocation = $723596, 
                         nValue = 0, 
                         nConditional = 2504, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitPurg
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $288752, 
                         srLocation = $723573, 
                         nValue = 0, 
                         nConditional = 2507, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitHosp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $569511, 
                         srLocation = $723573, 
                         nValue = 0, 
                         nConditional = 2508, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitHosp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524658, 
                         srLocation = $723575, 
                         nValue = 0, 
                         nConditional = 2509, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitHosp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524659, 
                         srLocation = $723575, 
                         nValue = 0, 
                         nConditional = 2510, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitHosp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $650796, 
                         srLocation = $723576, 
                         nValue = 0, 
                         nConditional = 2511, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitHosp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $705031, 
                         srLocation = $723573, 
                         nValue = 0, 
                         nConditional = 2512, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitHosp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $704195, 
                         srLocation = $723574, 
                         nValue = 0, 
                         nConditional = 2513, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitHosp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $349396, 
                         srLocation = $723573, 
                         nValue = 0, 
                         nConditional = 2514, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitHosp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $349391, 
                         srLocation = $723573, 
                         nValue = 0, 
                         nConditional = 2515, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitHosp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $705029, 
                         srLocation = $723573, 
                         nValue = 0, 
                         nConditional = 2516, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitHosp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $552723, 
                         srLocation = $723576, 
                         nValue = 0, 
                         nConditional = 2517, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitHosp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $705034, 
                         srLocation = $723574, 
                         nValue = 0, 
                         nConditional = 2518, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitHosp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $349396, 
                         srLocation = $723575, 
                         nValue = 0, 
                         nConditional = 2519, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitHosp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $322178, 
                         srLocation = $723574, 
                         nValue = 0, 
                         nConditional = 2581, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitHosp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $218732, 
                         srLocation = $723582, 
                         nValue = 0, 
                         nConditional = 2520, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitEmb
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $290612, 
                         srLocation = $723580, 
                         nValue = 0, 
                         nConditional = 2521, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitEmb
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $705027, 
                         srLocation = $723580, 
                         nValue = 0, 
                         nConditional = 2522, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitEmb
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524653, 
                         srLocation = $723580, 
                         nValue = 0, 
                         nConditional = 2523, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitEmb
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $651286, 
                         srLocation = $723580, 
                         nValue = 0, 
                         nConditional = 2524, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitEmb
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $208210, 
                         srLocation = $723579, 
                         nValue = 0, 
                         nConditional = 2525, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitEmb
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $334752, 
                         srLocation = $723580, 
                         nValue = 0, 
                         nConditional = 2526, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitEmb
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $349390, 
                         srLocation = $723580, 
                         nValue = 0, 
                         nConditional = 2527, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitEmb
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $705032, 
                         srLocation = $723580, 
                         nValue = 0, 
                         nConditional = 2528, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitEmb
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $704194, 
                         srLocation = $723580, 
                         nValue = 0, 
                         nConditional = 2529, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitEmb
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $349386, 
                         srLocation = $723578, 
                         nValue = 0, 
                         nConditional = 2530, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitEmb
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $694517, 
                         srLocation = $723580, 
                         nValue = 0, 
                         nConditional = 2570, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitEmb
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $694517, 
                         srLocation = $723581, 
                         nValue = 0, 
                         nConditional = 2571, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitEmb
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $712154, 
                         srLocation = $723578, 
                         nValue = 0, 
                         nConditional = 2572, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitEmb
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $712154, 
                         srLocation = $723578, 
                         nValue = 0, 
                         nConditional = 2580, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitEmb
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $712154, 
                         srLocation = $723578, 
                         nValue = 0, 
                         nConditional = 2586, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitEmb
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $695833, 
                         srLocation = $723581, 
                         nValue = 0, 
                         nConditional = 2587, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitEmb
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $619726, 
                         srLocation = $723580, 
                         nValue = 0, 
                         nConditional = 2666, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitEmb
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $311579, 
                         srLocation = $723579, 
                         nValue = 0, 
                         nConditional = 2702, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitEmb
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $663450, 
                         srLocation = $723583, 
                         nValue = 0, 
                         nConditional = 2532, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCamp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $663712, 
                         srLocation = $723583, 
                         nValue = 0, 
                         nConditional = 2533, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCamp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $664292, 
                         srLocation = $723584, 
                         nValue = 0, 
                         nConditional = 2534, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCamp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $705028, 
                         srLocation = $723585, 
                         nValue = 0, 
                         nConditional = 2535, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCamp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $218996, 
                         srLocation = $723584, 
                         nValue = 0, 
                         nConditional = 2536, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCamp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $567130, 
                         srLocation = $723586, 
                         nValue = 0, 
                         nConditional = 2537, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCamp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524656, 
                         srLocation = $723583, 
                         nValue = 0, 
                         nConditional = 2538, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCamp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524658, 
                         srLocation = $723586, 
                         nValue = 0, 
                         nConditional = 2539, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCamp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $345662, 
                         srLocation = $712544, 
                         nValue = 0, 
                         nConditional = 2540, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCamp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524653, 
                         srLocation = $723585, 
                         nValue = 0, 
                         nConditional = 2541, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCamp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524653, 
                         srLocation = $712546, 
                         nValue = 0, 
                         nConditional = 2542, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCamp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $705048, 
                         srLocation = $712546, 
                         nValue = 0, 
                         nConditional = 2543, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCamp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $306237, 
                         srLocation = $723585, 
                         nValue = 0, 
                         nConditional = 2544, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCamp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $322178, 
                         srLocation = $712546, 
                         nValue = 0, 
                         nConditional = 2584, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCamp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $702190, 
                         srLocation = $723584, 
                         nValue = 0, 
                         nConditional = 2585, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCamp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $691946, 
                         srLocation = $723585, 
                         nValue = 0, 
                         nConditional = 2589, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCamp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $670960, 
                         srLocation = $362124, 
                         nValue = 0, 
                         nConditional = 2590, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCamp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $619726, 
                         srLocation = $362124, 
                         nValue = 0, 
                         nConditional = 2667, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCamp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $619726, 
                         srLocation = $712546, 
                         nValue = 0, 
                         nConditional = 2668, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCamp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $619726, 
                         srLocation = $362124, 
                         nValue = 0, 
                         nConditional = 2669, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCamp
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $663454, 
                         srLocation = $723589, 
                         nValue = 0, 
                         nConditional = 2545, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCommons
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $705021, 
                         srLocation = $723587, 
                         nValue = 0, 
                         nConditional = 2546, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCommons
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $705033, 
                         srLocation = $723589, 
                         nValue = 0, 
                         nConditional = 2547, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCommons
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524657, 
                         srLocation = $712558, 
                         nValue = 0, 
                         nConditional = 2548, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCommons
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $238360, 
                         srLocation = $712558, 
                         nValue = 0, 
                         nConditional = 2549, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCommons
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524658, 
                         srLocation = $723590, 
                         nValue = 0, 
                         nConditional = 2551, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCommons
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524659, 
                         srLocation = $723590, 
                         nValue = 0, 
                         nConditional = 2552, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCommons
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524654, 
                         srLocation = $723590, 
                         nValue = 0, 
                         nConditional = 2561, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCommons
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524654, 
                         srLocation = $712558, 
                         nValue = 0, 
                         nConditional = 2553, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCommons
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $705024, 
                         srLocation = $340226, 
                         nValue = 0, 
                         nConditional = 2554, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCommons
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $705025, 
                         srLocation = $723589, 
                         nValue = 0, 
                         nConditional = 2555, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCommons
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $705030, 
                         srLocation = $723587, 
                         nValue = 0, 
                         nConditional = 2556, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCommons
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $704417, 
                         srLocation = $723590, 
                         nValue = 0, 
                         nConditional = 2557, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCommons
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $704417, 
                         srLocation = $723589, 
                         nValue = 0, 
                         nConditional = 2558, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCommons
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $690463, 
                         srLocation = $723591, 
                         nValue = 0, 
                         nConditional = 2559, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCommons
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524660, 
                         srLocation = $723589, 
                         nValue = 0, 
                         nConditional = 2560, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCommons
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $649163, 
                         srLocation = $723587, 
                         nValue = 0, 
                         nConditional = 2569, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCommons
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $663139, 
                         srLocation = $340226, 
                         nValue = 0, 
                         nConditional = 2575, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCommons
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $663456, 
                         srLocation = $712558, 
                         nValue = 0, 
                         nConditional = 2576, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCommons
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $663710, 
                         srLocation = $723591, 
                         nValue = 0, 
                         nConditional = 2577, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCommons
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $619637, 
                         srLocation = $723591, 
                         nValue = 0, 
                         nConditional = 2579, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCommons
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $695681, 
                         srLocation = $340226, 
                         nValue = 0, 
                         nConditional = 2588, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCommons
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $349386, 
                         srLocation = $340226, 
                         nValue = 0, 
                         nConditional = 2673, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_CitCommons
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524654, 
                         srLocation = $724053, 
                         nValue = 0, 
                         nConditional = 2041, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524654, 
                         srLocation = $712563, 
                         nValue = 0, 
                         nConditional = 2042, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524654, 
                         srLocation = $346145, 
                         nValue = 0, 
                         nConditional = 1825, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_4
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524653, 
                         srLocation = $346124, 
                         nValue = 0, 
                         nConditional = 915, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_5
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524653, 
                         srLocation = $342746, 
                         nValue = 0, 
                         nConditional = 2209, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524653, 
                         srLocation = $712563, 
                         nValue = 0, 
                         nConditional = 2210, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524657, 
                         srLocation = $724945, 
                         nValue = 0, 
                         nConditional = 2565, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_2
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524657, 
                         srLocation = $346139, 
                         nValue = 0, 
                         nConditional = 2566, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524656, 
                         srLocation = $346138, 
                         nValue = 0, 
                         nConditional = 2048, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524656, 
                         srLocation = $712563, 
                         nValue = 0, 
                         nConditional = 2050, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524656, 
                         srLocation = $342746, 
                         nValue = 0, 
                         nConditional = 2281, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524656, 
                         srLocation = $342746, 
                         nValue = 0, 
                         nConditional = 2567, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524656, 
                         srLocation = $724945, 
                         nValue = 0, 
                         nConditional = 2573, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_2
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524660, 
                         srLocation = $712561, 
                         nValue = 0, 
                         nConditional = 2578, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_2
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524660, 
                         srLocation = $346138, 
                         nValue = 0, 
                         nConditional = 2223, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524660, 
                         srLocation = $342746, 
                         nValue = 0, 
                         nConditional = 2224, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524660, 
                         srLocation = $712563, 
                         nValue = 0, 
                         nConditional = 2568, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524660, 
                         srLocation = $249012, 
                         nValue = 0, 
                         nConditional = 848, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_4
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524658, 
                         srLocation = $346132, 
                         nValue = 0, 
                         nConditional = 2132, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524658, 
                         srLocation = $342746, 
                         nValue = 0, 
                         nConditional = 2133, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524659, 
                         srLocation = $346132, 
                         nValue = 0, 
                         nConditional = 2150, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524659, 
                         srLocation = $712563, 
                         nValue = 0, 
                         nConditional = 2151, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524659, 
                         srLocation = $346133, 
                         nValue = 0, 
                         nConditional = 2167, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524659, 
                         srLocation = $249012, 
                         nValue = 0, 
                         nConditional = 2152, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_4
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524655, 
                         srLocation = $346145, 
                         nValue = 0, 
                         nConditional = 2170, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_4
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524655, 
                         srLocation = $346142, 
                         nValue = 0, 
                         nConditional = 2171, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_4
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524655, 
                         srLocation = $342746, 
                         nValue = 0, 
                         nConditional = 2172, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524655, 
                         srLocation = $346139, 
                         nValue = 0, 
                         nConditional = 2173, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $524655, 
                         srLocation = $712563, 
                         nValue = 0, 
                         nConditional = 2244, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $569495, 
                         srLocation = $346127, 
                         nValue = 0, 
                         nConditional = 13, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_2
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $687343, 
                         srLocation = $346147, 
                         nValue = 0, 
                         nConditional = 1442, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_4
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $662475, 
                         srLocation = $346124, 
                         nValue = 0, 
                         nConditional = 13, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_5
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $569510, 
                         srLocation = $346140, 
                         nValue = 0, 
                         nConditional = 422, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $569510, 
                         srLocation = $249012, 
                         nValue = 0, 
                         nConditional = 2597, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_4
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $569510, 
                         srLocation = $346133, 
                         nValue = 0, 
                         nConditional = 2227, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $569510, 
                         srLocation = $342746, 
                         nValue = 0, 
                         nConditional = 2243, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $288752, 
                         srLocation = $346140, 
                         nValue = 0, 
                         nConditional = 2592, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $288752, 
                         srLocation = $346133, 
                         nValue = 0, 
                         nConditional = 2591, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $288752, 
                         srLocation = $342746, 
                         nValue = 0, 
                         nConditional = 2593, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $569511, 
                         srLocation = $346140, 
                         nValue = 0, 
                         nConditional = 2596, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $569511, 
                         srLocation = $346133, 
                         nValue = 0, 
                         nConditional = 2594, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $569511, 
                         srLocation = $342746, 
                         nValue = 0, 
                         nConditional = 2595, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $306049, 
                         srLocation = $249012, 
                         nValue = 0, 
                         nConditional = 2598, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_4
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $306049, 
                         srLocation = $346142, 
                         nValue = 0, 
                         nConditional = 1445, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_4
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $306051, 
                         srLocation = $249012, 
                         nValue = 0, 
                         nConditional = 2599, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_4
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $306051, 
                         srLocation = $346142, 
                         nValue = 0, 
                         nConditional = 1445, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_4
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $214249, 
                         srLocation = $712561, 
                         nValue = 0, 
                         nConditional = 2601, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_2
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $214250, 
                         srLocation = $712561, 
                         nValue = 0, 
                         nConditional = 2602, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_2
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $523092, 
                         srLocation = $712561, 
                         nValue = 0, 
                         nConditional = 2603, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_2
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $523357, 
                         srLocation = $712561, 
                         nValue = 0, 
                         nConditional = 2607, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_2
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $179427, 
                         srLocation = $712561, 
                         nValue = 0, 
                         nConditional = 2608, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_2
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $674180, 
                         srLocation = $712561, 
                         nValue = 0, 
                         nConditional = 2609, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_2
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $349388, 
                         srLocation = $346140, 
                         nValue = 0, 
                         nConditional = 2604, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $516840, 
                         srLocation = $346140, 
                         nValue = 0, 
                         nConditional = 2605, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $525179, 
                         srLocation = $346140, 
                         nValue = 0, 
                         nConditional = 419, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_3
                        }, 
                        {
                         PlotId = {nIndex = 0, nType = SFXPlotType.SFXPlotType_Float}, 
                         srCharacter = $238360, 
                         srLocation = $724945, 
                         nValue = 0, 
                         nConditional = 13, 
                         nConditionalParam = 0, 
                         Floor = SFXAreaMapLayout.AM_Biop_nor_2
                        }
                       )
    MapLocationData = ({srLocation = $330712, nIndex = 1, Floor = SFXAreaMapLayout.AM_CitDock}, 
                       {srLocation = $723572, nIndex = 2, Floor = SFXAreaMapLayout.AM_CitDock}, 
                       {srLocation = $723571, nIndex = 3, Floor = SFXAreaMapLayout.AM_CitDock}, 
                       {srLocation = $362124, nIndex = 4, Floor = SFXAreaMapLayout.AM_CitDock}, 
                       {srLocation = $723593, nIndex = 1, Floor = SFXAreaMapLayout.AM_CitPurg}, 
                       {srLocation = $723595, nIndex = 2, Floor = SFXAreaMapLayout.AM_CitPurg}, 
                       {srLocation = $723596, nIndex = 3, Floor = SFXAreaMapLayout.AM_CitPurg}, 
                       {srLocation = $723598, nIndex = 4, Floor = SFXAreaMapLayout.AM_CitPurg}, 
                       {srLocation = $723573, nIndex = 1, Floor = SFXAreaMapLayout.AM_CitHosp}, 
                       {srLocation = $723574, nIndex = 2, Floor = SFXAreaMapLayout.AM_CitHosp}, 
                       {srLocation = $723575, nIndex = 3, Floor = SFXAreaMapLayout.AM_CitHosp}, 
                       {srLocation = $723576, nIndex = 4, Floor = SFXAreaMapLayout.AM_CitHosp}, 
                       {srLocation = $723582, nIndex = 1, Floor = SFXAreaMapLayout.AM_CitEmb}, 
                       {srLocation = $723579, nIndex = 2, Floor = SFXAreaMapLayout.AM_CitEmb}, 
                       {srLocation = $723578, nIndex = 3, Floor = SFXAreaMapLayout.AM_CitEmb}, 
                       {srLocation = $723580, nIndex = 4, Floor = SFXAreaMapLayout.AM_CitEmb}, 
                       {srLocation = $723581, nIndex = 5, Floor = SFXAreaMapLayout.AM_CitEmb}, 
                       {srLocation = $362124, nIndex = 1, Floor = SFXAreaMapLayout.AM_CitCamp}, 
                       {srLocation = $712544, nIndex = 2, Floor = SFXAreaMapLayout.AM_CitCamp}, 
                       {srLocation = $712545, nIndex = 3, Floor = SFXAreaMapLayout.AM_CitCamp}, 
                       {srLocation = $712546, nIndex = 4, Floor = SFXAreaMapLayout.AM_CitCamp}, 
                       {srLocation = $723583, nIndex = 5, Floor = SFXAreaMapLayout.AM_CitCamp}, 
                       {srLocation = $723584, nIndex = 6, Floor = SFXAreaMapLayout.AM_CitCamp}, 
                       {srLocation = $723585, nIndex = 7, Floor = SFXAreaMapLayout.AM_CitCamp}, 
                       {srLocation = $723586, nIndex = 8, Floor = SFXAreaMapLayout.AM_CitCamp}, 
                       {srLocation = $723587, nIndex = 1, Floor = SFXAreaMapLayout.AM_CitCommons}, 
                       {srLocation = $340226, nIndex = 2, Floor = SFXAreaMapLayout.AM_CitCommons}, 
                       {srLocation = $723590, nIndex = 3, Floor = SFXAreaMapLayout.AM_CitCommons}, 
                       {srLocation = $723589, nIndex = 4, Floor = SFXAreaMapLayout.AM_CitCommons}, 
                       {srLocation = $723591, nIndex = 5, Floor = SFXAreaMapLayout.AM_CitCommons}, 
                       {srLocation = $712558, nIndex = 6, Floor = SFXAreaMapLayout.AM_CitCommons}, 
                       {srLocation = $346126, nIndex = 1, Floor = SFXAreaMapLayout.AM_Biop_nor_1}, 
                       {srLocation = $346115, nIndex = 2, Floor = SFXAreaMapLayout.AM_Biop_nor_1}, 
                       {srLocation = $346116, nIndex = 3, Floor = SFXAreaMapLayout.AM_Biop_nor_1}, 
                       {srLocation = $724945, nIndex = 1, Floor = SFXAreaMapLayout.AM_Biop_nor_2}, 
                       {srLocation = $346127, nIndex = 2, Floor = SFXAreaMapLayout.AM_Biop_nor_2}, 
                       {srLocation = $712561, nIndex = 3, Floor = SFXAreaMapLayout.AM_Biop_nor_2}, 
                       {srLocation = $724052, nIndex = 4, Floor = SFXAreaMapLayout.AM_Biop_nor_2}, 
                       {srLocation = $724053, nIndex = 1, Floor = SFXAreaMapLayout.AM_Biop_nor_3}, 
                       {srLocation = $346138, nIndex = 2, Floor = SFXAreaMapLayout.AM_Biop_nor_3}, 
                       {srLocation = $346139, nIndex = 3, Floor = SFXAreaMapLayout.AM_Biop_nor_3}, 
                       {srLocation = $346140, nIndex = 4, Floor = SFXAreaMapLayout.AM_Biop_nor_3}, 
                       {srLocation = $342746, nIndex = 5, Floor = SFXAreaMapLayout.AM_Biop_nor_3}, 
                       {srLocation = $346132, nIndex = 6, Floor = SFXAreaMapLayout.AM_Biop_nor_3}, 
                       {srLocation = $712563, nIndex = 7, Floor = SFXAreaMapLayout.AM_Biop_nor_3}, 
                       {srLocation = $346133, nIndex = 8, Floor = SFXAreaMapLayout.AM_Biop_nor_3}, 
                       {srLocation = $249012, nIndex = 1, Floor = SFXAreaMapLayout.AM_Biop_nor_4}, 
                       {srLocation = $346142, nIndex = 2, Floor = SFXAreaMapLayout.AM_Biop_nor_4}, 
                       {srLocation = $346147, nIndex = 3, Floor = SFXAreaMapLayout.AM_Biop_nor_4}, 
                       {srLocation = $346145, nIndex = 4, Floor = SFXAreaMapLayout.AM_Biop_nor_4}, 
                       {srLocation = $346124, nIndex = 1, Floor = SFXAreaMapLayout.AM_Biop_nor_5}
                      )
}