Bot management UI and Data structure

Top level entity: Team

Team is comprised of multiple bots and has a specific Id (internal) and a name (external, user defined)

Bot belongs to a team and has a specific id, and type (Garrus, Tali, etc)

Bot will also have a Picture URL, A Weapon, and a list of Powers.

Power has an internal id(String) an external name (String) and an evolution choice- a 3 element array where the each element is either A or B. It also has a picture URL

A Weapon has an internal id(String) and an external name (String) and a picture URL. 

The UI should allow users to create new teams, add and remove bots from teams and edit bot details.

The Bot management UI will be part of a larger application.

The way it should be displayed is

Bot Management | Character Management | Match Settings

WHen I click on Bot Management it will display a list of Teams on the left. 

Selecting the Team will display the bots in that team on the right.

Each bot will display as a card with following elements

Bot Picture (clickable, displays list of available bots as pictures) Weapon (clickable, when clicked displays a list of weapons to select from as a table of pictures) then list of powers (1-5) and the evolution choice for each power A or B with a radio button to select between A and B. Each power will also have a picture.

e.g.:

________________________________________________________________________________________________________________
|                                                                                                              |
|   ________________________     _____________________________                                                 |
|   |                       |    |                           |    Power 1: Electrocute A ()  A ()  A ()        |
|   |                       |    |                           |                         B ()  B ()  B ()        |
|   |                       |    |                           |                                                 |
|   | Garrus Picture        |    | Weapon Picture (clickable)|    Power 2: Incinerate A ()  A ()  A ()         |
|   |                       |    |___________________________|                        B ()  B ()  B ()         |
|   |                       |                                                                                  |
|   |_______________________|                                     ... and so on for Power 3, Power 4, Power 5  |
|______________________________________________________________________________________________________________|

The powers will be predefined tof the bot type. But I should be able to click on the power Picture and select a different power from the list of available powers across all characters.
When I click on the power picture it will first display a list of all characters available, and then upon clicking the character it will display the powers from that character.