Class SFXSceneShopNodePlotCheck extends SFXSceneShopNode
    native;

struct native SFXSSPlotValue 
{
    var(SFXSSPlotValue) string sPinName;
    var(SFXSSPlotValue) float fValue;
};
enum ESFXSSPlotVarType
{
    PlotVar_Unset,
    PlotVar_State,
    PlotVar_Int,
    PlotVar_Float,
};

var(SFXSceneShopNodePlotCheck) array<SFXSSPlotValue> m_aValuesToCheck;
var int m_nIndex;
var(SFXSceneShopNodePlotCheck) EBioRegionAutoSet Region;
var(SFXSceneShopNodePlotCheck) EBioPlotAutoSet Plot;
var(SFXSceneShopNodePlotCheck) ESFXSSPlotVarType VarType;
var(SFXSceneShopNodePlotCheck) EBioAutoSet Variable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_nIndex = -1
    m_aInputPins = ({
                     sLinkName = "In", 
                     aLinks = ()
                    }
                   )
}