Class SFXNav_GoalPoint extends NavigationPoint
    native
    placeable;

var(SFXNav_GoalPoint) int m_nPriority;
var int m_nOverridePriority;
var(SFXNav_GoalPoint) bool m_bIsFinalGoal;

public final native function int GetPriority();

public final native function OverridePriority(int nNewPriority);

public final native function ResetPriority();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    m_nOverridePriority = -1
    CylinderComponent = CollisionCylinder
    Components = (None, None, None, CollisionCylinder, None)
    CollisionComponent = CollisionCylinder
}