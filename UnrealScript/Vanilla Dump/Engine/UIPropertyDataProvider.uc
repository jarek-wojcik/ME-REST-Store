Class UIPropertyDataProvider extends UIDataProvider
    native
    abstract
    transient;

var const array<Class<Property>> ComplexPropertyTypes;
var delegate<CanSupportComplexPropertyType> __CanSupportComplexPropertyType__Delegate;

public delegate function bool CanSupportComplexPropertyType(Property UnsupportedProperty);

public event function bool GetCustomPropertyValue(out UIProviderScriptFieldValue PropertyValue, optional int ArrayIndex = -1);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ComplexPropertyTypes = (Class'StructProperty', Class'MapProperty', Class'ArrayProperty', Class'DelegateProperty')
}