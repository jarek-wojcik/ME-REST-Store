Class SFXSimpleUseModule extends SFXSelectionModule
    native
    editinlinenew;

var delegate<OnUsed> __OnUsed__Delegate;
var(SFXSimpleUseModule) float fUseRange;
var(SFXSimpleUseModule) bool bStickForward;
var(SFXSimpleUseModule) transient bool bDeactivated;
var(SFXSimpleUseModule) bool bPlayUseAnimation;

public event simulated function HandlePostBeginPlay()
{
    Super.HandlePostBeginPlay();
    if (m_bCombatTargetable == TRUE && m_fMaxSelectionRangeSqr == default.m_fMaxSelectionRangeSqr)
    {
        m_fMaxSelectionRangeSqr = 0.0;
    }
}
public event function bool IsDefaultActionPossible()
{
    return !bDeactivated;
}
public delegate function OnUsed(Actor User);

public simulated native function ReInitialize(Actor oHost);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    fUseRange = 512.0
    m_fMaxSelectionRangeSqr = 262144.0
}