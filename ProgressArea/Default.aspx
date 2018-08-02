<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns='http://www.w3.org/1999/xhtml' dir="rtl">
<head runat="server">
    <title>Telerik ASP.NET Example</title>
    <style type="text/css">
        body {background-color: powderblue;}
        h1   {color: blue;}
        p    {color: red;}
    </style>
     <link rel="Stylesheet" type="text/css" href="Content/css/radCss.css" />
</head>

<body>
    <form id="form1" runat="server">

        <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
            <Services>
                <asp:ServiceReference Path="~/WebService/SaveLogout.asmx" />
            </Services>
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
        <telerik:RadCodeBlock runat="server">
            <script type="text/javascript">
                function pageLoad(sender, args) {
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
            <script type="text/javascript" src="Content/Script/radScript.js"></script>
                <script type="text/javascript">
                    //Put your JavaScript code here.

                    function onMenuShowing(sender, args) {
                        graffiti.RadContextMenu.OnMenuShowing(sender, args);
                    }
                    function onMenuShown(sender, args) {
                        if (gridCol._data.UniqueName == "ID") {
                            graffiti.RadContextMenu.Hide(sender, "FirstCond");
                        }
                        graffiti.RadContextMenu.Hide(sender, "SecondCond");

                        if (gridCol._data.UniqueName == "Items") {
                            graffiti.RadContextMenu.SetCustomWidth(sender, 425);
                        }
                        
                        graffiti.RadContextMenu.OnMenuShown(sender, args);
                        //$(".RadMenu_rtl .rmGroup .rmLeftImage").css({ 'left': '0px', 'right': 'inherit' });
                    }
                    function onMenuHiding(sender, args) {
                        graffiti.RadContextMenu.OnMenuHiding(sender, args);
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
            AllowFilteringByColumn="true"  EnableLinqExpressions="false"
            AllowPaging="true"  PagerStyle-AlwaysVisible="true" PageSize="2000"
            AllowSorting="true" AllowMultiRowSelection="True"
             OnPreRender="RadGrid1_PreRender"
             OnItemDataBound="RadGrid1_ItemDataBound">
            <ClientSettings AllowKeyboardNavigation="true">
                <Selecting AllowRowSelect="True" />
                <Scrolling AllowScroll="true" UseStaticHeaders="true" />
                <ClientEvents OnHeaderMenuShowing="onMenuShowing" OnGridCreated="graffiti.GridCreated" />
            </ClientSettings>
            <HeaderContextMenu OnClientShown="onMenuShown" OnClientHiding="onMenuHiding"  CssClass="myCustomFilterWidth myCustomFilterWidth_500">
                <CollapseAnimation Type="None" />
            </HeaderContextMenu>
            <MasterTableView ShowHeadersWhenNoRecords="true" CommandItemDisplay="Top" >
                <CommandItemTemplate>
                <div class="rgCommandCellRight">
                    <telerik:RadPushButton runat="server" ID="PerfromLinkButton"
                        CommandName="PerfromLinkSelected"
                        Text="Start Processing" OnClick="PerfromLinkButton_Click">
                    </telerik:RadPushButton>
                    <telerik:RadPushButton runat="server" ID="ClearFilters"
                         ToolTip="Clear Filters" OnClick="RadButton_ClearAllFilters_Click" Icon-CssClass="ClearAllFiltersIcon">
                    </telerik:RadPushButton>
                    <telerik:RadDropDownList RenderMode="Lightweight" ID="RadComboBoxPaymentMethod" runat="server">
                        <Items>   
                            <telerik:DropDownListItem runat="server" Text="RadComboBoxItem1" />   
                            <telerik:DropDownListItem runat="server" Text="RadComboBoxItem2" />   
                            <telerik:DropDownListItem runat="server" Text="RadComboBoxItem3" />
                        </Items>
                    </telerik:RadDropDownList>
                </div>
            </CommandItemTemplate>
            <ColumnGroups>
                <telerik:GridColumnGroup HeaderText="Group" Name="Group1" HeaderStyle-HorizontalAlign="Center">
                </telerik:GridColumnGroup>
            </ColumnGroups>
                <Columns>
                    <telerik:GridClientSelectColumn UniqueName="ClientSelectColumn">
                    </telerik:GridClientSelectColumn>
                    <telerik:GridBoundColumn DataField="ID" UniqueName="ID" HeaderText="Id" 
                        FilterControlAltText="Filter Id column"
                        FilterCheckListEnableLoadOnDemand="true" AutoPostBackOnFilter="true">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Items" UniqueName="Items" HeaderText="Items" 
                        FilterControlAltText="Filter items column" ColumnGroupName="Group1"
                        FilterCheckListEnableLoadOnDemand="true" AutoPostBackOnFilter="true" ShowFilterIcon="false">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="Rate" UniqueName="Rate" HeaderText="Rate" 
                        FilterControlAltText="Filter rate column" ColumnGroupName="Group1"
                        FilterCheckListEnableLoadOnDemand="true" AutoPostBackOnFilter="true">
                    </telerik:GridBoundColumn>
                    <telerik:GridDateTimeColumn DataField="MyDate" UniqueName="MyDate" HeaderText="Date" 
                        DataFormatString="{0:dd/MM/yyyy}" DataType="System.DateTime" 
                        FilterControlAltText="Filter date column"
                        CurrentFilterFunction="GreaterThanOrEqualTo" EnableRangeFiltering="true"
                        FilterCheckListEnableLoadOnDemand="false" AutoPostBackOnFilter="true">
                    </telerik:GridDateTimeColumn>
                    <telerik:GridTemplateColumn DataField="State" HeaderText="SelectToggleStateField" UniqueName="State" 
                        EnableHeaderContextMenu="false" ShowFilterIcon="false">
                        <ItemTemplate>
                           <telerik:RadButton RenderMode="Lightweight" ID="State" runat="server" ButtonType="ToggleButton" ToggleType="CustomToggle"
                               AutoPostBack="true" BackColor="transparent" OnToggleStateChanged="ThreeStateCheckBox_ToggleStateChanged"
                               Value='<%# Eval("State") %>'>
                                <ToggleStates>
                                    <telerik:RadButtonToggleState Text=" " Value="0" PrimaryIconCssClass="p-i-checkbox"></telerik:RadButtonToggleState>
                                    <telerik:RadButtonToggleState Text=" " Value="1" PrimaryIconCssClass="p-i-checkbox-checked"></telerik:RadButtonToggleState>
                                    <telerik:RadButtonToggleState Text="Use Default" Value="null" PrimaryIconCssClass="p-i-three-state-indeterminate"></telerik:RadButtonToggleState>
                                </ToggleStates>
                            </telerik:RadButton>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
<%--                    <telerik:GridTemplateColumn DataField="SelectToggleStateField" HeaderText="SelectToggleStateField">
                        <ItemTemplate>
                            <telerik:RadToggleButton runat="server" ID="RadToggleButton1"  SelectedToggleStateIndex='<%#Eval("State") %>' >
                                <ToggleStates>
                                    <telerik:ButtonToggleState Text="False" Value="0" CssClass="p-i-checkbox" >
                                    </telerik:ButtonToggleState>
                                    <telerik:ButtonToggleState Text="True" Value="1" CssClass="p-i-checkbox-checked">
                                    </telerik:ButtonToggleState>
                                    <telerik:ButtonToggleState Text="Use Default" Value="null" CssClass="p-i-three-state-indeterminate">
                                    </telerik:ButtonToggleState>
                                </ToggleStates>
                            </telerik:RadToggleButton>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>--%>
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
