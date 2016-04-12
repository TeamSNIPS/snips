using System;
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
        String error = process.StandardOutput.ReadToEnd();
        //String output = process.StandardError.ReadToEnd();
        process.Dispose();
        return error;
    }
}