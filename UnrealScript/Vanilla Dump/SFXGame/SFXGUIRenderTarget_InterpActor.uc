Class SFXGUIRenderTarget_InterpActor extends InterpActor
    native
    placeable;

enum MouseSupportLevel
{
    Mouse_None,
    Mouse_Click,
    Mouse_ClickAndMove,
};

var(SFXGUIRenderTarget_InterpActor) int RenderTextureUVChannel;
var(SFXGUIRenderTarget_InterpActor) MouseSupportLevel MouseSupport;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
    End Template
    Begin Template Class=StaticMeshComponent Name=StaticMeshComponent0
        ReplacementPrimitive = None
        LightEnvironment = MyLightEnvironment
    End Template
    StaticMeshComponent = StaticMeshComponent0
    LightEnvironment = MyLightEnvironment
    Components = (MyLightEnvironment, StaticMeshComponent0, None)
    CollisionComponent = StaticMeshComponent0
}