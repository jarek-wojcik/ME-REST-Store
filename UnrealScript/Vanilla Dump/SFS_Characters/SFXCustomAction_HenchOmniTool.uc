Class SFXCustomAction_HenchOmniTool extends SFXCustomAction_LoopingInteraction
    config(Game);

var Guid OmniToolGuid;
var RvrClientEffectInterface OmniToolVFX;

public function StartCustomAction()
{
    Super.StartCustomAction();
    if (m_oPawn != None)
    {
        OmniToolGuid = Class'RvrClientEffectManager'.static.GetClientEffectManager().Start(OmniToolVFX, m_oPawn);
    }
}
public function bool CanOverrideMoveWith(int OldCustomAction, int NewCustomAction)
{
    local int idx;
    local Class<BioCustomAction> NewClass;
    local Class<BioCustomAction> OldClass;
    
    OldClass = GetCustomActionClass(OldCustomAction);
    NewClass = GetCustomActionClass(NewCustomAction);
    if (NewClass != None && OldClass != None)
    {
        if (NewClass.default.Priority != ECustomActionPriority.CA_Priority_None && int(NewClass.default.Priority) > int(OldClass.default.Priority))
        {
            return TRUE;
        }
        for (idx = 0; idx < OverrideList.Length; idx++)
        {
            if (ClassIsChildOf(NewClass, OverrideList[idx]))
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}
public function StopCustomAction()
{
    Super.StopCustomAction();
    Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(OmniToolVFX, OmniToolGuid, TRUE);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    OmniToolVFX = RvrClientEffectMulti'BioVFX_T_TechPowers._OmniTool.VCFX.OmniTool_LeftFull_VCFX_M'
    BS_InteractionStart = {
                           AnimName = ('WI_OmniEnter')
                          }
    BS_InteractionLoop = {
                          AnimName = ('WI_OmniTwitch')
                         }
    BS_InteractionEnd = {
                         AnimName = ('WI_OmniExit')
                        }
    bHideWeapon = TRUE
    Priority = ECustomActionPriority.CA_Priority_SuperHigh
}