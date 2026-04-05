Class SFXSeqAct_RemoveCombatZone extends SequenceAction;

var(SFXSeqAct_RemoveCombatZone) array<SFXCombatZone> CombatZones;
var(SFXSeqAct_RemoveCombatZone) Actor Squad;

public function Activated()
{
    local BioBaseSquad TheSquad;
    local SFXCombatZone CombatZone;
    local bool bRemoved;
    
    TheSquad = BioBaseSquad(Squad);
    if (TheSquad == None)
    {
        return;
    }
    foreach CombatZones(CombatZone, )
    {
        if (CombatZone != None)
        {
            if (TheSquad.CombatZones.Find(CombatZone) != -1)
            {
                TheSquad.CombatZones.RemoveItem(CombatZone);
                bRemoved = TRUE;
            }
        }
    }
    if (bRemoved)
    {
        TheSquad.NotifyCombatZoneRemoved();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Combat Zones", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'CombatZones', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Squad", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'Squad', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}