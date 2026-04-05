Class SFXSeqAct_LinkLighting extends SequenceAction;

var(SFXSeqAct_LinkLighting) bool bLinkShadows;
var(SFXSeqAct_LinkLighting) bool bLinkEnvironment;

public event function Activated()
{
    local int nChildIdx;
    local MeshComponent oCurComponent;
    local Actor oCurChild;
    local Actor oTargetActor;
    local BioPawn oTargetPawn;
    local SkeletalMeshActor oTargetSkelMesh;
    local MeshComponent oShadowParent;
    local LightEnvironmentComponent oLightEnvironment;
    
    if (VariableLinks[1].LinkedVariables.Length == 1)
    {
        oTargetActor = Actor(SeqVar_Object(VariableLinks[1].LinkedVariables[0]).GetObjectValue());
    }
    else
    {
        oTargetPawn = None;
    }
    if (oTargetActor != None)
    {
        oTargetPawn = BioPawn(oTargetActor);
        oTargetSkelMesh = SkeletalMeshActor(oTargetActor);
        if (oTargetPawn != None)
        {
            oShadowParent = oTargetPawn.Mesh;
            oLightEnvironment = oTargetPawn.LightEnvironment;
        }
        else if (oTargetSkelMesh != None)
        {
            oShadowParent = oTargetSkelMesh.SkeletalMeshComponent;
            oLightEnvironment = oTargetSkelMesh.LightEnvironment;
        }
        else
        {
            foreach oTargetActor.ComponentList(Class'MeshComponent', oShadowParent)
            {
                break;
            }
            foreach oTargetActor.ComponentList(Class'LightEnvironmentComponent', oLightEnvironment)
            {
                break;
            }
        }
    }
    else
    {
        oShadowParent = None;
        oLightEnvironment = None;
    }
    for (nChildIdx = 0; nChildIdx < VariableLinks[0].LinkedVariables.Length; ++nChildIdx)
    {
        oCurChild = Actor(SeqVar_Object(VariableLinks[0].LinkedVariables[nChildIdx]).GetObjectValue());
        if (oCurChild != None)
        {
            foreach oCurChild.ComponentList(Class'MeshComponent', oCurComponent)
            {
                if (bLinkShadows)
                {
                    if (oShadowParent.Owner == oCurChild)
                    {
                        oCurComponent.SetShadowParent(None);
                    }
                    else
                    {
                        oCurComponent.SetShadowParent(oShadowParent);
                    }
                }
                if (bLinkEnvironment)
                {
                    oCurComponent.SetLightEnvironment(oLightEnvironment);
                }
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bLinkShadows = TRUE
    bLinkEnvironment = TRUE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Child", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Parent", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}