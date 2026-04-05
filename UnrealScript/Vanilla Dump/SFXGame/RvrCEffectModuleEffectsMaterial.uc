Class RvrCEffectModuleEffectsMaterial extends RvrClientEffectModule
    native
    editinlinenew;

var(RvrCEffectModuleEffectsMaterial) editinline RawDistributionFloat m_FractionEnabled;
var(RvrCEffectModuleEffectsMaterial) Name m_nmEffect;
var(RvrCEffectModuleEffectsMaterial) bool m_bAllAttachments;
var(RvrCEffectModuleEffectsMaterial) EEffectLocationTarget m_eTarget;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionFractionEnabled
        Constant = 1.0
    End Object
    m_FractionEnabled = {
                         Distribution = DistributionFractionEnabled, 
                         Type = 0, 
                         Op = 1, 
                         LookupTableNumElements = 1, 
                         LookupTableChunkSize = 1, 
                         LookupTable = (1.0, 1.0, 1.0, 1.0), 
                         LookupTableTimeScale = 0.0, 
                         LookupTableStartTime = 0.0
                        }
    m_eTarget = EEffectLocationTarget.ELT_Instigator
    m_pInstanceClass = Class'RvrCEffectModuleEffectsMaterialInstance'
    m_bSoftStopsAreHard = TRUE
    m_bExclusiveOnTarget = TRUE
}