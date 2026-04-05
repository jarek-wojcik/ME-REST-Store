Class UIComp_ListPresenter extends UIComp_ListPresenterBase within UIList
    implements(CustomPropertyItemHandler)
    native
    editinlinenew;

struct native UIElementCellSchema 
{
    var(UIElementCellSchema) array<UIListElementCellTemplate> Cells;
};
struct native UIListItem 
{
    var(UIListItem) editconst editfixedsize array<UIListElementCell> Cells;
    var const UIListItemDataBinding DataSource;
    var(UIListItem) editconst UIObject ElementWidget;
    var(UIListItem) editconst transient noimport EUIListElementState ElementState;
};
struct native UIListElementCellTemplate extends UIListElementCell 
{
    var(UIListElementCellTemplate) string ColumnHeaderText;
    var(UIListElementCellTemplate) Name CellDataField;
    var(UIListElementCellTemplate) UIScreenValue_Extent CellSize;
    var float CellPosition;
    
    structdefaultproperties
    {
        CellStyle[0] = {RequiredStyleClass = None}
        CellStyle[1] = {RequiredStyleClass = None}
        CellStyle[2] = {RequiredStyleClass = None}
        CellStyle[3] = {RequiredStyleClass = None}
    }
};
struct native UIListElementCell 
{
    var UIStyleReference CellStyle[4];
    var const transient native int ContainerElementIndex;
    var const transient UIList OwnerList;
    var transient noexport Object ValueObject;
    
    structdefaultproperties
    {
        CellStyle[0] = {
                        RequiredStyleClass = Class'UIStyle_Combo', 
                        AssignedStyleID = {A = 0, B = 0, C = 0, D = 0}, 
                        DefaultStyleTag = 'None', 
                        ResolvedStyle = None
                       }
        CellStyle[1] = {
                        RequiredStyleClass = Class'UIStyle_Combo', 
                        AssignedStyleID = {A = 0, B = 0, C = 0, D = 0}, 
                        DefaultStyleTag = 'None', 
                        ResolvedStyle = None
                       }
        CellStyle[2] = {
                        RequiredStyleClass = Class'UIStyle_Combo', 
                        AssignedStyleID = {A = 0, B = 0, C = 0, D = 0}, 
                        DefaultStyleTag = 'None', 
                        ResolvedStyle = None
                       }
        CellStyle[3] = {
                        RequiredStyleClass = Class'UIStyle_Combo', 
                        AssignedStyleID = {A = 0, B = 0, C = 0, D = 0}, 
                        DefaultStyleTag = 'None', 
                        ResolvedStyle = None
                       }
    }
};

var const native noexport Pointer VfTable_ICustomPropertyItemHandler;
var(Data) const UIElementCellSchema ElementSchema;
var(Data) editconst transient noimport init array<UIListItem> ListItems;
var(Style) TextureCoordinates ListItemOverlayCoordinates[4];
var(Style) TextureCoordinates ColumnHeaderBackgroundCoordinates[3];
var(Style) export editinlineuse UITexture ListItemOverlay[4];
var(Style) export editinlineuse UITexture ColumnHeaderBackground[3];
var(Appearance) UIScreenValue_Extent SelectionHintPadding;
var(Appearance) int MaxElementsPerPage;
var(Appearance) bool bDisplayColumnHeaders;

public final native function int FindElementIndex(int DataSourceIndex);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=UITexture Name=NormalOverlayTemplate
    End Object
    Begin Object Class=UITexture Name=ActiveOverlayTemplate
    End Object
    Begin Object Class=UITexture Name=SelectionOverlayTemplate
    End Object
    Begin Object Class=UITexture Name=HoverOverlayTemplate
    End Object
    ListItemOverlay[0] = NormalOverlayTemplate
    ListItemOverlay[1] = ActiveOverlayTemplate
    ListItemOverlay[2] = SelectionOverlayTemplate
    ListItemOverlay[3] = HoverOverlayTemplate
    bDisplayColumnHeaders = TRUE
}