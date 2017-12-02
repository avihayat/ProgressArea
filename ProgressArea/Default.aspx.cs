using System;
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
        dtValues.Columns.Add("Status");
        if (Session["Table"] != null)
        {
            dtValues = (DataTable)Session["Table"];
        }
        RadGrid1.DataSource = dtValues;//populate RadGrid with datatable

        if (dtValues.Rows.Count == 0)
        {
            for (int i = 0; i < 10; i++)
            {
                DataRow drValues = dtValues.NewRow();
                drValues["Id"] = i.ToString();
                drValues["Items"] = "Item " + (i+1).ToString();
                drValues["Rate"] = "Rate " + (i+1).ToString();
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
        dtValues.Rows.Cast<DataRow>().Distinct<DataRow>(new DataRowComparer(dataField))
            .ToList().ForEach(x => table.ImportRow(x));
        return table;
    }
    protected void RadGrid1_FilterCheckListItemsRequested(object sender, GridFilterCheckListItemsRequestedEventArgs e)
    {
        string DataField = (e.Column as IGridDataColumn).GetActiveDataField();

        dtValues = (DataTable)Session["Table"];
        var productsQuery = dtValues.AsEnumerable().Select(rec=> rec.Field<string>(DataField));
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
            for (int i = 1; i  < 100; i++)
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

}
