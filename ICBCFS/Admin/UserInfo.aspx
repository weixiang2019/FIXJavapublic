<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UserInfo.aspx.cs" Inherits="ICBCFS.Admin.UserInfo" %>

<%@ Register Assembly="DevExpress.Web.v19.1, Version=19.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>


<asp:Content ID="bcUserInfo" ContentPlaceHolderID="MainContent1" runat="server">
    <style>
        .ImageWidthHeight {
            /*margin: 0;*/
            height: 10px;
            width: 10px;
        }
        .EditFormStyle{
            margin-right: 0;
            padding-right: 0;
            width: 250px;
        }
    </style>
    <script type="text/javascript">

        function ShowCreateAccountWindow() {
            pcCreateAccount.Show();
            tbUsername.Focus();
        }
        
        function SetStandardValues() {
            cmbBranch.SetSelectedIndex(0);
            txtAccountRangeFrom.SetText('');
            txtAccountRangeTo.SetText('');
            cmbAccountType.SetSelectedIndex(0);

            cmbContraBranch.SetSelectedIndex(0);
            cmbContraAccountType.SetSelectedIndex(0);
            txtContraAcctNo.SetText('');
            txtContraBroker.SetText('');
           
            var date = new Date();
            dtSystemFrom.SetDate(date);
            dtSystemTo.SetDate(date);

            
            txtBRSecID.SetText('');           

            cmbSide.SetSelectedIndex(0);
            cmbCurrency.SetSelectedIndex(0);
            txtQuantity.SetText('');
            txtPrice.SetText('');
            txtNetAmt.SetText('');
            cmbCancelled.SetSelectedIndex(0);
            txtTradeID.SetText('');
            cmbEntryType.SetSelectedIndex(0);
            cmbBlotterCode.SetSelectedIndex(0);
            txtRRCode.SetText('');
            txtLoginID.SetText('');
            txtClientTagID.SetText('');
            txtBatchID.SetText('');

            dtTradeFrom.SetDate(null);
            dtTradeTo.SetDate(null);

            dtSettleFrom.SetDate(null);
            dtSettleTo.SetDate(null);
            return false;
        }

        function ShowPopupMenuAccess(userName) { 
            var tr = 'MenuAccess.aspx?UserName=';            
            popupMenuAccess.SetContentUrl(tr + userName);
            popupMenuAccess.Show();
        }

        function ShowPopupAccountAccess(userName) {
            var tr = 'AccountAccess.aspx?UserName=';
            popupAccountAccess.SetContentUrl(tr + userName);
            popupAccountAccess.Show();
        }

        function ShowPopupReportAccess(userName) {
            var tr = 'ReportAccess.aspx?UserName=';
            popupReportAccess.SetContentUrl(tr + userName);
            popupReportAccess.Show();
        }

        function onNameValidation(s, e) {
            var firstNname = e.value;
            if (firstNname == null)
                return;
            if (firstNname.length < 2)
                e.isValid = false;
        }
        
        function onBeginCallback(s, e) {
            command = e.command;
            alert(command);
        }
        function OnEndCallback(s, e) {
            if (s.cpSuc == true) {
                
                alert(s.cpSuc);
                delete s.cpSuc;
            }
        }
    </script>
    <dx:ASPxCallback ID="ASPxCallback1" runat="server" ClientInstanceName="Callback">
        <ClientSideEvents CallbackComplete="function(s, e) { LoadingPanel.Hide(); }" />
    </dx:ASPxCallback>
    <div>
        <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        </asp:ScriptManagerProxy>
    </div>
    <div>
        <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Width="100%" Height="875px" EnableHierarchyRecreation="false" ShowCollapseBackwardButton="True" ShowCollapseForwardButton="True" Orientation="Vertical" Style="margin-bottom: 16px;">
            <Panes>
                
                <dx:SplitterPane>
                    <ContentCollection>
                        <dx:SplitterContentControl ID="SplitterContentControl2" runat="server">
                            <asp:UpdatePanel ID="upListTransactions" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">

                                <ContentTemplate>
                                    <div>

                                   

                                        <dx:ASPxGridView ID="gridMainUserInfo" runat="server"  Width="100%" VisibleRowCount="true" AutoGenerateColumns="False" KeyFieldName="UserKey" OnRowInserting="gridMainUserInfo_RowInserting" 
                                            OnRowUpdating="gridMainUserInfo_RowUpdating" OnCellEditorInitialize="gridMainUserInfo_CellEditorInitialize" OnRowDeleting="gridMainUserInfo_RowDeleting" OnToolbarItemClick="gridMainUserInfo_ToolbarItemClick" 
                                            SettingsText-PopupEditFormCaption="User Info" OnHtmlEditFormCreated="gridMainUserInfo_HtmlEditFormCreated" OnDataBinding="gridMainUserInfo_DataBinding" EnableRowsCache="false"
                                            OnCommandButtonInitialize="gridMainUserInfo_CommandButtonInitialize">
                                           
                                            <SettingsEditing Mode="PopupEditForm">
                                            </SettingsEditing>
                                            <Settings VerticalScrollableHeight="600" VerticalScrollBarMode="Auto" HorizontalScrollBarMode="Auto" ShowFooter="True" ShowGroupFooter="VisibleAlways" ShowTitlePanel="true" UseFixedTableLayout="true" />

                                            <ClientSideEvents ToolbarItemClick="function(s, e) {   if (e.item.name === 'tbSaveLayout')  {   ShowLoginWindow();  }  if (e.item.name === 'tbLoadLayout') { ShowLoadLayoutWindow(); } 
                                                if (e.item.name === 'tbResetSorting') 
                                                    {
                                                        e.processOnServer = true;
                                                    }}" />
                                           
                                            <SettingsContextMenu Enabled="True" EnableFooterMenu="True" EnableGroupFooterMenu="True" EnableGroupPanelMenu="True" EnableRowMenu="True" EnableColumnMenu="True">
                                            </SettingsContextMenu>
                                            <SettingsCustomizationDialog Enabled="True" />
                                            <SettingsPager PageSize="500"></SettingsPager>
                                            <Settings ShowGroupPanel="True" ShowFooter="True" ShowFilterRow="True" />
                                            <SettingsPopup>
                                                <HeaderFilter MinHeight="140px"></HeaderFilter>
                                            </SettingsPopup>
                                            <SettingsSearchPanel Visible="true" CustomEditorID="tbToolbarSearch" />
                                            <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" />
                                            <SettingsPopup EditForm-HorizontalAlign="Center" EditForm-VerticalAlign="WindowCenter" EditForm-Width="690"></SettingsPopup>
                                            <SettingsResizing ColumnResizeMode="Control" Visualization="Live" />


                                            <Columns>

                                                <dx:GridViewCommandColumn ShowDeleteButton="True" ShowEditButton="True" ShowNewButtonInHeader="True" VisibleIndex="0" >
                                                </dx:GridViewCommandColumn>                                                 

                                                <dx:GridViewDataBinaryImageColumn FieldName="Image" Caption="Image" Width="150px" VisibleIndex="1" Visible="True">
                                                    <PropertiesBinaryImage ImageHeight="100px" ImageWidth="150px" EnableServerResize="True">
                                                        <EditingSettings Enabled="true" UploadSettings-UploadValidationSettings-MaxFileSize="4194304" />
                                                    </PropertiesBinaryImage>

                                                    <DataItemTemplate>
                                                        
                                                        <dx:ASPxImageZoom runat="server" ID="zoom" ShowHintText="false" ShowHint="false"
                                                            ImageContentBytes='<%# ConvertNullObjectToNothing(Eval("Image")) %>' LargeImageContentBytes='<%# ConvertNullObjectToNothing(Eval("Image")) %>' EnableZoomMode="true">
                                                            <SettingsAutoGeneratedImages ImageCacheFolder="~/Thumb/" ImageWidth="150" ImageHeight="10" LargeImageWidth="300" LargeImageHeight="300" />
                                                            <SettingsZoomMode ZoomWindowWidth="200" ZoomWindowHeight="200" ZoomWindowPosition="Right" />
                                                            <Border BorderStyle="None" />
                                                        </dx:ASPxImageZoom>
                                                    </DataItemTemplate>
                                                </dx:GridViewDataBinaryImageColumn>

                                                <dx:GridViewDataTextColumn FieldName="FirstName" Caption="First Name" VisibleIndex="2" Width="150px" Visible="True">
                                                    
                                                    <HeaderStyle HorizontalAlign=" Center" />
                                                    <CellStyle  HorizontalAlign="Left" Wrap="False"></CellStyle>

                                                    
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="LastName" Caption="Last Name" VisibleIndex="3" Width="150px" Visible="True">
                                               
                                                    <HeaderStyle HorizontalAlign=" Center" />
                                                    <CellStyle  HorizontalAlign="Left" Wrap="False"></CellStyle>

                                                   
                                                </dx:GridViewDataTextColumn>
                                                

                                                <dx:GridViewDataHyperLinkColumn FieldName="UserName" VisibleIndex="4" Width="150px" Caption="User Name" ShowInCustomizationForm="False" Settings-FilterMode="DisplayText">
                                                    <PropertiesHyperLinkEdit TextField="UserName" ClientInstanceName="UserName">
                                                    </PropertiesHyperLinkEdit>
                                                    <PropertiesHyperLinkEdit NavigateUrlFormatString="JavaScript:ShowPopupMenuAccess('{0}');">
                                                    </PropertiesHyperLinkEdit>

                                                </dx:GridViewDataHyperLinkColumn>

                                                <dx:GridViewDataHyperLinkColumn FieldName="UserName" VisibleIndex="5" Width="150px" Caption="Account" ShowInCustomizationForm="False" UnboundType="String" UnboundExpression="UserName" Settings-FilterMode="DisplayText">
                                                    <PropertiesHyperLinkEdit Text="View" ClientInstanceName="View">
                                                    </PropertiesHyperLinkEdit>
                                                    <PropertiesHyperLinkEdit NavigateUrlFormatString="JavaScript:ShowPopupAccountAccess('{0}');">
                                                    </PropertiesHyperLinkEdit>

                                                </dx:GridViewDataHyperLinkColumn>

                                                <dx:GridViewDataHyperLinkColumn FieldName="UserName" VisibleIndex="6" Width="150px" Caption="Report" ShowInCustomizationForm="False" UnboundType="String" UnboundExpression="UserName" Settings-FilterMode="DisplayText">
                                                    <PropertiesHyperLinkEdit Text="View" ClientInstanceName="View">
                                                    </PropertiesHyperLinkEdit>
                                                    <PropertiesHyperLinkEdit NavigateUrlFormatString="JavaScript:ShowPopupReportAccess('{0}');">
                                                    </PropertiesHyperLinkEdit>

                                                </dx:GridViewDataHyperLinkColumn>

                                                <dx:GridViewDataTextColumn FieldName="ParentUserName" Caption="Parent User Name" VisibleIndex="7" Width="130px" Visible="True">
                                                    <HeaderStyle HorizontalAlign=" Center" />
                                                    <CellStyle  HorizontalAlign="Left" Wrap="False"></CellStyle>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="CompanyName" Caption="Company Name" VisibleIndex="8" Width="170px" Visible="True">
                                                    <HeaderStyle HorizontalAlign=" Center" />
                                                    <CellStyle  HorizontalAlign="Left" Wrap="False"></CellStyle>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="Phone_Number" Caption="Phone Number" VisibleIndex="9" Width="150px" Visible="True">
                                                    <HeaderStyle HorizontalAlign=" Center" />
                                                    <CellStyle  HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="Email_Address" Caption="Email Address" VisibleIndex="10" Width="200px" Visible="True">
                                                    <HeaderStyle HorizontalAlign=" Center" />
                                                    <CellStyle  HorizontalAlign="Left" Wrap="False"></CellStyle>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataCheckColumn FieldName="IsPoweruser" Caption="Power user?" VisibleIndex="11" Width="80px" Visible="True">
                                                   
                                                </dx:GridViewDataCheckColumn>
                                               
                                                <dx:GridViewDataTextColumn FieldName="usertype" Caption="User Type" VisibleIndex="12" Width="100px" Visible="True">
                                                    <HeaderStyle HorizontalAlign=" Center" />
                                                    <CellStyle  HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataColumn FieldName="usertype2" Caption="User Access Type" VisibleIndex="13" Width="120px" Visible="True">
                                                   
                                                    <HeaderStyle HorizontalAlign=" Center" />
                                                    <CellStyle  HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                </dx:GridViewDataColumn>
                                                <dx:GridViewDataColumn FieldName="Default_Dashboard" Caption="User Default Dashboard" VisibleIndex="14" Width="150px" Visible="True">
                                                    
                                                    <HeaderStyle HorizontalAlign=" Center" />
                                                    <CellStyle  HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                </dx:GridViewDataColumn>
                                                 <dx:GridViewDataCheckColumn FieldName="IsReadOnly" Caption="Read Only user?" VisibleIndex="15" Width="80px" Visible="True">
                                                    <PropertiesCheckEdit ValueChecked="1" ValueUnchecked="0" ValueType="System.Int32"></PropertiesCheckEdit>
                                                    <HeaderStyle HorizontalAlign=" Center" />
                                                    <CellStyle  HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                </dx:GridViewDataCheckColumn>
                                                <dx:GridViewDataColumn FieldName="Department" Caption="Department" VisibleIndex="16" Width="120px" Visible="True">                                                   
                                                    <HeaderStyle HorizontalAlign=" Center" />
                                                    <CellStyle  HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                </dx:GridViewDataColumn>
                                            </Columns>
                                            
                                            <EditFormLayoutProperties ColumnCount="2" ColCount="2" >
                                                <Items>
                                                    <dx:GridViewLayoutGroup Caption="Personal Info" ColSpan="1" >
                                                        <Items>
                                                            <dx:GridViewColumnLayoutItem ColSpan="1" ColumnName="Image">
                                                            </dx:GridViewColumnLayoutItem>
                                                            <dx:GridViewColumnLayoutItem ColSpan="1" ColumnName="FirstName">
                                                            </dx:GridViewColumnLayoutItem>
                                                            <dx:GridViewColumnLayoutItem ColSpan="1" ColumnName="LastName">
                                                            </dx:GridViewColumnLayoutItem>
                                                            <dx:GridViewColumnLayoutItem ColSpan="1" ColumnName="UserName">
                                                            </dx:GridViewColumnLayoutItem>
                                                        </Items>
                                                    </dx:GridViewLayoutGroup>
                                                    <dx:GridViewLayoutGroup Caption="Company  Info" ColSpan="1" Height="213">
                                                        <Items>
                                                            <dx:GridViewColumnLayoutItem ColSpan="1" ColumnName="CompanyName">
                                                            </dx:GridViewColumnLayoutItem>
                                                            <dx:GridViewColumnLayoutItem ColSpan="1" ColumnName="Phone_Number">
                                                            </dx:GridViewColumnLayoutItem>
                                                            <dx:GridViewColumnLayoutItem ColSpan="1" ColumnName="Email_Address">
                                                            </dx:GridViewColumnLayoutItem>
                                                            <dx:GridViewColumnLayoutItem ColSpan="1" ColumnName="IsPoweruser">
                                                            </dx:GridViewColumnLayoutItem>
                                                            
                                                            <dx:GridViewColumnLayoutItem ColSpan="1" ColumnName="usertype">
                                                            </dx:GridViewColumnLayoutItem>
                                                            <dx:GridViewColumnLayoutItem ColSpan="1" ColumnName="usertype2" >
                                                            </dx:GridViewColumnLayoutItem>
                                                            <dx:GridViewColumnLayoutItem ColSpan="1" ColumnName="Default_Dashboard" Width="100%" >
                                                            </dx:GridViewColumnLayoutItem>
                                                             <dx:GridViewColumnLayoutItem ColSpan="1" ColumnName="IsReadOnly">
                                                            </dx:GridViewColumnLayoutItem>
                                                            <dx:GridViewColumnLayoutItem ColSpan="1" ColumnName="Department" >
                                                            </dx:GridViewColumnLayoutItem>
                                                        </Items>
                                                    </dx:GridViewLayoutGroup>
                                                    <dx:EditModeCommandLayoutItem Width="100%" HorizontalAlign="Right">
                                                        <TabImage IconID="export_export_svg_16x16">
                                                        </TabImage>
                                                    </dx:EditModeCommandLayoutItem>
                                                </Items>
                                                <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600">
                                                </SettingsAdaptivity>
                                            </EditFormLayoutProperties>

                                           
                                            <Toolbars>
                                                <dx:GridViewToolbar SettingsAdaptivity-Enabled="true" ItemAlign="Right">
                                                    <Items>
                                                        <dx:GridViewToolbarItem Alignment="Left">
                                                            <Template>
                                                                <dx:ASPxButtonEdit ID="tbToolbarSearch" runat="server" NullText="Search..." Width="250px" Height="100%">
                                                                    <Buttons>
                                                                        <dx:SpinButtonExtended Image-IconID="find_find_16x16gray" />
                                                                    </Buttons>
                                                                </dx:ASPxButtonEdit>
                                                            </Template>
                                                        </dx:GridViewToolbarItem>
                                                        <dx:GridViewToolbarItem Command="ExportToXlsx" DisplayMode="Image" ToolTip="Export to Excel">
                                                            <Image IconID="export_exporttoxlsx_16x16">
                                                            </Image>
                                                        </dx:GridViewToolbarItem>
                                                        <dx:GridViewToolbarItem Command="ExportToPdf" DisplayMode="Image">
                                                            <Image IconID="export_exporttopdf_16x16" ToolTip="Export to PDF">
                                                            </Image>
                                                        </dx:GridViewToolbarItem>
                                                        <dx:GridViewToolbarItem Command="ExportToXls" DisplayMode="Image">
                                                            <Image IconID="export_exporttoxls_16x16" ToolTip="Export to XLS">
                                                            </Image>
                                                        </dx:GridViewToolbarItem>
                                                        <dx:GridViewToolbarItem Command="ExportToDocx" DisplayMode="Image">
                                                            <Image IconID="export_exporttodocx_16x16" ToolTip="Export to DOCX">
                                                            </Image>
                                                        </dx:GridViewToolbarItem>
                                                        <dx:GridViewToolbarItem Command="ExportToRtf" DisplayMode="Image">
                                                            <Image IconID="export_exporttortf_16x16" ToolTip="Export to RTF">
                                                            </Image>
                                                        </dx:GridViewToolbarItem>
                                                        <dx:GridViewToolbarItem Command="ExportToCsv" DisplayMode="Image">
                                                            <Image IconID="export_exporttocsv_16x16" ToolTip="Export to CSV">
                                                            </Image>
                                                        </dx:GridViewToolbarItem>
                                                        <dx:GridViewToolbarItem Command="ShowCustomizationDialog" ClientEnabled="true" Text="Customization" DisplayMode="Image">
                                                        </dx:GridViewToolbarItem>
                                                        
                                                        <dx:GridViewToolbarItem Name="tbResetSorting" Text="Reset" DisplayMode="Image" ClientEnabled="true" Command="Custom">
                                                            <Image IconID="actions_reset_16x16" ToolTip="Reset Sorting">
                                                            </Image>
                                                        </dx:GridViewToolbarItem>
                                                    </Items>
                                                    <SettingsAdaptivity Enabled="True"></SettingsAdaptivity>
                                                </dx:GridViewToolbar>
                                            </Toolbars>

                                           

                                            <Styles>
                                                <Header  Font-Bold="True" Font-Names="Arial" Font-Size="Small" ForeColor="Black" HorizontalAlign="Center">
                                                </Header>
                                                <AlternatingRow Enabled="True">
                                                </AlternatingRow>
                                                <TitlePanel  Font-Bold="True" Font-Names="Arial" Font-Size="Large" ForeColor="Black" HorizontalAlign="Center"></TitlePanel>
                                            </Styles>
                                        </dx:ASPxGridView>
                                        
                                        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
                                            Modal="True">
                                        </dx:ASPxLoadingPanel>
                                        <dx:ASPxPopupControl ID="popupMenuAccess" runat="server" ClientInstanceName="popupMenuAccess" Width="1200px" Height="700px" ContentStyle-HorizontalAlign="Center" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="Menu Access"  ShowMaximizeButton="True" AllowDragging="True">
                                            <ContentCollection>
                                                <dx:PopupControlContentControl ID="pcccMenuAccess" runat="server" PopupVerticalAlign="WindowCenter" PopupHorizontalAlign="WindowCenter" EnableAnimation="True">
                                                </dx:PopupControlContentControl>
                                            </ContentCollection>
                                        </dx:ASPxPopupControl>
                                        <dx:ASPxPopupControl ID="popupAccountAccess" runat="server" ClientInstanceName="popupAccountAccess" Width="1200px" Height="700px" ContentStyle-HorizontalAlign="Center" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="Account Access"  ShowMaximizeButton="True" AllowDragging="True">
                                            <ContentCollection>
                                                <dx:PopupControlContentControl ID="pcccAccountAccess" runat="server" PopupVerticalAlign="WindowCenter" PopupHorizontalAlign="WindowCenter" EnableAnimation="True">
                                                </dx:PopupControlContentControl>
                                            </ContentCollection>
                                        </dx:ASPxPopupControl>
                                        <dx:ASPxPopupControl ID="popupReportAccess" runat="server" ClientInstanceName="popupReportAccess" Width="1200px" Height="700px" ContentStyle-HorizontalAlign="Center" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="Report Access"  ShowMaximizeButton="True" AllowDragging="True">
                                            <ContentCollection>
                                                <dx:PopupControlContentControl ID="pcccReportAccess" runat="server" PopupVerticalAlign="WindowCenter" PopupHorizontalAlign="WindowCenter" EnableAnimation="True">
                                                </dx:PopupControlContentControl>
                                            </ContentCollection>
                                        </dx:ASPxPopupControl>
                                       
                                        <dx:ASPxPopupControl ID="popupImage" runat="server" ClientInstanceName="popupImage" Width="550px" Height="600px" ContentStyle-HorizontalAlign="Center" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"  ShowMaximizeButton="True" AllowDragging="True" ShowHeader="false" CloseAction="MouseOut">
                                            <ContentCollection>
                                                <dx:PopupControlContentControl ID="PopupControlContentControl1" runat="server" PopupVerticalAlign="WindowCenter" PopupHorizontalAlign="WindowCenter" EnableAnimation="True" SupportsDisabledAttribute="True">
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                <dx:ASPxImage runat="server" ID="Image" ClientInstanceName="clientImage" Height="200px" Width="200px"></dx:ASPxImage>
                                                                
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </dx:PopupControlContentControl>
                                            </ContentCollection>
                                        </dx:ASPxPopupControl>
                                        <dx:ASPxPopupControl ID="pcErrorMessage" runat="server" ClientInstanceName="pcErrorMessage" SkinID="standard">
                                            <ContentCollection>
                                                <dx:PopupControlContentControl runat="server">

                                                    <dx:ASPxLabel ID="lblErrorMessage" runat="server" Text="UserName already exist" ClientInstanceName="lblErrorMessage" />

                                                    
                                                </dx:PopupControlContentControl>
                                            </ContentCollection>
                                        </dx:ASPxPopupControl>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>
            </Panes>
        </dx:ASPxSplitter>
    </div>
</asp:Content>

