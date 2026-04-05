Class BioEngineEnums
    native
    collapsecategories;

struct native BioStageDOFData 
{
    var(BioStageDOFData) float fFocusInnerRadius;
    var(BioStageDOFData) float fFocusDistance;
    var(BioStageDOFData) bool bEnable;
    
    structdefaultproperties
    {
        fFocusInnerRadius = 600.0
        fFocusDistance = 600.0
    }
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}