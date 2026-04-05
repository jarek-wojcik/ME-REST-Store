Class TextureRenderTarget extends Texture
    native
    abstract;

var transient bool bUpdateImmediate;
var(TextureRenderTarget) bool bNeedsTwoCopies;
var(TextureRenderTarget) bool bRenderOnce;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bNeedsTwoCopies = TRUE
    CompressionNone = TRUE
    NeverStream = TRUE
    LODGroup = TextureGroup.TEXTUREGROUP_RenderTarget
}