Class BioSeqAct_CauseDamage extends SequenceAction;

var(BioSeqAct_CauseDamage) Class<SFXDamageType> DamageType;
var(BioSeqAct_CauseDamage) float DamageAmount;
var(BioSeqAct_CauseDamage) float MomentumScale;
var Actor InstigatorController;
var(BioSeqAct_CauseDamage) bool bForceCinematicDamage;

public function Activated()
{
    local Controller Instigator;
    local BioWorldInfo WorldInfo;
    local Object ChkObject;
    local Actor ChkTarget;
    local Vector Momentum;
    
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
            if (Instigator != None)
            {
                Momentum = Normal(ChkTarget.location - Instigator.Pawn.location) * MomentumScale;
            }
            else if (InstigatorController != None)
            {
                Momentum = Normal(ChkTarget.location - InstigatorController.location) * MomentumScale;
            }
            else
            {
                Momentum = Vector(ChkTarget.Rotation) * -MomentumScale;
            }
            ChkTarget.TakeDamage(DamageAmount, Instigator, ChkTarget.location, Momentum, DamageType);
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