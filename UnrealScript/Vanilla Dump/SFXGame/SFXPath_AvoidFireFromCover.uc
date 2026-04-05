Class SFXPath_AvoidFireFromCover extends PathConstraint
    native;

struct native EnemyCoverInfo 
{
    var CoverInfo Cover;
    var BioPawn Enemy;
};

var array<EnemyCoverInfo> EnemyList;
var SFXAI_Core AI;

public function Recycle()
{
    Super.Recycle();
    AI = None;
    EnemyList.Length = 0;
}
public static function bool AvoidFireFromCover(Pawn P, bool bCheckPlayerOnly)
{
    local SFXPath_AvoidFireFromCover Con;
    local SFXAI_Core oAI;
    local BioPawn Enemy;
    local EnemyCoverInfo EnemyInfo;
    local int i;
    
    oAI = SFXAI_Core(P.Controller);
    if (oAI != None)
    {
        Con = SFXPath_AvoidFireFromCover(P.CreatePathConstraint(default.Class));
        Con.AI = oAI;
        for (i = 0; i < oAI.EnemyList.Length; i++)
        {
            Enemy = BioPawn(oAI.EnemyList[i].Pawn);
            if (Enemy != None && Enemy.IsValidTargetFor(oAI) && oAI.GetPawnCover(Enemy, EnemyInfo.Cover))
            {
                if (!bCheckPlayerOnly || Enemy.IsPlayerOwned())
                {
                    EnemyInfo.Enemy = Enemy;
                    Con.EnemyList.AddItem(EnemyInfo);
                }
            }
        }
        if (Con.EnemyList.Length > 0)
        {
            P.AddPathConstraint(Con);
        }
        return TRUE;
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CacheIdx = 10
}