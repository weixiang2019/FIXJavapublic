<%@ Page Language="C#"  AutoEventWireup="true" CodeBehind="BroadRidgeEntryCode.aspx.cs" Inherits="ICBCFS.Admin.BroadRidgeEntryCode" %>

<%@ Register Assembly="DevExpress.Web.v19.1, Version=19.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">

    <script type="text/javascript">
        function ShowLoginWindow() {
            pcSaveLayout.Show();
        }
        function ShowCreateAccountWindow() {
            pcCreateAccount.Show();
            tbUsername.Focus();
        }
        function ShowLoadLayoutWindow() {
            pcLoadLayout.Show();
        }
        function SetStandardValues() {
            cmbEnumType.SetSelectedIndex(0);
           

            return false;
        }
        function ShowDetailBRSecIDPopup(MSDURL) {
            //alert(URLCleranceStatus);
            //var tr;
            //tr = '/ClearanceStatus.aspx';

            brSecIDPopup.SetContentUrl(MSDURL);

            brSecIDPopup.Show();
        }
        function HidePopupAndShowInfo(closedBy, returnValue) {
            brSecIDPopup.Hide();
            txtBRSecID.SetText(returnValue);
            //alert('Closed By: ' + closedBy + '\nReturn Value: ' + returnValue);
        }
    </script>
    <dx:ASPxCallback ID="ASPxCallback1" runat="server" ClientInstanceName="Callback">
        <ClientSideEvents CallbackComplete="function(s, e) { LoadingPanel.Hide(); }" />
    </dx:ASPxCallback>
    <div>
        <asp:ScriptManager ID="ScriptManger1" runat="Server">
        </asp:ScriptManager>
        <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        </asp:ScriptManagerProxy>
    </div>

    <div>
        <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Width="100%" Height="508" EnableHierarchyRecreation="false" ShowCollapseBackwardButton="True" ShowCollapseForwardButton="True" Orientation="Vertical" Style="margin-bottom: 16px;">
            <Panes>

                <dx:SplitterPane>
                    <ContentCollection>
                        <dx:SplitterContentControl ID="SplitterContentControl2" runat="server">
                            <asp:UpdatePanel ID="upAccountActivity" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">

                                <ContentTemplate>
                                    <div>

                                        <dx:ASPxGridView ID="gridBroadRidgeEntryCode" runat="server"  Width="100%" ClientInstanceName="gridBroadRidgeEntryCode" VisibleRowCount="true" KeyFieldName="enum_key" OnRowInserting="gridMainMapping_RowInserting" OnRowUpdating="gridMainMapping_RowUpdating" OnCellEditorInitialize="gridMainMapping_CellEditorInitialize" OnDataBound="gridBroadRidgeEntryCode_DataBound">
                                            <%--<SettingsPager EnableAdaptivity="true" ></SettingsPager>--%>
                                            <%--<SettingsPager Mode="ShowAllRecords"></SettingsPager>--%>
                                            <%--<ClientSideEvents ToolbarItemClick="function(s, e) {   if (e.item.name === 'tbSaveLayout')  {   ShowLoginWindow();  }   if (e.item.name === 'tbLoadLayout') { ShowLoadLayoutWindow(); } }" />--%>
                                            <Settings VerticalScrollableHeight="347" VerticalScrollBarMode="Auto" HorizontalScrollBarMode="Auto" ShowFooter="True" ShowGroupFooter="VisibleAlways" ShowTitlePanel="true" UseFixedTableLayout="true" ShowHeaderFilterButton="true" />
                                            
                                            <%--<SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />--%>
                                            <%--<SettingsSearchPanel Visible="true" CustomEditorID="tbToolbarSearch" />--%>

                                        <%--    <EditFormLayoutProperties ColumnCount="2" ColCount="2">
                                                <Items>
                                                 
                                                    <dx:GridViewLayoutGroup Caption="Enum  Info" ColSpan="1">
                                                        <Items>
                                                            <dx:GridViewColumnLayoutItem ColSpan="1" ColumnName="enum_type">
                                                            </dx:GridViewColumnLayoutItem>
                                                            <dx:GridViewColumnLayoutItem ColSpan="1" ColumnName="Enum_value">
                                                            </dx:GridViewColumnLayoutItem>
                                                            <dx:GridViewColumnLayoutItem ColSpan="1" ColumnName="Enum_value_desc">
                                                            </dx:GridViewColumnLayoutItem>
                                                            <dx:GridViewColumnLayoutItem ColSpan="1" ColumnName="Enable_flag">
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
                                            </EditFormLayoutProperties>--%>
                                          <%--  <EditFormLayoutProperties>
                                                <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600" />
                                            </EditFormLayoutProperties>--%>

                                          <%--  <TotalSummary>
                                                <dx:ASPxSummaryItem DisplayFormat="{0:#,##0;(#,##0)}" FieldName="qty" ShowInColumn="Qty" SummaryType="Sum" />
                                            </TotalSummary>
                                            <TotalSummary>
                                                <dx:ASPxSummaryItem DisplayFormat="{0:#,##0.00;(#,##0.00)}" FieldName="gross amt" ShowInColumn="Gross Amt" SummaryType="Sum" />
                                            </TotalSummary>
                                            <TotalSummary>
                                                <dx:ASPxSummaryItem DisplayFormat="{0:#,##0.00;(#,##0.00)}" FieldName="net amt" ShowInColumn="Net Amt" SummaryType="Sum" />
                                            </TotalSummary>
                                            <TotalSummary>
                                                <dx:ASPxSummaryItem DisplayFormat="{0:#,##0.00;(#,##0.00)}" FieldName="accrued int" ShowInColumn="Accrued Int" SummaryType="Sum" />
                                            </TotalSummary>
                                            <TotalSummary>
                                                <dx:ASPxSummaryItem DisplayFormat="{0:#,##0.00;(#,##0.00)}" FieldName="comm" ShowInColumn="Comm" SummaryType="Sum" />
                                            </TotalSummary>
                                            <TotalSummary>
                                                <dx:ASPxSummaryItem DisplayFormat="{0:#,##0.00;(#,##0.00)}" FieldName="Misc Fee" ShowInColumn="Misc Fee" SummaryType="Sum" />
                                            </TotalSummary>
                                            <TotalSummary>
                                                <dx:ASPxSummaryItem DisplayFormat="{0:#,##0.00;(#,##0.00)}" FieldName="Sec Fee" ShowInColumn="Sec Fee" SummaryType="Sum" />
                                            </TotalSummary>
                                            <TotalSummary>
                                                <dx:ASPxSummaryItem DisplayFormat="{0:#,##0.00;(#,##0.00)}" FieldName="Brk Fee" ShowInColumn="Brk Fee" SummaryType="Sum" />
                                            </TotalSummary>
                                            <TotalSummary>
                                                <dx:ASPxSummaryItem DisplayFormat="{0:#,##0.00;(#,##0.00)}" FieldName="Occ Fee" ShowInColumn="Occ Fee" SummaryType="Sum" />
                                            </TotalSummary>
                                            <TotalSummary>
                                                <dx:ASPxSummaryItem DisplayFormat="{0:#,##0.00;(#,##0.00)}" FieldName="UK Stmp Tax" ShowInColumn="UK Stmp Tax" SummaryType="Sum" />
                                            </TotalSummary>
                                            <TotalSummary>
                                                <dx:ASPxSummaryItem DisplayFormat="{0:#,##0.00;(#,##0.00)}" FieldName="Irish Stmp Tax" ShowInColumn="Irish Stmp Tax" SummaryType="Sum" />
                                            </TotalSummary>
                                            <TotalSummary>
                                                <dx:ASPxSummaryItem DisplayFormat="{0:#,##0.00;(#,##0.00)}" FieldName="French Tax" ShowInColumn="French Tax" SummaryType="Sum" />
                                            </TotalSummary>
                                            <TotalSummary>
                                                <dx:ASPxSummaryItem DisplayFormat="{0:#,##0.00;(#,##0.00)}" FieldName="Italian Tax" ShowInColumn="Italian Tax" SummaryType="Sum" />
                                            </TotalSummary>

                                            <TotalSummary>
                                                <dx:ASPxSummaryItem DisplayFormat="{0:#,##0.00;(#,##0.00)}" FieldName="Total Fee" ShowInColumn="Total Fee" SummaryType="Sum" />
                                            </TotalSummary>--%>

                                            
                                          
                                            <SettingsContextMenu Enabled="True" EnableFooterMenu="True" EnableGroupFooterMenu="True" EnableGroupPanelMenu="True" EnableRowMenu="True" EnableColumnMenu="True">
                                            </SettingsContextMenu>
                                            <SettingsCustomizationDialog Enabled="True" />
                                            <SettingsPager PageSize="500" Visible="False"></SettingsPager>
                                            <SettingsEditing Mode="Inline" /> 
                                            <Settings ShowFooter="True" ShowFilterRow="True" />
                                            <SettingsResizing ColumnResizeMode="Control" Visualization="Live" />

                                            <SettingsPopup>
                                                <HeaderFilter Width="170px" MinWidth="170px"></HeaderFilter>
                                            </SettingsPopup>
                                            <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" />
                                            <SettingsText Title="<b>Broadridge Entry Code</b>" />

                                            
                                          
                                            <FormatConditions>
                                                <dx:GridViewFormatConditionHighlight ApplyToRow="False" Expression="[SDCashBalCCY] &lt; 0" FieldName="SDCashBalCCY">
                                                    <RowStyle BackColor="#CC0000" ForeColor="White" />
                                                </dx:GridViewFormatConditionHighlight>
                                            </FormatConditions>
                                            <Styles>
                                                <%--  <Header BackColor="#990033" Font-Bold="True" Font-Names="Arial" Font-Size="Small" ForeColor="White" HorizontalAlign="Center">
                             </Header>--%>
                                                <Header  Font-Bold="True" Font-Names="Arial" Font-Size="Small" ForeColor="Black" HorizontalAlign="Center">
                                                </Header>
                                                <AlternatingRow Enabled="True">
                                                </AlternatingRow>
                                                <TitlePanel  Font-Bold="True" Font-Names="Arial" Font-Size="Large" ForeColor="Black" HorizontalAlign="Center"></TitlePanel>
                                            </Styles>
                                        </dx:ASPxGridView>
                                        <%--</td>
            </tr>
        </table>--%>
                                        <dx:ASPxPopupControl ID="pcLoadLayout" runat="server" Width="320" CloseAction="CloseButton" CloseOnEscape="true" Modal="True"
                                            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="pcLoadLayout"
                                            HeaderText="Load Layout" AllowDragging="True" PopupAnimationType="None" EnableViewState="False" AutoUpdatePosition="true">
                                            <ClientSideEvents PopUp="function(s, e) { ASPxClientEdit.ClearGroup('entryGroup'); tbname.Focus(); }" />
                                            <ContentCollection>
                                                <dx:PopupControlContentControl runat="server">
                                                    <dx:ASPxPanel ID="ASPxPanel1" runat="server" DefaultButton="btOK">
                                                        <PanelCollection>
                                                            <dx:PanelContent runat="server">
                                                                <dx:ASPxFormLayout runat="server" ID="ASPxFormLayout1" Width="100%" Height="100%">
                                                                    <Items>
                                                                        <dx:LayoutItem Caption="Layout" ColSpan="1">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                                    <dx:ASPxComboBox ID="cbLayoutList" runat="server" Width="100%" ClientInstanceName="tbname">
                                                                                        <ValidationSettings EnableCustomValidation="True" ValidationGroup="entryGroup" SetFocusOnError="True"
                                                                                            ErrorDisplayMode="Text" ErrorTextPosition="Bottom" CausesValidation="True">
                                                                                            <RequiredField ErrorText="name required" IsRequired="True" />
                                                                                            <RegularExpression ErrorText="Layout name required" />
                                                                                            <ErrorFrameStyle Font-Size="10px">
                                                                                                <ErrorTextPaddings PaddingLeft="0px" />
                                                                                            </ErrorFrameStyle>
                                                                                        </ValidationSettings>
                                                                                    </dx:ASPxComboBox>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem ShowCaption="False" Paddings-PaddingTop="19">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxButton ID="ASPxButton1" runat="server" Text="OK" Width="80px" OnClick="LoadLayout_Click" AutoPostBack="False" Style="float: left; margin-right: 8px">
                                                                                        <%-- <ClientSideEvents Click="function(s, e) { if(ASPxClientEdit.ValidateGroup('entryGroup')) pcLogin.Hide(); }" />--%>
                                                                                    </dx:ASPxButton>
                                                                                    <dx:ASPxButton ID="ASPxButton2" runat="server" Text="Cancel" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px">
                                                                                        <ClientSideEvents Click="function(s, e) { pcLoadLayout.Hide(); }" />
                                                                                    </dx:ASPxButton>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                            <Paddings PaddingTop="19px"></Paddings>
                                                                        </dx:LayoutItem>
                                                                    </Items>
                                                                </dx:ASPxFormLayout>
                                                            </dx:PanelContent>
                                                        </PanelCollection>
                                                    </dx:ASPxPanel>

                                                </dx:PopupControlContentControl>
                                            </ContentCollection>
                                            <ContentStyle>
                                                <Paddings PaddingBottom="5px" />
                                            </ContentStyle>
                                        </dx:ASPxPopupControl>
                                        <dx:ASPxPopupControl ID="pcSaveLayout" runat="server" Width="320" CloseAction="CloseButton" CloseOnEscape="true" Modal="True"
                                            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="pcSaveLayout"
                                            HeaderText="Save Layout" AllowDragging="True" PopupAnimationType="None" EnableViewState="False" AutoUpdatePosition="true">
                                            <ClientSideEvents PopUp="function(s, e) { ASPxClientEdit.ClearGroup('entryGroup'); tbname.Focus(); }" />
                                            <ContentCollection>
                                                <dx:PopupControlContentControl runat="server">
                                                    <dx:ASPxPanel ID="Panel1" runat="server" DefaultButton="btOK">
                                                        <PanelCollection>
                                                            <dx:PanelContent runat="server">
                                                                <dx:ASPxFormLayout runat="server" ID="ASPxFormLayout2" Width="100%" Height="100%">
                                                                    <Items>
                                                                        <dx:LayoutItem Caption="Layout Name">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxTextBox ID="tbname" runat="server" Width="100%" ClientInstanceName="tbname">
                                                                                        <ValidationSettings EnableCustomValidation="True" ValidationGroup="entryGroup" SetFocusOnError="True"
                                                                                            ErrorDisplayMode="Text" ErrorTextPosition="Bottom" CausesValidation="True">
                                                                                            <RequiredField ErrorText="name required" IsRequired="True" />
                                                                                            <RegularExpression ErrorText="Layout name required" />
                                                                                            <ErrorFrameStyle Font-Size="10px">
                                                                                                <ErrorTextPaddings PaddingLeft="0px" />
                                                                                            </ErrorFrameStyle>
                                                                                        </ValidationSettings>
                                                                                    </dx:ASPxTextBox>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem ShowCaption="False" Paddings-PaddingTop="19">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxButton ID="btOK" runat="server" Text="OK" Width="80px" OnClick="SaveLayout_Click" AutoPostBack="False" Style="float: left; margin-right: 8px">
                                                                                        <%-- <ClientSideEvents Click="function(s, e) { if(ASPxClientEdit.ValidateGroup('entryGroup')) pcLogin.Hide(); }" />--%>
                                                                                    </dx:ASPxButton>
                                                                                    <dx:ASPxButton ID="btCancel" runat="server" Text="Cancel" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px">
                                                                                        <ClientSideEvents Click="function(s, e) { pcSaveLayout.Hide(); }" />
                                                                                    </dx:ASPxButton>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                            <Paddings PaddingTop="19px"></Paddings>
                                                                        </dx:LayoutItem>
                                                                    </Items>
                                                                </dx:ASPxFormLayout>
                                                            </dx:PanelContent>
                                                        </PanelCollection>
                                                    </dx:ASPxPanel>

                                                </dx:PopupControlContentControl>
                                            </ContentCollection>
                                            <ContentStyle>
                                                <Paddings PaddingBottom="5px" />
                                            </ContentStyle>
                                        </dx:ASPxPopupControl>
                                        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
                                            Modal="True">
                                        </dx:ASPxLoadingPanel>
                                        <dx:ASPxPopupControl ID="brSecIDPopup" runat="server" ClientInstanceName="brSecIDPopup" ContentUrl="~/Equity/BRSecIDPopup.aspx" Width="860px" Height="700px" ContentStyle-HorizontalAlign="Center" PopupHorizontalAlign="Center" HeaderText="Security Detail"  ShowMaximizeButton="True" AllowDragging="True" PopupVerticalAlign="Middle">
                                            <ContentCollection>
                                                <dx:PopupControlContentControl ID="PopupControlContentControl2" runat="server" PopupVerticalAlign="WindowCenter" PopupHorizontalAlign="WindowCenter" EnableAnimation="True">
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
<%--</asp:Content>--%>
         </form>

</body>

</html>
<%--<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
</body>
</html>--%>
