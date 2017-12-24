<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Check_all_from_results.aspx.cs" Inherits="Check_all_from_results" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style>
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
        <script type="text/javascript">
            function OnClientCheckAllChecking(sender, args) {
                // cancel the event
                args.set_cancel(true);

                var target = $telerik.$(args.get_domEvent().target); // get a reference to the element that was targeted by the click event
                var checkbox = sender.get_checkAllCheckBox(); // get a reference to the "Check All" checkbox

                // get all the items from the checklistbox
                var items = sender.get_items();

                // condition to check whether the target element fo the click event is the "Check All" checkbox input or the label
                if ((target.is("label") || target.is(".rlbCheckAllItemsCheckBox"))) {

                    /* This condition should be if(!checked), in case the "Check All" checkbox is about to be checked, 
                    its checked status will return false. */
                    if (!checkbox.checked) {

                        // loop through the items returned by search result and check them all
                        items.forEach(function (item) {
                            if ($telerik.$(item.get_element()).is(":visible")) {
                                item.check();
                            } else {
                                item.uncheck();
                            }
                        });

                        /*
                        Check the "Check All" checkbox at this point because its checked state can toggle based on the selected items on the list
                        If all items are selected, this will automatically gets checked, or if there is at least one item unchecked, its check status will be cleared as well
                        */
                        checkbox.checked = true;
                    } else {
                        // uncheck all items
                        sender.uncheckItems(sender.get_items())

                        // uncheck the "Check All" checkbox
                        checkbox.checked = false;
                    }
                }
            }
        </script>
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
        </telerik:RadAjaxManager>

        <div>
            <asp:Label ID="Label1" runat="server" Text="FilterExpression"></asp:Label>
            <br />
            <br />
            <telerik:RadGrid ID="RadGrid1" runat="server" AllowPaging="True" CellSpacing="0"
                GridLines="None" Width="800px"
                AllowFilteringByColumn="true" FilterType="HeaderContext" EnableHeaderContextMenu="true" EnableHeaderContextFilterMenu="true"
                EnableLinqExpressions="true"
                OnItemCommand="RadGrid1_ItemCommand"
                OnNeedDataSource="RadGrid1_NeedDataSource"
                OnPreRender="RadGrid1_PreRender"
                OnFilterCheckListItemsRequested="RadGrid1_FilterCheckListItemsRequested">
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
