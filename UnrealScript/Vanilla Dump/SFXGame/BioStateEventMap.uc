Class BioStateEventMap
    native;

enum EPlotElementTypes
{
    BIO_SE_ELEMENT_TYPE_INT,
    BIO_SE_ELEMENT_TYPE_FLOAT,
    BIO_SE_ELEMENT_TYPE_BOOL,
    BIO_SE_ELEMENT_TYPE_FUNCTION,
    BIO_SE_ELEMENT_TYPE_LOCAL_INT,
    BIO_SE_ELEMENT_TYPE_LOCAL_FLOAT,
    BIO_SE_ELEMENT_TYPE_LOCAL_BOOL,
    BIO_SE_ELEMENT_TYPE_SUBSTATE,
    BIO_SE_ELEMENT_TYPE_CONSEQUENCE,
};

var const native Map_Mirror StateEventMap;
var array<int> GalaxyAtWarBoolVarIDs;
var array<int> GalaxyAtWarIntVarIDs;
var array<int> GalaxyAtWarFloatVarIDs;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}