<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns='http://www.w3.org/1999/xhtml' dir="rtl">
<head runat="server">
    <title>Telerik ASP.NET Example</title>
    <style type="text/css">
        .RadMenu_rtl  .rgFilterListMenu  .rlbItem, .RadMenu_rtl  .rgFilterListMenu .rlbCheckAllItems {
            text-align: right;
        }

        .RadMenu_rtl .rmScrollWrap > .rmVertical:before {
            border-width: 0 0 0 1px;
            left: 0;
            right: auto
        }

        .RadMenu_rtl  .rlbItem, .RadMenu_rtl  .rlbCheckAllItems {
            text-align: right;
        }
        
        body {background-color: powderblue;}
        h1   {color: blue;}
        p    {color: red;}
    </style>
</head>

<body>
    <telerik:RadCodeBlock runat="server">

    <script type="text/javascript">
        function pageLoad(sender, args) {
            var $ = $telerik.$;
            $("#<%= RadProgressArea1.ClientID%>").on('click', ".ruCancel",
                function () {
                    var prm = Sys.WebForms.PageRequestManager.getInstance();
                    if (prm.get_isInAsyncPostBack()) {
                        console.log("abortPostBack")
<%--                    var finished = $("#<%= FinishedFlag.ClientID %>").val();
                    console.log(finished);--%>
                        prm.abortPostBack();

                        var url = "Ajax/WaitRadfProgress.ashx";
                        $.ajax({
                            type: "POST",
                            url: url,
                            data: "{variant_id:'1'}",
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (data) {
                                RefreshGrid();
                                alert("OK: " + data);
                            },
                            error: function (XMLHttpRequest, textStatus, errorThrown) {
                                alert("Error: " + textStatus + errorThrown);
                            }
                        });
                    }
                    //                    setTimeout(RefreshGrid, 500)
                });

                //        var url = "http://localhost:57558/WebService/WebServiceSample.asmx";
                //        $.ajax({
                //            type: "POST",
                //            url: url + "/HelloWorld",
                //            data: "{variant_id:'1'}",
                //            contentType: "application/json; charset=utf-8",
                //            dataType: "json",
                //            success: function (data) {
                //                alert("OK: " + data);
                //            },
                //            error: function (XMLHttpRequest, textStatus, errorThrown) {
                //                alert("Error: " + errorThrown);
                //            }
                //        });
                //    }
                //    //                    setTimeout(RefreshGrid, 500)
                //});
        }
                
        function RefreshGrid() {
<%--            var finished = $find("<%= FinishedFlag.ClientID %>").val();
            console.log(finished);
            setTimeout(RefreshGrid, 500)--%>
            var masterTable = $find("<%= RadGrid1.ClientID %>").get_masterTableView();
            masterTable.rebind();
            radalert("Canceled By User", "400", "250", "alert");
        }
    </script>
</telerik:RadCodeBlock>

    <form id="form1" runat="server">

        <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
            <Scripts>
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
            </Scripts>
        </telerik:RadScriptManager>
<%--        <asp:ScriptManager runat="server" />--%>


        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGrid1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1"/>
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
        </telerik:RadAjaxManager>
                <script type="text/javascript">
                    //Put your JavaScript code here.
                    function onMenuShowing(sender, args) {
                        RadContextMenuOnMenuShowing(sender, args);
                    }
                    function onMenuShown(sender, args) {
                        if (gridCol._data.UniqueName == "ID") {
                            RadContextMenu_Hide(gridCol, sender, "FirstCond");
                        }
                        RadContextMenu_Hide(RadContextMenu_GetCurCol(), sender, "SecondCond");

                        RadContextMenuOnMenuShown(sender, args);
                    }
                    function onMenuHiding(sender, args) {
                        RadContextMenuOnMenuHiding(sender, args);
                    }



                    var controlIDs = [];
                    var gridCol;
                    function RadContextMenu_GetCurCol() {
                        return gridCol;
                    }
                    function RadContextMenuOnMenuShowing(sender, args) {
                        gridCol = args.get_gridColumn();
                    }
                    function RadContextMenuOnMenuShown(sender, args) {
                        var container = $("#" + sender.get_id() + "_detached");

                        container.find(".rgHCMAnd").hide();
                        if (!gridCol._data.FilterCheckListEnableLoadOnDemand) {
                            container.find(".rgHCMShow").show();
                        }
                        else {
                            container.find(".rgHCMShow").hide();
                        }
                    }
                    function RadContextMenuOnMenuHiding(sender, args) {
                        $(controlIDs).each(function (i, ID) {
                            $find(ID).set_visible(true);
                        });
                        controlIDs = [];
                    }
                    function RadContextMenu_Hide(gridCol, sender, condName) {
                        var container = $("#" + sender.get_id() + "_detached");
                        var names = ["CMB", "TB", "DP", "NTB"];

                        for (var i = 0; i < names.length; i++) {
                            var pos = condName;
                            var control = $telerik.findControl(container[0], "HCFMR" + names[i] + pos);
                            if (control && control.get_visible()) {
                                var condition = condName == "SecondCond" ? false : !gridCol._data.FilterCheckListEnableLoadOnDemand;
                                control.set_visible(condition);

                                if (!condition) {
                                    controlIDs.push(control.get_id());
                                }
                            }
                        }
                    }
        </script>
<telerik:RadWindowManager runat="server" ID="radWindowManager" EnableShadow="true"
RenderMode="Auto" ShowContentDuringLoad="true" VisibleStatusbar="false"
ReloadOnShow="true" Style="z-index: 7001">
</telerik:RadWindowManager>

<telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" CssClass="demo-container no-bg">
         <asp:TextBox id="FinishedFlag" runat="server" ></asp:TextBox>
        <telerik:RadGrid ID="RadGrid1" RenderMode="Lightweight"  runat="server" 
            AutoGenerateColumns="false" OnNeedDataSource="RadGrid1_NeedDataSource"
            FilterType="HeaderContext" EnableHeaderContextMenu="true"  EnableHeaderContextFilterMenu="true"
            OnFilterCheckListItemsRequested="RadGrid1_FilterCheckListItemsRequested" 
            AllowFilteringByColumn="true" 
            AllowSorting="true" AllowMultiRowSelection="True">
            <ClientSettings AllowKeyboardNavigation="true">
                <Selecting AllowRowSelect="True" />
                <ClientEvents OnHeaderMenuShowing="onMenuShowing" />
            </ClientSettings>
            <HeaderContextMenu OnClientShown="onMenuShown" OnClientHiding="onMenuHiding">
                <CollapseAnimation Type="None" />
            </HeaderContextMenu>
            <MasterTableView ShowHeadersWhenNoRecords="true" CommandItemDisplay="Top" >
                <CommandItemTemplate>
                <div class="rgCommandCellRight">
                    <telerik:RadPushButton runat="server" ID="PerfromLinkButton"
                        CommandName="PerfromLinkSelected"
                        Text="Start Processing" OnClick="PerfromLinkButton_Click">
                    </telerik:RadPushButton>
                </div>
            </CommandItemTemplate>
                <Columns>
                    <telerik:GridClientSelectColumn UniqueName="ClientSelectColumn">
                    </telerik:GridClientSelectColumn>
                    <telerik:GridBoundColumn DataField="ID" UniqueName="ID" HeaderText="Id" 
                        FilterControlAltText="Filter Id column"
                        FilterCheckListEnableLoadOnDemand="true" AutoPostBackOnFilter="true">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Items" UniqueName="Items" HeaderText="Items" 
                        FilterControlAltText="Filter items column"
                        FilterCheckListEnableLoadOnDemand="true" AutoPostBackOnFilter="true" ShowFilterIcon="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Rate" UniqueName="Rate" HeaderText="Rate" 
                        FilterControlAltText="Filter rate column"
                        FilterCheckListEnableLoadOnDemand="true" AutoPostBackOnFilter="true">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Status" UniqueName="Status" HeaderText="Status" 
                        FilterControlAltText="Filter Status column"
                        FilterCheckListEnableLoadOnDemand="true" AutoPostBackOnFilter="true">
                    </telerik:GridBoundColumn>
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>
</telerik:RadAjaxPanel>

        <div class="demo-container size-narrow">
            <telerik:RadProgressManager ID="RadProgressManager1" runat="server" />

            <telerik:RadProgressArea ID="RadProgressArea1" runat="server" Width="600px"
                HeaderText="קישור קבצים" DisplayCancelButton="true"
                Style="position: fixed; top: 50% !important; left: 50% !important; margin: -93px 0 0 -188px;"
                ProgressIndicators="RequestSize,CurrentFileName,
                            TotalProgressPercent,TotalProgressBar,TotalProgress,
                            FilesCount,FilesCountBar,FilesCountPercent,SelectedFilesCount,
                            TimeElapsed">
                <Localization Total='סה"כ קבצים:' Uploaded="נטען: "
                    TotalFiles=':סה"כ תאים ' UploadedFiles='נטענו: '
                    CurrentFileName="שם קישור: "
                    ElapsedTime="זמן: " TransferSpeed="" />
            </telerik:RadProgressArea>
            <telerik:RadAjaxPanel runat="server">
                <telerik:RadButton RenderMode="Lightweight" ID="buttonSubmit" runat="server"  Visible="false" Text="Start Processing" OnClick="buttonSubmit_Click">
                </telerik:RadButton>
            </telerik:RadAjaxPanel>
        </div>
    </form>
</body>
</html>
