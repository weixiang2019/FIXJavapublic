using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ICBCFS.DataAccessLayer;
using System.Data;
using DevExpress.Web;
using static ICBCFS.DataAccessLayer.CommonDAL;
using System.Security.Principal;


namespace ICBCFS.Admin
{
    public partial class AccountAccess : System.Web.UI.Page
    {
        string userName = CommonUtility.GetUserId();
        IEquityDAL iEquityDAL = new EquityDAL();
        DataTable dt1 = null;
        string strBranch;
        string strAccountNo;
        string strUserName;

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    Session["AccountDetailAccountAccessDataTable"] = null;
                }

                gridMainAccountAccess.FocusedRowIndex = -1;
                GetData();

                GridViewFeaturesHelper.SetupGlobalGridViewBehavior(gridMainAccountAccess);
                GridViewFeaturesHelper.SetupGlobalGridViewBehavior(gridAccountDetailAccountAccess);
                ScriptManager sm = ScriptManager.GetCurrent(this.Page);

                if (Session["AccountDetailAccountAccessDataTable"] != null)
                {
                    DataTable dataTable = (DataTable)Session["AccountDetailAccountAccessDataTable"];

                    gridAccountDetailAccountAccess.DataSource = dataTable;
                    gridAccountDetailAccountAccess.DataBind();
                }



            }
            catch (Exception ex)
            { }
        }


        private void GetData()
        {

            strUserName = Request.QueryString["UserName"];
            string strBranch = "";
            string strAccountNo = "";
            string strHasAccess = "";
            string strReadWriteAccess = "R";

            string strCreatedBy = userName;
            string strPara = "SB";

            dt1 = (DataTable)Session["DataTable"];

            DataTable dtSelect = iEquityDAL.GetAccountAccess(strUserName,
               strBranch, strAccountNo, strHasAccess, strReadWriteAccess, strCreatedBy, strPara);

            dt1 = dtSelect;

            gridMainAccountAccess.DataSource = dt1;
            gridMainAccountAccess.DataBind();
            gridMainAccountAccess.PageIndex = 0;

        }

        protected void gridAccountDetailAccountAccess_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            try
            {
                if (e.Parameters != "-1")
                {
                    if (e.Parameters == "clear")
                    {
                    }
                    else
                    {

                        object objArray = gridMainAccountAccess.GetRowValues(Convert.ToInt32(e.Parameters), "Branch");
                        strBranch = objArray.ToString();
                        string strAccountNo = "";
                        string strHasAccess = "";

                        string strReadWriteAccess = "R";

                        string strCreatedBy = userName;
                        string strPara = "SA";

                        DataTable dtAccountDetailAccountAccess;
                        dtAccountDetailAccountAccess = iEquityDAL.GetAccountAccess(strUserName,
                            strBranch, strAccountNo, strHasAccess, strReadWriteAccess, strCreatedBy, strPara);

                        AssinGridAccountDetailAccess(dtAccountDetailAccountAccess);

                    }
                }
            }
            catch (Exception ex)
            { }
        }

        private void AssinGridAccountDetailAccess(DataTable dtAccountDetailAccountAccess)
        {
            DataTable dtReadWriteAccess = CommonDAL.GetFilterControl("AccountAccessReadWriteAccess", userName);

            var readWriteAccess = dtReadWriteAccess.AsEnumerable().Where(a => a.Field<string>("columnVal") != "all").CopyToDataTable();

            ((GridViewDataComboBoxColumn)gridAccountDetailAccountAccess.Columns["ReadWriteAccess"]).PropertiesComboBox.ValueType = typeof(string);
            ((GridViewDataComboBoxColumn)gridAccountDetailAccountAccess.Columns["ReadWriteAccess"]).PropertiesComboBox.DataSource = readWriteAccess;
            ((GridViewDataComboBoxColumn)gridAccountDetailAccountAccess.Columns["ReadWriteAccess"]).PropertiesComboBox.TextField = "DisplayText";
            ((GridViewDataComboBoxColumn)gridAccountDetailAccountAccess.Columns["ReadWriteAccess"]).PropertiesComboBox.ValueField = "columnVal";
            ((GridViewDataComboBoxColumn)gridAccountDetailAccountAccess.Columns["ReadWriteAccess"]).Index = 0;

            gridAccountDetailAccountAccess.DataBind();

            Session["AccountDetailAccountAccessDataTable"] = dtAccountDetailAccountAccess;

            gridAccountDetailAccountAccess.DataSource = dtAccountDetailAccountAccess;
            gridAccountDetailAccountAccess.DataBind();
            gridAccountDetailAccountAccess.PageIndex = 0;
        }


        protected void cb_Callback(object source, CallbackEventArgs e)
        {
            try
            {

                if (e.Parameter != "")
                {

                    String[] p = e.Parameter.Split('|');

                    strBranch = p[0];
                    strAccountNo = p[1];

                    DataTable dataTable = dt1;

                    string strHasAccess = "";
                    if (p[3] == "true")
                    {
                        strHasAccess = "1";
                    }
                    else
                    {
                        strHasAccess = "0";
                    }

                    string strReadWriteAccess = "";
                    strReadWriteAccess = gridAccountDetailAccountAccess.GetRowValues(Convert.ToInt32(p[4]), "ReadWriteAccess").ToString();


                    string strCreatedBy = userName;

                    string strPara = "U";
                    DataTable dtUpdate = iEquityDAL.GetAccountAccess(strUserName,
                       strBranch, strAccountNo, strHasAccess, strReadWriteAccess, strCreatedBy, strPara);

                    strPara = "SA";
                    DataTable dtSelect = iEquityDAL.GetAccountAccess(strUserName,
                       strBranch, strAccountNo, strHasAccess, strReadWriteAccess, strCreatedBy, strPara);

                    AssinGridAccountDetailAccess(dtSelect);

                }
            }
            catch (Exception ex)
            { }

        }

        protected void gridAccountDetailAccountAccess_DataBound(object sender, EventArgs e)
        {
            try
            {
                ASPxGridView grid = sender as ASPxGridView;

                object[] objArray;

                for (Int32 i = 0; i < grid.VisibleRowCount; i++)
                {
                    objArray = (object[])grid.GetRowValues(i, "Branch", "AccountNo", "HasAccess");
                    if (objArray[1].ToString() == "ALL")
                    {
                        if (objArray[2].ToString() == "1")
                        {

                            grid.Selection.SetSelection(i, true);
                        }
                        else
                            grid.Selection.SetSelection(i, false);
                    }
                    else
                    {
                        if (objArray[2].ToString() == "1")
                        {
                            grid.Selection.SetSelection(i, true);
                        }
                        else
                            grid.Selection.SetSelection(i, false);

                    }

                }
            }
            catch (Exception ex)
            { }
        }



        protected void gridAccountDetailAccountAccess_HtmlDataCellPrepared(object sender, ASPxGridViewTableDataCellEventArgs e)
        {
            if (e.DataColumn.FieldName == "ReadWriteAccess")
            {
                DataTable dtReadWriteAccess = CommonDAL.GetFilterControl("AccountAccessReadWriteAccess", userName);

                var readWriteAccess = dtReadWriteAccess.AsEnumerable().Where(a => a.Field<string>("columnVal") != "all").CopyToDataTable();

                ((GridViewDataComboBoxColumn)gridAccountDetailAccountAccess.Columns["ReadWriteAccess"]).PropertiesComboBox.ValueType = typeof(string);
                ((GridViewDataComboBoxColumn)gridAccountDetailAccountAccess.Columns["ReadWriteAccess"]).PropertiesComboBox.DataSource = readWriteAccess;
                ((GridViewDataComboBoxColumn)gridAccountDetailAccountAccess.Columns["ReadWriteAccess"]).PropertiesComboBox.TextField = "DisplayText";
                ((GridViewDataComboBoxColumn)gridAccountDetailAccountAccess.Columns["ReadWriteAccess"]).PropertiesComboBox.ValueField = "columnVal";
                ((GridViewDataComboBoxColumn)gridAccountDetailAccountAccess.Columns["ReadWriteAccess"]).Index = 0;

            }
        }

        protected void gridAccountDetailAccountAccess_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {

            try
            {
                DataTable dataTable = dt1;
                ASPxGridView gridView = (ASPxGridView)sender;
                string strBranch = "";


                object[] key = new object[3];
                key[0] = e.Keys["Branch"];
                key[1] = e.Keys["AccountNo"];
                key[2] = e.Keys["HasAccess"];
                int visibleIndex = gridView.FindVisibleIndexByKeyValue(key);

                strBranch = gridView.GetRowValues(visibleIndex, "Branch").ToString();

                string strHasAccess = gridView.GetRowValues(visibleIndex, "HasAccess").ToString();

                string strAccountNo = string.Empty;
                string strReadWriteAccess = string.Empty;


                if (e.NewValues["ReadWriteAccess"] != null)
                {
                    strReadWriteAccess = e.NewValues["ReadWriteAccess"].ToString();
                }
                if (e.NewValues["AccountNo"] != null)
                {
                    strAccountNo = e.NewValues["AccountNo"].ToString();
                }

                string strCreatedBy = userName;

                string strPara = "U";
                DataTable dtUpdate = iEquityDAL.GetAccountAccess(strUserName,
                   strBranch, strAccountNo, strHasAccess, strReadWriteAccess, strCreatedBy, strPara);

                strPara = "SA";
                DataTable dtSelect = iEquityDAL.GetAccountAccess(strUserName,
                   strBranch, strAccountNo, strHasAccess, strReadWriteAccess, strCreatedBy, strPara);


                e.Cancel = true;
                gridView.CancelEdit();

                AssinGridAccountDetailAccess(dtSelect);


            }
            catch (Exception ex)
            { }


        }
    }
}