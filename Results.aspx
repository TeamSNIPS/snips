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

        }
    }
</script>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">

    <script type="text/javascript">

    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="NavContent" runat="Server">
</asp:Content>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <form id="frm" runat="server">
        <div class="header">
            <div class="title">
                Results
               
                <img src="./images/crab.png" />
                <div class="title2">
                    <p style="margin-top: 0px">An auto-snippeting tool for video</p>
                </div>
            </div>
        </div>
        
        <div class="container" style="width:100%">
            <div id="divResults" runat="server">
            </div>

            <button type="button" class="btn btn-default btn-lg">
                <span class="" aria-hidden="true"></span><i class="fa fa-download"></i> Download
            </button>
        </div>
    </form>
</asp:Content>

