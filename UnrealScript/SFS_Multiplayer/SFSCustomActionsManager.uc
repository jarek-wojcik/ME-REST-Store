Class SFSCustomActionsManager extends SFSManager within SFXPawn;

const EvadeRangeStart = 54;
const EvadeRangeEnd = 57;
const HeavyMeleeIndex = 58;
const OptionalHeavyMeleeIndex = 73;
const LightMeleeRangeStart = 75;
const LightMeleeRangeEnd = 80;

public function exchangeHeavyMelee(SFXPawn_PlayerMP Source, SFXPawn_PlayerMP Target)
{
    //Need to pay attention to the player cast sound. Looking at the N7 adept and the cerberus vanguard, 
    //both have a SFXTimelineData object named Timeline0. This timelineData object contains an array of TimelineEffect structs in the TimelineVar
    //The number of timeline structs is variables, so we need to iterate over them on both Source and Target to find a timeline where 
    //The Sound and PlayerSound variables contain a string like "cast" and swap them across.
    //Otherwise a female character might sound like a male and vice versa.
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}