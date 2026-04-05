Class BioSeqAct_AOECauseDamage extends SequenceAction;

var(BioSeqAct_AOECauseDamage) Class<SFXDamageType> DamageType;
var(BioSeqAct_AOECauseDamage) float DamageAmount;
var(BioSeqAct_AOECauseDamage) float DamageRadius;
var(BioSeqAct_AOECauseDamage) float MomentumScale;
var Actor InstigatorController;
var(BioSeqAct_AOECauseDamage) bool bDamageFalloff;
var(BioSeqAct_AOECauseDamage) bool bForceCinematicDamage;

public function Activated()
{
    local Controller Instigator;
    local BioWorldInfo WorldInfo;
    local Object ChkObject;
    local Actor ChkTarget;
    local Actor DamageActor;
    local Vector ToDamageActor;
    local float Distance;
    
    Instigator = Controller(InstigatorController);
    if (Pawn(InstigatorController) != None)
    {
        Instigator = Pawn(InstigatorController).Controller;
    }
    WorldInfo = BioWorldInfo(GetWorldInfo());
    WorldInfo.m_bForceCinematicDamage = bForceCinematicDamage;
    foreach Targets(ChkObject, )
    {
        ChkTarget = Actor(ChkObject);
        if (Controller(ChkObject) != None)
        {
            ChkTarget = Controller(ChkObject).Pawn;
        }
        if (ChkTarget != None)
        {
            foreach ChkTarget.CollidingActors(Class'Actor', DamageActor, DamageRadius, , TRUE, , )
            {
                ToDamageActor = DamageActor.location - ChkTarget.location;
                Distance = VSize(ToDamageActor);
                ToDamageActor = Normal(ToDamageActor);
                if (bDamageFalloff)
                {
                    DamageAmount *= 1.0 - Distance / DamageRadius;
                    ToDamageActor *= 1.0 - Distance / DamageRadius;
                }
                DamageActor.TakeDamage(DamageAmount, Instigator, ChkTarget.location, ToDamageActor * MomentumScale, DamageType);
            }
        }
    }
    WorldInfo.m_bForceCinematicDamage = FALSE;
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 3;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DamageRadius = 200.0
    MomentumScale = 500.0
    bCallHandler = FALSE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Target", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'Targets', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Amount", 
                      ExpectedType = Class'SeqVar_Float', 
                      LinkVar = 'None', 
                      PropertyName = 'DamageAmount', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Instigator", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'InstigatorController', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}