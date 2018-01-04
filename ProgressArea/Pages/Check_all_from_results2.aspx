<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Check_all_from_results2.aspx.cs" Inherits="Cases_Grid_Filtering_Excel_Like_1145449_Check_all_from_results2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
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
        <script type="text/javascript">
            function OnClientCheckAllChecking(sender, args) {
                args.set_cancel(true);
                var target = $telerik.$(args.get_domEvent().target); // get a reference to the element that was targeted by the click event
                var checkbox = sender.get_checkAllCheckBox(); // get a reference to the "Check All" checkbox
                var items = sender.get_items(); // get all the items from the checklistbox
                var IsCheckAllChecked = false;
                if (target.is("label") && !checkbox.checked || target.is(".rlbCheckAllItemsCheckBox") && checkbox.checked) { // condition to check whether the target element fo the click event is the "Check All" checkbox input or the label
                    IsCheckAllChecked = true;
                    checkItems(items);
                } else {
                    sender.uncheckItems(sender.get_items()); // uncheck all items
                }
                setTimeout(function () {
                    items._parent.get_checkAllCheckBox().checked = IsCheckAllChecked;
                }, 10);
            }

            function checkItems(items) {
                items.forEach(function (item) {
                    if ($telerik.$(item.get_element()).is(":visible")) {
                        item.check();
                    } else {
                        item.uncheck();
                    }
                });
            }
        </script>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
        </telerik:RadAjaxManager>

        <div>
            <telerik:RadGrid ID="RadGrid1" runat="server" AllowPaging="True" CellSpacing="0"
                GridLines="None" Width="800px"
                AllowFilteringByColumn="true" FilterType="HeaderContext" EnableHeaderContextMenu="true" EnableHeaderContextFilterMenu="true"
                EnableLinqExpressions="true"
                OnNeedDataSource="RadGrid1_NeedDataSource"
                OnFilterCheckListItemsRequested="RadGrid1_FilterCheckListItemsRequested">

                <ClientSettings>
                </ClientSettings>
                <MasterTableView AutoGenerateColumns="False" DataKeyNames="OrderID">

                    <Columns>
                        <telerik:GridBoundColumn DataField="OrderID" DataType="System.Int32"
                            FilterControlAltText="Filter OrderID column" HeaderText="OrderID"
                            ReadOnly="True" SortExpression="OrderID" UniqueName="OrderID" FilterCheckListEnableLoadOnDemand="true">
                        </telerik:GridBoundColumn>
                        <telerik:GridDateTimeColumn DataField="OrderDate" DataType="System.DateTime"
                            FilterControlAltText="Filter OrderDate column" HeaderText="OrderDate"
                            SortExpression="OrderDate" UniqueName="OrderDate" FilterCheckListEnableLoadOnDemand="true">
                        </telerik:GridDateTimeColumn>
                        <telerik:GridNumericColumn DataField="Freight" DataType="System.Decimal"
                            FilterControlAltText="Filter Freight column" HeaderText="Freight"
                            SortExpression="Freight" UniqueName="Freight" FilterCheckListEnableLoadOnDemand="true">
                        </telerik:GridNumericColumn>
                        <telerik:GridBoundColumn DataField="ShipName"
                            FilterControlAltText="Filter ShipName column" HeaderText="ShipName"
                            SortExpression="ShipName" UniqueName="ShipName" FilterCheckListEnableLoadOnDemand="true">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="ShipCountry"
                            FilterControlAltText="Filter ShipCountry column" HeaderText="ShipCountry"
                            SortExpression="ShipCountry" UniqueName="ShipCountry" FilterCheckListEnableLoadOnDemand="true">
                        </telerik:GridBoundColumn>
                    </Columns>
                </MasterTableView>
            </telerik:RadGrid>
        </div>
    </form>
</body>
</html>
