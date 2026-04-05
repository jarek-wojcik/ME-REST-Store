Class FileLog extends FileWriter
    native;

public function CloseLog()
{
    CloseFile();
}
public function OpenLog(coerce string LogFileName, optional string extension, optional bool bUnique)
{
    OpenFile(LogFileName, 0, extension, bUnique);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}