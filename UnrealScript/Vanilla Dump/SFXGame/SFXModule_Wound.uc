Class SFXModule_Wound extends SFXModule
    native;

struct native BioWoundSpec 
{
    var(BioWoundSpec) Matrix m_mWoundEllipse;
    var(BioWoundSpec) BoxSphereBounds HitBox;
    var(BioWoundSpec) Name m_nmPart;
    var(BioWoundSpec) Name HitBoxBone;
    var(BioWoundSpec) SkeletalMesh m_pWoundModel;
    var(BioWoundSpec) Texture2D m_pBloodTexture;
    var(BioWoundSpec) RvrClientEffectInterface m_pEffect;
    var(BioWoundSpec) float m_fEffectDuration;
    var(BioWoundSpec) float m_fEffectRadius;
    var transient bool bIsActive;
    var(BioWoundSpec) EWoundSeverity m_eWoundSeverity;
};
enum EWoundSeverity
{
    WoundSev_Light,
    WoundSev_Medium,
    WoundSev_Heavy,
};

var(SFXModule_Wound) array<BioWoundSpec> m_aWoundSpecs;
var transient array<BioWoundSpec> m_aWounds;

public native function bool CanSupportAnotherWound();

public final native function CreateBestWound(Name HitPart, const out Vector HitLocation, Class<DamageType> DamageType, const out Vector Momentum);

public final native function CreateWound(int WoundIdx);

public final native function BoxSphereBounds GetWoundBox(int WoundIdx);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}