﻿using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

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
        HttpContext.Current.Session["guid"] = "12345";
        HttpContext.Current.Session["timestamps"] = "01:34,12:59";
        HttpContext.Current.Session["windows"] = "69:69,01:23";
        HttpContext.Current.Session["width"] = 624;
        HttpContext.Current.Session["height"] = 352;
        HttpContext.Current.Session["snipsNum"] = 2;

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
                            "</video>" +
                        "</div>"+
                        "<div class='details col-md-6 text-center'>" +
                            "<dl class='snippet-info dl-horizontal'>" +
                                "<dt><strong>Title:</strong></dt><dd class='text-left'>Snippet_" + i + ".mp4</dd>" +
                                "<dt><strong>Timestamp:</strong></dt><dd class='text-left'>" + timestamps[i - 1] + "</dd>" +
                                "<dt><strong>Window Size:</strong></dt><dd class='text-left'>" + windows[i - 1] + "</dd>" +
                            "</dl>" +
                            "<input type='checkbox' id='chkSnippet" + i + "' runat='server'>" +
                            "<label for='chkSnippet" + i + "'>Select this clip</label>" +
                        "</div>" +
                     "</div>";
        }

        return html;
    }
}