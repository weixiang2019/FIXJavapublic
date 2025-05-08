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
    public partial class Mapping : System.Web.UI.Page
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
            try
            {


                FillData();
                if (!IsPostBack)
                {
                    cmbEnumType.SelectedIndex = 0;
                    Session["DataTable"] = dt1;

                    MasterPage master = this.Master as MasterPage;
                    ASPxLabel masterLabel = master.FindControl("lblPageTitle") as ASPxLabel;
                    masterLabel.Text = "Key Mapping";
                }
                else
                {
                    GetData();
                }

                GridViewFeaturesHelper.SetupGlobalGridViewBehavior(gridMainMapping);

                ScriptManager sm = ScriptManager.GetCurrent(this.Page);
                sm.RegisterAsyncPostBackControl(btnSearch);
            }
            catch (Exception ex)
            { }

        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {

            upAccountActivity.Update();

        }

        private void GetData()
        {
            string strEnumKey = "";
            string strEnumType = cmbEnumType.SelectedItem.Value.ToString();
            string strEnumValue = "";
            string strEnumValueDesc = "";
            string strEnableFlag = "";
            //string userName = WindowsIdentity.GetCurrent().Name;

            string strPara = "S";

            DataTable dtSelect = iEquityDAL.GetMapping(strEnumKey, strEnumType, strEnumValue,
                strEnumValueDesc, strEnableFlag, userName, strPara);

            dt1 = dtSelect;

            gridMainMapping.DataSource = dt1;
            gridMainMapping.DataBind();
            gridMainMapping.PageIndex = 0;
        }


        private void FillData()
        {
            cmbEnumType.DataSource = CommonDAL.GetFilterControl("EnumType", userName);
            cmbEnumType.TextField = "DisplayText";
            cmbEnumType.ValueField = "columnVal";
            cmbEnumType.DataBind();
        }


        protected void gridMainMapping_RowInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e)
        {
            try
            {
                ASPxGridView gridView = sender as ASPxGridView;
                DataTable dataTable = dt1;

                IDictionaryEnumerator enumerator = e.NewValues.GetEnumerator();

                string strEnumKey = "";
                string strEnumValue = "";
                string strEnumType = e.NewValues[0].ToString();
                if (e.NewValues[1] != null)
                {
                    strEnumValue = e.NewValues[1].ToString();
                }
                else
                {
                    strEnumValue = "";
                }
                string strEnumValueDesc = "";
                if (e.NewValues[2] != null)
                {
                    strEnumValueDesc = e.NewValues[2].ToString();
                }
                else
                {
                    strEnumValueDesc = "";
                }
                string strEnableFlag = "";
                if (e.NewValues[2] != null)
                {
                    strEnableFlag = e.NewValues[3].ToString();
                }
                else
                {
                    strEnableFlag = "";
                }
                string strPara = "I";

                DataTable dtInsert = iEquityDAL.GetMapping(strEnumKey, strEnumType, strEnumValue,
                    strEnumValueDesc, strEnableFlag, userName, strPara);

                strPara = "S";
                DataTable dtSelect = iEquityDAL.GetMapping(strEnumKey, strEnumType, strEnumValue,
                    strEnumValueDesc, strEnableFlag, userName, strPara);

                dataTable = dtSelect;

                gridView.CancelEdit();
                e.Cancel = true;

                gridMainMapping.DataSource = dataTable;
                gridMainMapping.DataBind();
                gridMainMapping.PageIndex = 0;
            }
            catch (Exception ex)
            { }
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
            try
            {
                ASPxGridView gridView = (ASPxGridView)sender;

                DataTable dataTable;

                string strEnumKey = e.Keys[gridMainMapping.KeyFieldName].ToString();
                string strEnumValue = "";


                if (e.NewValues[1] != null)
                {
                    strEnumValue = e.NewValues[1].ToString();
                }

                string strEnumValueDesc = "";

                if (e.NewValues[2] != null)
                {
                    strEnumValueDesc = e.NewValues[2].ToString();
                }


                string strEnableFlag = e.NewValues[3].ToString();
                string strPara = "U";

                DataTable dtUpdate = iEquityDAL.GetMapping(strEnumKey, strEnumType, strEnumValue,
                    strEnumValueDesc, strEnableFlag, userName, strPara);

                strPara = "S";
                DataTable dtSelect = iEquityDAL.GetMapping(strEnumKey, strEnumType, strEnumValue,
                    strEnumValueDesc, strEnableFlag, userName, strPara);

                dataTable = dtSelect;

                gridView.CancelEdit();
                e.Cancel = true;

                gridMainMapping.DataSource = dataTable;
                gridMainMapping.DataBind();
                gridMainMapping.PageIndex = 0;
            }
            catch (Exception ex)
            { }
        }
        string strEnumType;
      
        protected void gridMainMapping_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            if (e.Value != null && !(sender as ASPxGridView).IsNewRowEditing)
            {


                if (e.Column.FieldName == "enum_type")
                {
                    strEnumType = e.Value.ToString();

                    e.Editor.ReadOnly = true;
                    //e.Editor.Enabled = false;
                }

            }

        }
    }
}