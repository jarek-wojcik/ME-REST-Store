public function createPowerSaveInfoAndReload(Class<SFXCharacterClass> fromCharacterClass, SFXMPCharacterRecord kitSave, int replacementIndex, int originalIndex)
{
    local array<PowerSaveInfo> powerSaves;
    local SFXPowerCustomActionBase powerIterator;
    local int iteratorInt;
    local PowerSaveInfo replacementPowerSaveInfo;
    local PowerSaveInfo currentPowerSaveInfo;
    local bool b_hasReplacementInfo;
    local bool b_hasEvolvedChoices;
    local int idx;
    
    b_hasReplacementInfo = getReplacementPowerSaveInfo(fromCharacterClass, kitSave, replacementIndex, replacementPowerSaveInfo, b_hasEvolvedChoices);
    foreach Outer.PowerManager.Powers(powerIterator, iteratorInt)
    {
        log(Self.Name, "iteratorInt " $ iteratorInt, Outer);
        if (iteratorInt == originalIndex && b_hasReplacementInfo)
        {
            log(Self.Name, "Has Replacement Info, Creating the save", Outer);
            if (!b_hasEvolvedChoices)
            {
                for (idx = 0; idx < 6; idx++)
                {
                    replacementPowerSaveInfo.EvolvedChoices[idx] = powerIterator.EvolvedChoices[idx];
                }
            }
            replacementPowerSaveInfo.WheelDisplayIndex = powerIterator.WheelDisplayIndex;
            powerSaves.AddItem(replacementPowerSaveInfo);
            Outer.PowerManager.RemovePower(powerIterator.Class);
        }
        else
        {
            currentPowerSaveInfo.EvolvedChoices = powerIterator.EvolvedChoices;
            currentPowerSaveInfo.PowerName = powerIterator.PowerName;
            currentPowerSaveInfo.PowerClassName = powerIterator.Class.Name;
            currentPowerSaveInfo.CurrentRank = powerIterator.Rank;
            currentPowerSaveInfo.WheelDisplayIndex = powerIterator.WheelDisplayIndex;
            powerSaves.AddItem(currentPowerSaveInfo);
        }
    }
    printPowerSaveInfo(powerSaves);
    Outer.PowerManager.LoadPowers(powerSaves);
    foreach Outer.PowerManager.Powers(powerIterator, )
    {
        powerIterator.RecalculateAllPowerInfo(TRUE);
    }
}