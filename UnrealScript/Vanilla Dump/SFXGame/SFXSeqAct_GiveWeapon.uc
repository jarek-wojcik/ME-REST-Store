Class SFXSeqAct_GiveWeapon extends SequenceAction;

var(SFXSeqAct_GiveWeapon) array<Class<SFXWeapon>> WeaponList;
var(SFXSeqAct_GiveWeapon) bool bClearExisting;
var(SFXSeqAct_GiveWeapon) bool bForceReplace;

public function Activated()
{
    local Class<SFXWeapon> WeaponClass;
    local SFXEngine Engine;
    local SFXPawn_Player pPawn;
    
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    pPawn = SFXPawn_Player(Targets[0]);
    if (pPawn == None && Targets[0] != None)
    {
        pPawn = SFXPawn_Player(Controller(Targets[0]).Pawn);
    }
    if (Engine != None && pPawn != None)
    {
        foreach WeaponList(WeaponClass, )
        {
            if (Engine.GetPlayerVariable(Name(PathName(WeaponClass))) < 1)
            {
                WeaponClass.static.Upgrade(pPawn, WeaponClass);
            }
        }
    }
    Super(SequenceOp).Activated();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}