using System;
using System.Data;

using Telerik.Web.UI;

public partial class ColumnWidth_StaticHeader_Scrolling_fullheight_V1 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            RadGrid1.PageSize = (int)Math.Floor(Math.Sqrt(GetGridSource().Rows.Count));
    }

    #region DataTable GetGridSource()
    private DataTable GetGridSource()
    {
        DataTable dataTable = new DataTable();
        int colCount = 20;

        for (int i = 0; i < colCount; i++)
        {
            DataColumn column = new DataColumn();
            column.DataType = Type.GetType("System.String");
            column.ColumnName = "Column" + (i);
            dataTable.Columns.Add(column);
        }

        DataColumn[] PrimaryKeyColumns = new DataColumn[1];
        PrimaryKeyColumns[0] = dataTable.Columns[0];
        dataTable.PrimaryKey = PrimaryKeyColumns;

        for (int i = 0; i < 50; i++)
        {
            DataRow row = dataTable.NewRow();

            for (int j = 0; j < colCount; j++)
            {
                row[j] = "Col " + j + "<br />Row " + i;
            }
            dataTable.Rows.Add(row);
        }
        return dataTable;
    }
    #endregion

    protected void RadGrid1_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
    {
        RadGrid1.DataSource = GetGridSource();
        RadGrid1.VirtualItemCount = GetGridSource().Rows.Count;
    }
}