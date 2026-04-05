Class Brush extends Actor
    native;

struct native export GeomSelection 
{
    var int Type;
    var int Index;
    var int SelectionIndex;
};
enum ECsgOper
{
    CSG_Active,
    CSG_Add,
    CSG_Subtract,
    CSG_Intersect,
    CSG_Deintersect,
};

var(Brush) Color BrushColor;
var int PolyFlags;
var const export Model Brush;
var const editinline editconst export BrushComponent BrushComponent;
var(Brush) bool bColored;
var bool bSolidWhenSelected;
var bool bPlaceableFromClassBrowser;
var(Brush) ECsgOper CsgOper;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
    End Object
    BrushComponent = BrushComponent0
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
    bStatic = TRUE
    bHidden = TRUE
    bNoDelete = TRUE
    bEdShouldSnap = TRUE
}