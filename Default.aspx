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
            String result = ProcessVideo.StartProcess("C:\\ffmpeg.exe", "-i " + map_path + "\\sample.mp4 -ss 00:00:00 -t 00:00:04 -async 1 " + map_path + "\\cut.mp4");  
                
            String results2 = ProcessVideo.StartProcess("C:\\ffprobe.exe", "-v error -show_entries format=size -of default=noprint_wrappers=1 "+ map_path +"\\cut.mp4");

            pResults.InnerText = results2;
        }
    }
</script>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">

<script type="text/javascript">

    $(function () {
        // SAMPLE VALIDATE CODE
<%--        $('#frm').preventDoubleSubmission();

        $('#txtFirstName').focus();
        $('#txtPhone').mask("(000) 000-0000");
        $('#txtFax').mask("(000) 000-0000");
        $('#txtEmergencyPhone').mask("(000) 000-0000");
        $('#selOrganization').chosen();
        $('#selState').chosen();

        $('#frm').validate({
            rules: {
                <%=txtFirstName.UniqueID%>: { required: true },
                <%=txtLastName.UniqueID%>: { required: true },
                <%=txtEmail.UniqueID%>: { required: true, email: true },
                <%=selUserType.UniqueID%>: { required: true },
                <%=txtFax.UniqueID%>: { required: function(element){ return $('#ddlFax').val() == 'fax'; }, phoneUS: true },

            },
            messages: {
                <%=txtFirstName.UniqueID%>: { 
                    required: 'Please enter a First Name.'
                },
                <%=txtLastName.UniqueID%>: { 
                    required: 'Please enter a Last Name.'
                },
                <%=txtEmail.UniqueID%>: { 
                    required: 'Please enter an Email Address.',
                    email: 'Please enter a valid Email Address.'
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
            }
        });--%>
    });
  </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="NavContent" Runat="Server">
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <form id="frm" runat="server">
        <div class="title">
            SNIPS
            <img src="/images/crab.png" />
        </div>
        <button type="submit">Test Snippetting</button>
        <p id="pResults" runat="server"></p>
    </form>
</asp:Content>
