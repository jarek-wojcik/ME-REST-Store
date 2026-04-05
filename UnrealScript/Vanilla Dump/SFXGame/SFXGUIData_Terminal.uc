Class SFXGUIData_Terminal extends SFXGameChoiceGUIData
    native
    editinlinenew
    perobjectconfig
    config(UI);

struct native TerminalItemData 
{
    var biodynamicload string LargeImage;
    var biodynamicload string SmallImage;
    var stringref ItemTitle;
    var stringref ItemDesc;
    var int PlotUnlockID;
    var stringref AButtonText;
    var stringref BButtonText;
};

var config array<TerminalItemData> TerminalItemArray;
var config string DefaultImage;
var config Name TerminalName;
var config stringref srTerminalTitle;
var config stringref srTerminalDescription;
var config stringref srDefaultAButtonText;
var config stringref srDefaultBButtonText;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TerminalItemArray = ({
                          LargeImage = "GUI_Codex_Images.Fortification_512", 
                          SmallImage = "GUI_Codex_Images.Fortification_512", 
                          ItemTitle = $335571, 
                          ItemDesc = $724792, 
                          PlotUnlockID = 0, 
                          AButtonText = $244393, 
                          BButtonText = $529360
                         }, 
                         {
                          LargeImage = "GUI_Codex_Images.Fortification_512", 
                          SmallImage = "GUI_Codex_Images.Fortification_512", 
                          ItemTitle = $315188, 
                          ItemDesc = $724791, 
                          PlotUnlockID = 0, 
                          AButtonText = $244393, 
                          BButtonText = $529360
                         }, 
                         {
                          LargeImage = "GUI_Codex_Images.Fortification_512", 
                          SmallImage = "GUI_Codex_Images.Fortification_512", 
                          ItemTitle = $338063, 
                          ItemDesc = $724817, 
                          PlotUnlockID = 0, 
                          AButtonText = $244393, 
                          BButtonText = $529360
                         }
                        )
    DefaultImage = "GUI_Codex_Images.Fortification_512"
    TerminalName = 'ShepardPersonalTerminal'
    srTerminalTitle = $346114
    srTerminalDescription = $346114
    srDefaultAButtonText = $244393
    srDefaultBButtonText = $529360
}