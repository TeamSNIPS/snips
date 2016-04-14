<%@ Page Title="SNIPS | Home" Language="C#" MasterPageFile="MasterContent.master" %>

<%@ Import Namespace="System.IO" %>

<script runat="server">

    protected void Page_Load(object sender, System.EventArgs e) {

        bool testingFFMpeg = false;
        if (!IsPostBack)
        {

        }
        else
        {
            String map_path = HttpContext.Current.Server.MapPath(".");

            if (testingFFMpeg)
            {
                if ((System.IO.File.Exists(map_path + "\\cut.mp4")))
                {
                    System.IO.File.Delete(map_path + "\\cut.mp4");
                }
                if ((System.IO.File.Exists(map_path + "\\cut1.mp4")))
                {
                    System.IO.File.Delete(map_path + "\\cut1.mp4");
                }
                String result = ProcessVideo.StartProcess("C:\\ffmpeg.exe", "-ss 00:09:00 -i " + map_path + "\\sample2.mp4 -to 00:03:00 -c copy " + map_path + "\\cut.mp4");
                String result1 = ProcessVideo.StartProcess("C:\\ffmpeg.exe", "-ss 00:08:20 -i " + map_path + "\\sample2.mp4 -to 00:01:00 -c copy " + map_path + "\\cut1.mp4");
                //String results2 = ProcessVideo.StartProcess("C:\\ffprobe.exe", "-v error -show_entries format=size -of default=noprint_wrappers=1 "+ map_path +"\\cut.mp4");
                //pResults.InnerText = results2;
            }
            else
            {
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
                        for (int i = 0; i < time_stamps.Length; i++)
                        {
                            TimeSpan start = TimeSpan.Parse("00:" + time_stamps[i]);
                            TimeSpan window = TimeSpan.Parse("00:00:" + window_sizes[i]);
                            start = start.Subtract(window);
                            TimeSpan length = window.Add(window);
                            ProcessVideo.StartProcess("C:\\ffmpeg.exe", "-ss " + start.ToString() + " -i " + save_location + "\\" + file_name + " -to " + length.ToString() + " -c copy " + save_location + "\\Snippet_" + (i + 1) + ".mp4");
                        }
                        HttpContext.Current.Session["snipsNum"] = time_stamps.Length;
                        Response.Redirect("/Results.aspx");
                    }
                    catch (Exception ex)
                    {

                    }


                }
            }
        }
    }
</script>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">

<script type="text/javascript">

    $(function () {
        // SAMPLE VALIDATE CODE
        $('#frm').preventDoubleSubmission();

        $('.times').each(function () {
            $(this).mask("00:00");
        });
        $('.windowsizes').each(function () {
            $(this).mask("000");
        });

        $('#frm').validate({
<%--            rules: {
                <%=video.UniqueID%>: { required: true },
                <%=time1.UniqueID%>: { required: true },
                <%=window1.UniqueID%>: { required: true},
                <%=selUserType.UniqueID%>: { required: true },
                <%=txtFax.UniqueID%>: { required: function(element){ return $('#ddlFax').val() == 'fax'; }, phoneUS: true },

            },
            messages: {
                <%=video.UniqueID%>: { 
                    required: 'Please upload a video file.'
                },
                <%=time1.UniqueID%>: { 
                    required: 'Please enter valid timestamps.'
                },
                <%=window1.UniqueID%>: { 
                    required: 'Please enter an Email Address.'
                }, 
                <%=selUserType.UniqueID%>: { 
                    required: 'Please select a User Type.',
                },                 
            },
            highlight: function(element) {
                $(element).parent().addClass("field-error");
            },
            unhighlight: function(element) {
                $(element).parent().removeClass("field-error");
            },
            errorPlacement: function(error, element) {
                error.insertAfter(element.parent());
            },
            invalidHandler: function(form, validator) {
                var errors = validator.numberOfInvalids();
                if (errors) {
                        $("html, body").animate({ scrollTop: 0 }, "fast");
                        $('#spnErrors').html('Please correct the form errors below.');
                }
            }--%>
        });
        $('.times').each(function () {
            $(this).rules('add', {
                required: true,
                messages: {
                    required: "Enter a time stamp.",
                }
            });
        });
        $('.windowsizes').each(function () {
            $(this).rules('add', {
                required: true,
                messages: {
                    required: "Enter a window size.",
                }
            });
        });
    });
    function saveValues() {
        var time_stamps = "";
        $('.times').each(function () {
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
        var dummy = '<div class="form-group row">' +
                        '<div class="form-column">' +
                            '<label for="txtTime' + num + '">Time Stamp:</label>' +
                            '<input type="text" class="times form-control" id ="txtTime' + num + '" placeholder="00:00">' +
                            '</div>' +
                            '<div class="form-column">' +
                                '<label for="txtWindow' + num + '">Window Size:</label>' +
                                '<input type="text" class="windowsizes form-control" id ="txtWindow' + num + '" placeholder="0">' +
                                '<small class="text-muted">(seconds)</small>' +
                            '</div>' +
                        '</div>';
        num = num + 1;
        $('#timeInputs').html($('#timeInputs').html() + dummy);
        //document.getElementById('addmore' + (num - 1)).innerHTML += dummy;
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
    window.URL = window.URL || window.webkitURL;
    function setFileInfo(files) {
        myVideos.pop();
        myVideos.push(files[0]);
        var video = document.createElement('video');
        video.preload = 'metadata';
        video.onloadedmetadata = function () {
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
            <div class="form-group row">
                <div class="form-column">
                    <label for="txtTime1">Time Stamp:</label>
                    <input type="text" class="times form-control" id ="txtTime1" placeholder="00:00">
                </div>
                <div class="form-column">
                    <label for="txtWindow1">Window Size:</label>
                    <input type="text" class="windowsizes form-control" id ="txtWindow1" placeholder="0">
                    <small class="text-muted">(seconds)</small>
                </div>
            </div>
<%--            <div class="form-group row">
                <div id ="addmore2"></div>
            </div>--%>
        </div>
        <div class="windows">
            <button type="button" class="btn btn-default" id="morefields" onclick="addMoreTimes();">  <strong>+</strong> </button>
        </div>

        <div class="submit">
            <input type ="button" class="btn btn-default btn-lg" onclick ="javascript: saveValues(); $('#frm').submit();" value="Submit" />
        </div>

        <button type="submit">Test Snippetting</button>
        <p id="pResults" runat="server"></p>
    </form>

</asp:Content>


