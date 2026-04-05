Class LightmassPrimitiveSettingsObject
    native
    editinlinenew;

var(Lightmass) LightmassPrimitiveSettings LightmassSettings;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    LightmassSettings = {
                         bUseTwoSidedLighting = FALSE, 
                         bShadowIndirectOnly = FALSE, 
                         bUseEmissiveForStaticLighting = FALSE, 
                         EmissiveLightFalloffExponent = 2.0, 
                         EmissiveLightExplicitInfluenceRadius = 0.0, 
                         EmissiveBoost = 1.0, 
                         DiffuseBoost = 1.0, 
                         SpecularBoost = 1.0, 
                         FullyOccludedSamplesFraction = 1.0
                        }
}