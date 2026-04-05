Class ShadowMapTexture2D extends Texture2D
    native
    noexport
    config(Engine);

var int ShadowmapFlags;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LODGroup = TextureGroup.TEXTUREGROUP_Shadowmap
}