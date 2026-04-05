Class SFXAI_Critter extends SFXAI_Core
    placeable
    config(AI);

var Class<SFXAICommand> CritterCommand;
var Vector m_vRepulsor;
var Vector m_vCurrentSteeringDirection;
var bool m_bUnderAttack;

public function Initialize()
{
    Super.Initialize();
    if (MyBP != None)
    {
        MyBP.bAmbientCreature = TRUE;
    }
}
public function NotifyTakeHit(Controller instigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum)
{
    Super.NotifyTakeHit(instigatedBy, HitLocation, Damage, DamageType, Momentum);
    if (!m_bUnderAttack)
    {
        m_bUnderAttack = TRUE;
        CancelAction();
    }
    m_vRepulsor = HitLocation;
    m_bClearVelocityAfterMove = TRUE;
}
public function NotifyNearMiss(Vector HitLocation)
{
    Super.NotifyNearMiss(HitLocation);
    if (!m_bUnderAttack)
    {
        m_bUnderAttack = TRUE;
        CancelAction();
    }
    m_vRepulsor = HitLocation;
    m_bClearVelocityAfterMove = TRUE;
}
public function bool ShouldCancelMove(int nReason)
{
    return m_bUnderAttack;
}

auto state Critter 
{
    
Begin:
    while (TRUE)
    {
        CritterCommand.static.InitCommand(Self);
        Sleep(0.5);
    }
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CritterCommand = Class'SFXAICmd_Critter'
}