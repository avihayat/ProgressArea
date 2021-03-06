﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading;
using System.Web.UI;
using System.Web.UI.WebControls;

using Telerik.Web.UI;
using Telerik.Web.UI.Upload;

using Model.ViewModel.Rad;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            //Do not display SelectedFilesCount progress indicator.
            RadProgressArea1.ProgressIndicators &= ~ProgressIndicators.SelectedFilesCount;

            Session["TestData"] = "UserName is avi";
        }
    }
    protected void buttonSubmit_Click(object sender, System.EventArgs e)
    {
        UpdateProgressContext(new List<int> { 1 });
    }

    DataTable dtValues;
    protected void RadGrid1_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
    {
        //creating datatable
        dtValues = new DataTable();
        dtValues.Columns.Add("ID");
        dtValues.Columns.Add("Items");
        dtValues.Columns.Add("Rate");
        dtValues.Columns.Add("MyDate");
        dtValues.Columns.Add("State", typeof(bool));
        dtValues.Columns.Add("Status");
        if (Session["Table"] != null)
        {
            dtValues = (DataTable)Session["Table"];
        }
        RadGrid1.DataSource = dtValues;//populate RadGrid with datatable

        if (dtValues.Rows.Count == 0)
        {
            for (int i = 0; i < 1240; i++)
            {
                DataRow drValues = dtValues.NewRow();
                drValues["Id"] = i.ToString();
                drValues["Items"] = (i <= 5 ? "Item " : "Item is to long for excel-like filter") + (i + 1).ToString();
                drValues["Rate"] = "Rate " + (i + 1).ToString();
                var dt = new DateTime(2017, (i%12) + 1, 1);
                drValues["MyDate"] = dt;
                if (i <= 3)
                    drValues.SetField("State", DBNull.Value);
                else if (i > 3 && i <= 7)
                    drValues.SetField("State", true);
                else
                    drValues.SetField("State", false);
                drValues["Status"] = "";
                dtValues.Rows.Add(drValues);
            }
        }

        Session["Table"] = dtValues;
    }

    protected void Page_PreRenderComplete(object sender, EventArgs e)
    {
        RadContextMenu menu = RadGrid1.HeaderContextMenu;
        string[] valuesToHide = { "GroupBy", "UnGroupBy", "topGroupSeperator", "bottomGroupSeperator",
                                  "SortAsc", "SortDesc", "SortNone",
                                  "ColumnsContainer", "_filterMenuSeparator", "_FilterList", "_FilterMenuParent"};
        string s = string.Empty;
        foreach (RadMenuItem item in menu.Items)
        {
            s += item.Value + ",";
            if (valuesToHide.Contains(item.Value))
            {
                item.Visible = false;
            }
            //if (item.Value == "FilterMenuParent")
            //{
            //    foreach (Control ctrl in item.Controls)
            //    {
            //        if (!ctrl.ClientID.EndsWith("HCFMFilterButton") && !ctrl.ClientID.EndsWith("HCFMClearFilterButton"))
            //        {
            //            ctrl.Visible = false;
            //        }
            //    }
            //}
        }
    }

    protected void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            GridDataItem item = (GridDataItem)e.Item;
            RadButton btn = (RadButton)item.FindControl("State");//accessing Label
                                                                 //bool? itemValue = item.DataItem["State"];
            object o = ((DataRowView)e.Item.DataItem)["State"];
            bool? b;
            if (o == DBNull.Value)
                b = null;
            else
                b = (bool?)((DataRowView)e.Item.DataItem)["State"];
            btn.SetSelectedToggleStateByValue(b.HasValue ? (b.Value ? "1" : "0") : "null");
        }
    }

    private class DataRowComparer : IEqualityComparer<DataRow>
    {
        private string dataField;
        public DataRowComparer(string dataField)
        {
            this.dataField = dataField;
        }
        public bool Equals(DataRow x, DataRow y)
        {
            return x[dataField].ToString() == y[dataField].ToString();
        }
        public int GetHashCode(DataRow dataRow)
        {
            return dataRow[dataField].GetHashCode();
        }
    }
    private DataTable GetListBoxSource(string dataField)
    {
        dtValues = (DataTable)Session["Table"];
        DataTable table = dtValues.Clone();
        table.Rows.Clear();

        string filterExp = RadGrid1.MasterTableView.FilterExpression;

        string filterSqlExp = string.Empty;
        foreach (GridColumn column in RadGrid1.MasterTableView.Columns)
        {
            if (column.ListOfFilterValues == null)
                continue;

            var x1 = column.CurrentFilterFunction;
            var x2 = column.CurrentFilterValue;
            var x3 = column.EvaluateFilterExpression();


            if (dataField == column.UniqueName)
                continue;

            if (!string.IsNullOrEmpty(filterSqlExp))
                filterSqlExp += " and ";
            filterSqlExp += " " + column.UniqueName + " in (";
            bool firstItem = true;
            foreach (var item in column.ListOfFilterValues)
            {
                if (!firstItem)
                    filterSqlExp += ",";
                else
                    firstItem = false;

                filterSqlExp += "'" + item.ToString() + "'";
            }
            filterSqlExp += ")";
        }

        //filterExp = "Items='Item 2' or Items='Item 3'";
        if (!string.IsNullOrEmpty(filterSqlExp))
        {
            var dr = dtValues.Select(filterSqlExp);
            dr.Cast<DataRow>().Distinct<DataRow>(new DataRowComparer(dataField))
                .ToList().ForEach(x => table.ImportRow(x));
        }
        else
        {
            dtValues.Rows.Cast<DataRow>().Distinct<DataRow>(new DataRowComparer(dataField))
                .ToList().ForEach(x => table.ImportRow(x));
        }
        return table;
    }
    protected void RadGrid1_FilterCheckListItemsRequested(object sender, GridFilterCheckListItemsRequestedEventArgs e)
    {
        string DataField = (e.Column as IGridDataColumn).GetActiveDataField();

        dtValues = (DataTable)Session["Table"];
        var productsQuery = dtValues.AsEnumerable().Select(rec => rec.Field<string>(DataField));
        var selectedColumn = from m in dtValues.AsEnumerable() select new { Text = m.Field<string>(DataField) };

        e.ListBox.DataSource = GetListBoxSource(DataField);
        e.ListBox.DataKeyField = DataField;
        e.ListBox.DataTextField = DataField;
        e.ListBox.DataValueField = DataField;
        e.ListBox.DataBind();
    }

    bool bCanceledByUser = false;
    private void UpdateProgressContext(List<int> lst)
    {
        bCanceledByUser = false;
        const int Total = 100;

        RadProgressContext progress = RadProgressContext.Current;
        progress.OperationComplete = false;
        progress.Speed = "N/A";

        progress.PrimaryTotal = lst.Count();
        progress.PrimaryValue = 1;

        for (int k = 0; k < lst.Count(); k++)
        {
            int rowNum = lst[k];
            for (int i = 0; i < Total; i++)
            {
                progress.PrimaryValue = k;
                progress.PrimaryPercent = Math.Round(((float)k / (float)lst.Count() * 100), 1);

                progress.SecondaryTotal = Total;
                progress.SecondaryValue = i;
                progress.SecondaryPercent = i;

                progress.CurrentOperationText = "Step " + i.ToString();

                if (!Response.IsClientConnected)
                {
                    bCanceledByUser = true;
                    //Cancel button was clicked or the browser was closed, so stop processing
                    break;
                }

                progress.TimeEstimated = (Total - i) * 100;
                //Stall the current thread for 0.1 seconds
                System.Threading.Thread.Sleep(100);
            }
            dtValues = (DataTable)Session["Table"];
            if (bCanceledByUser)
            {
                dtValues.Rows[rowNum]["Status"] = "Terminated";
                break;
            }
            else
            {
                dtValues.Rows[rowNum]["Status"] = "OK";
            }
        }
        progress.OperationComplete = true;
    }

    protected void PerfromLinkButton_Click(object sender, EventArgs e)
    {
        MdlRadProgress radProgress = new MdlRadProgress();
        radProgress.bFinished = false;
        Session["PerfromLinkButton_Click"] = radProgress;

        // get list of selected items
        List<int> lst = new List<int>();
        foreach (GridDataItem item in RadGrid1.SelectedItems)
        {
            //your code
            String sId = item["Id"].Text;
            int iId;
            if (int.TryParse(sId, out iId))
                lst.Add(iId);
        }

        // Handle selected items
        String sMsg = String.Empty;
        if (lst.Count == 0)
        {
            sMsg = "No records were selected, Please select records!";
            radWindowManager.RadAlert(sMsg, 400, 250, Page.Title, String.Empty);
            return;
        }

        UpdateProgressContext(lst);
        if (bCanceledByUser)
        {
            for (int i = 1; i < 100; i++)
                Thread.Sleep(100);
        }

        // finalize engine
        RadGrid1.Rebind();

        if (bCanceledByUser)
            sMsg = "הפעולה הופסקה ע'י המשתמש";
        else
            sMsg = "OK";

        radProgress.sMsg = sMsg;
        radProgress.sTitle = Page.Title;
        radProgress.x = 400;
        radProgress.y = 250;
        radProgress.bFinished = true;
        Session["PerfromLinkButton_Click"] = radProgress;

        radWindowManager.RadAlert(sMsg, 400, 250, Page.Title, String.Empty);
    }

    //show filtering indicator
    protected void RadGrid1_PreRender(object sender, EventArgs e)
    {
        //GridHeaderItem header = RadGrid1.MasterTableView.GetItems(GridItemType.Header)[0] as GridHeaderItem;
        //var headers = RadGrid1.MasterTableView.GetItems(GridItemType.Header);

        foreach (GridColumn col in RadGrid1.MasterTableView.RenderColumns
               .OfType<IGridDataColumn>().Where(x => x.AllowFiltering))
        {
            if (!string.IsNullOrEmpty(col.EvaluateFilterExpression()))
            {
                for (int i = 0; i < 1 /* headers.Count() */ ; i++)
                {
                    //GridHeaderItem header = headers[i] as GridHeaderItem;
                    //TableCell cell = header[col.UniqueName];
                    TableCell cell = RadGrid1.MasterTableView.GetHeaderCellByColumnUniqueName(col.UniqueName);

                    //style the cell as desired (e.g., change class, background color, add image, etc.
                    //cell.CssClass = "rgFiltered";

                    if (cell != null && cell.Controls != null)
                    {
                        foreach (var ctrl in cell.Controls)
                        {
                            if (ctrl is WebControl)
                            {
                                var cssClass = ((WebControl)ctrl).CssClass;
                                if (cssClass.Contains("rgOptions") && !cssClass.Contains("rgFiltered"))
                                    ((WebControl)ctrl).CssClass += " rgFiltered";
                            }
                        }
                    }

                    cell.BackColor = System.Drawing.Color.Aqua;
                    cell.Style["background-image"] = "none";

                    //cell.Controls.Add(new Image()
                    //{
                    //    ID = "FilterIndicator" + col.UniqueName,
                    //    ImageUrl = "~/images/filterIndicator.png"
                    //});
                }
            }
        }

        //// Method1
        //var lb = RadGrid1.FindControl("filterCheckList") as RadListBox;
        //lb.OnClientLoad = "graffiti.FilterListBoxLoad";
        //lb.OnClientCheckAllChecked = "graffiti.CheckAllChecked";

        // method2
        var lb = RadGrid1.FindControl("filterCheckList") as RadListBox;
        //lb.ShowCheckAll = false;
        lb.OnClientCheckAllChecking = "graffiti.OnClientCheckAllChecking";
    }

    // Clear All Filters
    protected void RadButton_ClearAllFilters_Click(object sender, EventArgs e)
    {
        foreach (GridColumn column in RadGrid1.MasterTableView.Columns)
        {
            column.ListOfFilterValues = null; // CheckList values set to null will uncheck all the checkboxes

            column.CurrentFilterFunction = GridKnownFunction.NoFilter;
            column.CurrentFilterValue = string.Empty;
        }
        RadGrid1.MasterTableView.FilterExpression = string.Empty;
        RadGrid1.MasterTableView.Rebind();
    }

    //protected void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
    //{
    //    if (e.CommandName == "ClearFiltersCustom")
    //    {
    //        RadGrid1.MasterTableView.FilterExpression = string.Empty;
    //        foreach (GridColumn column in RadGrid1.MasterTableView.RenderColumns)
    //        {
    //            column.CurrentFilterFunction = GridKnownFunction.NoFilter;
    //            column.CurrentFilterValue = string.Empty;
    //        }
    //        RadGrid1.MasterTableView.Rebind();
    //    }
    //}


    protected void ThreeStateCheckBox_ToggleStateChanged(object sender, ButtonToggleStateChangedEventArgs e)
    {

    }
}
