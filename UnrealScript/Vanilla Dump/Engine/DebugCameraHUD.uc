Class DebugCameraHUD extends HUD
    transient
    config(Game);

public event simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
}
public event function PostRender()
{
    local DebugCameraController DCC;
    local float XL;
    local float YL;
    local float X;
    local float Y;
    local string myText;
    local Vector CamLoc;
    local Vector ZeroVec;
    local Rotator CamRot;
    local TraceHitInfo HitInfo;
    local Actor HitActor;
    local MeshComponent MeshComp;
    local Vector HitLoc;
    local Vector HitNormal;
    local bool bFoundMaterial;
    
    Super.PostRender();
    DCC = DebugCameraController(PlayerOwner);
    if (DCC != None)
    {
        Canvas.SetDrawColor(0, 0, 255, 255);
        myText = "DebugCameraHUD";
        Canvas.Font = Class'Engine'.static.GetSmallFont();
        Canvas.StrLen(myText, XL, YL);
        X = float(Canvas.SizeX) * 0.0500000007;
        Y = YL;
        YL += float(2) * Y;
        Canvas.SetPos(X, YL);
        Canvas.DrawText(myText, TRUE);
        Canvas.SetDrawColor(128, 128, 128, 255);
        CamLoc = DCC.PlayerCamera.CameraCache.POV.location;
        CamRot = DCC.PlayerCamera.CameraCache.POV.Rotation;
        YL += Y;
        Canvas.SetPos(X, YL);
        Canvas.DrawText("CamLoc:" $ CamLoc @ "CamRot:" $ CamRot);
        HitActor = Trace(HitLoc, HitNormal, Vector(CamRot) * float(5000) * float(20) + CamLoc, CamLoc, TRUE, ZeroVec, HitInfo, );
        if (HitActor != None)
        {
            YL += Y;
            Canvas.SetPos(X, YL);
            Canvas.DrawText("HitLoc:" $ HitLoc @ "HitNorm:" $ HitNormal);
            YL += Y;
            Canvas.SetPos(X, YL);
            Canvas.DrawText("HitActor: '" $ HitActor.Name $ "'");
            bFoundMaterial = FALSE;
            if (HitInfo.Material != None)
            {
                YL += Y;
                Canvas.SetPos(X + Y, YL);
                Canvas.DrawText("Material:" $ HitInfo.Material.Name);
                bFoundMaterial = TRUE;
            }
            else if (HitInfo.HitComponent != None)
            {
                bFoundMaterial = DisplayMaterials(X, YL, Y, MeshComponent(HitInfo.HitComponent));
            }
            else
            {
                foreach HitActor.AllOwnedComponents(Class'MeshComponent', MeshComp)
                {
                    bFoundMaterial = bFoundMaterial || DisplayMaterials(X, YL, Y, MeshComp);
                }
            }
            if (!bFoundMaterial)
            {
                YL += Y;
                Canvas.SetPos(X + Y, YL);
                Canvas.DrawText("Material: NONE");
            }
            DrawDebugLine(HitLoc, HitLoc + HitNormal * float(30), 255, 255, 231);
        }
        else
        {
            YL += Y;
            Canvas.SetPos(X, YL);
            Canvas.DrawText("Not trace hit");
        }
        if (DCC.bShowSelectedInfo == TRUE && DCC.SelectedActor != None)
        {
            YL += Y;
            Canvas.SetPos(X, YL);
            Canvas.DrawText("Selected actor: '" $ DCC.SelectedActor.Name $ "'");
            DisplayMaterials(X, YL, Y, MeshComponent(DCC.SelectedComponent));
        }
    }
}
public function bool DisplayMaterials(float X, out float Y, float DY, MeshComponent MeshComp)
{
    local int MaterialIndex;
    local bool bDisplayedMaterial;
    local MaterialInterface Material;
    
    bDisplayedMaterial = FALSE;
    if (MeshComp != None)
    {
        for (MaterialIndex = 0; MaterialIndex < MeshComp.GetNumElements(); ++MaterialIndex)
        {
            Material = MeshComp.GetMaterial(MaterialIndex);
            if (Material != None)
            {
                Y += DY;
                Canvas.SetPos(X + DY, Y);
                Canvas.DrawText("Material: '" $ Material.Name $ "'");
                bDisplayedMaterial = TRUE;
            }
        }
    }
    return bDisplayedMaterial;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bHidden = FALSE
}