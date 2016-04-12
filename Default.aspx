<%@ Page Title="SNIPS | Home" Language="C#" MasterPageFile="MasterContent.master" %>

<script runat="server">

    protected void Page_Load(object sender, System.EventArgs e) {

        if (!IsPostBack)
        {

        }
        else
        {
            String map_path = HttpContext.Current.Server.MapPath(".");
            if ((System.IO.File.Exists(map_path + "\\cut.mp4")))
            {
                System.IO.File.Delete(map_path + "\\cut.mp4");
            }
            String result = ProcessVideo.StartProcess("C:\\ffmpeg.exe", "-ss 00:09:00 -i " + map_path + "\\sample2.mp4 -to 00:03:00 -c copy " + map_path + "\\cut.mp4");
            String result1 = ProcessVideo.StartProcess("C:\\ffmpeg.exe", "-ss 00:08:20 -i " + map_path + "\\sample2.mp4 -to 00:01:00 -c copy " + map_path + "\\cut1.mp4");  
            //String results2 = ProcessVideo.StartProcess("C:\\ffprobe.exe", "-v error -show_entries format=size -of default=noprint_wrappers=1 "+ map_path +"\\cut.mp4");

            //pResults.InnerText = results2;
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

        /* $('#txtFirstName').focus();
        $('#timestamp').mask("00:00");
        $('#txtFax').mask("(000) 000-0000");
        $('#txtEmergencyPhone').mask("(000) 000-0000");
        $('#selOrganization').chosen();
        $('#selState').chosen(); */

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
    function SaveResponses() {

    }
  </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="NavContent" Runat="Server">
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <form id="frm" runat="server">
        <asp:HiddenField ID="hdnTimestamps" runat="server" />
        <asp:HiddenField ID="hdnWindows" runat="server" />
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
            <input type="file" id="video" accept=".mov,.mp4,.m4v">
            <p style="margin-bottom: 0px">Max video length: 30 minutes</p>
            <p style="margin: 0px">File formats accepted: .mov, .mp4, .m4v</p>
        </div>
        <div class="windows" id ="timeInputs">
              Time Stamp:<br>
              <input type="text" class="times" id ="txtTime1">
              <br>
              Window Size (Seconds):<br>
              <input type="text" class="windowsizes" id="txtWindow1"> <br>
        </div>
        <div class="windows">
            <input type ="button" id ="morefields" onclick ="addMoreTimes();" value="+" />
        </div>

        <div class="submit">
            <input type ="button" onclick ="$('#frm').submit();" value="Submit" />
        </div>
         

        <button type="submit">Test Snippetting</button>
        <p id="pResults" runat="server"></p>
    </form>


<script>
    var num = 2;
    function addMoreTimes() {
        var dummy = 'Time Stamp:<br> <input type="text" class="times" id="time' + num + '"> <br> Window Size (Seconds):<br> <input type="text" class="windowsizes" id="window' + num + '"> <br>';
        num = num + 1;
        document.getElementById('timeInputs').innerHTML += dummy;
    }
</script>
</asp:Content>


