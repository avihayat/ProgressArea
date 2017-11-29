<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns='http://www.w3.org/1999/xhtml' dir="rtl">
<head runat="server" dir="rtl">
    <title>Telerik ASP.NET Example</title>
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

        <telerik:RadScriptManager runat="server" ID="RadScriptManager1" />
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

<telerik:RadWindowManager runat="server" ID="radWindowManager" EnableShadow="true"
RenderMode="Auto" ShowContentDuringLoad="true" VisibleStatusbar="false"
ReloadOnShow="true" Style="z-index: 7001">
</telerik:RadWindowManager>

<telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" CssClass="demo-container no-bg" EnableAJAX="true">
         <asp:TextBox id="FinishedFlag" runat="server" ></asp:TextBox>
        <telerik:RadGrid ID="RadGrid1" RenderMode="Lightweight"  runat="server" 
            AutoGenerateColumns="true" OnNeedDataSource="RadGrid1_NeedDataSource"
            EnableHeaderContextMenu="true" FilterType="HeaderContext" OnFilterCheckListItemsRequested="RadGrid1_FilterCheckListItemsRequested"
            AllowFilteringByColumn="true" 
            AllowSorting="true" AllowMultiRowSelection="True">
            <ClientSettings AllowKeyboardNavigation="true">
                <Selecting AllowRowSelect="True" />
            </ClientSettings>
            <MasterTableView ShowHeadersWhenNoRecords="true" CommandItemDisplay="Top">
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
                        FilterControlAltText="Filter ContactTitle column Id"
                        FilterCheckListEnableLoadOnDemand="true" AutoPostBackOnFilter="true" >
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
