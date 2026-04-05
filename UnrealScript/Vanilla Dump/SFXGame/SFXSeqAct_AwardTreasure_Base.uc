Class SFXSeqAct_AwardTreasure_Base extends SequenceAction
    native
    abstract;

enum ETreasureIndex
{
    TREASURE_ONE,
    TREASURE_TWO,
    TREASURE_THREE,
    TREASURE_FOUR,
    TREASURE_FIVE,
    TREASURE_SIX,
    TREASURE_SEVEN,
    TREASURE_EIGHT,
    TREASURE_NINE,
    TREASURE_TEN,
};

var(SFXSeqAct_AwardTreasure_Base) ETreasureIndex TREASURE;

public function Activated()
{
    Super(SequenceOp).Activated();
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}