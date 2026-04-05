Class WindDirectionalSourceComponent extends ActorComponent
    native
    editinlinenew
    collapsecategories;

var const transient native noimport Pointer SceneProxy;
var(WindDirectionalSourceComponent) interp float Strength;
var(WindDirectionalSourceComponent) interp float Phase;
var(WindDirectionalSourceComponent) interp float Frequency;
var(WindDirectionalSourceComponent) interp float Speed;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Strength = 1.0
    Frequency = 1.0
    Speed = 1.0
}