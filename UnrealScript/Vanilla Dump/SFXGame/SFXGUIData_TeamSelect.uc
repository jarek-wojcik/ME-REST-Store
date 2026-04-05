Class SFXGUIData_TeamSelect extends SFXGameChoiceGUIData
    editinlinenew
    config(UI);

struct SelectInfo 
{
    var Name MemberTag;
    var int InfoId;
    var int Ability1ID;
    var int Ability2ID;
    var int Ability3ID;
    var int Ability4ID;
    var int Ability5ID;
};
struct PowerInfo 
{
    var Name PowerName;
    var int PowerInfoID;
    var stringref DisplayName;
    var stringref Description;
};
struct AppearanceSet 
{
    var biodynamicload string HighlightImage;
    var biodynamicload string AvailableImage;
    var biodynamicload string DeadImage;
    var biodynamicload string SilhouetteImage;
    var array<stringref> DescriptionText;
    var array<int> CustomToken0;
    var Name MemberTag;
    var Name MemberAppearancePlotLabel;
    var int AppearanceId;
    var int MemberAppearanceValue;
    var int PlotUnlockCID;
};
struct SelectIdentity 
{
    var Name MemberTag;
    var Name MemberInPartyPlotLabel;
    var Name MemberAvailablePlotLabel;
    var int MemberId;
    var stringref MemberName;
    var stringref MemberDossier;
    var int MemberValidCID;
    var int MemberDeadPlotID;
};

var config array<SelectIdentity> HenchIdentities;
var config array<AppearanceSet> SelectAppearances;
var config array<PowerInfo> PowerInfos;
var config array<SelectInfo> SelectInfos;
var config string DefaultImage;
var config Name SelectName;
var config stringref srSelectTitle;
var config stringref srDefaultAButtonText;
var config stringref srDefaultBButtonText;
var config stringref srDefaultXButtonText;
var config stringref srDefaultYButtonText;
var config stringref srPartyConfirm;
var config stringref srPartyCancel;
var config stringref srPartyQuestion;
var config stringref srInfoExit;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    HenchIdentities = ({
                        MemberTag = 'hench_garrus', 
                        MemberInPartyPlotLabel = 'InSquadGarrus', 
                        MemberAvailablePlotLabel = 'IsSelectableGarrus', 
                        MemberId = 0, 
                        MemberName = $178197, 
                        MemberDossier = $338300, 
                        MemberValidCID = 20, 
                        MemberDeadPlotID = 0
                       }, 
                       {
                        MemberTag = 'hench_kaidan', 
                        MemberInPartyPlotLabel = 'InSquadKaidan', 
                        MemberAvailablePlotLabel = 'IsSelectableKaidan', 
                        MemberId = 1, 
                        MemberName = $188702, 
                        MemberDossier = $338299, 
                        MemberValidCID = 18, 
                        MemberDeadPlotID = 0
                       }, 
                       {
                        MemberTag = 'hench_edi', 
                        MemberInPartyPlotLabel = 'InSquadEDI', 
                        MemberAvailablePlotLabel = 'IsSelectableEDI', 
                        MemberId = 2, 
                        MemberName = $188353, 
                        MemberDossier = $338297, 
                        MemberValidCID = 21, 
                        MemberDeadPlotID = 0
                       }, 
                       {
                        MemberTag = 'hench_tali', 
                        MemberInPartyPlotLabel = 'InSquadTali', 
                        MemberAvailablePlotLabel = 'IsSelectableTali', 
                        MemberId = 3, 
                        MemberName = $178203, 
                        MemberDossier = $338296, 
                        MemberValidCID = 185, 
                        MemberDeadPlotID = 1
                       }, 
                       {
                        MemberTag = 'hench_liara', 
                        MemberInPartyPlotLabel = 'InSquadLiara', 
                        MemberAvailablePlotLabel = 'IsSelectableLiara', 
                        MemberId = 4, 
                        MemberName = $205754, 
                        MemberDossier = $178194, 
                        MemberValidCID = 17, 
                        MemberDeadPlotID = 0
                       }, 
                       {
                        MemberTag = 'hench_prothean', 
                        MemberInPartyPlotLabel = 'InSquadProthean', 
                        MemberAvailablePlotLabel = 'IsSelectableProthean', 
                        MemberId = 5, 
                        MemberName = $500142, 
                        MemberDossier = $524655, 
                        MemberValidCID = 22, 
                        MemberDeadPlotID = 0
                       }, 
                       {
                        MemberTag = 'hench_marine', 
                        MemberInPartyPlotLabel = 'InSquadMarine', 
                        MemberAvailablePlotLabel = 'IsSelectableMarine', 
                        MemberId = 6, 
                        MemberName = $500147, 
                        MemberDossier = $338293, 
                        MemberValidCID = 33, 
                        MemberDeadPlotID = 0
                       }, 
                       {
                        MemberTag = 'hench_ashley', 
                        MemberInPartyPlotLabel = 'InSquadAshley', 
                        MemberAvailablePlotLabel = 'IsSelectableAshley', 
                        MemberId = 7, 
                        MemberName = $206249, 
                        MemberDossier = $346233, 
                        MemberValidCID = 19, 
                        MemberDeadPlotID = 0
                       }
                      )
    SelectAppearances = ({
                          HighlightImage = "GUI_Henchmen_Images.Garrus0Glow", 
                          AvailableImage = "GUI_Henchmen_Images.Garrus0", 
                          DeadImage = "GUI_Henchmen_Images.PlaceHolder", 
                          SilhouetteImage = "GUI_Henchmen_Images.Garrus0_locked", 
                          DescriptionText = ($683395), 
                          CustomToken0 = (25), 
                          MemberTag = 'hench_garrus', 
                          MemberAppearancePlotLabel = 'AppearanceGarrus', 
                          AppearanceId = 0, 
                          MemberAppearanceValue = 0, 
                          PlotUnlockCID = 0
                         }, 
                         {
                          HighlightImage = "GUI_Henchmen_Images.Garrus1Glow", 
                          AvailableImage = "GUI_Henchmen_Images.Garrus1", 
                          DeadImage = "GUI_Henchmen_Images.PlaceHolder", 
                          SilhouetteImage = "GUI_Henchmen_Images.Garrus0_locked", 
                          DescriptionText = ($683402), 
                          CustomToken0 = (25), 
                          MemberTag = 'hench_garrus', 
                          MemberAppearancePlotLabel = 'AppearanceGarrus', 
                          AppearanceId = 1, 
                          MemberAppearanceValue = 1, 
                          PlotUnlockCID = 0
                         }, 
                         {
                          HighlightImage = "GUI_Henchmen_Images.Kaidan0Glow", 
                          AvailableImage = "GUI_Henchmen_Images.Kaidan0", 
                          DeadImage = "GUI_Henchmen_Images.PlaceHolder", 
                          SilhouetteImage = "GUI_Henchmen_Images.Kaidan0_locked", 
                          DescriptionText = ($718121), 
                          CustomToken0 = (25), 
                          MemberTag = 'hench_kaidan', 
                          MemberAppearancePlotLabel = 'AppearanceKaidan', 
                          AppearanceId = 2, 
                          MemberAppearanceValue = 0, 
                          PlotUnlockCID = 0
                         }, 
                         {
                          HighlightImage = "GUI_Henchmen_Images.Kaidan1Glow", 
                          AvailableImage = "GUI_Henchmen_Images.Kaidan1", 
                          DeadImage = "GUI_Henchmen_Images.PlaceHolder", 
                          SilhouetteImage = "GUI_Henchmen_Images.Kaidan0_locked", 
                          DescriptionText = ($683399), 
                          CustomToken0 = (25), 
                          MemberTag = 'hench_kaidan', 
                          MemberAppearancePlotLabel = 'AppearanceKaidan', 
                          AppearanceId = 3, 
                          MemberAppearanceValue = 1, 
                          PlotUnlockCID = 0
                         }, 
                         {
                          HighlightImage = "GUI_Henchmen_Images.EDI0Glow", 
                          AvailableImage = "GUI_Henchmen_Images.EDI0", 
                          DeadImage = "GUI_Henchmen_Images.PlaceHolder", 
                          SilhouetteImage = "GUI_Henchmen_Images.EDI0_locked", 
                          DescriptionText = ($683399), 
                          CustomToken0 = (25), 
                          MemberTag = 'hench_edi', 
                          MemberAppearancePlotLabel = 'AppearanceEDI', 
                          AppearanceId = 4, 
                          MemberAppearanceValue = 0, 
                          PlotUnlockCID = 0
                         }, 
                         {
                          HighlightImage = "GUI_Henchmen_Images.EDI1Glow", 
                          AvailableImage = "GUI_Henchmen_Images.EDI1", 
                          DeadImage = "GUI_Henchmen_Images.PlaceHolder", 
                          SilhouetteImage = "GUI_Henchmen_Images.EDI0_locked", 
                          DescriptionText = ($718121), 
                          CustomToken0 = (25), 
                          MemberTag = 'hench_edi', 
                          MemberAppearancePlotLabel = 'AppearanceEDI', 
                          AppearanceId = 5, 
                          MemberAppearanceValue = 1, 
                          PlotUnlockCID = 0
                         }, 
                         {
                          HighlightImage = "GUI_Henchmen_Images.Tali0Glow", 
                          AvailableImage = "GUI_Henchmen_Images.Tali0", 
                          DeadImage = "GUI_Henchmen_Images.Tali0_dead", 
                          SilhouetteImage = "GUI_Henchmen_Images.Tali0_locked", 
                          DescriptionText = ($683399), 
                          CustomToken0 = (25), 
                          MemberTag = 'hench_tali', 
                          MemberAppearancePlotLabel = 'AppearanceTali', 
                          AppearanceId = 6, 
                          MemberAppearanceValue = 0, 
                          PlotUnlockCID = 0
                         }, 
                         {
                          HighlightImage = "GUI_Henchmen_Images.Tali1Glow", 
                          AvailableImage = "GUI_Henchmen_Images.Tali1", 
                          DeadImage = "GUI_Henchmen_Images.Tali0_dead", 
                          SilhouetteImage = "GUI_Henchmen_Images.Tali0_locked", 
                          DescriptionText = ($718121), 
                          CustomToken0 = (25), 
                          MemberTag = 'hench_tali', 
                          MemberAppearancePlotLabel = 'AppearanceTali', 
                          AppearanceId = 7, 
                          MemberAppearanceValue = 1, 
                          PlotUnlockCID = 0
                         }, 
                         {
                          HighlightImage = "GUI_Henchmen_Images.Liara0Glow", 
                          AvailableImage = "GUI_Henchmen_Images.Liara0", 
                          DeadImage = "GUI_Henchmen_Images.PlaceHolder", 
                          SilhouetteImage = "GUI_Henchmen_Images.Liara0_locked", 
                          DescriptionText = ($683399), 
                          CustomToken0 = (25), 
                          MemberTag = 'hench_liara', 
                          MemberAppearancePlotLabel = 'AppearanceLiara', 
                          AppearanceId = 8, 
                          MemberAppearanceValue = 0, 
                          PlotUnlockCID = 0
                         }, 
                         {
                          HighlightImage = "GUI_Henchmen_Images.Liara1Glow", 
                          AvailableImage = "GUI_Henchmen_Images.Liara1", 
                          DeadImage = "GUI_Henchmen_Images.PlaceHolder", 
                          SilhouetteImage = "GUI_Henchmen_Images.Liara0_locked", 
                          DescriptionText = ($718121), 
                          CustomToken0 = (25), 
                          MemberTag = 'hench_liara', 
                          MemberAppearancePlotLabel = 'AppearanceLiara', 
                          AppearanceId = 9, 
                          MemberAppearanceValue = 1, 
                          PlotUnlockCID = 0
                         }, 
                         {
                          HighlightImage = "GUI_Henchmen_Images.Prothean0Glow", 
                          AvailableImage = "GUI_Henchmen_Images.Prothean0", 
                          DeadImage = "GUI_Henchmen_Images.PlaceHolder", 
                          SilhouetteImage = "GUI_Henchmen_Images.Prothean0_locked", 
                          DescriptionText = ($683399), 
                          CustomToken0 = (25), 
                          MemberTag = 'hench_prothean', 
                          MemberAppearancePlotLabel = 'AppearanceProthean', 
                          AppearanceId = 10, 
                          MemberAppearanceValue = 0, 
                          PlotUnlockCID = 0
                         }, 
                         {
                          HighlightImage = "GUI_Henchmen_Images.James0Glow", 
                          AvailableImage = "GUI_Henchmen_Images.James0", 
                          DeadImage = "GUI_Henchmen_Images.PlaceHolder", 
                          SilhouetteImage = "GUI_Henchmen_Images.James0_locked", 
                          DescriptionText = ($683395), 
                          CustomToken0 = (25), 
                          MemberTag = 'hench_marine', 
                          MemberAppearancePlotLabel = 'AppearanceMarine', 
                          AppearanceId = 11, 
                          MemberAppearanceValue = 0, 
                          PlotUnlockCID = 0
                         }, 
                         {
                          HighlightImage = "GUI_Henchmen_Images.James1Glow", 
                          AvailableImage = "GUI_Henchmen_Images.James1", 
                          DeadImage = "GUI_Henchmen_Images.PlaceHolder", 
                          SilhouetteImage = "GUI_Henchmen_Images.James0_locked", 
                          DescriptionText = ($683402), 
                          CustomToken0 = (25), 
                          MemberTag = 'hench_marine', 
                          MemberAppearancePlotLabel = 'AppearanceMarine', 
                          AppearanceId = 12, 
                          MemberAppearanceValue = 1, 
                          PlotUnlockCID = 0
                         }, 
                         {
                          HighlightImage = "GUI_Henchmen_Images.Ashley0Glow", 
                          AvailableImage = "GUI_Henchmen_Images.Ashley0", 
                          DeadImage = "GUI_Henchmen_Images.PlaceHolder", 
                          SilhouetteImage = "GUI_Henchmen_Images.Ashley0_locked", 
                          DescriptionText = ($683402), 
                          CustomToken0 = (25), 
                          MemberTag = 'hench_ashley', 
                          MemberAppearancePlotLabel = 'AppearanceAshley', 
                          AppearanceId = 13, 
                          MemberAppearanceValue = 0, 
                          PlotUnlockCID = 0
                         }, 
                         {
                          HighlightImage = "GUI_Henchmen_Images.Ashley1Glow", 
                          AvailableImage = "GUI_Henchmen_Images.Ashley1", 
                          DeadImage = "GUI_Henchmen_Images.PlaceHolder", 
                          SilhouetteImage = "GUI_Henchmen_Images.Ashley0_locked", 
                          DescriptionText = ($683395), 
                          CustomToken0 = (25), 
                          MemberTag = 'hench_ashley', 
                          MemberAppearancePlotLabel = 'AppearanceAshley', 
                          AppearanceId = 14, 
                          MemberAppearanceValue = 1, 
                          PlotUnlockCID = 0
                         }
                        )
    PowerInfos = ({PowerName = 'DisruptorAmmo', PowerInfoID = 0, DisplayName = $505658, Description = $664216}, 
                  {PowerName = 'IncendiaryAmmo', PowerInfoID = 1, DisplayName = $93964, Description = $703485}, 
                  {PowerName = 'ArmorPiercingAmmo', PowerInfoID = 2, DisplayName = $93965, Description = $155053}, 
                  {PowerName = 'WarpAmmo', PowerInfoID = 3, DisplayName = $326671, Description = $326672}, 
                  {PowerName = 'ConcussiveShot', PowerInfoID = 4, DisplayName = $190258, Description = $190259}, 
                  {PowerName = 'InfernoGrenade', PowerInfoID = 5, DisplayName = $349055, Description = $703559}, 
                  {PowerName = 'Fortification', PowerInfoID = 6, DisplayName = $314036, Description = $314037}, 
                  {PowerName = 'FragGrenade', PowerInfoID = 7, DisplayName = $506269, Description = $703562}, 
                  {PowerName = 'Marksman', PowerInfoID = 8, DisplayName = $572088, Description = $703576}, 
                  {PowerName = 'ProximityMine', PowerInfoID = 9, DisplayName = $572665, Description = $703577}, 
                  {PowerName = 'Carnage', PowerInfoID = 10, DisplayName = $668831, Description = $690808}, 
                  {PowerName = 'Singularity', PowerInfoID = 11, DisplayName = $127058, Description = $703579}, 
                  {PowerName = 'Shockwave', PowerInfoID = 12, DisplayName = $314056, Description = $703605}, 
                  {PowerName = 'Warp', PowerInfoID = 13, DisplayName = $501005, Description = $170520}, 
                  {PowerName = 'Barrier', PowerInfoID = 14, DisplayName = $93973, Description = $155065}, 
                  {PowerName = 'Reave', PowerInfoID = 15, DisplayName = $314878, Description = $314879}, 
                  {PowerName = 'Stasis', PowerInfoID = 16, DisplayName = $127059, Description = $703654}, 
                  {PowerName = 'BioticGrenade', PowerInfoID = 17, DisplayName = $660491, Description = $703655}, 
                  {PowerName = 'Slam', PowerInfoID = 18, DisplayName = $542178, Description = $716449}, 
                  {PowerName = 'DarkChannel', PowerInfoID = 19, DisplayName = $716448, Description = $716450}, 
                  {PowerName = 'Incinerate', PowerInfoID = 20, DisplayName = $244472, Description = $664218}, 
                  {PowerName = 'Overload', PowerInfoID = 21, DisplayName = $250696, Description = $682935}, 
                  {PowerName = 'Hacking', PowerInfoID = 22, DisplayName = $536448, Description = $664221}, 
                  {PowerName = 'CryoBlast', PowerInfoID = 23, DisplayName = $325479, Description = $682936}, 
                  {PowerName = 'CombatDrone', PowerInfoID = 24, DisplayName = $199784, Description = $703685}, 
                  {PowerName = 'GethShieldBoost', PowerInfoID = 25, DisplayName = $314066, Description = $314067}, 
                  {PowerName = 'EnergyDrain', PowerInfoID = 26, DisplayName = $205894, Description = $703687}, 
                  {PowerName = 'Decoy', PowerInfoID = 27, DisplayName = $674631, Description = $690836}, 
                  {PowerName = 'ProtectorDrone', PowerInfoID = 28, DisplayName = $663224, Description = $690854}, 
                  {PowerName = 'DisruptorAmmo', PowerInfoID = 29, DisplayName = $505658, Description = $664216}, 
                  {PowerName = 'AshleyPassive', PowerInfoID = 30, DisplayName = $572512, Description = $572513}, 
                  {PowerName = 'KaidenPassive', PowerInfoID = 31, DisplayName = $572512, Description = $579350}, 
                  {PowerName = 'LiaraPassive', PowerInfoID = 32, DisplayName = $537961, Description = $537962}, 
                  {PowerName = 'EDIPassive', PowerInfoID = 33, DisplayName = $663213, Description = $704189}, 
                  {PowerName = 'GarrusPassive', PowerInfoID = 34, DisplayName = $573513, Description = $704190}, 
                  {PowerName = 'JimmyPassive', PowerInfoID = 35, DisplayName = $537919, Description = $704191}, 
                  {PowerName = 'TaliPassive', PowerInfoID = 36, DisplayName = $690872, Description = $704192}, 
                  {PowerName = 'ProtheanPassive', PowerInfoID = 37, DisplayName = $716452, Description = $716451}, 
                  {PowerName = 'LiftGrenade', PowerInfoID = 38, DisplayName = $538988, Description = $703657}, 
                  {PowerName = 'Pull', PowerInfoID = 39, DisplayName = $189298, Description = $703578}
                 )
    SelectInfos = ({
                    MemberTag = 'hench_garrus', 
                    InfoId = 0, 
                    Ability1ID = 2, 
                    Ability2ID = 4, 
                    Ability3ID = 9, 
                    Ability4ID = 21, 
                    Ability5ID = 34
                   }, 
                   {
                    MemberTag = 'hench_kaidan', 
                    InfoId = 1, 
                    Ability1ID = 14, 
                    Ability2ID = 15, 
                    Ability3ID = 21, 
                    Ability4ID = 23, 
                    Ability5ID = 31
                   }, 
                   {
                    MemberTag = 'hench_edi', 
                    InfoId = 2, 
                    Ability1ID = 20, 
                    Ability2ID = 21, 
                    Ability3ID = 25, 
                    Ability4ID = 27, 
                    Ability5ID = 33
                   }, 
                   {
                    MemberTag = 'hench_tali', 
                    InfoId = 3, 
                    Ability1ID = 22, 
                    Ability2ID = 24, 
                    Ability3ID = 26, 
                    Ability4ID = 28, 
                    Ability5ID = 36
                   }, 
                   {
                    MemberTag = 'hench_liara', 
                    InfoId = 4, 
                    Ability1ID = 3, 
                    Ability2ID = 11, 
                    Ability3ID = 13, 
                    Ability4ID = 16, 
                    Ability5ID = 32
                   }, 
                   {
                    MemberTag = 'hench_prothean', 
                    InfoId = 5, 
                    Ability1ID = 19, 
                    Ability2ID = 38, 
                    Ability3ID = 39, 
                    Ability4ID = 18, 
                    Ability5ID = 37
                   }, 
                   {
                    MemberTag = 'hench_marine', 
                    InfoId = 6, 
                    Ability1ID = 1, 
                    Ability2ID = 6, 
                    Ability3ID = 7, 
                    Ability4ID = 10, 
                    Ability5ID = 30
                   }, 
                   {
                    MemberTag = 'hench_ashley', 
                    InfoId = 7, 
                    Ability1ID = 0, 
                    Ability2ID = 4, 
                    Ability3ID = 5, 
                    Ability4ID = 8, 
                    Ability5ID = 35
                   }
                  )
    DefaultImage = "GUI_Henchmen_Images.Garrus"
    SelectName = 'SquadSelect'
    srSelectTitle = $387214
    srDefaultAButtonText = $163280
    srDefaultBButtonText = $529360
    srDefaultXButtonText = $338057
    srDefaultYButtonText = $700139
    srPartyConfirm = $168245
    srPartyCancel = $168246
    srPartyQuestion = $168244
    srInfoExit = $641195
}