using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ionic.Zip;
using Ionic.Zlib;

/// <summary>
/// Summary description for Retrieve
/// </summary>
public class Retrieve
{
    public Retrieve()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public static String GenerateHtml()
    {
        //HttpContext.Current.Session["guid"] = "12345";
        //HttpContext.Current.Session["timestamps"] = "01:34,12:59";
        //HttpContext.Current.Session["windows"] = "69:69,01:23";
        HttpContext.Current.Session["width"] = 624;
        HttpContext.Current.Session["height"] = 352;
        //HttpContext.Current.Session["snipsNum"] = 2;

        String guid = HttpContext.Current.Session["guid"].ToString();
        String[] timestamps = HttpContext.Current.Session["timestamps"].ToString().Split(',');
        String[] windows = HttpContext.Current.Session["windows"].ToString().Split(',');

        int width = Convert.ToInt32(HttpContext.Current.Session["width"]);
        int height  = Convert.ToInt32(HttpContext.Current.Session["height"]);
        
        if (16*height == 9*width)
        {
            width = 448;
            height = 252;
        }
        else
        {
            width = 320;
            height = 240;
        }

        int snipsNum = Convert.ToInt32(HttpContext.Current.Session["snipsNum"]);
        String html = String.Empty;

        for (int i = 1; i <= snipsNum; i++)
        {
            html += "<div class='snippet row'>" +
                        "<div class='col-md-6 text-center'>" +
                            "<video class='video' width='" + width + "' height='" + height + "' controls>" +
                                "<source src='/videos/" + guid + "/Snippet_" + i + ".mp4' type='video/mp4'>" +
                                "Your browser does not support the video tag." +
                            "</video>" +
                        "</div>"+
                        "<div class='details col-md-6 text-center'>" +
                            "<dl class='snippet-info dl-horizontal'>" +
                                "<dt><strong>Title:</strong></dt><dd class='text-left'>Snippet_" + i + ".mp4</dd>" +
                                "<dt><strong>Timestamp:</strong></dt><dd class='text-left'>" + timestamps[i - 1] + "</dd>" +
                                "<dt><strong>Length:</strong></dt><dd class='text-left'>" + windows[i - 1] + "</dd>" +
                            "</dl>" +
                            "<div style='float:left; padding-left:40px;'>" +
                                "<input type='checkbox' id='chkSnippet" + i + "' name='" + i + "' runat='server' style='margin-right:5px;'>" +
                                "<label for='chkSnippet" + i + "'>  Select snippet</label>" +
                            "</div>" +
                        "</div>" +
                     "</div>";
        }

        return html;
    }
    public static void DownloadFiles(ArrayList file_names) {

        System.Web.HttpContext.Current.Response.Clear();
        System.Web.HttpContext.Current.Response.BufferOutput = false;
        System.Web.HttpContext.Current.Response.ContentType = "application/zip";
        System.Web.HttpContext.Current.Response.AddHeader("content-disposition", "attachment; filename=snips.zip");

        using (ZipFile zip = new ZipFile())
        {
            zip.CompressionLevel = CompressionLevel.None;
            foreach (string file_name in file_names)
            {
                zip.AddFile(file_name, "");
            }
            zip.Save(System.Web.HttpContext.Current.Response.OutputStream);
        }

        System.Web.HttpContext.Current.Response.Close();
    }
}