Class ScriptedTexture extends TextureRenderTarget2D
    native;

var delegate<Render> __Render__Delegate;
var transient bool bNeedsUpdate;
var transient bool bSkipNextClear;

public delegate function Render(Canvas C);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bNeedsUpdate = TRUE
    bNeedsTwoCopies = FALSE
}