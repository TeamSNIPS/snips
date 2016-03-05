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
            //System.Diagnostics.ProcessStartInfo p = new System.Diagnostics.ProcessStartInfo();
            //p.FileName = "C:\\ffmpeg\\bin\\ffmpeg.exe";
            //p.Arguments = "-i C:\\Users\\Thomas\\Documents\\repos\\snips\\website\\sample.mp4 -ss 00:00:00 -t 00:00:04 -async 1 C:\\Users\\Thomas\\Documents\\repos\\snips\\website\\cut.mp4";
            //p.UseShellExecute = false;
            //p.CreateNoWindow = false;
            //p.RedirectStandardOutput = true;

            //var process = new System.Diagnostics.Process();
            //process.StartInfo = p;
            //process.Start();
            //process.WaitForExit();
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
    </form>
</body>
</html>
