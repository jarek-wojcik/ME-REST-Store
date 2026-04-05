Class GFxEngine
    native;

struct native GCReference 
{
    var const Object m_object;
    var int m_count;
    var int m_statid;
};

var transient array<GCReference> GCReferences;
var transient int RefCount;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    RefCount = 1
}