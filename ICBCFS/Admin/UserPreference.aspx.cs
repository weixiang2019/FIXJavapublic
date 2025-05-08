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

namespace ICBCFS.Admin
{
    public partial class UserPreference : System.Web.UI.Page
    {
        IEquityDAL iEquityDAL = new EquityDAL();

        string strUserName = string.Empty;
        string strPhoneNumber = string.Empty;
        string strEmailAddress = "";
        string strIsPowerUser = "";
        string strCreatedBy = string.Empty;
        string strIsEnabled = "";
        string strNotificationTradeReject = "";
        string strNotificationUserAccssChange = "";
        string skin = string.Empty;
        string strPara = "S";
        string strTradeRejectEntityList = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {


            List<string> availableThemes = new List<string>();
            availableThemes.Add("Default");
            List<string> themeList = DevExpress.Web.ASPxThemes.ThemesProviderEx.GetThemes(true);
            availableThemes.AddRange(themeList);
            cmbSkins.DataSource = availableThemes;
            cmbSkins.DataBind();

            strUserName = CommonUtility.GetUserId();

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

            FillData();


            if (!IsPostBack)
            {
                cmbSkins.SelectedIndex = 0;
                GetUserPreferenceData();

                MasterPage master = this.Master as MasterPage;
                ASPxLabel masterLabel = master.FindControl("lblPageTitle") as ASPxLabel;
                masterLabel.Text = "User Preference";
            }
            else
            {

                if (btn.ID == "btnUpdate")
                {
                    InsertUserPreferenceData();
                }
                else if (btn.ID == "btnUpdate2")
                {
                    UpdateScreenData();
                }

            }
        }


        private void GetUserPreferenceData()
        {
            try
            {
                DateTime dtTrade;
                dtTrade = DateTime.MinValue;


                strUserName = CommonUtility.GetUserId();
                strPhoneNumber = string.Empty;
                strEmailAddress = "";
                strIsPowerUser = "";
                strCreatedBy = CommonUtility.GetUserId();
                strIsEnabled = "";
                strNotificationTradeReject = "";
                strNotificationUserAccssChange = "";
                skin = string.Empty;
                strPara = "S";
                strTradeRejectEntityList = string.Empty;

                DataTable dtSelect = iEquityDAL.GetUserPreference(strUserName, strPhoneNumber, strEmailAddress, strIsPowerUser, strCreatedBy, strIsEnabled, strNotificationTradeReject, strNotificationUserAccssChange, skin, strPara, strTradeRejectEntityList);

                DataTable dtUserPreference = dtSelect;
                ScUserPreference.DataSource = dtUserPreference;
                ScUserPreference.DataBind();

                if (dtSelect.Rows.Count == 0)
                {
                    lblUserName.Text = strUserName;
                }

                if (dtSelect.Rows.Count == 1)
                {
                    strTradeRejectEntityList = dtSelect.Rows[0]["TradeRejectEntityList"].ToString();
                    string[] strEntityList = strTradeRejectEntityList.Split(',');

                    foreach (string strEntity in strEntityList)
                    {
                        ListEditItem item = lbEntityCodeList.Items.FindByValue(strEntity);
                        if (null != item)
                        {
                            item.Selected = true;
                        }
                    }

                    cmbSkins.Value = dtSelect.Rows[0]["default_skin"].ToString();
                }
            }
            catch (Exception ex)
            {

            }
        }

        private void InsertUserPreferenceData()
        {
            try
            {

                DateTime dtTrade;
                dtTrade = DateTime.MinValue;

                strUserName = CommonUtility.GetUserId();
                strPhoneNumber = txtPhoneNumber.Text.ToString();
                strEmailAddress = txtEmailAddress.Text.ToString();
                strIsPowerUser = "";
                strCreatedBy = CommonUtility.GetUserId();
                strIsEnabled = chkIsEnabled.Checked ? "1" : "0";
                strNotificationTradeReject = chkTradeRejectNotification.Checked ? "1" : "0";
                strNotificationUserAccssChange = chkUserAccssChange.Checked ? "1" : "0";
                skin = cmbSkins.Text.ToString();
                strTradeRejectEntityList = string.Empty;

                foreach (ListEditItem item in lbEntityCodeList.SelectedItems)
                {
                    if (item.Selected)
                    {
                        strTradeRejectEntityList += item.Value + ",";
                    }
                }
                strTradeRejectEntityList = strTradeRejectEntityList.Substring(0, strTradeRejectEntityList.Length - 1);
                strPara = "U";

             
                DataTable dtSelect = iEquityDAL.GetUserPreference(strUserName, strPhoneNumber, strEmailAddress, strIsPowerUser, strCreatedBy, strIsEnabled, strNotificationTradeReject, strNotificationUserAccssChange, skin, strPara, strTradeRejectEntityList);

                DataTable dtUserPreference = dtSelect;
                ScUserPreference.DataSource = dtUserPreference;
                ScUserPreference.DataBind();

                if (dtSelect.Rows.Count == 0)
                    lblUserName.Text = CommonUtility.GetUserId();

                if (dtSelect.Rows.Count == 1)
                {
                    //lblUserName.Text = userName;
                    strTradeRejectEntityList = dtSelect.Rows[0]["TradeRejectEntityList"].ToString();
                    string[] strEntityList = strTradeRejectEntityList.Split(',');

                    foreach (string strEntity in strEntityList)
                    {
                        ListEditItem item = lbEntityCodeList.Items.FindByValue(strEntity);
                        if (null != item)
                        {
                            item.Selected = true;
                        }
                    }
                }

            }
            catch (Exception ex)
            {

            }
        }

        private void UpdateScreenData()
        {

            string strUserName = CommonUtility.GetUserId();
            try
            {
                int strLayoutKey = Convert.ToInt32(lstLayout.Value.ToString());
                string strLayout = lstLayout.SelectedItem.Text.ToString();
                string strScreenName = cmbScreens.SelectedItem.Text.ToString();

                iEquityDAL.UpdateScreenLayout(strLayoutKey, strScreenName, strLayout, strUserName);
            }
            catch (Exception ex)
            {

            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {


            upUserPreference.Update();

        }

        protected void btnUpdate2_Click(object sender, EventArgs e)
        {

            upUserPreference.Update();

        }



        protected void cmbScreens_SelectedIndexChanged(object sender, EventArgs e)
        {

            try
            {
                string screenName = cmbScreens.Text.ToString();
                screenName = cmbScreens.SelectedItem.Text.ToString();

                var layout = "";
                string layoutname = "test"; ;
                String UserName = CommonUtility.GetUserName();// Request.LogonUserIdentity.Name;
                DataTable dtLayout = CommonDAL.LoadGridLayout(screenName, layoutname, layout, UserName, "S");
                lstLayout.DataSource = dtLayout;
                lstLayout.TextField = "LayoutName";
                lstLayout.ValueField = "ScreenLayout_Key";
                lstLayout.DataBind();

                DataRow[] drLayout = dtLayout.Select("IsDefault = true");
                if (drLayout.Length >= 1)
                {
                    layout = drLayout[0]["ScreenLayout_Key"].ToString();
                }
                lstLayout.SelectedIndex = lstLayout.Items.IndexOfValue(layout);

            }
            catch (Exception ex)
            {
                // lblMessage.Text = ex.Message;
            }

        }


        private void FillData()
        {

            strUserName = CommonUtility.GetUserId();
            string strMenuID = "";
            string strAccessType = "";
            string strCreatedBy = CommonUtility.GetUserId();
            string strHasAccess = "";
            string strPara = "S";

            cmbScreens.DataSource = iEquityDAL.GetMenuAccessFilterControl(strUserName,
               strMenuID, strAccessType, strCreatedBy, strHasAccess, strPara);

            cmbScreens.TextField = "DisplayText";
            cmbScreens.ValueField = "columnVal";
            cmbScreens.DataBind();


            lbEntityCodeList.DataSource = CommonDAL.Get_FI_EntityCodeTraderSelection("", "FixedIncomeEntityCode", strUserName);
            lbEntityCodeList.TextField = "DisplayText";
            lbEntityCodeList.ValueField = "columnVal";
            lbEntityCodeList.DataBind();

        }




    }
}