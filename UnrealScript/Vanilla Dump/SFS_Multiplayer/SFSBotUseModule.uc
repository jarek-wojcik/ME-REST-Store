Class SFSBotUseModule extends SFXSimpleUseModule within SFXPawn;

public event function HandlePostAdd()
{
    __OnUsed__Delegate = useBot;
    SetTargetable(TRUE);
    fUseRange = 1500.0;
    m_TargetTipText = ETargetTipText.TargetTipText_None;
    BioWorldInfo(Outer.WorldInfo).SelectableActors.AddItem(Outer);
}
public function useBot(Actor User)
{
    local SFXPawn sfxUser;
    local SFSWeaponManager weaponManager;
    
    sfxUser = SFXPawn(User);
    if (sfxUser != None)
    {
        weaponManager = sfxUser.GetModule(Class'SFSWeaponManager');
        if (weaponManager != None)
        {
            weaponManager.exchangeWeapons(SFXPawn(ModuleOwner));
        }
    }
}
public function followMe(Actor User)
{
    local SFXAI_Bot botAI;
    
    //We're going to scrap all of this, and instead have this work like Halo mechanic where you can take weapons from others
    botAI = SFXAI_Bot(Outer.Controller);
    if (botAI != None)
    {
        if (botAI.FollowPlayer)
        {
            Class'SFSCore'.static.log(Self.Name, "Not following player anymore", Outer);
            botAI.FollowPlayer = FALSE;
        }
        else
        {
            Class'SFSCore'.static.log(Self.Name, "Following player", Outer);
            botAI.FollowPlayer = TRUE;
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}