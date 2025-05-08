using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ICBCFS.DataAccessLayer;
using System.Data;
using DevExpress.Web;
using ICBCFS.Common;
using System.Text;

namespace ICBCFS.Admin
{
    public partial class UserReportSubscription : System.Web.UI.Page
    {
        IEquityDAL iEquityDAL = new EquityDAL();
        string userName;

        string strUserName = string.Empty;
        string strTradeRejectEntityList = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {


            userName = CommonUtility.GetUserId();

            ASPxButton btn = new ASPxButton();
            string id = Page.Request.Params["__EVENTTTARGET"];
            if (!String.IsNullOrEmpty(id))
            {
                btn = Page.FindControl(id) as ASPxButton;
            }
            else
            {
                foreach (var cid in Page.Request.Form.AllKeys)
                {
                    if (cid != null)
                    {
                        Control c = Page.FindControl(cid) as Control;
                        if (c is ASPxButton)
                        {
                            btn = c as ASPxButton;
                        }
                    }
                }
            }

            FillData(!IsPostBack);

            if (!IsPostBack)
            {
                chkIsEnabled.Checked = true;
                cmbSubscriptionName.SelectedIndex = 0;
                cmbSubscriptionName_SelectedIndexChanged(null, null);

                MasterPage master = this.Master as MasterPage;
                ASPxLabel masterLabel = master.FindControl("lblPageTitle") as ASPxLabel;
                masterLabel.Text = "User Report Subscription";
            }
            else
            {
                if (btn.ID == "btnRunSubscription")
                {
                    //RunSubscription();
                    cmbSubscriptionName_SelectedIndexChanged(null, null);
                }
                else if (btn.ID == "btnUpdateReportPreference")
                {
                    InsertUpdateSubscription();
                }
            }
        }

        protected void gridMainSummary_CustomColumnDisplayText(object sender, ASPxGridViewColumnDisplayTextEventArgs e)
        {
            if (e.Column.FieldName == "Report_Execution_status_indicator" ) //|| e.Column.FieldName == "FTP_Execution_status" || e.Column.FieldName == "Email_Execution_status")
            {
                if (e.Value == DBNull.Value)
                {
                    return;
                }
                else
                {
                    e.DisplayText = "";
                }
            }

        }
        private void RunSubscription()
        {
            UserSubscription uSubscription = new UserSubscription();
            uSubscription.SubscriptionName = cmbSubscriptionName.Text.ToString();
            uSubscription.UserName = userName;
            iEquityDAL.RunSubscriptionUpdateScreenTime(uSubscription);
            lblMessage.Text = cmbSubscriptionName.Text.ToString() + " Subscription has been intitiated.";
            FillData(true);
        }

        private void InsertUpdateSubscription()
        {
            try
            {
                UserSubscription uSubscription = new UserSubscription();
                uSubscription.SubscriptionName = cmbSubscriptionName.Text.ToString();
                uSubscription.UserName = userName;
                uSubscription.IsActive = chkIsEnabled.Checked ? true : false;
                uSubscription.SchduelTime = dtScheduleTime.Text.ToString();
                uSubscription.ToEmailAddress = txtToEmailAddress.Text.ToString();
                uSubscription.CcEmailAddress = txtCCEmailAddress.Text.ToString();
                uSubscription.EmailSubject = txtEmailSubject.Text.ToString();

                List<UserReportEntitySubscription> userReportEntitySubscriptions = new List<UserReportEntitySubscription>();
                foreach (ListEditItem item in lbEntityCodeList.SelectedItems)
                {
                    if (item.Selected)
                    {
                        UserReportEntitySubscription entitySubscription = new UserReportEntitySubscription();
                        entitySubscription.EntityCode = item.Value.ToString();
                        strTradeRejectEntityList += item.Value + ",";
                        userReportEntitySubscriptions.Add(entitySubscription);
                    }
                }
                uSubscription.userReportEntitySubscriptions = userReportEntitySubscriptions;


                List<userReportNameSubscription> userReportNameSubscriptions = new List<userReportNameSubscription>();
                for (int i = 0; i < GridRealTimeReports.VisibleRowCount; i++)
                {

                    //DataRow row = GridRealTimeReports.GetDataRow(i);
                    int reportId = int.Parse(GridRealTimeReports.GetRowValues(i, "ReportId").ToString());
                    string reportName = GridRealTimeReports.GetRowValues(i, "ReportName").ToString();
                    CheckBox chkIsRun = GridRealTimeReports.FindRowCellTemplateControl(i, GridRealTimeReports.DataColumns[1], "chkIsRun") as CheckBox;
                    bool IsRun = chkIsRun == null ? false: chkIsRun.Checked;
                    CheckBox chkIsFtp = GridRealTimeReports.FindRowCellTemplateControl(i, GridRealTimeReports.DataColumns[2], "chkIsFtp") as CheckBox;
                    bool IsFtp = chkIsFtp.Checked;
                    CheckBox chkIsSchedule = GridRealTimeReports.FindRowCellTemplateControl(i, GridRealTimeReports.DataColumns[3], "chkIsSchedule") as CheckBox;
                    bool IsSchedule = chkIsSchedule.Checked;
                    CheckBox chkIsEmail = GridRealTimeReports.FindRowCellTemplateControl(i, GridRealTimeReports.DataColumns[4], "chkIsEmail") as CheckBox;
                    bool IsEmail = chkIsEmail.Checked;

                    if (IsRun || IsFtp || IsSchedule || IsEmail)
                    {
                        userReportNameSubscription uNameSubscription = new userReportNameSubscription();
                        uNameSubscription.ReportId = reportId;
                        uNameSubscription.ReportName = reportName;
                        uNameSubscription.IsRun = IsRun;
                        uNameSubscription.IsFtp = IsFtp;
                        uNameSubscription.IsSchedule = IsSchedule;
                        uNameSubscription.IsEmail = IsEmail;
                        userReportNameSubscriptions.Add(uNameSubscription);
                    }
                }
                uSubscription.userReportNameSubscriptions = userReportNameSubscriptions;

                int subscriptionId = iEquityDAL.AddUpdateSubscription(uSubscription);
                lblMessage.Text = cmbSubscriptionName.Text.ToString() + " Sucessfully added/updated.";
                FillData(true);
            }
            catch (Exception ex)
            {

            }
        }


        protected void btnUpdate2_Click(object sender, EventArgs e)
        {


            upUserPreference.Update();

        }

        private void FillData(bool IsRefreshRequired)
        {
            if (IsRefreshRequired)
            {
                strUserName = userName;
                DataTable dtSubscription = iEquityDAL.GetUserSubscription(userName);
                Session["MyDataSource"] = dtSubscription;

            }
            cmbSubscriptionName.DataSource = Session["MyDataSource"];
            cmbSubscriptionName.TextField = "SubscriptionName";
            cmbSubscriptionName.ValueField = "UserSubscriptionId";
            cmbSubscriptionName.DataBind();

            GridRealTimeReportSubscriptions.DataSource = Session["MyDataSource"];
            GridRealTimeReportSubscriptions.DataBind();

        }

        protected void cmbSubscriptionName_SelectedIndexChanged(object sender, EventArgs e)
        {
            int subscriptionId = 0;
            if (cmbSubscriptionName.SelectedItem != null)
            {
                string UserSubscriptionId = cmbSubscriptionName.SelectedItem.Value.ToString();
                subscriptionId = int.Parse(UserSubscriptionId);
                DataTable dtSubscription = (DataTable)cmbSubscriptionName.DataSource;
                DataRow[] drs = dtSubscription.Select("UserSubscriptionId=" + subscriptionId);
                dtScheduleTime.Text = drs[0]["SubscriptionScheduleTime"].ToString();
                chkIsEnabled.Checked = (bool)drs[0]["IsActive"];
                txtToEmailAddress.Text = drs[0]["EmailTo"].ToString();
                txtCCEmailAddress.Text = drs[0]["EmailCC"].ToString();

                txtEmailSubject.Text = drs[0]["Emailsubject"].ToString();
                if (drs[0]["SubscriptionEndTime"] == DBNull.Value && drs[0]["SubscriptionStartTime"] != DBNull.Value)
                {
                    //btnRunSubscription.Enabled = false;
                    btnUpdateReportPreference.Enabled = false;
                    lblMessage.Text = "'" + cmbSubscriptionName.SelectedItem.Text.ToString() + "' Is currently running. Please wait till it completed to make any changes to subscription.";
                }
                else
                {
                    //btnRunSubscription.Enabled = chkIsEnabled.Checked;
                    btnUpdateReportPreference.Enabled = true;
                    lblMessage.Text = string.Empty;
                }
            }
            else
            {
                chkIsEnabled.Checked = false;
                //btnRunSubscription.Enabled = chkIsEnabled.Checked;
                btnUpdateReportPreference.Enabled = true;
                lblMessage.Text = string.Empty;
            }

            DataSet dsEntitySet = iEquityDAL.GetUserSubscriptionEntityReports(userName, subscriptionId);

            GridRealTimeReports.DataSource = dsEntitySet.Tables[1];
            GridRealTimeReports.DataBind();

            GridRealTimeReportSubscriptionlog.DataSource = dsEntitySet.Tables[2];
            GridRealTimeReportSubscriptionlog.DataBind();

            lbEntityCodeList.DataSource = dsEntitySet.Tables[0];
            lbEntityCodeList.DataBind();
        }

        protected void lbEntityCodeList_DataBound(object sender, EventArgs e)
        {
            var listBox = (ASPxListBox)sender;
            listBox.UnselectAll();
            DataTable dataTable = (DataTable)listBox.DataSource;
            DataRow[] drRowValueItems = dataTable.Select("IsSelected=1");
            StringBuilder selecedEntities = new StringBuilder();
            foreach (DataRow dr in drRowValueItems)
            {
                string strEntity = dr["EntityCode"].ToString();
                // selecedEntities.Append(dr["EntityCode"].ToString() + "|");
                ListEditItem item = listBox.Items.FindByValue(strEntity);
                if (null != item)
                {
                    item.Selected = true;
                }
            }
          

        }

        protected void cmbSubscriptionName_Callback(object sender, CallbackEventArgsBase e)
        {
            try
            {
                int id = (int)GridRealTimeReportSubscriptions.GetRowValues(Convert.ToInt32(e.Parameter), "UserSubscriptionId");

                for (int i = 0; i < cmbSubscriptionName.Items.Count; i++)
                {
                    string item = cmbSubscriptionName.Items[i].Value.ToString();
                    item = item.Trim();
                    if (id.ToString() == item)
                    {
                        cmbSubscriptionName.SelectedIndex = i;
                        cmbSubscriptionName_SelectedIndexChanged(null, null);
                        break;
                    }
                }
            }
            catch (Exception ex) { }
            
        }

        protected void GridRealTimeReportSubscriptions_CustomButtonCallback(object sender, ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            if (e.ButtonID == "cmdRunSubscription")
            {
                string subscriptionName =  (string) GridRealTimeReportSubscriptions.GetRowValues(Convert.ToInt32(e.VisibleIndex), "SubscriptionName");
                UserSubscription uSubscription = new UserSubscription();
                uSubscription.SubscriptionName = subscriptionName;
                uSubscription.UserName = userName;
                iEquityDAL.RunSubscriptionUpdateScreenTime(uSubscription);
                lblMessage.Text = cmbSubscriptionName.Text.ToString() + " Subscription has been intitiated.";
                FillData(true);
            }
        }
    }
}