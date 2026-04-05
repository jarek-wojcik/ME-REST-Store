Class ActorComponent extends Component
    native
    noexport
    abstract;

enum EComponentType
{
    COMPONENT_Unknown,
    COMPONENT_Animation,
    COMPONENT_AI,
    COMPONENT_Gameplay,
    COMPONENT_Graphics,
    COMPONENT_Particles,
    COMPONENT_StaticMesh,
    COMPONENT_SkinMesh,
    COMPONENT_Lights,
    COMPONENT_Audio,
    COMPONENT_Physics,
    COMPONENT_Engine,
};

var const transient native Pointer Scene;
var const transient Actor Owner;
var const transient native bool bAttached;
var const bool bTickInEditor;
var const transient bool bNeedsReattach;
var const transient bool bNeedsUpdateTransform;
var const ETickingGroup TickGroup;
var const EComponentType ComponentType;

public final native function DetachFromAny();

public final native function ForceUpdate(bool bTransformOnly);

public final native function SetComponentRBFixed(bool bFixed);

public final native function SetTickGroup(ETickingGroup NewTickGroup);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}