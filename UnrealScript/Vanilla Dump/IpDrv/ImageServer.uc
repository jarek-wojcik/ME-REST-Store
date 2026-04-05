Class ImageServer extends WebApplication;

public event function Query(WebRequest request, WebResponse Response)
{
    local string Image;
    
    Image = request.URI;
    if (!Response.FileExists(Path $ Image))
    {
        Response.HTTPError(404);
        return;
    }
    else if (Right(Caps(Image), 4) == ".JPG" || Right(Caps(Image), 5) == ".JPEG")
    {
        Response.SendStandardHeaders("image/jpeg", TRUE);
    }
    else if (Right(Caps(Image), 4) == ".GIF")
    {
        Response.SendStandardHeaders("image/gif", TRUE);
    }
    else if (Right(Caps(Image), 4) == ".BMP")
    {
        Response.SendStandardHeaders("image/bmp", TRUE);
    }
    else if (Right(Caps(Image), 4) == ".PNG")
    {
        Response.SendStandardHeaders("image/png", TRUE);
    }
    else
    {
        Response.SendStandardHeaders("application/octet-stream", TRUE);
    }
    Response.IncludeBinaryFile(Path $ Image);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}