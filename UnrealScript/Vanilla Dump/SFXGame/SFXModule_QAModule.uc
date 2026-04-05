Class SFXModule_QAModule extends SFXModule;

var string barkName;
var WwiseEvent m_nextBark;
var float m_fBarkDelay;
var int AIBarkI;
var int AIBarkJ;
var int AIBarkK;
var int AIBarkVar;
var bool bDoneCombatBarks;
var bool bDoneExploreBarks;
var bool bDoneStealthBarks;
var bool bDoneCombatVarBarks;

public event simulated function HandlePostBeginPlay()
{
    Super.HandlePostBeginPlay();
    AIBarkI = 0;
    AIBarkJ = 0;
    AIBarkK = 0;
    AIBarkVar = 0;
    m_nextBark = GetNextAIBark();
}
public function Tick(float TimeDelta)
{
    Super.Tick(TimeDelta);
    if (m_nextBark != None)
    {
        if (m_fBarkDelay <= 0.0)
        {
            ModuleOwner.PlaySound(m_nextBark);
            m_fBarkDelay = m_nextBark.DurationMilliseconds / float(1000) + float(1);
            BioWorldInfo(ModuleOwner.WorldInfo).GetLocalPlayerController().ClientMessage("Playing " $ barkName, , m_fBarkDelay);
            m_nextBark = GetNextAIBark();
        }
        else
        {
            m_fBarkDelay = m_fBarkDelay - TimeDelta;
        }
    }
    else
    {
        ModuleOwner.RemoveSFXModule(Self);
    }
}
public function WwiseEvent GetNextAIBark()
{
    local BioPawn pPawn;
    local WwiseEvent Next;
    
    pPawn = BioPawn(ModuleOwner);
    if (pPawn == None)
    {
        return None;
    }
    if (!bDoneCombatBarks && pPawn.CombatVoc != None)
    {
        Next = GetNextCombatBark(pPawn);
        if (Next != None)
        {
            barkName = "Combat bark " $ Next.Name;
        }
        return Next;
    }
    else if (!bDoneExploreBarks && pPawn.ExplorationVoc != None)
    {
        Next = GetNextExploreBark(pPawn);
        if (Next != None)
        {
            barkName = "Exploration bark " $ Next.Name;
        }
        return Next;
    }
    else if (!bDoneStealthBarks && pPawn.StealthVoc != None)
    {
        Next = GetNextStealthBark(pPawn);
        if (Next != None)
        {
            barkName = "Stealth bark " $ Next.Name;
        }
        return Next;
    }
    else if (!bDoneCombatVarBarks && pPawn.CombatVocVariants.Length != 0)
    {
        Next = GetNextCombatVariantBark(pPawn);
        if (Next != None)
        {
            barkName = "Combat bark variation " $ Next.Name;
        }
        return Next;
    }
    else
    {
        return None;
    }
}
public function WwiseEvent GetNextCombatBark(BioPawn pPawn)
{
    if (AIBarkI < pPawn.CombatVoc.Vocalizations.Length)
    {
        if (AIBarkJ < pPawn.CombatVoc.Vocalizations[AIBarkI].Roles.Length)
        {
            if (AIBarkK < pPawn.CombatVoc.Vocalizations[AIBarkI].Roles[AIBarkJ].Variations.Length)
            {
                return pPawn.CombatVoc.Vocalizations[AIBarkI].Roles[AIBarkJ].Variations[AIBarkK++].Sound;
            }
            else
            {
                AIBarkK = 0;
                AIBarkJ++;
                return GetNextCombatBark(pPawn);
            }
        }
        else
        {
            AIBarkK = 0;
            AIBarkJ = 0;
            AIBarkI++;
            return GetNextCombatBark(pPawn);
        }
    }
    else
    {
        AIBarkI = 0;
        AIBarkJ = 0;
        AIBarkK = 0;
        bDoneCombatBarks = TRUE;
        return GetNextAIBark();
    }
}
public function WwiseEvent GetNextCombatVariantBark(BioPawn pPawn)
{
    if (AIBarkVar < pPawn.CombatVocVariants.Length)
    {
        if (AIBarkI < pPawn.CombatVocVariants[AIBarkVar].Vocalizations.Length)
        {
            if (AIBarkJ < pPawn.CombatVocVariants[AIBarkVar].Vocalizations[AIBarkI].Roles.Length)
            {
                if (AIBarkK < pPawn.CombatVocVariants[AIBarkVar].Vocalizations[AIBarkI].Roles[AIBarkJ].Variations.Length)
                {
                    return pPawn.CombatVocVariants[AIBarkVar].Vocalizations[AIBarkI].Roles[AIBarkJ].Variations[AIBarkK++].Sound;
                }
                else
                {
                    AIBarkK = 0;
                    AIBarkJ++;
                    return GetNextCombatVariantBark(pPawn);
                }
            }
            else
            {
                AIBarkK = 0;
                AIBarkJ = 0;
                AIBarkI++;
                return GetNextCombatVariantBark(pPawn);
            }
        }
        else
        {
            AIBarkK = 0;
            AIBarkJ = 0;
            AIBarkI = 0;
            AIBarkVar++;
            return GetNextCombatVariantBark(pPawn);
        }
    }
    else
    {
        AIBarkI = 0;
        AIBarkJ = 0;
        AIBarkK = 0;
        AIBarkVar = 0;
        bDoneCombatVarBarks = TRUE;
        return None;
    }
}
public function WwiseEvent GetNextExploreBark(BioPawn pPawn)
{
    if (AIBarkI < pPawn.ExplorationVoc.Vocalizations.Length)
    {
        if (AIBarkJ < pPawn.ExplorationVoc.Vocalizations[AIBarkI].Roles.Length)
        {
            if (AIBarkK < pPawn.ExplorationVoc.Vocalizations[AIBarkI].Roles[AIBarkJ].Variations.Length)
            {
                return pPawn.ExplorationVoc.Vocalizations[AIBarkI].Roles[AIBarkJ].Variations[AIBarkK++].Sound;
            }
            else
            {
                AIBarkK = 0;
                AIBarkJ++;
                return GetNextExploreBark(pPawn);
            }
        }
        else
        {
            AIBarkK = 0;
            AIBarkJ = 0;
            AIBarkI++;
            return GetNextExploreBark(pPawn);
        }
    }
    else
    {
        AIBarkI = 0;
        AIBarkJ = 0;
        AIBarkK = 0;
        bDoneExploreBarks = TRUE;
        return GetNextAIBark();
    }
}
public function WwiseEvent GetNextStealthBark(BioPawn pPawn)
{
    if (AIBarkI < pPawn.StealthVoc.Vocalizations.Length)
    {
        if (AIBarkJ < pPawn.StealthVoc.Vocalizations[AIBarkI].Roles.Length)
        {
            if (AIBarkK < pPawn.StealthVoc.Vocalizations[AIBarkI].Roles[AIBarkJ].Variations.Length)
            {
                return pPawn.StealthVoc.Vocalizations[AIBarkI].Roles[AIBarkJ].Variations[AIBarkK++].Sound;
            }
            else
            {
                AIBarkK = 0;
                AIBarkJ++;
                return GetNextStealthBark(pPawn);
            }
        }
        else
        {
            AIBarkK = 0;
            AIBarkJ = 0;
            AIBarkI++;
            return GetNextStealthBark(pPawn);
        }
    }
    else
    {
        AIBarkI = 0;
        AIBarkJ = 0;
        AIBarkK = 0;
        bDoneStealthBarks = TRUE;
        return GetNextAIBark();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bTickWhilePaused = TRUE
}