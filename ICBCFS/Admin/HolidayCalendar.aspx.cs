using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ICBCFS.DataAccessLayer;
using System.Data;
using ICBCFS.Common;
using static ICBCFS.DataAccessLayer.CommonDAL;
using DevExpress.Web;


namespace ICBCFS.Admin
{

    public partial class HolidayCalendar : System.Web.UI.Page
    {
        IEquityDAL iEquityDAL = new EquityDAL();
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                FillData();
                cmbYear.SelectedIndex = 0;
                cmbIsHoliday.SelectedIndex = 0;

                MasterPage master = this.Master as MasterPage;
                ASPxLabel masterLabel = master.FindControl("lblPageTitle") as ASPxLabel;
                masterLabel.Text = "Holiday Calendar";
            }

            //Bind the grid only once
            if (!IsPostBack)
                gridHolidayCalendar.DataBind();

            GridViewFeaturesHelper.SetupGlobalGridViewBehavior(gridHolidayCalendar);
            ScriptManager sm = ScriptManager.GetCurrent(this.Page);
            sm.RegisterAsyncPostBackControl(btnSearch);

        }
        protected void grid_DataBinding(object sender, EventArgs e)
        {
            // Assign the data source in grid_DataBinding
            gridHolidayCalendar.DataSource = GetData();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            gridHolidayCalendar.DataBind();
            upAccountMapping.Update();

        }

        private DataTable GetData()
        {

            DateTime dtHistorydate;
            dtHistorydate = DateTime.MinValue;

            string userName = CommonUtility.GetUserId();

            string category, subCategory, description, branchcd, accountcd, typeAccountcd, ownerName, externalFeedReference, currenctcd, glaccount, insertedby, lastupdtby, actiontype, acctClass, dynamicAcct, dynamicDept;
            DateTime insertedDatetime, updatedDatetime;
            category = subCategory = description = branchcd = accountcd = typeAccountcd = ownerName = externalFeedReference = currenctcd = glaccount = insertedby = lastupdtby = acctClass = dynamicAcct = dynamicDept = string.Empty;
            insertedDatetime = updatedDatetime = DateTime.MinValue;
            actiontype = "S";

            DateTime calendarDate, DOM_SYSDATE, DOM_PREVDATE, INTL_SYSDATE, INTL_PREVDATE;
            calendarDate = DOM_SYSDATE = DOM_PREVDATE = INTL_SYSDATE = INTL_PREVDATE = DateTime.MinValue;
            int Year, DOM_TradeDay, DOM_SettleDay, INTL_TradeDay, INTL_SettleDay, isHoliday, Euroclear_holiday_Flag, Clearstram_holiday_Flag, Kass_holiday_Flag, Local_holiday_Flag;
            Year = DOM_TradeDay = DOM_SettleDay = INTL_TradeDay = INTL_SettleDay = isHoliday = Euroclear_holiday_Flag = Clearstram_holiday_Flag = Kass_holiday_Flag = Local_holiday_Flag = 0;
            string HolidayDescr, HolidayComment, Actiontype, username;
            HolidayDescr = HolidayComment = Actiontype = username = string.Empty;
            Year = cmbYear.SelectedItem.Value.ToString() == "All" ? 0 : Convert.ToInt16(cmbYear.SelectedItem.Value.ToString());
            isHoliday = cmbIsHoliday.SelectedItem.Value.ToString() == "All" ? 2 : Convert.ToInt16(cmbIsHoliday.SelectedItem.Value.ToString());



            DataTable dt = iEquityDAL.GetHolidayCalendar(calendarDate, Year, DOM_SYSDATE, DOM_PREVDATE, DOM_TradeDay, DOM_SettleDay, INTL_SYSDATE, INTL_PREVDATE, INTL_TradeDay, INTL_SettleDay, isHoliday, HolidayDescr, HolidayComment, Euroclear_holiday_Flag,
            Clearstram_holiday_Flag, Kass_holiday_Flag, Local_holiday_Flag, actiontype, userName);


            return dt;
        }


        private void FillData()
        {
            cmbYear.Items.Clear();
            cmbYear.Items.Add("All", "All");
            for (int i= (DateTime.Now.Year-1); i<= DateTime.Now.Year+10; i++)
            {
                cmbYear.Items.Add(i.ToString(), i.ToString());
            }
           
            cmbIsHoliday.Items.Clear();
            cmbIsHoliday.Items.Add("All", "All");
            cmbIsHoliday.Items.Add("0", "0");
            cmbIsHoliday.Items.Add("1", "1");
        }


        protected void gridHolidayCalendar_ToolbarItemClick(object source, DevExpress.Web.Data.ASPxGridViewToolbarItemClickEventArgs e)
        {
            if (e.Item.Name == "tbResetSorting")
            {
                gridHolidayCalendar.ClearSort();
            }
        }


        protected void gridHolidayCalendar_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            ASPxGridView grid = sender as ASPxGridView;
            DateTime calendarDate, DOM_SYSDATE, DOM_PREVDATE, INTL_SYSDATE, INTL_PREVDATE;
            calendarDate = DOM_SYSDATE = DOM_PREVDATE = INTL_SYSDATE = INTL_PREVDATE = DateTime.MinValue;
            int Year, DOM_TradeDay, DOM_SettleDay, INTL_TradeDay, INTL_SettleDay, isHoliday, Euroclear_holiday_Flag, Clearstram_holiday_Flag, Kass_holiday_Flag, Local_holiday_Flag;
            Year = DOM_TradeDay = DOM_SettleDay = INTL_TradeDay = INTL_SettleDay = isHoliday = Euroclear_holiday_Flag = Clearstram_holiday_Flag = Kass_holiday_Flag = Local_holiday_Flag = 0;
            string HolidayDescr, HolidayComment, actiontype, username;
            HolidayDescr = HolidayComment = actiontype = username = string.Empty;
            Year = cmbYear.SelectedItem.Value.ToString() == "All" ? 0 : Convert.ToInt16(cmbYear.SelectedItem.Value.ToString());
            isHoliday = cmbIsHoliday.SelectedItem.Value.ToString() == "All" ? 2 : Convert.ToInt16(cmbIsHoliday.SelectedItem.Value.ToString());

            actiontype = "U";
            username = CommonUtility.GetUserId();


            int Id = (int)e.Keys[0];
            DOM_SYSDATE = (DateTime)e.NewValues["DOM_SYSDATE"];
            DOM_PREVDATE = (DateTime)e.NewValues["DOM_PREVDATE"];
            DOM_TradeDay = (int)e.NewValues["DOM_TradeDay"];
            DOM_SettleDay = (int)e.NewValues["DOM_SettleDay"];
            INTL_SYSDATE = (DateTime)e.NewValues["INTL_SYSDATE"];
            INTL_PREVDATE = (DateTime)e.NewValues["INTL_PREVDATE"];
            INTL_TradeDay = (int)e.NewValues["INTL_TradeDay"];
            INTL_SettleDay = (int)e.NewValues["INTL_SettleDay"];
            isHoliday = (int)e.NewValues["isHoliday"];
            HolidayDescr = (string)e.NewValues["HolidayDescr"];
            HolidayComment = (string)e.NewValues["HolidayComment"];
            Euroclear_holiday_Flag = (int)e.NewValues["Euroclear_holiday_Flag"];
            Clearstram_holiday_Flag = (int)e.NewValues["Clearstram_holiday_Flag"];
            Kass_holiday_Flag = (int)e.NewValues["Kass_holiday_Flag"];
            Local_holiday_Flag = (int)e.NewValues["Local_holiday_Flag"];
            Euroclear_holiday_Flag = (int)e.NewValues["Euroclear_holiday_Flag"];

            int ret = iEquityDAL.UpdateHolidayCalendar(calendarDate, Year, DOM_SYSDATE, DOM_PREVDATE, DOM_TradeDay, DOM_SettleDay, INTL_SYSDATE, INTL_PREVDATE, INTL_TradeDay, INTL_SettleDay, isHoliday, HolidayDescr, HolidayComment, Euroclear_holiday_Flag,
            Clearstram_holiday_Flag, Kass_holiday_Flag, Local_holiday_Flag, actiontype, username, Id);

            e.Cancel = true;
            grid.CancelEdit();

        }


        protected void gridHolidayCalendar_RowDeleting(object sender, DevExpress.Web.Data.ASPxDataDeletingEventArgs e)
        {
            ASPxGridView grid = sender as ASPxGridView;

            string userName = CommonUtility.GetUserId();

            string category, subCategory, description, branchcd, accountcd, typeAccountcd, ownerName, externalFeedReference, currenctcd, glaccount, insertedby, lastupdtby, actiontype, acctClass, dynamicAcct, dynamicDept;
            DateTime insertedDatetime, updatedDatetime;
            category = subCategory = description = branchcd = accountcd = typeAccountcd = ownerName = externalFeedReference = currenctcd = glaccount = insertedby = lastupdtby = acctClass = dynamicAcct = dynamicDept = string.Empty;
            insertedDatetime = updatedDatetime = DateTime.MinValue;
            actiontype = "D";

            int accountMappingId = (int)e.Keys[0];
            int ret = iEquityDAL.UpdateAccountMapping(category, subCategory, description, branchcd, accountcd, typeAccountcd, ownerName, externalFeedReference, currenctcd, glaccount, insertedby, lastupdtby, insertedDatetime, updatedDatetime, userName, actiontype, acctClass, dynamicAcct, dynamicDept, accountMappingId);

            e.Cancel = true;
        }

        protected void gridHolidayCalendar_RowInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e)
        {
            ASPxGridView grid = sender as ASPxGridView;
            string userName = CommonUtility.GetUserId();

            string category, subCategory, description, branchcd, accountcd, typeAccountcd, ownerName, externalFeedReference, currenctcd, glaccount, insertedby, lastupdtby, actiontype, acctClass, dynamicAcct, dynamicDept;
            DateTime insertedDatetime, updatedDatetime;
            category = subCategory = description = branchcd = accountcd = typeAccountcd = ownerName = externalFeedReference = currenctcd = glaccount = insertedby = lastupdtby = acctClass = dynamicAcct = dynamicDept = string.Empty;
            insertedDatetime = updatedDatetime = DateTime.MinValue;
            actiontype = "A";

            int accountMappingId = (int)(99);
            category = (string)e.NewValues["Category"];
            subCategory = (string)e.NewValues["SubCategory"];
            description = (string)e.NewValues["Description"];
            branchcd = (string)e.NewValues["Branch_cd"];
            accountcd = (string)e.NewValues["Account_cd"];
            typeAccountcd = (string)e.NewValues["type_Account_cd"];
            ownerName = (string)e.NewValues["OwnerName"];
            externalFeedReference = (string)e.NewValues["ExternalFeedReference"];
            currenctcd = (string)e.NewValues["Currenct_cd"];
            glaccount = (string)e.NewValues["GLAccount"];

            acctClass = (string)e.NewValues["Acct_Class"];
            dynamicAcct = (string)e.NewValues["DynamicAcct"];
            dynamicDept = (string)e.NewValues["DynamicDept"];

            int ret = iEquityDAL.UpdateAccountMapping(category, subCategory, description, branchcd, accountcd, typeAccountcd, ownerName, externalFeedReference, currenctcd, glaccount, insertedby, lastupdtby, insertedDatetime, updatedDatetime, userName, actiontype, acctClass, dynamicAcct, dynamicDept, accountMappingId);

            e.Cancel = true;
            grid.CancelEdit();

        }

    }
}