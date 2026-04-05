Class SFXGUIData_Elevator extends SFXGameChoiceGUIData
    native
    editinlinenew
    perobjectconfig
    config(UI);

struct native ElevatorDestinationData 
{
    var biodynamicload string LargeImage;
    var biodynamicload string SmallImage;
    var int DestId;
    var stringref DestTitle;
    var stringref DestSubTitle;
    var stringref DestDesc;
    var int PlotUnlockID;
    var stringref AButtonText;
    var stringref BButtonText;
};

var config array<ElevatorDestinationData> ElevatorDestinations;
var config string DefaultImage;
var config Name ElevatorName;
var config stringref srElevatorTitle;
var config stringref srElevatorDescription;
var config stringref srDefaultAButtonText;
var config stringref srDefaultBButtonText;

public function DestinationDescString(SFXGUIMovie Elevator, ElevatorDestinationData Destination, out string Desc)
{
    Desc = Elevator.GetUIString(Destination.DestDesc, FALSE);
}
public function DestinationTitleString(SFXGUIMovie Elevator, ElevatorDestinationData Destination, out string Title)
{
    Title = Elevator.GetUIString(Destination.DestTitle, FALSE);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DefaultImage = "GUI_Codex_Images.Fortification_512"
    ElevatorName = 'Base'
    srElevatorTitle = $346114
    srElevatorDescription = $346114
    srDefaultAButtonText = $244393
    srDefaultBButtonText = $529360
}