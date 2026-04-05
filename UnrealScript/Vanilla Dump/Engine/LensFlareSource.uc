Class LensFlareSource extends Actor
    native
    placeable;

var(LensFlareSource) const editinline editconst export LensFlareComponent LensFlareComp;
var repnotify bool bCurrentlyActive;

public simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        LensFlareComp.SetIsActive(TRUE);
        bCurrentlyActive = TRUE;
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        LensFlareComp.SetIsActive(FALSE);
        bCurrentlyActive = FALSE;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        if (!bCurrentlyActive)
        {
            LensFlareComp.SetIsActive(TRUE);
            bCurrentlyActive = TRUE;
        }
        else
        {
            LensFlareComp.SetIsActive(FALSE);
            bCurrentlyActive = FALSE;
        }
    }
    LensFlareComp.LastRenderTime = WorldInfo.TimeSeconds;
    ForceNetRelevant();
}
public simulated function SetActorParameter(Name ParameterName, Actor Param);

public simulated function SetColorParameter(Name ParameterName, LinearColor Param);

public simulated function SetFloatParameter(Name ParameterName, float Param);

public final native function SetTemplate(LensFlare NewTemplate);

public simulated function SetVectorParameter(Name ParameterName, Vector Param);

public simulated function SetExtColorParameter(Name ParameterName, float Red, float Green, float Blue, float Alpha);


replication
{
    if (bNoDelete)
        bCurrentlyActive;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=LensFlareComponent Name=LensFlareComponent0
        ReplacementPrimitive = None
    End Object
    LensFlareComp = LensFlareComponent0
    Components = (None, None, None, None, LensFlareComponent0, None)
    bNoDelete = TRUE
    bHardAttach = TRUE
    bGameRelevant = TRUE
    bEdShouldSnap = TRUE
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}