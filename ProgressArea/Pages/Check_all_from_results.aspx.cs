using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

public partial class Check_all_from_results : System.Web.UI.Page
{
    protected void Page_PreRender(object sender, EventArgs e)
    {
        var lb = RadGrid1.FindControl("filterCheckList") as RadListBox;
        lb.OnClientLoad = "listBoxLoad";
        lb.OnClientCheckAllChecked = "CheckAllChecked";
    }
    protected void Page_Load(object sender, EventArgs e)
    {
    }
    protected void RadGrid1_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
    {
        RadGrid1.DataSource = GetGridSource();
    }
    #region DataTable GetGridSource
    private DataTable GetGridSource()
    {
        DataTable dataTable = new DataTable();

        DataColumn column = new DataColumn();
        column.DataType = Type.GetType("System.Int32");
        column.ColumnName = "OrderID";
        dataTable.Columns.Add(column);

        column = new DataColumn();
        column.DataType = Type.GetType("System.DateTime");
        column.ColumnName = "OrderDate";
        dataTable.Columns.Add(column);

        column = new DataColumn();
        column.DataType = Type.GetType("System.Decimal");
        column.ColumnName = "Freight";
        dataTable.Columns.Add(column);

        column = new DataColumn();
        column.DataType = Type.GetType("System.String");
        column.ColumnName = "ShipName";
        dataTable.Columns.Add(column);

        column = new DataColumn();
        column.DataType = Type.GetType("System.String");
        column.ColumnName = "ShipCountry";
        dataTable.Columns.Add(column);

        DataColumn[] PrimaryKeyColumns = new DataColumn[1];
        PrimaryKeyColumns[0] = dataTable.Columns["OrderID"];
        dataTable.PrimaryKey = PrimaryKeyColumns;

        for (int i = 0; i <= 80; i++)
        {
            DataRow row = dataTable.NewRow();
            row["OrderID"] = i + 1;
            row["OrderDate"] = DateTime.Now;
            row["Freight"] = (i + 1) + (i + 1) * 0.1 + (i + 1) * 0.01;

            if (i % 9 == 0)
            {
                row["ShipCountry"] = "Austria";
            }
            else if (i % 8 == 0)
            {
                row["ShipCountry"] = "Belgium";
            }
            else if (i % 7 == 0)
            {
                row["ShipCountry"] = "France";
            }
            else if (i % 6 == 0)
            {
                row["ShipCountry"] = "Spain";
            }
            else if (i % 5 == 0)
            {
                row["ShipCountry"] = "Germany";
            }
            else if (i % 4 == 0)
            {
                row["ShipCountry"] = "Denmark";
            }
            else if (i % 3 == 0)
            {
                row["ShipCountry"] = "Bulgaria";
            }
            else if (i % 2 == 0)
            {
                row["ShipCountry"] = "Hungary";
            }
            else
            {
                row["ShipCountry"] = "Poland";
            }

            if (i % 3 == 0)
            {
                row["ShipName"] = "Fedex";
            }
            else if (i % 2 == 0)
            {
                row["ShipName"] = "DHL";
            }
            else
            {
                row["ShipName"] = "UPS";
            }


            dataTable.Rows.Add(row);
        }

        return dataTable;
    }
    #endregion
    protected void RadGrid1_FilterCheckListItemsRequested(object sender, GridFilterCheckListItemsRequestedEventArgs e)
    {
        string DataField = (e.Column as IGridDataColumn).GetActiveDataField();
        e.ListBox.DataSource = GetGridSource().DefaultView.ToTable(true, DataField);
        e.ListBox.DataKeyField = DataField;
        e.ListBox.DataTextField = DataField;
        e.ListBox.DataValueField = DataField;
        e.ListBox.DataBind();
    }
}