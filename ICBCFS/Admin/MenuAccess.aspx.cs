﻿using System;
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

namespace ICBCFS.Admin
{
    public partial class MenuAccess : System.Web.UI.Page
    {
        string userName = CommonUtility.GetUserId();

        IEquityDAL iEquityDAL = new EquityDAL();
        DataTable dt1 = null;
        string strUserName;

      
        protected void Page_Load(object sender, EventArgs e)
        {
           
            GridViewFeaturesHelper.SetupGlobalGridViewBehavior(gridMainMenuAccess);

        }
        protected void Page_Init(object sender, EventArgs e)
        {
            GetData();

        }

        private void GetData()
        {
            
            strUserName = Request.QueryString["UserName"];
            string strMenuID = "";
            string strAccessType = "";            
            string strCreatedBy = userName;
            string strHasAccess = "";
            string strPara = "S";

            DataTable dtSelect = iEquityDAL.GetMenuAccess(strUserName,
               strMenuID, strAccessType, strCreatedBy, strHasAccess, strPara);

            dt1 = dtSelect;
             

            gridMainMenuAccess.DataSource = dt1;
            gridMainMenuAccess.DataBind();
            gridMainMenuAccess.PageIndex = 0;
            
        }

        
        
       
        
        ASPxCheckBox headerCb;
        protected void gridMainMenuAccess_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            var grid = sender as ASPxGridView;
            var state = Convert.ToBoolean(e.Parameters);

            for (int i = 0 * grid.PageIndex; i < grid.SettingsPager.PageSize; i++)
            {
                grid.Selection.SetSelection(i, state);
            }

            headerCb = grid.FindHeaderTemplateControl(grid.Columns[3], "SelectAllCheckBox") as ASPxCheckBox;
            headerCb.Checked = state;
            ViewState["value"] = state;
        }

        

        protected void cb_Callback(object source, CallbackEventArgs e)
        {
            string strMenuID;

            if (e.Parameter != "")
            {
                String[] p = e.Parameter.Split('|');
                String[] s = new String[3];
                

                string strAccessType = "", strHasAccess = "";
                // if e.isAllRecordsOnPage is true (perform batch update)
                if (p[0] == "null")
                {

                    strMenuID = "ALL";

                    if (p[1] == "true")
                    {
                        strHasAccess = "1";
                    }
                    else
                    {
                        strHasAccess = "0";
                    }
                }
                else
                {
                    strMenuID = p[0];

                    if (p[2] == "true")
                    {
                        strHasAccess = "1";
                    }
                    else
                    {
                        strHasAccess = "0";
                    }
                }


                string strCreatedBy = userName;
                string strPara = "U";
                DataTable dtUpdate = iEquityDAL.GetMenuAccess(strUserName,
                       strMenuID, strAccessType, strCreatedBy, strHasAccess, strPara);

                strPara = "S";
                DataTable dtSelect = iEquityDAL.GetMenuAccess(strUserName,
                strMenuID, strAccessType, strCreatedBy, strHasAccess, strPara);

                gridMainMenuAccess.DataSource = dtSelect;
                gridMainMenuAccess.DataBind();
                gridMainMenuAccess.PageIndex = 0;

            }            
        }

        protected void gridMainMenuAccess_DataBound(object sender, EventArgs e)
        {
            ASPxGridView grid = sender as ASPxGridView;

            object[] objArray;
            //List<object> lstObjArray = new List<object>(); -- need to double check
            
            for (Int32 i = 0; i < grid.VisibleRowCount; i++)
            {
                objArray = (object[])grid.GetRowValues(i, "Menu ID", "AccessType");
                //lstObjArray.Add(objArray);


                if (objArray[1].ToString() == "0")
                {
                    grid.Selection.SetSelection(i, false);
                }
                else
                {
                    grid.Selection.SetSelection(i, true);
                }
            }
        }
    }
}