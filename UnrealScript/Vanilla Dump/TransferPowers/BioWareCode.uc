--BioCheatManager--
public exec function GivePower(string nmPawn, string PowerClassName)
{
    local Class<SFXPowerCustomActionBase> PowerClass;
    local BioPawn oPawn;
    local SFXPowerCustomActionBase oPower;
    
    PowerClass = FindPowerClass(PowerClassName);
    if (PowerClass == None)
    {
        PowerClass = FindPowerClass("SFXGameContent." $ PowerClassName);
    }
    if (PowerClass == None)
    {
        PowerClass = FindPowerClass("SFXGameMPContent." $ PowerClassName);
    }
    if (PowerClass == None)
    {
        PowerClass = FindPowerClass("SFXGameContent.SFXPowerCustomAction_" $ PowerClassName);
    }
    if (PowerClass == None)
    {
        PowerClass = FindPowerClass("SFXGameMPContent.SFXPowerCustomAction_" $ PowerClassName);
    }
    if (PowerClass == None)
    {
        Outer.ClientMessage("Unable to give power - Failed to load power " $ PowerClassName);
        return;
    }
    oPawn = BioPawn(GetActorFromString(nmPawn));
    if (oPawn == None || oPawn.PowerManager == None)
    {
        Outer.ClientMessage("Unable to give power - " $ nmPawn $ " is not a valid pawn name");
        return;
    }
    oPawn.PowerManager.AddPower(PowerClass);
    oPower = oPawn.PowerManager.GetPowerByClass(PowerClass);
    if (oPower != None)
    {
        Outer.ClientMessage("The power has been given to the pawn");
        oPower.Rank = 1.0;
        oPower.OnPowerRankIncreased();
    }
    else
    {
        Outer.ClientMessage("Unable to give the power to the pawn");
    }
}
--PowerManager--
public function SFXPowerCustomActionBase AddPower(Class<Object> PowerClass)
{
    local SFXPowerCustomActionBase Power;
    local SFXPowerCustomActionBase PowerInList;
    local int nIndex;
    local Class<SFXPowerCustomActionBase> PowerClassCast;
    local int PowerID;
    
    PowerClassCast = Class<SFXPowerCustomActionBase>(PowerClass);
    if (PowerClassCast == None)
    {
        return None;
    }
    PowerID = PowerClassCast.default.PowerCustomActionID;
    if (PowerID == 0)
    {
        return None;
    }
    for (nIndex = 0; nIndex < Powers.Length; nIndex++)
    {
        PowerInList = Powers[nIndex];
        if (PowerInList != None && PowerInList.Class == PowerClassCast)
        {
            return None;
        }
    }
    if (MyPawn != None)
    {
        MyPawn.PowerCustomActionClasses[PowerID] = PowerClassCast;
        MyPawn.VerifyCAHasBeenInstanced(132, PowerID);
    }
    Power = SFXPowerCustomActionBase(MyPawn.PowerCustomActions[PowerID]);
    if (Power != None)
    {
        Powers.AddItem(Power);
        for (nIndex = 0; nIndex < Powers.Length; nIndex++)
        {
            PowerInList = Powers[nIndex];
            if (PowerInList != None)
            {
                PowerInList.OnPowerAdded(Power);
            }
        }
    }
    return Power;
}
public native function SFXPowerCustomActionBase GetPowerByClass(Class<Object> PowerClass);

