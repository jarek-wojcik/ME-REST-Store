Class BioSkillMap;

var(BioSkillMap) array<Name> SkillToStateMap;
var bool m_bClosedIsSkillState;

public static function Name GetSkill(int Num)
{
    return default.SkillToStateMap[Num];
}
public static function bool IsSkillInMap(Name Skill)
{
    local int i;
    
    if (default.m_bClosedIsSkillState == FALSE && Skill == default.SkillToStateMap[0])
    {
        return FALSE;
    }
    for (i = 0; i < default.SkillToStateMap.Length; i++)
    {
        if (default.SkillToStateMap[i] == Skill)
        {
            return TRUE;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}