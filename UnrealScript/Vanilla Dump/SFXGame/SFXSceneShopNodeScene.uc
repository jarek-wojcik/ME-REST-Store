Class SFXSceneShopNodeScene extends SFXSceneShopNode
    native;

var(SFXSceneShopNodeScene) editconst SFXSceneGroup m_pLinkedScene;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_aOutputPins = ({
                      sLinkName = "Out", 
                      aLinks = ()
                     }
                    )
    m_aInputPins = ({
                     sLinkName = "In", 
                     aLinks = ()
                    }
                   )
}