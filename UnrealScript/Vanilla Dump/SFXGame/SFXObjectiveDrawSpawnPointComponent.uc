Class SFXObjectiveDrawSpawnPointComponent extends PrimitiveComponent
    native
    config(Editor)
    collapsecategories;

struct native SFXObjectiveSpawnLocationSize 
{
    var Vector Extents;
    var EObjectiveLocation Type;
};

var config array<SFXObjectiveSpawnLocationSize> SpawnLocationExtents;
var LinearColor LineColor;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SpawnLocationExtents = ({
                             Extents = {X = 200.0, Y = 200.0, Z = 200.0}, 
                             Type = EObjectiveLocation.EObjectiveLocation_Floor
                            }, 
                            {
                             Extents = {X = 100.0, Y = 100.0, Z = 50.0}, 
                             Type = EObjectiveLocation.EObjectiveLocation_Table
                            }
                           )
    LineColor = {R = 0.0, G = 200.0, B = 200.0, A = 1.0}
    ReplacementPrimitive = None
    HiddenGame = TRUE
    AlwaysLoadOnClient = FALSE
    AlwaysLoadOnServer = FALSE
}