using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Diagnostics;
using System.ComponentModel;
using System.Text;
using System.Threading;
using System.IO;

/// <summary>
/// Summary description for Process
/// </summary>
public class ProcessVideo
{
    public ProcessVideo()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public static ArrayList GetArguments(String[] time_stamps, String[] window_sizes, string save_location, string file_name)
    {
        ArrayList arguments = new ArrayList();
        for (int i = 0; i < time_stamps.Length; i++)
        {
            int temp = Convert.ToInt32(window_sizes[i]);
            int mins = temp / 60;

            string win_sizes;
            if (mins >= 10)
            {
                win_sizes = mins + ":";
            }
            else
            {
                win_sizes = "0" + mins + ":";
            }

            if (temp % 60 < 10)
                win_sizes += "0";
            win_sizes += (temp % 60);

            TimeSpan start = TimeSpan.Parse("00:" + time_stamps[i]);
            TimeSpan length = TimeSpan.Parse("00:" + win_sizes);

            //TimeSpan window = TimeSpan.Parse("00:" + win_sizes);
            //start = start.Subtract(window);
            //TimeSpan length = window.Add(window);

            TimeSpan end = start.Add(length);
            if (file_name.Contains(".mp4"))
                arguments.Add("-i \"" + save_location + "\\" + file_name + "\" -ss " + start.ToString() + " -to " + end.ToString() + " -c copy " + save_location + "\\Snippet_" + (i + 1) + ".mp4");
            else if (file_name.Contains(".mov"))
                // include different arguments for videos ending in .mov
                arguments.Add("-i \"" + save_location + "\\" + file_name + "\" -ss " + start.ToString() + " -to " + end.ToString() + " -vcodec " + save_location + "\\Snippet_" + (i + 1) + ".mp4");
            else if (file_name.Contains(".m4v"))
                // include different arguments for videos ending in .m4v
                arguments.Add("-i \"" + save_location + "\\" + file_name + "\" -ss " + start.ToString() + " -to " + end.ToString() + " -vcodec " + save_location + "\\Snippet_" + (i + 1) + ".mp4");

        }
        return arguments;
    }

    public static String StartProcess(string filename, string arguments)
    {
        Process process = new Process();
        process.StartInfo.FileName = filename;
        process.StartInfo.Arguments = arguments;
        process.StartInfo.UseShellExecute = false;
        process.StartInfo.RedirectStandardError = true;
        process.StartInfo.RedirectStandardOutput = true;

        //StringBuilder output = new StringBuilder();
        //StringBuilder error = new StringBuilder();

        process.StartInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;

        process.Start();
        
        process.WaitForExit();
        String output = process.StandardOutput.ReadToEnd();
        String error = process.StandardError.ReadToEnd();
        process.Dispose();
        return output;
    }
}