<%@ Page Title="SNIPS | Results" Language="C#" MasterPageFile="MasterContent.master" %>

<script runat="server">

    protected void Page_Load(object sender, System.EventArgs e)
    {

        if (!IsPostBack)
        {
            divResults.InnerHtml = Retrieve.GenerateHtml();
        }
        else
        {
            String[] selected_raw = hdnSelected.Value.Split(',');
            ArrayList file_names = new ArrayList();
            String map_path = HttpContext.Current.Server.MapPath(".");
            String guid = HttpContext.Current.Session["guid"].ToString();

            //testing!!!
            guid = "12345";

            foreach (string str in selected_raw)
            {
                //ensure checkbox name hasn't been manipulated by converting to int
                int n;
                if (int.TryParse(str, out n))
                {
                    file_names.Add(map_path + "/videos/" + guid + "/Snippet_" + Convert.ToInt32(str) + ".mp4");
                }
            }
            if (file_names.Count > 0)
            {
                Retrieve.DownloadFiles(file_names);
            }
        }
    }
</script>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">

    <script type="text/javascript">
        $(function () {


        });
        function getSelected() {
            var selected = [];
            $('input:checked').each(function () {
                $('#hdnSelected').val($('#hdnSelected').val() + $(this).attr('name') + ",");
            });
            if ($('#hdnSelected').val() != "") {
                $('#hdnSelected').val($('#hdnSelected').val().substr(0, $('#hdnSelected').val().length - 1));
            }

        }
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="NavContent" runat="Server">
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <form id="frm" runat="server">
        <asp:HiddenField id="hdnSelected" value="" runat="server" />
        <div class="header">
            <div class="title">
                Results
               
                <img src="./images/crab.png" />
                <div class="title2">
                    <p style="margin-top: 0px">An auto-snippeting tool for video</p>
                </div>
            </div>
        </div>

        <div id="divResults" runat="server">
        </div>

        <button type="button" class="btn btn-default btn-lg" onclick="javascript: getSelected(); $('#frm').submit();">
            <span class="" aria-hidden="true"></span><i class="fa fa-download"></i> Download
        </button>

    </form>
</asp:Content>
