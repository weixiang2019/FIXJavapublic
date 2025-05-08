using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ICBCFS.DataAccessLayer;
using System.Data;
using System.Security.Principal;
using ICBCFS.Common;
using DevExpress.Web;
using System.Collections;
using static ICBCFS.DataAccessLayer.CommonDAL;

namespace ICBCFS.Admin
{
    public partial class BroadRidgeEntryCode : System.Web.UI.Page
    {
        string userName = CommonUtility.GetUserId();

        IEquityDAL iEquityDAL = new EquityDAL();
        DataTable dt1 = null;
        /// <summary>
        /// UI Web Page Page Load activities
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>

        protected void Page_Load(object sender, EventArgs e)
        {

            FillData();
            LoadLayout();
            //if (!IsPostBack)
            //{
            //    cmbEnumType.SelectedIndex = 0;
            //    //GetData();
            //    Session["DataTable"] = dt1;
            //}
            //else
            //{
                GetData();
            //}
            //if (IsPostBack)
            //    GetData();
            //Session["DataTable"] = dt1;

            GridViewFeaturesHelper.SetupGlobalGridViewBehavior(gridBroadRidgeEntryCode);

            //ScriptManager sm = ScriptManager.GetCurrent(this.Page);
            //sm.RegisterAsyncPostBackControl(btnSearch);

        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            //string strBranch = cmbBranch.SelectedItem.ToString();
            //string strAccountType = cmbAccountType.SelectedItem.Value.ToString();
            //string strCurrency = cmbCurrency.SelectedItem.Value.ToString();
            //string strAccountFrom = txtAccountFrom.Text.ToString();
            //string strAccountTo = txtAccountTo.Text.ToString();

            //string strSecuritySearchType = cmbSecuritySearchType.SelectedItem.Value.ToString();
            //string strSearch = txtSearch.Text.ToString();
            //DateTime dtTradeStart = dtTradeFrom.Value == null ? DateTime.MinValue :  dtTradeFrom.Date;
            //DateTime dtTradeEnd = dtTradeTo.Value == null ? DateTime.MinValue : dtTradeTo.Date; 
            //DateTime dtSettleStart = dtSettleFrom.Value == null ? DateTime.MinValue : dtSettleFrom.Date;
            //DateTime dtSettleEnd = dtSettleTo.Value == null ? DateTime.MinValue : dtSettleTo.Date;

            //string userName = WindowsIdentity.GetCurrent().Name;

            //DataTable dt = iEquityDAL.GetAccountActivity(strBranch, strAccountFrom, strAccountTo, strAccountType, strCurrency, dtTradeStart, dtTradeEnd, dtSettleStart, dtSettleEnd, strSearch, strSecuritySearchType, userName);
            //gridMainAccountActivity.DataSource = dt;
            //gridMainAccountActivity.DataBind();
            //GridViewFeaturesHelper.SetupGlobalGridViewBehavior(gridMainAccountActivity);

            upAccountActivity.Update();
        }

        private void GetData()
        {
            string strEnumKey = "";
            //string strEnumType = cmbEnumType.SelectedItem.Value.ToString();
            string strEnumType = "Entry Type";
            //string strEntryCode = Request.QueryString["EntryType"];
            //string strEnumValue = "";
            string strEnumValue = Request.QueryString["EntryType"];
            string strEnumValueDesc = "";
            string strEnableFlag = "";
            //string userName = WindowsIdentity.GetCurrent().Name;

            //string strPara = "S";

            //DataTable dtSelect = iEquityDAL.GetBroadRidgeEntryCode(strEnumKey, strEnumType, strEnumValue,
            //    strEnumValueDesc, strEnableFlag, userName, strPara);

            DataTable dtSelect = iEquityDAL.GetBroadRidgeEntryCode(strEnumKey, strEnumType, strEnumValue,
                strEnumValueDesc, strEnableFlag, userName);

            dt1 = dtSelect;

            gridBroadRidgeEntryCode.DataSource = dt1;
            gridBroadRidgeEntryCode.DataBind();
            gridBroadRidgeEntryCode.PageIndex = 0;
        }

        protected void SaveLayout_Click(object sender, EventArgs e)
        {
            var layout = gridBroadRidgeEntryCode.SaveClientLayout();
            string layoutname = tbname.Text;
            String UserName = Request.LogonUserIdentity.Name;
            List<CustomSummary> customSummaryList = new List<CustomSummary>();
            foreach (ASPxSummaryItem summaryItem in gridBroadRidgeEntryCode.GroupSummary)
            {
                CustomSummary custSummary = new CustomSummary();
                custSummary.CustomSummaryColumnName = summaryItem.FieldName;
                custSummary.CustomSummaryType = (int)summaryItem.SummaryType;
                customSummaryList.Add(custSummary);
            }
            CommonDAL.SaveGridLayout("Mapping", layoutname, layout, UserName, "I", ref customSummaryList);
            pcSaveLayout.ShowOnPageLoad = false;
        }

        private void FillData()
        {
            //cmbEnumType.DataSource = CommonDAL.GetFilterControl("EnumType");
            //cmbEnumType.TextField = "DisplayText";
            //cmbEnumType.ValueField = "columnVal";
            //cmbEnumType.DataBind();
        }

        protected void LoadLayout_Click(object sender, EventArgs e)
        {
            //var layout = gridProductProfile.SaveClientLayout();
            var layout = "test7";
            string layoutname = tbname.Text;
            String UserName = Request.LogonUserIdentity.Name;
            List<CustomSummary> customSummaryList = new List<CustomSummary>();
            string layoutString = CommonDAL.LoadGridLayoutValue(Common.Constants.pgAccountActivity, layoutname, layout, UserName, "S", ref customSummaryList);

            pcLoadLayout.ShowOnPageLoad = false;

            gridBroadRidgeEntryCode.LoadClientLayout(layoutString);

            upAccountActivity.Update();
        }

        private void LoadLayout()
        {
            var layout = "";
            string layoutname = tbname.Text;
            String UserName = Request.LogonUserIdentity.Name;
            DataTable dtLayout = CommonDAL.LoadGridLayout(Common.Constants.pgAccountActivity, layoutname, layout, UserName, "S");
            cbLayoutList.DataSource = dtLayout;
            cbLayoutList.TextField = "LayoutName";
            cbLayoutList.ValueField = "ScreenLayout_Key";
            cbLayoutList.DataBind();
        }

        protected void gridMainMapping_RowInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e)
        {
            //dt1 = (DataTable)Session["DataTable"];
            ASPxGridView gridView = sender as ASPxGridView;
            DataTable dataTable = dt1;
            //DataTable dataTable;

            //DataRow row = dataTable.NewRow();
            //e.NewValues["enum_key"] = GetNewEnumKey();

            IDictionaryEnumerator enumerator = e.NewValues.GetEnumerator();

            //e.NewValues[0].ToString();
            string strEnumKey = "";
            string strEnumType = e.NewValues[0].ToString();
            string strEnumValue = e.NewValues[1].ToString();
            //string userName = CommonUtility.GetUserName();
            string strEnumValueDesc = e.NewValues[2].ToString();
            string strEnableFlag = e.NewValues[3].ToString();
            //string strEmailAddress = e.NewValues[5].ToString();
            //string strIsPoweruser = e.NewValues[6].ToString();
            //string strCreatedBy = CommonUtility.GetUserName();
            string strPara = "I";

            DataTable dtInsert = iEquityDAL.GetMapping(strEnumKey, strEnumType, strEnumValue,
                strEnumValueDesc, strEnableFlag, userName, strPara);

            strPara = "S";
            DataTable dtSelect = iEquityDAL.GetMapping(strEnumKey, strEnumType, strEnumValue,
                strEnumValueDesc, strEnableFlag, userName, strPara);

            dataTable = dtSelect;

            //dataTable = dtInsert;

            //enumerator.Reset();
            //while (enumerator.MoveNext())
            //    if (enumerator.Key.ToString() != "Count")
            //        row[enumerator.Key.ToString()] = enumerator.Value;
            gridView.CancelEdit();
            e.Cancel = true;
            //dataTable.Rows.Add(row);

            //DataRow[] rows;
            //rows = dataTable.Select("IsEnabled = '0'");  //'UserName' is ColumnName
            //foreach (DataRow row1 in rows)
            //    dataTable.Rows.Remove(row1);

            gridBroadRidgeEntryCode.DataSource = dataTable;
            gridBroadRidgeEntryCode.DataBind();
            gridBroadRidgeEntryCode.PageIndex = 0;
        }
        private int GetNewEnumKey()
        {
            dt1 = (DataTable)Session["DataTable"];
            DataTable table = dt1;
            if (table.Rows.Count == 0) return 0;
            int max = Convert.ToInt32(table.Rows[0]["enum_key"]);
            for (int i = 1; i < table.Rows.Count; i++)
            {
                if (Convert.ToInt32(table.Rows[i]["enum_key"]) > max)
                    max = Convert.ToInt32(table.Rows[i]["enum_key"]);
            }
            return max + 1;
        }
        protected void gridMainMapping_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            //int i = gridMainMapping.FindVisibleIndexByKeyValue(e.Keys[gridMainMapping.KeyFieldName]);
            //dt1 = (DataTable)Session["DataTable"];
            ASPxGridView gridView = (ASPxGridView)sender;

            //DataTable dataTable = dt1;
            DataTable dataTable;

            //DataRow row = dataTable.Rows.Find(e.Keys[0]);

            //string strFirstName = "";
            //string strLastName = "";
            //string strUserName = e.NewValues[2].ToString();
            string strEnumKey = e.Keys[gridBroadRidgeEntryCode.KeyFieldName].ToString();
            //string strEnumType = e.NewValues[0].ToString();
            string strEnumValue = e.NewValues[0].ToString();
            string strEnumValueDesc = e.NewValues[1].ToString();
            string strEnableFlag = e.NewValues[2].ToString();
            //string userName = WindowsIdentity.GetCurrent().Name;
            string strPara = "U";

            DataTable dtUpdate = iEquityDAL.GetMapping(strEnumKey, strEnumType, strEnumValue,
                strEnumValueDesc, strEnableFlag, userName, strPara);

            //dataTable = dtUpdate;
            strPara = "S";
            DataTable dtSelect = iEquityDAL.GetMapping(strEnumKey, strEnumType, strEnumValue,
                strEnumValueDesc, strEnableFlag, userName, strPara);

            dataTable = dtSelect;
            //DataRow[] rows;
            //rows = dataTable.Select("Enable_flag = '1'");  //'UserName' is ColumnName
            //foreach (DataRow row in rows)
            //    dataTable.Rows.Remove(row);

            ////IDictionaryEnumerator enumerator = e.NewValues.GetEnumerator();
            ////enumerator.Reset();
            ////while (enumerator.MoveNext())
            ////    row[enumerator.Key.ToString()] = enumerator.Value;
            gridView.CancelEdit();
            e.Cancel = true;

            gridBroadRidgeEntryCode.DataSource = dataTable;
            gridBroadRidgeEntryCode.DataBind();
            gridBroadRidgeEntryCode.PageIndex = 0;
        }
        string strEnumType;
        //string strLastName;
        //string strUserName;
        protected void gridMainMapping_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            if (e.Value != null && !(sender as ASPxGridView).IsNewRowEditing)
            {


                if (e.Column.FieldName == "enum_type")
                {
                    strEnumType = e.Value.ToString();
                    e.Editor.Enabled = false;
                }
                //if (e.Column.FieldName == "LastName")
                //{
                //    strLastName = e.Value.ToString();
                //    e.Editor.Enabled = false;
                //}
                //if (e.Column.FieldName == "UserName")
                //{
                //    strUserName = e.Value.ToString();
                //    e.Editor.Enabled = false;
                //}
            }
        }

        protected void gridBroadRidgeEntryCode_DataBound(object sender, EventArgs e)
        {
            var grid = sender as ASPxGridView;
            if (grid == null) return;
            foreach (var column in grid.Columns.OfType<GridViewDataColumn>().Where(c => c.Visible))
            {
                if(column.FieldName == "BatchCode" || column.FieldName == "EntryCodes" || column.FieldName == "Entry Type")
                {
                    column.Width = System.Web.UI.WebControls.Unit.Point(50);
                }

                if(column.FieldName == "SPIN" )
                {
                    column.Width = System.Web.UI.WebControls.Unit.Point(50);
                }
                if (column.FieldName == "Description")
                {
                    column.Width = System.Web.UI.WebControls.Unit.Point(200);
                }
                if(column.FieldName == "BookkeepingType")
                {
                    column.Width = System.Web.UI.WebControls.Unit.Point(200);
                    //column.Width = System.Web.UI.WebControls.Unit.Point(column.FieldName.Length * 12);
                }
                if(column.FieldName == "orderno")
                {
                    column.Visible = false;
                }
                //column.Width = System.Web.UI.WebControls.Unit.Point(column.FieldName.Length * 12);
                column.SettingsHeaderFilter.Mode = GridHeaderFilterMode.CheckedList;
                //column.SettingsHeaderFilter = 140;

            }
        }
    }
}