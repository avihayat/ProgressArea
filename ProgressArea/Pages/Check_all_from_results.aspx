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
            var checkedState = false;
            function listBoxLoad(sender, args) {
                var checkAllCheckBox = sender.get_checkAllCheckBox();
                var checkAllItem = $(checkAllCheckBox).parents("li").first();
                checkAllItem.on("mousedown", function (event) {
                    checkedState = checkAllCheckBox.checked;
                });
            }
            function CheckAllChecked(sender, args) {
                var items = sender.get_items();
                for (var i = 0; i < items.get_count() ; i++) {
                    var item = items.getItem(i);
                    item.set_checked(!checkedState && item.get_visible());
                }
                sender.get_checkAllCheckBox().checked = !checkedState;
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