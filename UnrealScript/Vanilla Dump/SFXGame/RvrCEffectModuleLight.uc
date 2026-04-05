Class RvrCEffectModuleLight extends RvrClientEffectModule
    native
    editinlinenew;

var(RvrCEffectModuleLight) editinline RawDistributionFloat Brightness;
var(RvrCEffectModuleLight) editinline RawDistributionVector ColorOverLife;
var(RvrCEffectModuleLight) editinline RawDistributionFloat Radius;
var(RvrCEffectModuleLight) Class<Light> m_pLightClass;
var(RvrCEffectModuleLight) bool m_bCastShadows;
var(RvrCEffectModuleLight) bool m_bCastStaticShadows;
var(RvrCEffectModuleLight) bool m_bCastDynamicShadows;
var(RvrCEffectModuleLight) bool m_bCastCompositeShadow;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DistributionFloatConstant Name=DistributionBrightness
        Constant = 1.0
    End Object
    Begin Object Class=DistributionFloatConstant Name=DistributionRadius
        Constant = 1000.0
    End Object
    Begin Object Class=DistributionVectorConstant Name=DistributionColor
        Constant = {X = 1.0, Y = 1.0, Z = 1.0}
    End Object
    Brightness = {
                  Distribution = DistributionBrightness, 
                  Type = 0, 
                  Op = 1, 
                  LookupTableNumElements = 1, 
                  LookupTableChunkSize = 1, 
                  LookupTable = (1.0, 1.0, 1.0, 1.0), 
                  LookupTableTimeScale = 0.0, 
                  LookupTableStartTime = 0.0
                 }
    ColorOverLife = {
                     Distribution = DistributionColor, 
                     Type = 0, 
                     Op = 1, 
                     LookupTableNumElements = 1, 
                     LookupTableChunkSize = 3, 
                     LookupTable = (1.0, 
                                    1.0, 
                                    1.0, 
                                    1.0, 
                                    1.0, 
                                    1.0, 
                                    1.0, 
                                    1.0
                                   ), 
                     LookupTableTimeScale = 0.0, 
                     LookupTableStartTime = 0.0
                    }
    Radius = {
              Distribution = DistributionRadius, 
              Type = 0, 
              Op = 1, 
              LookupTableNumElements = 1, 
              LookupTableChunkSize = 1, 
              LookupTable = (1000.0, 1000.0, 1000.0, 1000.0), 
              LookupTableTimeScale = 0.0, 
              LookupTableStartTime = 0.0
             }
    m_pLightClass = Class'RvrClientEffectPointLight'
    m_pInstanceClass = Class'RvrCEffectModuleLightInstance'
    m_bSoftStopsAreHard = TRUE
}