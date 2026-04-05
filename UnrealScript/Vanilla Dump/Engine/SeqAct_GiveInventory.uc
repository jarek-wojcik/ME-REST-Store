Class SeqAct_GiveInventory extends SequenceAction;

var(SeqAct_GiveInventory) array<Class<Inventory>> InventoryList;
var(SeqAct_GiveInventory) bool bClearExisting;
var(SeqAct_GiveInventory) bool bForceReplace;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}