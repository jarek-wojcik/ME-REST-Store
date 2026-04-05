Class UIResourceDataProvider extends UIPropertyDataProvider
    implements(UIListElementProvider, UIListElementCellProvider)
    native
    perobjectconfig
    abstract
    transient
    config(Game);

var const native noexport Pointer VfTable_IUIListElementProvider;
var const native noexport Pointer VfTable_IUIListElementCellProvider;
var bool bDataBindingPropertiesOnly;
var config bool bSkipDuringEnumeration;

public event function InitializeProvider(bool bIsEditor);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ComplexPropertyTypes = (Class'StructProperty', Class'MapProperty', Class'DelegateProperty')
}