Class SFXPowerCustomAction_GrenadeBase extends SFXPowerCustomAction
    abstract
    config(Game);

var stringref srNoGrenades;

public function bool CanUsePower(Actor oTarget)
{
    local string EmptyString;
    local bool Result;
    
    if (SFXPawn_Henchman(m_oPawn) != None && !m_bPlayerOrderedPowerUse)
    {
        return FALSE;
    }
    Result = ShouldUsePower(oTarget, EmptyString);
    if (SFXPawn_Player(m_oPawn) != None && !Result)
    {
        return FALSE;
    }
    return Result && Super.CanUsePower(oTarget);
}
public event function string GetHUDWheelIconInfo()
{
    return string(GetGrenadeCount());
}
public event function bool ShouldUsePower(Actor Target, out string sOptionalInfo)
{
    if (SFXPawn_PlayerParty(m_oPawn) == None)
    {
        return TRUE;
    }
    if (GetGrenadeCount() <= 0)
    {
        sOptionalInfo = string(srNoGrenades);
        return FALSE;
    }
    return TRUE;
}
public function OnPowerAdded(SFXPowerCustomActionBase Power)
{
    local SFXInventoryManager Inventory;
    
    Super(SFXPowerCustomActionBase).OnPowerAdded(Power);
    if (Power == Self)
    {
        Inventory = SFXInventoryManager(m_oPawn.InvManager);
        if (Inventory != None)
        {
            Inventory.bCanPickUpGrenades = TRUE;
        }
    }
}
public function OnPowerRankIncreased()
{
    Super(SFXPowerCustomActionBase).OnPowerRankIncreased();
    ApplyGrenadeBonus();
}
public function OnPowersLoaded()
{
    local SFXInventoryManager Inventory;
    
    Super(SFXPowerCustomActionBase).OnPowersLoaded();
    Inventory = SFXInventoryManager(m_oPawn.InvManager);
    if (Inventory != None)
    {
        Inventory.bCanPickUpGrenades = TRUE;
    }
    ApplyGrenadeBonus();
}
public function OnSquadMemberAdded(Pawn Pawn)
{
    Super(SFXPowerCustomActionBase).OnSquadMemberAdded(Pawn);
    ApplyGrenadeBonus();
}
public function ReleasePower()
{
    local BioPlayerController PC;
    
    Super.ReleasePower();
    PC = BioPlayerController(m_oPawn.Controller);
    if (PC != None && PC.IsLocalPlayerController())
    {
        PC.HintSystem.HintEvent('UsedGrenade');
    }
    AdjustGrenadeCount(-1);
}
public function ResetPower()
{
    Super(SFXPowerCustomActionBase).ResetPower();
    ApplyGrenadeBonus();
}
public function AdjustGrenadeCount(int Amount)
{
    if (SFXPawn_PlayerParty(m_oPawn) != None)
    {
        m_oPawn.AdjustInventoryResource(3, Amount, FALSE);
    }
}
public function ApplyGrenadeBonus();

public function int GetGrenadeCount()
{
    local SFXInventoryManager oInventory;
    
    oInventory = SFXInventoryManager(m_oPawn.InvManager);
    if (oInventory == None)
    {
        return 0;
    }
    return oInventory.GetResource(3);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=BioDynamicAnimSet Name=MY_DYN_HMM_CB_Grenade
        m_nmOrigSetName = 'HMM_CB_Grenade'
        Sequences = (AnimSequence'BIOG_HMM_CB_A.HMM_CB_Grenade_CB_Grenade2')
        m_pBioAnimSetData = BioAnimSetData'BIOG_HMM_CB_A.HMM_CB_Grenade_BioAnimSetData'
    End Object
    srNoGrenades = $538903
    BS_EndCastAnimation = {
                           AnimName = ('None', 
                                       'CB_Grenade2', 
                                       'CB_Grenade2', 
                                       'CB_Grenade2', 
                                       'CB_Grenade2', 
                                       'CB_Grenade2', 
                                       'CB_Grenade2', 
                                       'CB_Grenade2', 
                                       'None', 
                                       'None', 
                                       'None', 
                                       'CB_Grenade2'
                                      )
                          }
    ReleaseTime = 0.550000012
    CastAnimSet = MY_DYN_HMM_CB_Grenade
    CastCameraAnim = CameraAnim'BioVFX_C_CamAnim.Powers.BC_RifleTelekinesisFloat'
    bPlayStartCastAnim = FALSE
    ProjectileSpeed = {BaseValue = 3000.0}
    UsesSharedCooldown = FALSE
    PowerType = EPowerType.PowerType_Projectile
    bHideWeapon = TRUE
}