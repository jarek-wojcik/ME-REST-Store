Class SFXModule_AimAssistTarget extends SFXSimpleUseModule
    native
    editinlinenew;

struct native AimAssistBox 
{
    var(AimAssistBox) float Width;
    var(AimAssistBox) float Height;
    var(AimAssistBox) float SoftMargin;
    var(AimAssistBox) EAimNodes NodeType;
};

var(SFXModule_AimAssistTarget) array<Name> AimNodes;
var(SFXModule_AimAssistTarget) array<AimAssistBox> AimAssistRegions;

public event simulated function HandlePostBeginPlay()
{
    local int idx;
    
    Super.HandlePostBeginPlay();
    if (BioPawn(ModuleOwner) != None)
    {
        AimNodes.Length = BioPawn(ModuleOwner).AimNodes.Length;
        for (idx = 0; idx < AimNodes.Length; idx++)
        {
            AimNodes[idx] = BioPawn(ModuleOwner).AimNodes[idx];
        }
    }
}
public event function bool IsDefaultActionPossible()
{
    return __OnUsed__Delegate != None;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_fMaxSelectionRangeSqr = 0.0
    m_bCombatTargetable = TRUE
}