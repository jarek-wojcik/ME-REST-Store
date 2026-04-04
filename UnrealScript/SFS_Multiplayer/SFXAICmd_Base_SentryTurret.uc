Class SFXAICmd_Base_SentryTurret extends SFXAICommand_Base_Combat within SFXAI_SentryTurret;

var Name ShockPower;
var Name RocketPower;
var Name CryoAmmoPower;
var Name ArmorPiercingAmmoPower;
var Name PowerToUse;
var float FlamethrowerRangeSq;
var Actor PowerTarget;

public function bool ShouldUsePower(out Name PowerName, out Actor Target)
{
    local SFXPowerCustomAction oPower;
    
    oPower = SFXPowerCustomAction(Outer.MyBP.PowerManager.GetPower(ShockPower));
    if (oPower != None && oPower.CanUsePower(Outer.FireTarget))
    {
        Target = Outer.FireTarget;
        PowerName = ShockPower;
        return TRUE;
    }
    oPower = SFXPowerCustomAction(Outer.MyBP.PowerManager.GetPower(RocketPower));
    if (oPower != None && oPower.CanUsePower(Outer.FireTarget))
    {
        Target = Outer.FireTarget;
        PowerName = RocketPower;
        return TRUE;
    }
    oPower = SFXPowerCustomAction(Outer.MyBP.PowerManager.GetPower(CryoAmmoPower));
    if (oPower != None && oPower.CanUsePower(Outer.FireTarget))
    {
        Target = Outer.MyBP;
        PowerName = CryoAmmoPower;
        return TRUE;
    }
    oPower = SFXPowerCustomAction(Outer.MyBP.PowerManager.GetPower(ArmorPiercingAmmoPower));
    if (oPower != None && oPower.CanUsePower(Outer.FireTarget))
    {
        Target = Outer.MyBP;
        PowerName = ArmorPiercingAmmoPower;
        return TRUE;
    }
    return FALSE;
}
public function ChooseWeapon()
{
    if (Outer.MyBP.InvManager.FindInventoryType(Class'SFXWeapon_Heavy_FlameThrower_SentryTurret') != None)
    {
        if (VSizeSq(Outer.FireTarget.location - Outer.MyBP.location) < FlamethrowerRangeSq)
        {
            if (SFXWeapon_Heavy_FlameThrower_SentryTurret(Outer.MyBP.Weapon) != None || Outer.MyBP.SetWeaponImmediatelyByClass(Class'SFXWeapon_Heavy_FlameThrower_SentryTurret'))
            {
                return;
            }
        }
    }
    if (SFXWeapon_AssaultRifle_SentryTurret(Outer.MyBP.Weapon) == None)
    {
        Outer.MyBP.SetWeaponImmediatelyByClass(Class'SFXWeapon_AssaultRifle_SentryTurret');
    }
}

auto state Combat extends InCombat 
{
    
Begin:
    if (Outer.FireTarget == None)
    {
        while (Outer.SelectTarget() == FALSE)
        {
            Outer.Sleep(1.0);
        }
    }
    Outer.Focus = Outer.FireTarget;
    if (ShouldUsePower(PowerToUse, PowerTarget))
    {
        Class'SFXAICmd_UsePower'.static.UsePower(Outer, PowerToUse, PowerTarget, , TRUE);
    }
    else
    {
        ChooseWeapon();
        Outer.ShootWeaponAtFireTarget();
    }
    Outer.Sleep(0.5);
    goto 'Begin';
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ShockPower = 'SentryTurretShock'
    RocketPower = 'SentryTurretRocket'
    CryoAmmoPower = 'SentryTurretCryoAmmo'
    ArmorPiercingAmmoPower = 'SentryTurretArmorPiercingAmmo'
    FlamethrowerRangeSq = 1000000.0
}