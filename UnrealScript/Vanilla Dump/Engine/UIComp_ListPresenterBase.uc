Class UIComp_ListPresenterBase extends UIComp_ListComponentBase within UIList
    native
    editinlinenew
    abstract;

struct native UIListItemDataBinding 
{
    var UIListElementCellProvider DataSourceProvider;
    var Name DataSourceTag;
    var int DataSourceIndex;
};

var transient bool bReapplyFormatting;

public final native function CalculateAutoSizeColumnWidth(int ColIndex, out float out_ColWidth, out float out_StylePadding, optional bool bReturnUnformattedValue);

public final native function CalculateAutoSizeRowHeight(int RowIndex, out float out_RowHeight, out float out_StylePadding, optional bool bReturnUnformattedValue);

public final native function EnableColumnHeaderRendering(optional bool bShouldRenderColHeaders = TRUE);

public final native function UIListElementCellProvider GetCellSchemaProvider();

public final native function string GetElementValue(int ElementIndex, optional int CellIndex = -1);

public final native function int GetMaxElementsPerPage();

public final native function int GetSchemaCellCount();

public final native function float GetSchemaCellPosition(int SchemaCellIndex);

public final native function float GetSchemaCellSize(int SchemaCellIndex, optional EUIExtentEvalType EvalType = 0);

public final native function SetMaxElementsPerPage(int NewMaxVisibleElements);

public final native function bool SetSchemaCellSize(int SchemaCellIndex, float NewCellSize, optional EUIExtentEvalType EvalType = 0);

public final native function bool ShouldAdjustListBounds(EUIOrientation Orientation);

public final native function bool ShouldRenderColumnHeaders();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bReapplyFormatting = TRUE
}