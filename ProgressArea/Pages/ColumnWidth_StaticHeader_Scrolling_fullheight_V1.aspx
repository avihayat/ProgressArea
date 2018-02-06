<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ColumnWidth_StaticHeader_Scrolling_fullheight_V1.aspx.cs" Inherits="ColumnWidth_StaticHeader_Scrolling_fullheight_V1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        html,
        body {
            margin: 0;
            padding: 0;
            height: 100%;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
            <Scripts>
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
            </Scripts>
        </telerik:RadScriptManager>
        <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
            <script type="text/javascript">
                //function GridCreated(sender, args) {
                //    var gridHeight = sender.get_element().clientHeight;
                //    //var parent = $get("gridItemsContainer");
                //    var parentHeight = document.body.clientHeight;

                //    var parentHeight = $(window).height();  // my code
                //    var gridTop = (sender.TopPagerControl) ? (sender.TopPagerControl).offsetTop : ((sender.GridHeaderDiv) ? sender.GridHeaderDiv.offsetTop : 0);
                //    parentHeight = parentHeight - (gridTop + 10);

                //    var scrollArea = sender.GridDataDiv;
                //    var gridTopPagerHeight = (sender.TopPagerControl) ? sender.TopPagerControl.clientHeight : 0;
                //    var gridHeaderHeight = (sender.GridHeaderDiv) ? sender.GridHeaderDiv.clientHeight : 0;
                //    var gridDataHeight = sender.get_masterTableView().get_element().clientHeight;
                //    var gridFooterHeight = (sender.GridFooterDiv) ? sender.GridFooterDiv.clientHeight : 0;
                //    var gridPagerHeight = (sender.PagerControl) ? sender.PagerControl.clientHeight : 0;
                //    var itemHeight = $(".rgDataDiv .rgRow").height();
                //    var nItemsRequested = sender.get_masterTableView().get_pageSize();
                //    var nDataRows = sender.get_masterTableView().get_dataItems().length;

                //    if (nItemsRequested > nDataRows) {
                //        nItemsRequested = nDataRows;
                //    }

                //    var itemHeight = gridDataHeight / nItemsRequested;
                //    var h = parentHeight - gridHeaderHeight - gridPagerHeight - gridTopPagerHeight - gridFooterHeight - 2;
                //    var nItems = Math.floor(h / itemHeight);
                //    if (nItems >= nItemsRequested) {
                //        sender.get_masterTableView().set_pageSize(nItems);
                //    }

                //    scrollArea.style.height = (nItems * itemHeight) + "px";
                //}

                function GridCreated(sender, args) {
                    //var parentHeight = document.body.clientHeight;
                    var parentHeight = $(window).height();
                    var scrollArea = sender.GridDataDiv;
                    var gridHeaderHeight = (sender.GridHeaderDiv) ? sender.GridHeaderDiv.clientHeight : 0;
                    var gridTopPagerHeight = (sender.TopPagerControl) ? sender.TopPagerControl.clientHeight : 0;
                    var gridDataHeight = sender.get_masterTableView().get_element().clientHeight;
                    var gridFooterHeight = (sender.GridFooterDiv) ? sender.GridFooterDiv.clientHeight : 0;
                    var gridPagerHeight = (sender.PagerControl) ? sender.PagerControl.clientHeight : 0;

                    if (gridDataHeight < 350 || parentHeight > (gridDataHeight + gridHeaderHeight + gridPagerHeight + gridTopPagerHeight + gridFooterHeight)) {
                        scrollArea.style.height = gridDataHeight + "px";
                    } else {
                        scrollArea.style.height = (parentHeight - gridHeaderHeight - gridPagerHeight - gridTopPagerHeight - gridFooterHeight - 2) + "px"
                    }
                }

                //function GridCreated(sender, args) {
                //    sender.get_element().style.height = window.innerHeight - 2 + "px";
                //}

            </script>
        </telerik:RadCodeBlock>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
        </telerik:RadAjaxManager>

        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server" Skin="Default"></telerik:RadAjaxLoadingPanel>

        <div id="gridItemsContainer">
            <telerik:RadGrid ID="RadGrid1" runat="server" ForeColor="#000000" AutoGenerateColumns="true"
                ShowHeadersWhenNoRecords="true"
                RenderMode="Lightweight" GridLines="None"
                OnNeedDataSource="RadGrid1_NeedDataSource">

                <ClientSettings EnableAlternatingItems="False">
                    <ClientEvents OnGridCreated="GridCreated" />
                    <Scrolling UseStaticHeaders="true" AllowScroll="true" />
                </ClientSettings>
                <MasterTableView AllowPaging="true" AutoGenerateColumns="true" CommandItemDisplay="TopAndBottom">
                    <HeaderStyle Width="20px" />
                </MasterTableView>
            </telerik:RadGrid>
        </div>
    </form>
</body>
</html>
