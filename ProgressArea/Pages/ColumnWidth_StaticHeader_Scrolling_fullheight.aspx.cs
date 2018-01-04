using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

public partial class ColumnWidth_StaticHeader_Scrolling_fullheight : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
  
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

        for (int i = 0; i < 1000; i++)
        {
            DataRow row = dataTable.NewRow();

            for (int j = 0; j < colCount; j++)
            {
                row[j] = "Col " + j + "<br />Row "+i;
            }
            dataTable.Rows.Add(row);
        }
        return dataTable;
    }
    #endregion

    protected void RadGrid1_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
    {
        RadGrid1.DataSource = GetGridSource();
    }
}