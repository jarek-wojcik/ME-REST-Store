Class Scoreboard extends HUD
    transient
    config(Game);

var bool bDisplayMessages;

public function ChangeState(bool bIsVisible);

public function DrawHUD()
{
    UpdateGRI();
    UpdateScoreBoard();
}
public function bool UpdateGRI()
{
    if (WorldInfo.GRI == None)
    {
        return FALSE;
    }
    WorldInfo.GRI.SortPRIArray();
    return TRUE;
}
public function UpdateScoreBoard();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}