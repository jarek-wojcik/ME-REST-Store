Class SFXPowerCustomAction_IncendiaryAmmo extends SFXPowerCustomAction_AmmoPower
    config(Game);

var config PowerData AreaExplosionRadius;
var config PowerData AreaExplosionChance;
var config PowerData AreaExplosionDamage;
var config AreaEffectParameters AoEParams;
var config float Evolve_AmmoIncrease;
var config float Evolve_HeadShotDamage;
var config float Evolve_ArmorDamageBonus;
var config float Evolve_DamageBonus;
var config float Evolve_DamageBonus2;
var config float PanicChanceIncrease;
var config float AreaExplosionVFXScale;
var config float DOTDuration;
var config float DoTDamage;

public function bool OnActorImpacted(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local BioPawn oPawn;
    local SFXGameEffect_IncendiaryAmmo IncendiaryAmmoEffect;
    
    oPawn = BioPawn(oImpacted);
    if (oPawn != None)
    {
        IncendiaryAmmoEffect = GetIncendiaryAmmoEffect();
        if (IncendiaryAmmoEffect != None)
        {
            if (!SFXGRI(m_oPawn.WorldInfo.GRI).IsMultiplayerGame())
            {
                SpawnRandomImpactVFX(oPawn, IncendiaryAmmoEffect.PS_FlameEffect, None);
            }
            IncendiaryAmmoEffect.AddGameEffects(oPawn);
        }
    }
    return TRUE;
}
public static function PrecacheVFX(SFXObjectPool ObjectPool, RvrClientEffectManager ClientEffects)
{
    Super.PrecacheVFX(ObjectPool, ClientEffects);
    Class'SFXGameEffect_IncendiaryAmmo'.static.PrecacheVFX(ObjectPool, ClientEffects);
}
public function ApplyBonus(Name Parameter, SFXGameEffect Bonus, optional bool bRemove = FALSE)
{
    Super(SFXPowerCustomAction).ApplyBonus(Parameter, Bonus, bRemove);
    switch (Parameter)
    {
        case 'AmmoPowerDamage':
            ApplyBonusToParameter(Damage, Bonus, bRemove);
            ApplyBonusToParameter(AreaExplosionDamage, Bonus, bRemove);
            break;
        case 'Damage':
            ApplyBonusToParameter(AreaExplosionDamage, Bonus, bRemove);
            break;
        case 'ImpactRadius':
            ApplyBonusToParameter(AreaExplosionRadius, Bonus, bRemove);
            break;
        default:
    }
}
public function ClientDoCustomActionImpact(Actor oActor, int ImpactCount, optional bool bFirstTarget, optional Vector HitLocation, optional Vector HitNormal, optional int CustomActionReactionType)
{
    local SFXGameEffect_IncendiaryAmmo IncendiaryAmmoEffect;
    
    Super.ClientDoCustomActionImpact(oActor, ImpactCount, bFirstTarget, HitLocation, HitNormal, CustomActionReactionType);
    if (ImpactCount > 0)
    {
        IncendiaryAmmoEffect = GetIncendiaryAmmoEffect();
        if (IncendiaryAmmoEffect != None)
        {
            if (!SFXGRI(m_oPawn.WorldInfo.GRI).IsMultiplayerGame())
            {
                SpawnRandomImpactVFX(BioPawn(oActor), IncendiaryAmmoEffect.PS_FireSpreadEffect, None);
            }
        }
    }
}
public function ClientDoPowerSubsequentImpact(Actor oActor, optional int CustomActionReactionType, optional float Duration, optional int ImpactCount, optional float Delay, optional bool DoCallback)
{
    if (oActor != None)
    {
        DoAreaExplosionForActor(oActor, oActor.location, ImpactCount, AreaExplosionDamage.CurrentValue, GetDamageType(), 0.0, AoEParams, 0, OnActorImpacted);
    }
    if (BioPawn(oActor) != None)
    {
        BioPawn(oActor).ClientPlayAnimatedReaction(CustomActionReactionType);
    }
}
public function EvolvePower(EEvolveChoice choice)
{
    Super(SFXPowerCustomActionBase).EvolvePower(choice);
    switch (choice)
    {
        case EEvolveChoice.EvolveChoice1:
            AddEvolvedRankBonus(Damage, Evolve_DamageBonus);
            break;
        case EEvolveChoice.EvolveChoice2:
            BuffAppliesToSquad = TRUE;
            break;
        case EEvolveChoice.EvolveChoice3:
            break;
        case EEvolveChoice.EvolveChoice4:
            break;
        case EEvolveChoice.EvolveChoice5:
            AddEvolvedRankBonus(Damage, Evolve_DamageBonus2);
            break;
        case EEvolveChoice.EvolveChoice6:
            break;
        default:
    }
    RecalculateAllPowerInfo();
}
public final function Class<SFXDamageType> GetDamageType()
{
    if (Rank > float(1))
    {
        return Class'SFXDamageType_IncendiaryAmmoImproved';
    }
    else
    {
        return DefaultDamageType;
    }
}
public function PopulatePowerStatBarEvolves()
{
    PowerStatBars.Length = 2;
    PowerStatBars[0].Data = Damage;
    PowerStatBars[0].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[0].srDisplayTotalToken = StatBarToken_PositivePercent;
    PowerStatBars[0].srStatBarDisplayTitle = StatBarTitle_HealthDamage;
    PowerStatBars[0].EvolvedBonuses[0] = Evolve_DamageBonus;
    PowerStatBars[0].EvolvedBonuses[4] = Evolve_DamageBonus2;
    PowerStatBars[1].Data = Damage;
    PowerStatBars[1].Formula = EPowerStatBarFormula.EPowerStatBarFormula_Percent;
    PowerStatBars[1].srDisplayTotalToken = StatBarToken_PositivePercent;
    PowerStatBars[1].srStatBarDisplayTitle = StatBarTitle_ArmorDamage;
    PowerStatBars[1].EvolvedBonuses[0] = Evolve_DamageBonus;
    PowerStatBars[1].EvolvedBonuses[4] = Evolve_DamageBonus2;
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super(SFXPowerCustomActionBase).RecalculateAllPowerData(bReset);
    RecalculatePowerData(AreaExplosionRadius, bReset);
    RecalculatePowerData(AreaExplosionChance, bReset);
    RecalculatePowerData(AreaExplosionDamage, bReset);
}
public function ResetPower()
{
    Super(SFXPowerCustomActionBase).ResetPower();
    BuffAppliesToSquad = FALSE;
}
public function ApplyPowerEffects(BioPawn oPawn, SFXWeapon oWeapon)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_IncendiaryAmmo oEffect;
    
    if (oPawn == None || oWeapon == None)
    {
        return;
    }
    Manager = oWeapon.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return;
    }
    oEffect = SFXGameEffect_IncendiaryAmmo(Manager.CreateEffect(Class'SFXGameEffect_IncendiaryAmmo', oWeapon.Name, 0.0, 2, 1.0, m_oPawn.Controller));
    if (oEffect != None)
    {
        SetupEffect(oEffect, oPawn);
        oEffect.Power = Self;
        oEffect.AddedByPlayer = m_bPlayerOrderedPowerUse;
        oEffect.OnApplied();
    }
}
public function ConcussiveShotCustomImpact(EPowerResistance Resistance, Actor oImpacted, int nPreviouslyImpacted, Vector HitLocation, Vector HitNormal)
{
    local BioPawn oImpactedPawn;
    local SFXModule_GameEffectManager Manager;
    
    oImpactedPawn = BioPawn(oImpacted);
    if (oImpactedPawn == None)
    {
        return;
    }
    Manager = oImpactedPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return;
    }
    if (Resistance != EPowerResistance.Resistance_Full)
    {
        if (m_oPawn != None && m_oPawn.Role == ENetRole.ROLE_Authority)
        {
            DoConcussiveShotSpecialImpact(oImpacted, DOTDuration);
        }
    }
}
public function DoConcussiveShotSpecialImpact(Actor oImpacted, float ImpactEffectDuration)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_FireDamageOverTime DamageEffect;
    
    if (oImpacted == None)
    {
        return;
    }
    Manager = oImpacted.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return;
    }
    DamageEffect = SFXGameEffect_FireDamageOverTime(Manager.CreateEffect(Class'SFXGameEffect_FireDamageOverTime', Name, DOTDuration, 1, DoTDamage / DOTDuration, m_oPawn.Controller));
    if (DamageEffect != None)
    {
        DamageEffect.DamageType = GetDamageType();
        DamageEffect.ComboPower = Self;
        DamageEffect.OnApplied();
    }
    ReplicateConcussiveShotSpecialImpact(BioPawn(oImpacted), ImpactEffectDuration);
}
public function DoEvolvedAoEImpact(ImpactInfo Impact, SFXGameEffect_IncendiaryAmmo Effect)
{
    local BioPawn oPawn;
    
    AreaExplosion(Impact.HitLocation, AreaExplosionRadius.CurrentValue, AreaExplosionDamage.CurrentValue, GetDamageType(), 0.0, AoEParams, 0, OnActorImpacted);
    oPawn = BioPawn(Impact.HitActor);
    if (oPawn != None && Effect != None)
    {
        if (!SFXGRI(m_oPawn.WorldInfo.GRI).IsMultiplayerGame())
        {
            SpawnRandomImpactVFX(oPawn, Effect.PS_FireSpreadEffect, None);
        }
        if (ShouldReplicate())
        {
            ReplicateImpact(oPawn);
        }
    }
}
public function SFXGameEffect_IncendiaryAmmo GetIncendiaryAmmoEffect()
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect Effect;
    
    if (m_oPawn != None && m_oPawn.Weapon != None)
    {
        Manager = m_oPawn.Weapon.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            Effect = Manager.GetFirstEffectOfType(Class'SFXGameEffect_IncendiaryAmmo');
            return SFXGameEffect_IncendiaryAmmo(Effect);
        }
    }
    return None;
}
public function SetupEffect(SFXGameEffect_AmmoPower Effect, optional BioPawn oPawn)
{
    local SFXGameEffect_IncendiaryAmmo effectIncendiaryAmmo;
    local float fEffectValue;
    
    fEffectValue = 1.0;
    if (oPawn != None && oPawn != m_oPawn)
    {
        fEffectValue = SquadEffectiveness;
    }
    effectIncendiaryAmmo = SFXGameEffect_IncendiaryAmmo(Effect);
    if (effectIncendiaryAmmo != None)
    {
        effectIncendiaryAmmo.DamageType = GetDamageType();
        effectIncendiaryAmmo.bAreaExplosion = IsEvolvedWithChoice(5);
        effectIncendiaryAmmo.AreaExplosionChance = AreaExplosionChance.CurrentValue * fEffectValue;
        effectIncendiaryAmmo.Damage = Damage.CurrentValue * fEffectValue;
        if (IsEvolvedWithChoice(2))
        {
            effectIncendiaryAmmo.SpareAmmoBonus = Evolve_AmmoIncrease * fEffectValue;
        }
        if (IsEvolvedWithChoice(3))
        {
            effectIncendiaryAmmo.HeadShotDamageBonus = Evolve_HeadShotDamage * fEffectValue;
        }
    }
}
private final function SpawnRandomImpactVFX(BioPawn Pawn, ParticleSystem ImpactParticleSystem, Actor inInstigator)
{
    local SFXDuringAsyncWorkTicker oTicker;
    local Name BoneName;
    
    if (Pawn != None && ImpactParticleSystem != None)
    {
        BoneName = Pawn.GetRandomImpactBone();
        if (BoneName != 'None')
        {
            oTicker = SFXGRI(Pawn.WorldInfo.GRI).DuringAsyncWorker;
            if (oTicker != None)
            {
                oTicker.SpawnImpactEffectAtLocation(inInstigator, ImpactParticleSystem, Pawn, Pawn.Mesh.GetBoneLocation(BoneName), vect(0.0, 1.0, 0.0), Pawn.Mesh, BoneName, AreaExplosionVFXScale);
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDynamicAnimSet Name=MY_DYN_HMM_BC_SniperSpecial
        m_nmOrigSetName = 'HMM_BC_SniperSpecial'
        Sequences = (AnimSequence'BIOG_HMM_BC_A.HMM_BC_SniperSpecial_BC_Start', AnimSequence'BIOG_HMM_BC_A.HMM_BC_SniperSpecial_BC_Start_Cover_Neutral', AnimSequence'BIOG_HMM_BC_A.HMM_BC_SniperSpecial_BC_Start_Cover_Neutral_Mid', AnimSequence'BIOG_HMM_BC_A.HMM_BC_SniperSpecial_BC_End_Cover_Neutral', AnimSequence'BIOG_HMM_BC_A.HMM_BC_SniperSpecial_BC_End_Cover_Neutral_Mid')
        m_pBioAnimSetData = BioAnimSetData'BIOG_HMM_BC_A.HMM_BC_SniperSpecial_BioAnimSetData'
    End Object
    AreaExplosionRadius = {
                           DynamicBonuses = (), 
                           RankBonuses[0] = 0.0, 
                           RankBonuses[1] = 0.0, 
                           RankBonuses[2] = 0.0, 
                           RankBonuses[3] = 0.0, 
                           RankBonuses[4] = 0.0, 
                           RankBonuses[5] = 0.0, 
                           BaseValue = 250.0, 
                           CurrentValue = 0.0, 
                           Formula = EPowerDataFormula.Normal
                          }
    AreaExplosionChance = {
                           DynamicBonuses = (), 
                           RankBonuses[0] = 0.0, 
                           RankBonuses[1] = 0.0, 
                           RankBonuses[2] = 0.0, 
                           RankBonuses[3] = 0.0, 
                           RankBonuses[4] = 0.0, 
                           RankBonuses[5] = 0.0, 
                           BaseValue = 0.5, 
                           CurrentValue = 0.0, 
                           Formula = EPowerDataFormula.Normal
                          }
    AreaExplosionDamage = {
                           DynamicBonuses = (), 
                           RankBonuses[0] = 0.0, 
                           RankBonuses[1] = 0.0, 
                           RankBonuses[2] = 0.0, 
                           RankBonuses[3] = 0.0, 
                           RankBonuses[4] = 0.0, 
                           RankBonuses[5] = 0.0, 
                           BaseValue = 100.0, 
                           CurrentValue = 0.0, 
                           Formula = EPowerDataFormula.Normal
                          }
    AoEParams = {
                 ConeDirection = {X = 0.0, Y = 0.0, Z = 0.0}, 
                 HitDirectionOffset = {Pitch = 0, Yaw = 0, Roll = 0}, 
                 ConeAngle = 0.0, 
                 ImpactFriends = FALSE, 
                 ImpactDeadPawns = FALSE, 
                 ImpactPlaceables = TRUE, 
                 BlockedByObjects = TRUE, 
                 DistancedSorted = FALSE
                }
    Evolve_AmmoIncrease = 0.300000012
    Evolve_HeadShotDamage = 0.25
    Evolve_DamageBonus = 0.0599999987
    Evolve_DamageBonus2 = 0.100000001
    PanicChanceIncrease = 0.150000006
    AreaExplosionVFXScale = 1.70000005
    DOTDuration = 3.0
    DoTDamage = 100.0
    WeaponPowerEffectClass = Class'SFXGameEffect_IncendiaryAmmo'
    ConcussiveShotDamageType = Class'SFXDamageType_ConcussiveShot_Incendiary'
    oTracer = StaticMesh'BioVFX_C_Weapons.Tracers.Meshes.Tracer_Generic_Mesh'
    oImpactVFX = ParticleSystem'BioVFX_C_Carnage.Particles.Carnage_Xmod_Imp'
    oMuzzleVFX = ParticleSystem'BioVFX_C_Modal.Particles.Modal_Mzl1_Carnage'
    oMuzzleLoopVFX = ParticleSystem'BioVFX_C_Modal.Particles.Modal_Mzl_Carnage'
    CE_ConcussiveShotImpact = RvrClientEffect'BioVFX_C_FlashBang.VCFX.FlashBang_Incinerate_Imp_VCFX'
    LoadAmmoPowerSound = WwiseEvent'Wwise_Power_Soldier_Ammo.Play_power_soldier_P_ammo_inc_cast'
    HenchmanLoadAmmoPowerSound = WwiseEvent'Wwise_Power_Soldier_Ammo.Play_power_soldier_NP_ammo_inc_cast'
    bModifyTracer = TRUE
    bModifyImpactVFX = TRUE
    bModifyMuzzle = TRUE
    DefaultDamageType = Class'SFXDamageType_IncendiaryAmmo'
    CastAnimSet = MY_DYN_HMM_BC_SniperSpecial
    Damage = {RankBonuses[2] = 0.0399999991, BaseValue = 0.100000001, Formula = EPowerDataFormula.BonusIsHardValue}
    Ranks = ({
              Icon = 57, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $93964, 
              Evolved1Description = $155051, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 57, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $244423, 
              Evolved1Description = $699771, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 57, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $244424, 
              Evolved1Description = $505522, 
              Evolved2Name = $0, 
              Evolved2Description = $0
             }, 
             {
              Icon = 57, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $193066, 
              Evolved1Description = $327020, 
              Evolved2Name = $193067, 
              Evolved2Description = $327021
             }, 
             {
              Icon = 57, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $505537, 
              Evolved1Description = $505538, 
              Evolved2Name = $505539, 
              Evolved2Description = $505540
             }, 
             {
              Icon = 57, 
              Name = $0, 
              Description = $0, 
              Evolved1Name = $505542, 
              Evolved1Description = $505543, 
              Evolved2Name = $505544, 
              Evolved2Description = $505545
             }
            )
    PowerName = 'IncendiaryAmmo'
    PowerCustomActionID = 17
    DisplayName = $93964
    Description = $703485
    Icon = 57
    TalentDescription = $703485
    VocalizationEvent = ESFXVocalizationEventID.SFXVocalizationEvent_Power_Ammo
}