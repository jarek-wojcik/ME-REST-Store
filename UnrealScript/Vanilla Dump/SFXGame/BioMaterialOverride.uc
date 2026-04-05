Class BioMaterialOverride
    native;

struct native ScalarParameter 
{
    var Name nName;
    var float sValue;
};
struct native ColorParameter 
{
    var LinearColor cValue;
    var Name nName;
};
struct native TextureParameter 
{
    var Name nName;
    var Texture m_pTexture;
};

var(BioMaterialOverride) array<TextureParameter> m_aTextureOverrides;
var(BioMaterialOverride) array<ColorParameter> m_aColorOverrides;
var(BioMaterialOverride) array<ScalarParameter> m_aScalarOverrides;

public final native function Apply(MeshComponent InComponent);

public final native function Unapply(MeshComponent InComponent);

public final function ApplyOverride(Actor InTarget)
{
    local MeshComponent CurComponent;
    
    foreach InTarget.ComponentList(Class'MeshComponent', CurComponent)
    {
        Apply(CurComponent);
    }
}
public final function UnapplyOverride(Actor InTarget)
{
    local MeshComponent CurComponent;
    
    foreach InTarget.ComponentList(Class'MeshComponent', CurComponent)
    {
        Unapply(CurComponent);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}