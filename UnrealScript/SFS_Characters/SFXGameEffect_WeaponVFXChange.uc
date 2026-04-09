Class SFXGameEffect_WeaponVFXChange extends SFXGameEffect;

var StaticMesh Tracer;
var ParticleSystem oMuzzleVFX;
var ParticleSystem oMuzzleLoopVFX;
var ParticleSystem oImpactVFX;
var SFXWeapon OwnerWeapon;
var bool bModifyTracer;
var bool bModifyMuzzleFlash;
var bool bModifyImpactVFX;

public function OnRemoved()
{
    Super.OnRemoved();
    if (OwnerWeapon == None)
    {
        return;
    }
    OwnerWeapon.TracerInfo.StaticMesh = OwnerWeapon.default.TracerInfo.StaticMesh;
    OwnerWeapon.PS_DefaultImpactEffect = OwnerWeapon.default.PS_DefaultImpactEffect;
    if (OwnerWeapon.PSC_MuzFlashEmitter != None)
    {
        OwnerWeapon.PSC_MuzFlashEmitter.SetTemplate(OwnerWeapon.PSC_MuzFlashEmitter.default.Template);
    }
}
public function OnApplied()
{
    Super.OnApplied();
    OwnerWeapon = SFXWeapon(Owner);
    if (OwnerWeapon == None)
    {
        return;
    }
    if (bModifyTracer)
    {
        OwnerWeapon.TracerInfo.StaticMesh = Tracer;
    }
    if (bModifyImpactVFX && oImpactVFX != None && !SFXGRI(Owner.WorldInfo.GRI).IsMultiplayerGame())
    {
        OwnerWeapon.PS_DefaultImpactEffect = oImpactVFX;
    }
    if (bModifyMuzzleFlash)
    {
        if (OwnerWeapon.bLoopingFlashEmitter)
        {
            OwnerWeapon.PSC_MuzFlashEmitter.SetTemplate(oMuzzleLoopVFX);
        }
        else
        {
            OwnerWeapon.PSC_MuzFlashEmitter.SetTemplate(oMuzzleVFX);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}