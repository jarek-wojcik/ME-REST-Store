Class Bio2DA
    native;

struct native Bio2daMasterRowIndexRec 
{
    var int nRowIndex;
    var Bio2DA pTable;
};
struct Bio2DACellData 
{
    var byte nDataType_NATIVE_MIRROR;
    var Pointer nData_NATIVE_MIRROR;
};
const BIO2DA_INDEX_ERROR = -1;

var const native Map_Mirror m_CellDataMap;
var native Map_Mirror m_MasterRowNameToIndex;
var native Map_Mirror m_ColumnIndex;
var const native array<Bio2DACellData> m_CellData;
var native array<Bio2daMasterRowIndexRec> m_MasterRowIndex;
var array<Name> m_sRowLabel;

public native function int GetColumnIndex(Name nmColumnLabel);

public native function Name GetColumnName(int nColumn);

public native function array<Name> GetColumnNames();

public native function bool GetFloatEntryII(int nRow, int nColumn, out float fEntry);

public native function bool GetFloatEntryIN(int nRow, Name sColumn, out float fEntry);

public native function bool GetFloatEntryNI(Name sRow, int nColumn, out float fEntry);

public native function bool GetFloatEntryNN(Name sRow, Name sColumn, out float fEntry);

public native function bool GetFloatEntryNumI(int nRowID, int nColumn, out float fEntry);

public native function bool GetFloatEntryNumN(int nRowID, Name sColumn, out float fEntry);

public native function bool GetIntEntryII(int nRow, int nColumn, out int nEntry);

public native function bool GetIntEntryIN(int nRow, Name sColumn, out int nEntry);

public native function bool GetIntEntryNI(Name sRow, int nColumn, out int nEntry);

public native function bool GetIntEntryNN(Name sRow, Name sColumn, out int nEntry);

public native function bool GetIntEntryNumI(int nRowID, int nColumn, out int nEntry);

public native function bool GetIntEntryNumN(int nRowID, Name sColumn, out int nEntry);

public native function bool GetNameEntryII(int nRow, int nColumn, out Name nEntry);

public native function bool GetNameEntryIN(int nRow, Name sColumn, out Name nEntry);

public native function bool GetNameEntryNI(Name sRow, int nColumn, out Name nEntry);

public native function bool GetNameEntryNN(Name sRow, Name sColumn, out Name nEntry);

public native function bool GetNameEntryNumI(int nRowID, int nColumn, out Name nEntry);

public native function bool GetNameEntryNumN(int nRowID, Name sColumn, out Name nEntry);

public native function int GetNumberedRowIndex(int nRowID);

public native function int GetNumColumns();

public native function int GetNumRows();

public native function int GetRowIndex(Name nmRowLabel);

public native function Name GetRowName(int nRowIndex);

public native function array<Name> GetRowNames();

public native function int GetRowNumber(int nRowIndex);

public native function bool GetStringEntryII(int nRow, int nColumn, out string sEntry);

public native function bool GetStringEntryIN(int nRow, Name sColumn, out string sEntry);

public native function bool GetStringEntryNI(Name sRow, int nColumn, out string sEntry);

public native function bool GetStringEntryNN(Name sRow, Name sColumn, out string sEntry);

public native function bool GetStringEntryNumI(int nRowID, int nColumn, out string sEntry);

public native function bool GetStringEntryNumN(int nRowID, Name sColumn, out string sEntry);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}