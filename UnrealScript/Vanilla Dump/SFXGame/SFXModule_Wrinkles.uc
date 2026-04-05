Class SFXModule_Wrinkles extends SFXModule
    native
    config(Game);

struct native BioWrinkleConfig 
{
    var(BioWrinkleConfig) string WrinkleParameterName;
    var(BioWrinkleConfig) Texture2D WrinkleTexture;
};

var config string m_sWrinkleMaterialIdentifier;
var(SFXModule_Wrinkles) array<BioWrinkleConfig> TextureOverrides;
var config int m_nWrinkleHighestLOD;
var(SFXModule_Wrinkles) bool bUseWrinkles;

public simulated function Tick(float DeltaTime)
{
    Tick_Wrinkle(DeltaTime);
}
public native function Tick_Wrinkle(float DeltaTime);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_sWrinkleMaterialIdentifier = "_face"
}