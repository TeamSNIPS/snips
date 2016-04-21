<%@ Page Title="SNIPS | Home" Language="C#" MasterPageFile="MasterContent.master" %>

<%@ Import Namespace="System.IO" %>

<script runat="server">

    protected void Page_Load(object sender, System.EventArgs e) {

        if (!IsPostBack)
        {

        }
        else
        {
            String map_path = HttpContext.Current.Server.MapPath(".");

            if (files.PostedFile != null && files.PostedFile.ContentLength > 0)
            {
                String guid = Guid.NewGuid().ToString();
                HttpContext.Current.Session["guid"] = guid;
                HttpContext.Current.Session["timestamps"] = hdnTimestamps.Value;
                HttpContext.Current.Session["windows"] = hdnWindows.Value;

                string file_name = System.IO.Path.GetFileName(files.PostedFile.FileName);
                String save_location = map_path + "\\videos\\" + guid;
                Directory.CreateDirectory(save_location);
                try
                {
                    files.PostedFile.SaveAs(save_location + "\\" + file_name);
                    String[] time_stamps = hdnTimestamps.Value.Split(',');
                    String[] window_sizes = hdnWindows.Value.Split(',');

                    ArrayList arguments = ProcessVideo.GetArguments(time_stamps, window_sizes, save_location, file_name);

                    foreach (String argument in arguments)
                    {
                        ProcessVideo.StartProcess("C:\\ffmpeg.exe", argument);

                    }
                    //var mi = new MediaInfoLib.MediaInfo();
                    //mi.Open(save_location + "\\" + file_name);
                    //Console.WriteLine(mi.Inform());
                    //mi.Close();
                    HttpContext.Current.Session["snipsNum"] = time_stamps.Length;
                    Response.Redirect("/Results.aspx");
                }
                catch (Exception ex)
                {

                }


            }
        }
    }
</script>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">

<script type="text/javascript">

    $(function () {
        $('#frm').preventDoubleSubmission();

        $('.times').each(function () {
            $(this).mask("00:00", { reverse: true });
        });
        $('.windowsizes').each(function () {
            $(this).mask("000");
        });

    });

    var error = "";
    var time_stamps = [];
    var windows = [];

    function check_time_input() {
        var duration = $('#hdnDuration').val();
        if (parseInt(duration) > 1800) {
            error = "Video length over 30 minutes";
            return false;
        }

        for (var i = 0; i < time_stamps.length; i++) {
            var split_time = time_stamps[i].split(':');
            if (parseInt(split_time[0]) >= 30 || parseInt(split_time[1]) >= 60){
                error = "Invalid time stamp."
                return false;
            }
        }
        return true;
    }

    function check_time_bounds() {
        var duration = moment().hour(12).minute(0).second($('#hdnDuration').val());
        for (var i = 0; i < time_stamps.length; i++) {
            var split_time = time_stamps[i].split(':');
            var time_stamp = moment().hour(12).minute(split_time[0]).second(split_time[1]);
            var begin = moment().hour(12).minute(split_time[0]).second(split_time[1]);
            //begin.subtract(parseInt(windows[i]), 'seconds');
            var end = moment().hour(12).minute(split_time[0]).second(split_time[1]);
            end.add(parseInt(windows[i]), 'seconds');
            var zero = moment().hour(12).minute(0).second(0);
            if (windows[i] == '0' || windows[i] == '00' || windows[i] == '000') {
                error = "Window size: " + windows[i] + " with time stamp: " + time_stamps[i] + " is not a valid window size.";
                return false;
            }
            if (moment.max(time_stamp, duration) == time_stamp) {
                error = "Time stamp: " + time_stamp[i] + " is out of bounds.";
                return false;
            }
            if (moment.max(duration, end) == end) {
                error = "Window size: " + windows[i] + " with time stamp: " + time_stamps[i] + " is out of bounds.";
                return false;
            }
            //if (moment.max(zero, begin) == zero) {
            //    error = "Window size: " + windows[i] + " with time stamp: " + time_stamps[i] + " is out of bounds.";
            //    return false;
            //}

        }


        return true;
    }

    function validate_form() {
        var valid = true;
        time_stamps = $('#hdnTimestamps').val().split(',');
        windows = $('#hdnWindows').val().split(',');
        

        if (time_stamps[0] == "00:" || windows[0] == "" || time_stamps.length != windows.length) {
            error = "One or more inputs is empty.";
            valid = false;
        } else if (!videoUploaded) {
            error = "No video uploaded.";
            valid = false;
        } else if (!check_time_input()) {
            valid = false;
        } else if (!check_time_bounds()) {
            valid = false;
        }

        if (valid) {
            $('#frm').submit();
        } else {
            alert(error);
        }
    }
    function saveValues() {
        var time_stamps = "";
        $('.times').each(function () {
            if ($(this).val().indexOf(':') == -1) {
                time_stamps += '00:';
            }
            time_stamps += $(this).val() + ",";
        });
        time_stamps = time_stamps.substr(0, time_stamps.length - 1);

        var windows_sizes = "";
        $('.windowsizes').each(function () {
            windows_sizes += $(this).val() + ",";
        });
        windows_sizes = windows_sizes.substr(0, windows_sizes.length - 1);

        $('#hdnTimestamps').val(time_stamps);
        $('#hdnWindows').val(windows_sizes);
    }

    // create additional time inputs
    var num = 2;
    function addMoreTimes() {
        var dummy =     '<div class="form-column">' +
                            '<label for="txtTime' + num + '">Time Stamp:</label>' +
                            '<input type="text" class="times form-control" id ="txtTime' + num + '" placeholder="00:00">' +
                        '</div>' +
                        '<div class="form-column">' +
                                '<label for="txtWindow' + num + '">Snippet Length:</label>' +
                                '<input type="text" class="windowsizes form-control" id ="txtWindow' + num + '" placeholder="0">' +
                                '<small class="text-muted">(seconds)</small>' +
                        '</div>' +
                    '<div class="form-group" id="addmore'+(num+1)+'">' +
                    '</div>';
        num = num + 1;
        document.getElementById('addmore' + (num - 1)).innerHTML += dummy;
        masking();
    }
    function masking() {
        $('.times').each(function () {
            $(this).mask("00:00");
        });
        $('.windowsizes').each(function () {
            $(this).mask("000");
        });
    }

    // get video metadata
    var myVideos = [];
    var videoUploaded = false;
    window.URL = window.URL || window.webkitURL;
    function setFileInfo(files) {
        myVideos.pop();
        myVideos.push(files[0]);
        var video = document.createElement('video');
        video.preload = 'metadata';
        video.onloadedmetadata = function () {
            videoUploaded = true;
            window.URL.revokeObjectURL(this.src)
            var duration = video.duration;
            $('#hdnDuration').val(duration);
            myVideos[myVideos.length - 1].duration = duration;
            updateInfos();
        }
        video.src = URL.createObjectURL(files[0]);;
    }

    function updateInfos() {
        document.querySelector('#infos').innerHTML = "";
        for (i = 0; i < myVideos.length; i++) {
            document.querySelector('#infos').innerHTML += "<div>" + myVideos[i].name/* + " duration: " + myVideos[i].duration*/ + '</div>';
        }
    }

    function openSnippy() {
        document.getElementById("processing-snippy").style.width = "100%";
    }

    //function handleFileSelect(evt) {
    //    var files = evt.target.files; // FileList object

    //    // files is a FileList of File objects. List some properties.
    //    var output = [];
    //    for (var i = 0, f; f = files[i]; i++) {
    //        output.push('<li><strong>', escape(f.name), '</strong> (', f.type || 'n/a', ') - ',
    //                    f.size, ' bytes, last modified: ',
    //                    f.lastModifiedDate ? f.lastModifiedDate.toLocaleDateString() : 'n/a',
    //                    '</li>');
    //        console.log(f);
    //    }
    //    document.getElementById('list').innerHTML = '<ul>' + output.join('') + '</ul>';
    //}

    //document.getElementById('files').addEventListener('change', handleFileSelect, false);
  </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="NavContent" Runat="Server">
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <form id="frm" runat="server">
        <asp:HiddenField ID="hdnTimestamps" runat="server" />
        <asp:HiddenField ID="hdnWindows" runat="server" />
        <asp:HiddenField ID="hdnDuration" runat="server" />
        <div class="header">
            <div class="title">
                SNIPS
                <img src="./images/crab.png" />
                <div class="title2">
                    <p style="margin-top: 0px">An auto-snippeting tool for video</p>
                </div>
            </div>
        </div>

        <div class="upload">
            <%--<output id="list"></output>--%>
            <input type="file" id="files" name="files[]" accept=".mov,.mp4,.m4v" onchange="setFileInfo(this.files)" runat="server" />
            <label class="btn btn-default btn-lg" for="files">
                <i class="fa fa-cloud-upload"></i>&nbsp Upload
            </label>
            <output id="infos"></output>

            <p style="margin-bottom: 0px">Max video length: 30 minutes</p>
            <p style="margin: 0px">File formats accepted: .mov, .mp4, .m4v</p>
        </div>
        <div class="windows" id ="timeInputs">
            <div class="form-group" id="addmore1">
                <div class="form-column">
                    <label for="txtTime1">Time Stamp:</label>
                    <input type="text" class="times form-control" id ="txtTime1" placeholder="00:00">
                </div>
                <div class="form-column">
                    <label for="txtWindow1">Snippet Length:</label>
                    <input type="text" class="windowsizes form-control" id ="txtWindow1" placeholder="0">
                    <small class="text-muted">(seconds)</small>
                </div>
            </div>
            <div class="form-group" id="addmore2">
            </div>
        </div>

        
        <div class="windows">
            <button type="button" class="btn btn-default" id="morefields" onclick="addMoreTimes();">  <strong>+</strong> </button>
        </div>
        <div class="submit">
            <input type ="button" class="btn btn-default btn-lg" onclick ="javascript: saveValues(); validate_form();" value="Submit" />
        </div>

        <%--<button type="submit">Test Snippetting</button>--%>
        <p id="pResults" runat="server"></p>

        <div id="processing-snippy" class="overlay">
            <h1>Processing...</h1>
            <p><strong>Do not leave this page!</strong></p>
            <p>Your video clips are processing. Your results will be displayed shortly.</p>
            <div class="overlay-content">
                <img src="http://45.media.tumblr.com/ac869f256984ecd84491dcf0815b8344/tumblr_nn4zjshHba1sscxw7o1_400.gif" alt="Snippy graphic from Emmanuel Ortega. Tumblr Page: http://omg-emmanemsaurio-rex.tumblr.com/">
            </div>
        </div>
        
    </form>

</asp:Content>


