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
using System.IO;
using System.Drawing;
using System.Runtime.Serialization.Formatters.Binary;



namespace ICBCFS.Admin
{
    public partial class CustomComboBoxEdit : ITemplate
    {
        string userName = CommonUtility.GetUserId();
        IEquityDAL iEquityDAL = new EquityDAL();
        public void InstantiateIn(Control container)
        {
            try
            {
                GridViewEditItemTemplateContainer tcont = (GridViewEditItemTemplateContainer)container;
                if (tcont.Column.Caption == "User Access Type")
                {
                    ASPxComboBox cmbUserAccessType = new ASPxComboBox();
                    cmbUserAccessType.ID = "cmbuserAccessType";
                    tcont.Controls.Add(cmbUserAccessType);

                    DataTable dtUserAccessType = CommonDAL.GetFilterControl("UserInfoUserAccessType", userName);

                    var userAccessType = dtUserAccessType.AsEnumerable().Where(a => a.Field<string>("columnVal") != "all").CopyToDataTable();


                    cmbUserAccessType.DataSource = userAccessType;
                    cmbUserAccessType.TextField = "DisplayText";
                    cmbUserAccessType.ValueField = "columnVal";
                    cmbUserAccessType.ValueType = typeof(string);
                    cmbUserAccessType.DataBind();
                }
                else if (tcont.Column.Caption == "User Default Dashboard")
                {

                    ASPxComboBox cmbDefaultDashboard = new ASPxComboBox();
                    cmbDefaultDashboard.ID = "cmbdefaultDashboard";
                    tcont.Controls.Add(cmbDefaultDashboard);

                    DataTable dtDefaultDashboard = CommonDAL.GetFilterControl("APP_USER_Default_Dashboard", userName);

                    var defaultDashboard = dtDefaultDashboard.AsEnumerable().Where(a => a.Field<string>("columnVal") != "all").CopyToDataTable();


                    cmbDefaultDashboard.DataSource = defaultDashboard;
                    cmbDefaultDashboard.TextField = "DisplayText";
                    cmbDefaultDashboard.ValueField = "columnVal";
                    cmbDefaultDashboard.ValueType = typeof(string);
                    cmbDefaultDashboard.DataBind();
                }
                else
                {
                    ASPxComboBox cmbDepartment = new ASPxComboBox();
                    cmbDepartment.ID = "cmbdepartment";
                    tcont.Controls.Add(cmbDepartment);

                    DataTable dtDepartment = CommonDAL.GetFilterControl("Department", userName);

                    var department = dtDepartment.AsEnumerable().Where(a => a.Field<string>("columnVal") != "all").CopyToDataTable();


                    cmbDepartment.DataSource = department;
                    cmbDepartment.TextField = "DisplayText";
                    cmbDepartment.ValueField = "columnVal";
                    cmbDepartment.ValueType = typeof(string);
                    cmbDepartment.DataBind();
                }
            }
            catch (Exception ex)
            { }

        }
    }
    public partial class UserInfo : System.Web.UI.Page
    {
        string userName = CommonUtility.GetUserId();
        //string userName = "adm_bpatel";       
        IEquityDAL iEquityDAL = new EquityDAL();
        DataTable dt1 = null;

        protected void Page_Init(object sender, EventArgs e)
        {
            try
            {
                CustomComboBoxEdit comboBoxUserAccessType = new CustomComboBoxEdit();

                ((GridViewDataColumn)gridMainUserInfo.Columns["usertype2"]).EditItemTemplate = comboBoxUserAccessType;

                CustomComboBoxEdit comboBoxDefaultDashboard = new CustomComboBoxEdit();

                ((GridViewDataColumn)gridMainUserInfo.Columns["Default_Dashboard"]).EditItemTemplate = comboBoxDefaultDashboard;

                CustomComboBoxEdit comboBoxDepartment = new CustomComboBoxEdit();

                ((GridViewDataColumn)gridMainUserInfo.Columns["Department"]).EditItemTemplate = comboBoxDepartment;

            }
            catch (Exception ex)
            {

            }

        }


        protected void Page_Load(object sender, EventArgs e)
        {


            if (!IsPostBack)
            {

                gridMainUserInfo.DataBind();
                Session["DataTable"] = dt1;

                MasterPage master = this.Master as MasterPage;
                ASPxLabel masterLabel = master.FindControl("lblPageTitle") as ASPxLabel;
                masterLabel.Text = "User Info";
            }
            else
            {
                gridMainUserInfo.DataBind();
            }


            GridViewFeaturesHelper.SetupGlobalGridViewBehavior(gridMainUserInfo);

            ScriptManager sm = ScriptManager.GetCurrent(this.Page);

            sm.RegisterPostBackControl(gridMainUserInfo);
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            upListTransactions.Update();
        }

        private void GetData()
        {
            DateTime dtTradeStart, dtTradeEnd, dtSettleStart, dtSettleEnd, dtSystemStart, dtSystemEnd;
            dtTradeStart = dtTradeEnd = dtSettleStart = dtSettleEnd = DateTime.MinValue;

            string strFirstName = "";
            string strLastName = "";
            string strUserName = userName;

            string strParentUserName = userName;

            string strCompanyName = "";
            string strPhoneNumber = "";
            string strEmailAddress = "";
            string strIsPowerUser = "";
            string strCreatedBy = "";


            byte[] bytes = new byte[50];

            byte[] image = null;
            string strPara = "";
            string strUserType = "";
            string strUserType2 = "";
            string strDefaultDashboard = "";
            string strDepartment = "";


            dt1 = (DataTable)Session["DataTable"];

            DataTable dtSelect = iEquityDAL.GetUserInfo(strFirstName, strLastName, strUserName,
               strParentUserName, strCompanyName, strPhoneNumber,
               strEmailAddress, strIsPowerUser, strCreatedBy, image, strPara, strUserType, strUserType2, strDefaultDashboard, false, strDepartment);

            dt1 = dtSelect;

            DataRow[] rows, rowsPowerUser;
            rows = dt1.Select("IsEnabled = '0'");  //'UserName' is ColumnName
            foreach (DataRow row in rows)
                dt1.Rows.Remove(row);

            gridMainUserInfo.DataSource = dt1;
            gridMainUserInfo.DataBind();
            gridMainUserInfo.PageIndex = 0;
        }

        protected object ConvertNullObjectToNothing(object content)
        {

            if (content != null && !(content is DBNull) && content.GetType().Name != "byte[]")
            {
                byte[] b = (byte[])content;
                byte byteVal1 = 0;
                if (b.Length == 0)
                {
                    content = null;

                }
                return content;
            }
            else
            {
                byte[] bytes = null;


                return bytes;
            }
        }





        protected void gridMainUserInfo_RowInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e)
        {
            dt1 = (DataTable)Session["DataTable"];
            ASPxGridView gridView = sender as ASPxGridView;
            DataTable dataTable = dt1;
            DataRow row = dataTable.NewRow();
            e.NewValues["UserKey"] = GetNewUserKey();
            IDictionaryEnumerator enumerator = e.NewValues.GetEnumerator();


            byte[] bytes = null;
            if (e.NewValues["Image"] == null)
            {
                //bytes = (byte[])e.NewValues[0];
                bytes = System.Text.Encoding.UTF8.GetBytes(String.Empty);
            }
            else
            {
                bytes = (byte[])e.NewValues["Image"];
            }

            string strFirstName = e.NewValues["FirstName"].ToString();
            string strLastName = e.NewValues["LastName"].ToString();
            string strUserName = e.NewValues["UserName"].ToString();

            string strParentUserName = userName;
            string strCompanyName = String.Empty;
            if (e.NewValues["CompanyName"] == null)
            {
                strCompanyName = String.Empty;
            }
            else
            {
                strCompanyName = e.NewValues["CompanyName"].ToString();
            }

            string strPhoneNumber = String.Empty;
            if (e.NewValues["Phone_Number"] == null)
            {
                strPhoneNumber = String.Empty;
            }
            else
            {
                strPhoneNumber = e.NewValues["Phone_Number"].ToString();
            }

            string strEmailAddress = String.Empty;
            if (e.NewValues["Email_Address"] == null)
            {
                strEmailAddress = String.Empty;
            }
            else
            {
                strEmailAddress = e.NewValues["Email_Address"].ToString();
            }


            string strIsPowerUser = String.Empty;
            if (e.NewValues["IsPoweruser"] == null)
            {
                strIsPowerUser = "0";
            }
            else
            {
                strIsPowerUser = e.NewValues["IsPoweruser"].ToString();
            }
            string strUserType = String.Empty;
            if (e.NewValues["usertype"] == null)
            {
                strUserType = "";
            }
            else
            {
                strUserType = e.NewValues["usertype"].ToString();
            }

            bool IsReadOnlyUser = false;
            if (e.NewValues["IsReadOnly"] != null)
            {
                IsReadOnlyUser = bool.Parse(e.NewValues["IsReadOnly"].ToString());
            }

            ASPxGridView gv = sender as ASPxGridView;
            GridViewDataColumn column = gv.Columns["usertype2"] as GridViewDataColumn;
            ASPxComboBox cBox = gv.FindEditRowCellTemplateControl(column, "cmbuserAccessType") as ASPxComboBox;

            string newValue;
            if (cBox.SelectedItem == null)
            {
                newValue = "";
            }
            else
            {
                newValue = cBox.SelectedItem.Value.ToString();
            }
            e.NewValues["usertype2"] = newValue;


            string strUserType2 = "";
            if (e.NewValues["usertype2"] == null)
            {
                strUserType2 = "";
            }
            else
            {
                strUserType2 = e.NewValues["usertype2"].ToString();
            }


            GridViewDataColumn colDefaultDashboard = gv.Columns["Default_Dashboard"] as GridViewDataColumn;
            ASPxComboBox cBoxDefaultDashboard = gv.FindEditRowCellTemplateControl(colDefaultDashboard, "cmbdefaultDashboard") as ASPxComboBox;

            string newValueDefaultDashboard;
            if (cBoxDefaultDashboard.SelectedItem == null)
            {
                newValueDefaultDashboard = "";
            }
            else
            {
                newValueDefaultDashboard = cBoxDefaultDashboard.SelectedItem.Value.ToString();
            }
            e.NewValues["Default_Dashboard"] = newValueDefaultDashboard;

            string strDefaultDashboard = "";
            if (e.NewValues["Default_Dashboard"] == null)
            {
                strDefaultDashboard = "";
            }
            else
            {
                strDefaultDashboard = e.NewValues["Default_Dashboard"].ToString();
            }

            GridViewDataColumn colDepartment = gv.Columns["Department"] as GridViewDataColumn;
            ASPxComboBox cBoxDepartment = gv.FindEditRowCellTemplateControl(colDepartment, "cmbdepartment") as ASPxComboBox;
            string newValueDepartment;

            if (cBox.SelectedItem == null)
            {
                newValueDepartment = String.Empty;
            }
            else
            {
                newValueDepartment = cBoxDepartment.SelectedItem.Value.ToString();
            }
            e.NewValues["Department"] = newValueDepartment;

            string strDepartment = String.Empty;
            if (e.NewValues["Department"] == null)
            {
                strDepartment = String.Empty;
            }
            else
            {
                strDepartment = e.NewValues["Department"].ToString();
            }

            string strCreatedBy = userName;
            string strPara = "I";


            DataTable dtInsert = iEquityDAL.GetUserInfo(strFirstName, strLastName, strUserName,
               strParentUserName, strCompanyName, strPhoneNumber,
               strEmailAddress, strIsPowerUser, strCreatedBy, bytes, strPara, strUserType, strUserType2, strDefaultDashboard, IsReadOnlyUser, strDepartment);
            //dataTable = dtInsert;
            strPara = "S";
            strUserName = userName;
            DataTable dtSelect = iEquityDAL.GetUserInfo(strFirstName, strLastName, strUserName,
               strParentUserName, strCompanyName, strPhoneNumber,
               strEmailAddress, strIsPowerUser, strCreatedBy, bytes, strPara, strUserType, strUserType2, strDefaultDashboard, IsReadOnlyUser, strDepartment);

            dataTable = dtSelect;

            gridView.CancelEdit();
            e.Cancel = true;


            DataRow[] rows;
            rows = dataTable.Select("IsEnabled = '0'");  //'UserName' is ColumnName
            foreach (DataRow row1 in rows)
                dataTable.Rows.Remove(row1);

            gridMainUserInfo.DataSource = dataTable;
            gridMainUserInfo.DataBind();
            gridMainUserInfo.PageIndex = 0;
        }

        private int GetNewUserKey()
        {
            dt1 = (DataTable)Session["DataTable"];
            DataTable table = dt1;
            if (table.Rows.Count == 0) return 0;
            int max = Convert.ToInt32(table.Rows[0]["UserKey"]);
            for (int i = 1; i < table.Rows.Count; i++)
            {
                if (Convert.ToInt32(table.Rows[i]["UserKey"]) > max)
                    max = Convert.ToInt32(table.Rows[i]["UserKey"]);
            }
            return max + 1;
        }

        protected void gridMainUserInfo_RowDeleting(object sender, DevExpress.Web.Data.ASPxDataDeletingEventArgs e)
        {
            e.Cancel = true;


            byte[] bytes = null;
            string strFirstName = "";
            string strLastName = "";
            string strUserName = e.Values[3].ToString();

            string strParentUserName = userName;
            string strCompanyName = "";
            string strPhoneNumber = "";
            string strEmailAddress = "";
            string strIsPowerUser = "";
            string strCreatedBy = "";
            string strPara = "D";
            string strUserType = "";
            string strUserType2 = "";
            string strDefaultDashboard = "";
            string strDepartment = "";

            DataTable dtDelete = iEquityDAL.GetUserInfo(strFirstName, strLastName, strUserName,
               strParentUserName, strCompanyName, strPhoneNumber,
               strEmailAddress, strIsPowerUser, strCreatedBy, bytes, strPara, strUserType, strUserType2, strDefaultDashboard, false, strDepartment);



            strPara = "S";
            strUserName = userName;
            DataTable dtSelect = iEquityDAL.GetUserInfo(strFirstName, strLastName, strUserName,
               strParentUserName, strCompanyName, strPhoneNumber,
               strEmailAddress, strIsPowerUser, strCreatedBy, bytes, strPara, strUserType, strUserType2, strDefaultDashboard, false, strDepartment);

            dt1 = dtSelect;

            DataRow[] rows;
            rows = dt1.Select("IsEnabled = '0'");  //'UserName' is ColumnName
            foreach (DataRow row in rows)
                dt1.Rows.Remove(row);

            gridMainUserInfo.DataSource = dt1;
            gridMainUserInfo.DataBind();
            gridMainUserInfo.PageIndex = 0;
        }

        protected void gridMainUserInfo_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            dt1 = (DataTable)Session["DataTable"];
            ASPxGridView gridView = (ASPxGridView)sender;
            DataTable dataTable = dt1;


            byte[] bytes = (byte[])e.NewValues["Image"];
            string strParentUserName = userName;

            string strCompanyName = String.Empty;
            if (e.NewValues["CompanyName"] == null)
            {
                strCompanyName = String.Empty;
            }
            else
            {
                strCompanyName = e.NewValues["CompanyName"].ToString();
            }

            string strPhoneNumber = String.Empty;
            if (e.NewValues["Phone_Number"] == null)
            {
                strPhoneNumber = String.Empty;
            }
            else
            {
                strPhoneNumber = e.NewValues["Phone_Number"].ToString();
            }

            string strEmailAddress = String.Empty;
            if (e.NewValues["Email_Address"] == null)
            {
                strEmailAddress = String.Empty;
            }
            else
            {
                strEmailAddress = e.NewValues["Email_Address"].ToString();
            }


            string strIsPowerUser = String.Empty;
            if (e.NewValues["IsPoweruser"] == null)
            {
                strIsPowerUser = "0";
            }
            else
            {
                strIsPowerUser = e.NewValues["IsPoweruser"].ToString();
            }
            string strCreatedBy = String.Empty;
            string strPara = "U";
            string strUserType = String.Empty;
            if (e.NewValues["usertype"] == null)
            {
                strUserType = "";
            }
            else
            {
                strUserType = e.NewValues["usertype"].ToString();
            }

            bool IsReadOnlyUser = false;
            if (e.NewValues["IsReadOnly"] != null)
            {
                IsReadOnlyUser = bool.Parse(e.NewValues["IsReadOnly"].ToString());
            }


            ASPxGridView gv = sender as ASPxGridView;
            GridViewDataColumn column = gv.Columns["usertype2"] as GridViewDataColumn;
            ASPxComboBox cBox = gv.FindEditRowCellTemplateControl(column, "cmbuserAccessType") as ASPxComboBox;
            string newValue;
            if (cBox.SelectedItem == null)
            {
                newValue = String.Empty;
            }
            else
            {
                newValue = cBox.SelectedItem.Value.ToString();
            }
            e.NewValues["usertype2"] = newValue;

            string strUserType2 = String.Empty;
            if (e.NewValues["usertype2"] == null)
            {
                strUserType2 = String.Empty;
            }
            else
            {
                strUserType2 = e.NewValues["usertype2"].ToString();
            }

            GridViewDataColumn colDefaultDashboard = gv.Columns["Default_Dashboard"] as GridViewDataColumn;
            ASPxComboBox cBoxDefaultDashboard = gv.FindEditRowCellTemplateControl(colDefaultDashboard, "cmbdefaultDashboard") as ASPxComboBox;

            string newValueDefaultDashboard;
            if (cBoxDefaultDashboard.SelectedItem == null)
            {
                newValueDefaultDashboard = String.Empty;
            }
            else
            {
                newValueDefaultDashboard = cBoxDefaultDashboard.SelectedItem.Value.ToString();
            }
            e.NewValues["Default_Dashboard"] = newValueDefaultDashboard;


            string strDefaultDashboard = String.Empty;
            if (e.NewValues["Default_Dashboard"] == null)
            {
                strDefaultDashboard = String.Empty;
            }
            else
            {
                strDefaultDashboard = e.NewValues["Default_Dashboard"].ToString();
            }

            GridViewDataColumn colDepartment = gv.Columns["Department"] as GridViewDataColumn;
            ASPxComboBox cBoxDepartment = gv.FindEditRowCellTemplateControl(colDepartment, "cmbdepartment") as ASPxComboBox;
            string newValueDepartment;

            if (cBox.SelectedItem == null)
            {
                newValueDepartment = String.Empty;
            }
            else
            {
                newValueDepartment = cBoxDepartment.SelectedItem.Value.ToString();
            }
            e.NewValues["Department"] = newValueDepartment;

            string strDepartment = String.Empty;
            if (e.NewValues["Department"] == null)
            {
                strDepartment = String.Empty;
            }
            else
            {
                strDepartment = e.NewValues["Department"].ToString();
            }


            DataTable dtUpdate = iEquityDAL.GetUserInfo(strFirstName, strLastName, strUserName,
               strParentUserName, strCompanyName, strPhoneNumber,
               strEmailAddress, strIsPowerUser, strCreatedBy, bytes, strPara, strUserType, strUserType2, strDefaultDashboard, IsReadOnlyUser, strDepartment);


            strPara = "S";
            strUserName = userName;
            DataTable dtSelect = iEquityDAL.GetUserInfo(strFirstName, strLastName, strUserName,
               strParentUserName, strCompanyName, strPhoneNumber,
               strEmailAddress, strIsPowerUser, strCreatedBy, bytes, strPara, strUserType, strUserType2, strDefaultDashboard, IsReadOnlyUser, strDepartment);

            dataTable = dtSelect;

            DataRow[] rows;
            rows = dataTable.Select("IsEnabled = '0'");  //'UserName' is ColumnName
            foreach (DataRow row in rows)
                dataTable.Rows.Remove(row);


            gridView.CancelEdit();
            e.Cancel = true;

            gridMainUserInfo.DataSource = dataTable;
            gridMainUserInfo.DataBind();
            gridMainUserInfo.PageIndex = 0;
        }
        string strFirstName;
        string strLastName;
        string strUserName;
        protected void gridMainUserInfo_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {

            if (e.Value != null && !(sender as ASPxGridView).IsNewRowEditing)
            {


                if (e.Column.FieldName == "FirstName")
                {
                    strFirstName = e.Value.ToString();
                    e.Editor.Enabled = false;
                }
                if (e.Column.FieldName == "LastName")
                {
                    strLastName = e.Value.ToString();
                    e.Editor.Enabled = false;
                }
                if (e.Column.FieldName == "UserName")
                {
                    strUserName = e.Value.ToString();
                    e.Editor.Enabled = false;
                }
            }
        }

        protected void gridMainUserInfo_ToolbarItemClick(object source, DevExpress.Web.Data.ASPxGridViewToolbarItemClickEventArgs e)
        {
            if (e.Item.Name == "tbResetSorting")
            {
                gridMainUserInfo.ClearSort();
            }

        }


        protected void gridMainUserInfo_RowValidating(object sender, DevExpress.Web.Data.ASPxDataValidationEventArgs e)
        {
            foreach (GridViewColumn column in gridMainUserInfo.Columns)
            {
                GridViewDataColumn dataColumn = column as GridViewDataColumn;

                if (dataColumn == null) continue;

                if (dataColumn.Caption == "User Name")
                {
                    if (e.NewValues[3] == null)
                    {
                        e.Errors[dataColumn] = "User Name can't be null.";
                    }
                    else
                    {
                        dt1 = (DataTable)Session["DataTable"];


                        for (int i = 0; i < gridMainUserInfo.VisibleRowCount; i++)
                        {
                            string uname = gridMainUserInfo.GetRowValues(i, "UserName").ToString();
                            if (e.NewValues[3].ToString() == uname)
                            {
                                e.Errors[dataColumn] = "User Name is already added.";
                            }
                        }
                    }
                }
            }
        }

        protected void gridMainUserInfo_HtmlEditFormCreated(object sender, ASPxGridViewEditFormEventArgs e)
        {
            ASPxGridView gv = sender as ASPxGridView;
            GridViewDataColumn column = gv.Columns["usertype2"] as GridViewDataColumn;
            ASPxComboBox cBox = gv.FindEditRowCellTemplateControl(column, "cmbuserAccessType") as ASPxComboBox;
            //var newValue = cBox.SelectedItem.Value;
            int key = gridMainUserInfo.EditingRowVisibleIndex;
            string field = Convert.ToString(gridMainUserInfo.GetRowValues(key, "usertype2"));

            cBox.SelectedItem = cBox.Items.FindByValue(field);

            GridViewDataColumn col = gv.Columns["Default_Dashboard"] as GridViewDataColumn;
            ASPxComboBox cBoxDefaultDashboard = gv.FindEditRowCellTemplateControl(col, "cmbdefaultDashboard") as ASPxComboBox;

            int keyDefaultDashboard = gridMainUserInfo.EditingRowVisibleIndex;
            string fieldDefaultDashboard = Convert.ToString(gridMainUserInfo.GetRowValues(keyDefaultDashboard, "Default_Dashboard"));

            cBoxDefaultDashboard.SelectedItem = cBoxDefaultDashboard.Items.FindByValue(fieldDefaultDashboard);

            GridViewDataColumn colDepartment = gv.Columns["Department"] as GridViewDataColumn;
            ASPxComboBox cBoxDeaprtment = gv.FindEditRowCellTemplateControl(colDepartment, "cmbdepartment") as ASPxComboBox;
            //var newValue = cBox.SelectedItem.Value;
            int keyDeaprtment = gridMainUserInfo.EditingRowVisibleIndex;
            string fieldDepartment = Convert.ToString(gridMainUserInfo.GetRowValues(keyDeaprtment, "Department"));

            cBoxDeaprtment.SelectedItem = cBoxDeaprtment.Items.FindByValue(fieldDepartment);
        }

        protected void gridMainUserInfo_DataBinding(object sender, EventArgs e)
        {
            DateTime dtTradeStart, dtTradeEnd, dtSettleStart, dtSettleEnd, dtSystemStart, dtSystemEnd;
            dtTradeStart = dtTradeEnd = dtSettleStart = dtSettleEnd = DateTime.MinValue;

            string strFirstName = "";
            string strLastName = "";
            string strUserName = userName;
            string strParentUserName = userName;
            string strCompanyName = "";
            string strPhoneNumber = "";
            string strEmailAddress = "";
            string strIsPowerUser = "";
            string strCreatedBy = "";

            byte[] bytes = new byte[50];

            byte[] image = null;
            string strPara = "";
            string strUserType = "";
            string strUserType2 = "";
            string strDefaultDashboard = "";
            string strDepartment = "";

            dt1 = (DataTable)Session["DataTable"];

            DataTable dtSelect = iEquityDAL.GetUserInfo(strFirstName, strLastName, strUserName,
               strParentUserName, strCompanyName, strPhoneNumber,
               strEmailAddress, strIsPowerUser, strCreatedBy, image, strPara, strUserType, strUserType2, strDefaultDashboard, false, strDepartment);

            dt1 = dtSelect;


            DataRow[] rows, rowsPowerUser;
            rows = dt1.Select("IsEnabled = '0'");  //'UserName' is ColumnName
            foreach (DataRow row in rows)
                dt1.Rows.Remove(row);

            gridMainUserInfo.DataSource = dt1;
        }

        protected void gridMainUserInfo_CommandButtonInitialize(object sender, ASPxGridViewCommandButtonEventArgs e)
        {
            ASPxGridView grid = sender as ASPxGridView;
            if (e.ButtonType == ColumnCommandButtonType.Edit && e.VisibleIndex != -1)
            {
                int powerUser = Convert.ToInt32(grid.GetRowValues(e.VisibleIndex, "IsPoweruser"));
                string userType = Convert.ToString(grid.GetRowValues(e.VisibleIndex, "usertype"));

                if (powerUser == 1 || userType == "I")
                {
                    e.Visible = true;
                }
                else
                {
                    e.Visible = false;
                }

            }
        }
    }


}