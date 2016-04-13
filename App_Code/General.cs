using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for General
/// </summary>
public class General
{
    public General()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    public static void CleanUpFolders() {

        DateTime now = DateTime.Now;

        String videos_path = HttpContext.Current.Server.MapPath("./videos");
        String[] guid_folders = Directory.GetDirectories(videos_path);
        foreach (String folder in guid_folders)
        {
            // if the folder itself is older than 1 day, delete the folder
            if (File.GetCreationTime(folder).AddDays(1) < now && !folder.Contains("12345"))
            {
                Directory.Delete(folder, true);
            }
            // if the folder contains finished.txt and is older than 4 hours, delete the folder
            else if (File.GetCreationTime(folder).AddHours(4) < now && File.Exists(folder + "/finished.txt") && !folder.Contains("12345"))
            {
                Directory.Delete(folder, true);
            }
        }
    }
}