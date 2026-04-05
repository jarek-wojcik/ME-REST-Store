Class SpeechRecognition
    native
    collapsecategories;

struct native RecogUserData 
{
    var array<byte> UserData;
    var int ActiveVocabularies;
    
    structdefaultproperties
    {
        UserData = ""
    }
};
struct native RecogVocabulary 
{
    var(RecogVocabulary) array<RecognisableWord> WhoDictionary;
    var(RecogVocabulary) array<RecognisableWord> WhatDictionary;
    var(RecogVocabulary) array<RecognisableWord> WhereDictionary;
    var string VocabName;
    var array<byte> VocabData;
    var array<byte> WorkingVocabData;
    
    structdefaultproperties
    {
        VocabData = ""
        WorkingVocabData = ""
    }
};
struct native RecognisableWord 
{
    var(RecognisableWord) string ReferenceWord;
    var(RecognisableWord) string PhoneticWord;
    var(RecognisableWord) int Id;
};

var RecogUserData InstanceData[4];
var(SpeechRecognition) string Language;
var(SpeechRecognition) array<RecogVocabulary> Vocabularies;
var array<byte> VoiceData;
var array<byte> WorkingVoiceData;
var array<byte> UserData;
var const native duplicatetransient Pointer FnxVoiceData;
var(SpeechRecognition) float ConfidenceThreshhold;
var transient duplicatetransient bool bDirty;
var transient duplicatetransient bool bInitialised;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Language = "INT"
    ConfidenceThreshhold = 50.0
}