Class SeqEvent_TakeDamage extends SequenceEvent
    native;

var(SeqEvent_TakeDamage) array<Class<DamageType>> DamageTypes;
var(SeqEvent_TakeDamage) array<Class<DamageType>> IgnoreDamageTypes;
var(SeqEvent_TakeDamage) Vector vHitLocation;
var(SeqEvent_TakeDamage) float MinDamageAmount;
var(SeqEvent_TakeDamage) float DamageThreshold;
var float CurrentDamage;
var(SeqEvent_TakeDamage) Actor oDamagedActor;
var(SeqEvent_TakeDamage) bool bResetDamageOnToggle;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 5;
}
public function Reset()
{
    Super.Reset();
    CurrentDamage = 0.0;
}
public event function Toggled()
{
    if (bResetDamageOnToggle)
    {
        CurrentDamage = 0.0;
    }
    Super.Toggled();
}
public function HandleDamage(Actor inOriginator, Actor inInstigator, Class<DamageType> inDamageType, float inAmount, optional Vector InHitLocation, optional Actor DamageCauser)
{
    local SeqVar_Float FloatVar;
    local SeqVar_Vector VectorVar;
    local bool bAlreadyActivatedThisTick;
    
    if (inOriginator != None && bEnabled && inAmount >= MinDamageAmount && IsValidDamageType(inDamageType) && PassesWhoTriggers(inInstigator))
    {
        CurrentDamage += inAmount;
        if (CurrentDamage >= DamageThreshold)
        {
            bAlreadyActivatedThisTick = bActive && ActivationTime ~= GetWorldInfo().TimeSeconds;
            if (CheckActivate(inOriginator, inInstigator, FALSE))
            {
                foreach LinkedVariables(Class'SeqVar_Float', FloatVar, "Damage Taken")
                {
                    if (bAlreadyActivatedThisTick)
                    {
                        FloatVar.FloatValue += CurrentDamage;
                    }
                    else
                    {
                        FloatVar.FloatValue = CurrentDamage;
                    }
                }
                foreach LinkedVariables(Class'SeqVar_Vector', VectorVar, "Hit Location")
                {
                    vHitLocation = InHitLocation;
                }
                if (DamageCauser != None)
                {
                    SetNameVars("Weapon", DamageCauser.Class.Name);
                }
                SetObjectVars("Damaged Actor", inOriginator);
                if (DamageThreshold <= 0.0)
                {
                    CurrentDamage = 0.0;
                }
                else
                {
                    CurrentDamage -= DamageThreshold;
                }
            }
        }
    }
}
public final function bool IsValidDamageType(Class<DamageType> inDamageType)
{
    local int idx;
    local bool bValidDamageType;
    
    if (DamageTypes.Length > 0)
    {
        bValidDamageType = FALSE;
        for (idx = 0; idx < DamageTypes.Length; idx++)
        {
            if (ClassIsChildOf(inDamageType, DamageTypes[idx]))
            {
                bValidDamageType = TRUE;
                break;
            }
        }
        if (!bValidDamageType)
        {
            return FALSE;
        }
    }
    if (IgnoreDamageTypes.Length > 0)
    {
        for (idx = 0; idx < IgnoreDamageTypes.Length; idx++)
        {
            if (ClassIsChildOf(inDamageType, IgnoreDamageTypes[idx]))
            {
                return FALSE;
            }
        }
    }
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DamageThreshold = 1.0
    bResetDamageOnToggle = TRUE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Instigator", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Damage Taken", 
                      ExpectedType = Class'SeqVar_Float', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Weapon", 
                      ExpectedType = Class'SeqVar_Name', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Damaged Actor", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}