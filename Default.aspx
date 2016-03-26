<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, System.EventArgs e) {

        if (!IsPostBack)
        {

        }
        else
        {
            // reference code for running ffmpeg
            //
            System.IO.StreamReader errorreader;
            String duration;
            String result;
            System.Diagnostics.ProcessStartInfo p = new System.Diagnostics.ProcessStartInfo();
            string map_path = HttpContext.Current.Server.MapPath(".");
            p.FileName = "C:\\ffmpeg.exe";
            p.Arguments = "-i " + map_path + "\\sample.mp4 -ss 00:00:00 -t 00:00:04 -async 1 " + map_path + "\\cut.mp4";
            p.UseShellExecute = false;
            p.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
            //p.CreateNoWindow = false;
            //p.RedirectStandardOutput = true;
            p.RedirectStandardError = true;

            var process = new System.Diagnostics.Process();
            process.StartInfo = p;
            process.Start();
            errorreader = process.StandardError;
            process.WaitForExit();
            result = errorreader.ReadToEnd();

            duration = result.Substring(result.IndexOf("Duration: ") + ("Duration: ").Length, ("00:00:00").Length);
            results.InnerText = duration;
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="/css/main.css" />
    <script type="text/javascript" src="/scripts/jquery-2.1.4.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {

        });
    </script>
</head>
<body>
    <form id="frm" runat="server">
        <div class="title">
            SNIPS
            <img src="/images/crab.png" />
        </div>
        <button type="submit">Test Snippetting</button>
        <p id="results" runat="server"></p>
    </form>
</body>
</html>
