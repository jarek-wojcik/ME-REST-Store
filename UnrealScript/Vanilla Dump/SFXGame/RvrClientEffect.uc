Class RvrClientEffect extends RvrClientEffectInterface
    native;

const DefaultPreviewPhys = "BioEditorResources.ClientEffectPreviewPhys";
const DefaultPreviewMesh = "BioEditorResources.ClientEffectPreviewMesh";

var export array<RvrClientEffectModule> m_lstModules;

public native function ApplyParameters(RvrClientEffectComponent pComponent, RvrClientEffectModuleInstance pInstance, int nIndex);

public native function array<RvrClientEffectModule> GetModuleArray(RvrClientEffectComponent pComponent);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}