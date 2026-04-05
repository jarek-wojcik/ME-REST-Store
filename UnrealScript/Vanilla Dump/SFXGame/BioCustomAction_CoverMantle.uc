Class BioCustomAction_CoverMantle extends BioCustomAction_CoverClimbMantleBase
    config(Game);

var transient array<Actor> aBumpList;
var transient Vector vStartLocation;

public function bool NotifyBump(Actor Other, Vector HitNormal)
{
    local BioPawn OtherPawn;
    local Vector Dir;
    
    OtherPawn = BioPawn(Other);
    if (OtherPawn != None)
    {
        Dir = Normal(OtherPawn.location - m_oPawn.location) * 100.0;
        if (OtherPawn.Role == ENetRole.ROLE_Authority)
        {
            if (OtherPawn.RequestReaction(1, m_oPawn.Controller, Dir))
            {
                OtherPawn.ReplicateAnimatedReaction(OtherPawn.CurrentCustomAction);
            }
        }
        if (aBumpList.Find(Other) == -1)
        {
            aBumpList.AddItem(Other);
        }
    }
    return TRUE;
}
public function StartCustomAction()
{
    vStartLocation = m_oPawn.location;
    Super.StartCustomAction();
}
public function BodyStanceAnimEndNotification(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    Super.BodyStanceAnimEndNotification(SeqNode, PlayedTime, ExcessTime);
}
public function StopCustomAction()
{
    local Vector vDir2D;
    
    Super.StopCustomAction();
    if (aBumpList.Length != 0)
    {
        vDir2D = m_oPawn.location - vStartLocation;
        vDir2D.Z = 0.0;
        vDir2D = Normal(vDir2D);
        m_oPawn.Acceleration = 1000.0 * vDir2D;
    }
    aBumpList.Length = 0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_BS_StanceFromExplore = {
                              AnimName = ('EX_Mantle_Start')
                             }
    m_BS_StanceFromCombat = {
                             AnimName = ('CB_Mantle_Start')
                            }
    m_BS_StanceFromCover = {
                            AnimName = ('CB_Mantle_Start_Cover')
                           }
}