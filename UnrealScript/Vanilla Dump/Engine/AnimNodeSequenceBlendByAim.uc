Class AnimNodeSequenceBlendByAim extends AnimNodeSequenceBlendBase
    native;

var(AnimNodeSequenceBlendByAim) Vector2D Aim;
var const transient Vector2D PreviousAim;
var(AnimNodeSequenceBlendByAim) Vector2D HorizontalRange;
var(AnimNodeSequenceBlendByAim) Vector2D VerticalRange;
var(AnimNodeSequenceBlendByAim) Vector2D AngleOffset;
var(AnimNodeSequenceBlendByAim) Name AnimName_LU;
var(AnimNodeSequenceBlendByAim) Name AnimName_LC;
var(AnimNodeSequenceBlendByAim) Name AnimName_LD;
var(AnimNodeSequenceBlendByAim) Name AnimName_CU;
var(AnimNodeSequenceBlendByAim) Name AnimName_CC;
var(AnimNodeSequenceBlendByAim) Name AnimName_CD;
var(AnimNodeSequenceBlendByAim) Name AnimName_RU;
var(AnimNodeSequenceBlendByAim) Name AnimName_RC;
var(AnimNodeSequenceBlendByAim) Name AnimName_RD;

public final native function CheckAnimsUpToDate();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    HorizontalRange = {X = -1.0, Y = 1.0}
    VerticalRange = {X = -1.0, Y = 1.0}
    Anims = ({
              AnimInfo = {AnimSeqName = 'None', AnimSeq = None, AnimLinkupIndex = 0}, 
              AnimName = 'None', 
              Weight = 1.0
             }, 
             {
              AnimInfo = {AnimSeqName = 'None', AnimSeq = None, AnimLinkupIndex = 0}, 
              AnimName = 'None', 
              Weight = 0.0
             }, 
             {
              AnimInfo = {AnimSeqName = 'None', AnimSeq = None, AnimLinkupIndex = 0}, 
              AnimName = 'None', 
              Weight = 0.0
             }, 
             {
              AnimInfo = {AnimSeqName = 'None', AnimSeq = None, AnimLinkupIndex = 0}, 
              AnimName = 'None', 
              Weight = 0.0
             }, 
             {
              AnimInfo = {AnimSeqName = 'None', AnimSeq = None, AnimLinkupIndex = 0}, 
              AnimName = 'None', 
              Weight = 0.0
             }, 
             {
              AnimInfo = {AnimSeqName = 'None', AnimSeq = None, AnimLinkupIndex = 0}, 
              AnimName = 'None', 
              Weight = 0.0
             }, 
             {
              AnimInfo = {AnimSeqName = 'None', AnimSeq = None, AnimLinkupIndex = 0}, 
              AnimName = 'None', 
              Weight = 0.0
             }, 
             {
              AnimInfo = {AnimSeqName = 'None', AnimSeq = None, AnimLinkupIndex = 0}, 
              AnimName = 'None', 
              Weight = 0.0
             }, 
             {
              AnimInfo = {AnimSeqName = 'None', AnimSeq = None, AnimLinkupIndex = 0}, 
              AnimName = 'None', 
              Weight = 0.0
             }
            )
}