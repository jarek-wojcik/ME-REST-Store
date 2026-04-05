Class OnlineAccountInterface extends Interface
    abstract;

var delegate<OnCreateOnlineAccountCompleted> __OnCreateOnlineAccountCompleted__Delegate;

public function AddCreateOnlineAccountCompletedDelegate(delegate<OnCreateOnlineAccountCompleted> AccountCreateDelegate);

public function ClearCreateOnlineAccountCompletedDelegate(delegate<OnCreateOnlineAccountCompleted> AccountCreateDelegate);

public function bool CreateLocalAccount(string Username, optional string Password);

public function bool CreateOnlineAccount(string Username, string Password, string EmailAddress, optional string ProductKey);

public function bool DeleteLocalAccount(string Username, optional string Password);

public function bool GetLocalAccountNames(out array<string> Accounts);

public delegate function OnCreateOnlineAccountCompleted(EOnlineAccountCreateStatus ErrorStatus);

public function bool RenameLocalAccount(string NewUserName, string OldUserName, optional string Password);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}