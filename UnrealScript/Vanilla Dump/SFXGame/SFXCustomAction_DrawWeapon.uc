Class SFXCustomAction_DrawWeapon extends BioCustomAction
    config(Game);

var(SFXCustomAction_DrawWeapon) BodyStance BS_Draw;
var(SFXCustomAction_DrawWeapon) float fAnimBlendInTime;
var(SFXCustomAction_DrawWeapon) float fAnimBlendOutTime;
var(SFXCustomAction_DrawWeapon) float fAnimPlaybackRate;
var(SFXCustomAction_DrawWeapon) AlphaBlendType BlendType;

public static event function GetUsedAnimNames(out array<Name> UsedAnims)
{
    GetAnimsUsedByBodyStance(default.BS_Draw, UsedAnims);
    Super.GetUsedAnimNames(UsedAnims);
}
public function StartCustomAction()
{
    Super.StartCustomAction();
    if (m_oPawn.PlayBodyStance(BS_Draw, fAnimPlaybackRate, fAnimBlendInTime, fAnimBlendOutTime, , , , , BlendType) != 0.0)
    {
        m_oPawn.SetBodyStanceAnimEndNotification(BS_Draw, TRUE);
    }
}
public function StopCustomAction()
{
    local SFXWeapon CurrWeapon;
    
    Super.StopCustomAction();
    m_oPawn.StopBodyStance(BS_Draw, fAnimBlendOutTime);
    m_oPawn.SetBodyStanceAnimEndNotification(BS_Draw, FALSE);
    CurrWeapon = SFXWeapon(m_oPawn.Weapon);
    if (CurrWeapon != None)
    {
        CurrWeapon.EquipFinished();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BS_Draw = {
               AnimName = ('None', 
                           'CB_Draw', 
                           'CB_Draw', 
                           'CB_Draw_Cover', 
                           'None', 
                           'CB_Draw_Cover_Mid', 
                           'None', 
                           'None', 
                           'None', 
                           'None', 
                           'None', 
                           'CB_Draw'
                          )
              }
    fAnimBlendInTime = 0.100000001
    fAnimBlendOutTime = 0.200000003
    fAnimPlaybackRate = 1.0
    BlendType = AlphaBlendType.ABT_EaseInOutExponent2
    bDisableLeftHandIK = TRUE
    bDisableAiming = FALSE
    bBlockingAction = FALSE
    Priority = ECustomActionPriority.CA_Priority_Medium
}