Class BioPlotTreasure
    native;

var Bio2DA oPlotTreasureResources2DA;
var Bio2DA oPlotTreasureTreasure2DA;
var Bio2DA oPlotTreasureTech2DA;

public native function bool GetMapName(out string sOutMapName);

public native function bool GetPlotTreasureResourcesInt(Name nmLevel, Name nmHeader, out int nPlotTreasureValue);

public native function bool GetPlotTreasureTechInt(Name nmTech, Name nmNameHeader, Name nmHeader, out int nTechValue);

public native function bool GetPlotTreasureTechName(Name nmTech, Name nmHeader, out Name nmTechName);

public native function bool GetPlotTreasureTreasureInt(int nTreasureId, Name nmHeader, out int nPlotTreasureValue);

public native function bool GetPlotTreasureTreasureName(int nTreasureId, Name nmHeader, out Name nmPlotTreasureName);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    oPlotTreasureResources2DA = Bio2DA'BIOG_2DA_PlotManager_X.Plot_Treasure_Resources'
    oPlotTreasureTreasure2DA = Bio2DANumberedRows'BIOG_2DA_PlotManager_X.Plot_Treasure_Treasure'
    oPlotTreasureTech2DA = Bio2DANumberedRows'BIOG_2DA_PlotManager_X.Plot_Treasure_Tech'
}