Class SFXSceneShopNodeKisVarCheck extends SFXSceneShopNode
    native;

const SFX_SS_KISVAR_FALSE_INDEX = 1;
const SFX_SS_KISVAR_TRUE_INDEX = 0;

var(SFXSceneShopNodeKisVarCheck) Name m_nmKismetBoolVarName;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_aOutputPins = ({
                      sLinkName = "True", 
                      aLinks = ()
                     }, 
                     {
                      sLinkName = "False", 
                      aLinks = ()
                     }
                    )
    m_aInputPins = ({
                     sLinkName = "In", 
                     aLinks = ()
                    }
                   )
}