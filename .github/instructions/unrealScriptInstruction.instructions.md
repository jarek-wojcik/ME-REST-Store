---
description: Describe when these instructions should be loaded by the agent based on task context
applyTo: '**/*.uc' Only apply to uc files, which are UnrealScript source files from the Mass Effect 3 decompiled dump.
---
# Copilot Instructions for Mass Effect 3 UnrealScript Dump

## Project Overview
This codebase is a decompiled dump of UnrealScript source files from Mass Effect 3, organized by module. It is not a typical application project, but a large set of interrelated game logic, AI, effects, and gameplay systems. Each folder (e.g., `BIO_COMMON`, `BIOP_MP_COMMON`, `WwiseAudio`) represents a major subsystem or feature area from the game.

## Key Structure and Patterns
- **Class Declarations:** Each `.uc` file typically declares a single UnrealScript class, using `Class <Name> extends <Parent>`. Inheritance and component composition are central.
- **Default Properties:** Many files end with a `defaultproperties` block, which sets initial values for class fields. These are critical for game logic and tuning.
- **Component System:** Many classes use `var editinline export` to declare editable components, following Unreal Engine's actor/component model.
- **Templates:** Some classes use `Begin Template Class=...` blocks to define default subobjects/components.
- **Comments:** Comments often reference in-editor properties or Unreal Engine conventions, e.g., `//class default properties can be edited in the Properties tab for the class's Default__ object.`

## Developer Workflows
- **No Build/Test Automation:** This dump is not directly buildable or runnable. It is intended for analysis, modding, or porting. There are no build scripts, tests, or automation.
- **Navigation:** Use folder/module names to locate related systems (e.g., `SFXGame/` for core gameplay, `WwiseAudio/` for audio integration).
- **Cross-References:** Inheritance and component usage are the main cross-file links. Use class names to search for usages and relationships.

## Conventions and Integration
- **Unreal Engine 3 Patterns:** Follows UE3 UnrealScript idioms: class-based logic, defaultproperties, actor/component separation.
- **No External Dependencies:** All code is self-contained UnrealScript. External integration (e.g., Wwise audio) is via Unreal's native extension points, not via external scripts or libraries.
- **Naming:** Prefixes like `SFX`, `BIO`, `Wwise` indicate subsystem or vendor. Multiplayer code is in `BIOP_MP_COMMON`.

## Examples
- See `WwiseAudio/WwiseMusicVolume.uc` for a typical audio component class with default properties and template usage.
- See `BIOP_MP_COMMON/SFXGameEffect_AmmoPower.uc` for a gameplay effect class.

## AI Agent Guidance
- Focus on UnrealScript idioms and class relationships.
- When searching for logic, prefer class and property names over file names.
- Do not expect build/test/run automation; this is a static code dump for reference and analysis.
- Document only patterns present in the codebase, not modern Unreal Engine 4+ practices.

## ME3 Unreal Script Notes
UnrealScript in LegendaryExplorer
 
Natalie Howes edited this page on Aug 29, 2024 · 3 revisions
There are two good general UnrealScript references:

The official docs: docs.unrealengine.com/udk/Three/UnrealScriptHome.html
The wiki: wiki.beyondunreal.com/UnrealScript_reference
I've often found the wiki to be more illuminating than the official docs, but both contain useful information. If either site is ever down, you can access them through the wayback machine on archive.org

The UnrealScript that you can write in LegendaryExplorer is a slightly different dialect than the one used in UnrealEd/UDK. In this list of differences, UScript will refer to the UnrealEd/UDK dialect of UnrealScript, and LEXScript will refer to the LegendaryExplorer dialect.

In UScript, class definitions must always include an extends clause. This is optional in LEXScript, leaving it out will implicitly extend Object.

LEXScript does not support multiline comments (/* */).

In UScript, Inner classes declared with a within clause can access members of the specified outer class without having to qualify the access with the Outer property declared in Object. This is not true in LEXScript. You must access outer class members via the Outer property.

In UScript all three statements in a for loop must be present (for (initstatement; loopcondition; updatestatement)), and the updatestatement must be an assignment or function call. In LEXScript, the initstatement and updatestatement are optional, and the updatestatement can be any statement.

In UScript, when declaring a dynamic array of delegates or class limiters, you must put a space between the last two right carets, like so:  array<delegate<delegatename> >  or  array<class<classname> > . In LEXScript the space is unnecessary, you can just type array<class<classname>>.

In UScript, enum values can be used bare, without a reference to the enum type (similar to c++). In LEXScript, you must qualify all enum values with the the enum type. (UScript: Explosion, LEXScript: EAttackType.Explosion)

defaultproperties
The defaultproperties format in LEXScript has many differences to UScript, so read this section carefully.

The defaultproperties block is used to specify default values for a class or struct's properties. When used for a struct, the keyword is structdefaultproperties instead. The block can only contain subobject declarations and assignments to class/struct members. Unlike in UScript, it cannot contain dynamic array manipulation operations. In UScript, spaces are discouraged and newlines are significant and restricted in where they can be used. In LEXScript, whitespace and newlines are not significant, so use them (or don't) wherever you want. Semicolons after each assignment statement are optional.

Every assigned value must be a literal, expressions are not allowed:

Structs:
There are no struct literals in regular code, except for special syntax for vectors (vect(0.0, 0.0, 0.0)) and rotators (rot(0, 0, 0)). You cannot use that special syntax in defaultproperties, but there is a general struct literal syntax. You can provide values for some or all properties. Any properties you don't specify will get their values from the struct's defaults.

StructProp = {X=1,Y=2,Z=0}
//you can split larger structs onto multiple lines.
StructProp = {
               Default = TRUE,
               GameplayPhysics = TRUE, 
               EffectPhysics = TRUE, 
               BlockingVolume = TRUE
             }
Static Arrays:
You must assign each index individually. You do not need to assign them all; any you do not specify will have their default value, or inherit from the base class when applicable.

Prop[0] = 'AName'
Prop[2] = 'AnotherName'
Dynamic Arrays:
There are no dynamic array literals in regular code, but there is in defaultproperties. You must assign the whole array literal, you cannot assign to specific indices.

ArrayProp = (5, 9, 23, 87)
//you can split arrays onto multiple lines. This is especially useful for arrays of structs
Points = ({InVal = 0.0, OutVal = 0.35, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_Linear}, 
          {InVal = 0.35, OutVal = 0.1, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_Linear}, 
          {InVal = 1.0, OutVal = 0.1, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_Linear}, 
          {InVal = 4.0, OutVal = 0.012, ArriveTangent = 0.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_Linear}
         )
Delegates:
DelegateProp = FunctionName //function is in the same class
DelegateProp = Class'ClassName'.FunctionName //function is in a different class
Objects:
//for a class, you just give the class name
ClassProp = Class'ClassName'
//for any other kind of object, you must give the Instanced Full Path of the object in this file (which can be found in the Metadata tab for that object in Package Editor).
ObjectProp = SkeletalMesh'BioBaseResources.MissingResources.Missing_Creature_Class'
//In addition to the normal class literals, you can use the name of a subobject
ObjectProp = subobjectName
SubObjects:
SubObjects can only be declared in defaultproperties, not structdefaultproperties. They may contain other subobjects. Examples:

Begin Object Class=BioDynamicAnimSet Name=MY_DYN_HMM_BC_SniperSpecial
    m_nmOrigSetName = 'HMM_BC_SniperSpecial'
    Sequences = (AnimSequence'BIOG_HMM_BC_A.HMM_BC_SniperSpecial_BC_Start')
    m_pBioAnimSetData = BioAnimSetData'BIOG_HMM_BC_A.HMM_BC_SniperSpecial_BioAnimSetData'
End Object

//SubObjects declared with "Begin Template" will use a same-named SubObject in the defaultproperties of the current class's super class as their Archetype
Begin Template Class=SkeletalMeshComponent Name=SkeletalMeshComponent0
    Begin Template Class=AnimNodeSequence Name=AnimNodeSeq0
    End Template
    Animations = AnimNodeSeq0
    ReplacementPrimitive = None
    RBCollideWithChannels = {Pawn = TRUE, Vehicle = TRUE}
End Template
Enums:
EnumProp = EnumType.EnumValue
Names:
NameProp = 'AName'
Booleans:
BoolProp = True
Integers and Bytes
Byte literals are the same as int literals, they just have to be in the range 0 to 255

ByteProp = 0xF //numbers starting with 0x are interpreted as hexadecimal
IntProp = -8903
Floats:
FloatProp = 10.43
FloatProp = -8903
FloatProp = 1.45e12 //scientific notation can be used
Strings:
StringProp = "AString"
StringRef:
string refs are tlk ids

StringRefProp = $12340


