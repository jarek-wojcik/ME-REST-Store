Class BioPhysicsSounds
    native
    config(Game);

var config float m_fMaxMass;
var config float m_fMaxSpeed;
var config float m_fMinTimeBetweenSoundByActor;
var config float m_fMinSpeedToPlay;
var config bool m_bEnableLogging;

public native function bool CanPlay(PrimitiveComponent oComp0, PrimitiveComponent oComp1, const out CollisionImpactData RigidCollisionData);

public native function float GetMassSpecifier(PrimitiveComponent oComp);

public native function float GetSpeedSpecifier(PrimitiveComponent oComp, float fSpeedToUse);

public native function bool IsSameCollidedActor(PrimitiveComponent oComp, Actor OtherActor);

public native function bool IsTooSlowToPlay(PrimitiveComponent oComp);

public native function bool IsTooSoonToPlay(PrimitiveComponent oComp);

public event function PlaySoundOnPhysMatAt(GameReplicationInfo GRI, PhysicalMaterial PhysMat, PhysicalMaterial PhysMatSweetener, Vector pos, array<string> RTPCNames, array<float> RTPCValues)
{
    local WwiseEvent PhysicsWwiseEvent;
    local int SweetenerRTPCValue;
    
    if (GRI == None)
    {
        return;
    }
    PhysicsWwiseEvent = GetWwiseEvent(PhysMat);
    if (PhysicsWwiseEvent != None)
    {
        if (PhysMatSweetener != None)
        {
            SweetenerRTPCValue = GetPhysMatWwiseType(PhysMatSweetener);
            if (SweetenerRTPCValue != -1)
            {
                RTPCNames.AddItem("Physics_Physmat_Type");
                RTPCValues.AddItem(float(SweetenerRTPCValue));
            }
        }
        SFXGRI(GRI).PlayTransientSound(PhysicsWwiseEvent, pos, RTPCNames, RTPCValues);
    }
}
public native function UpdateLastCollidedActor(PrimitiveComponent oComp, Actor OtherActor);

public native function UpdateLastTimePlayed(PrimitiveComponent oComp);

public function int GetPhysMatWwiseType(PhysicalMaterial PhysMat)
{
    local int PhysMatWwiseType;
    local SFXPhysicalMaterialPhysics PhysMatPhysics;
    
    PhysMatWwiseType = -1;
    while (PhysMatWwiseType == -1 && PhysMat != None)
    {
        if (PhysMat.PhysicalMaterialProperty != None && SFXPhysicalMaterialProperty(PhysMat.PhysicalMaterialProperty) != None && SFXPhysicalMaterialProperty(PhysMat.PhysicalMaterialProperty).PhysicalMaterialPhysics != None)
        {
            PhysMatPhysics = SFXPhysicalMaterialProperty(PhysMat.PhysicalMaterialProperty).PhysicalMaterialPhysics;
            PhysMatWwiseType = PhysMatPhysics.WwiseType;
        }
        PhysMat = PhysMat.Parent;
    }
    return PhysMatWwiseType;
}
public function WwiseEvent GetWwiseEvent(PhysicalMaterial PhysMat)
{
    local WwiseEvent PhysMatWwiseEvent;
    local SFXPhysicalMaterialPhysics PhysMatPhysics;
    
    while (PhysMatWwiseEvent == None && PhysMat != None)
    {
        if (PhysMat.PhysicalMaterialProperty != None && SFXPhysicalMaterialProperty(PhysMat.PhysicalMaterialProperty) != None && SFXPhysicalMaterialProperty(PhysMat.PhysicalMaterialProperty).PhysicalMaterialPhysics != None)
        {
            PhysMatPhysics = SFXPhysicalMaterialProperty(PhysMat.PhysicalMaterialProperty).PhysicalMaterialPhysics;
            PhysMatWwiseEvent = PhysMatPhysics.Sound;
        }
        PhysMat = PhysMat.Parent;
    }
    return PhysMatWwiseEvent;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_fMaxMass = 100.0
    m_fMaxSpeed = 500.0
}