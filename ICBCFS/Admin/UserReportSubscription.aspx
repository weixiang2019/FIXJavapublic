<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UserReportSubscription.aspx.cs" Inherits="ICBCFS.Admin.UserReportSubscription" %>

<%@ Register Assembly="DevExpress.Web.v19.1, Version=19.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>



<%@ Register TagPrefix="dx" Namespace="DevExpress.Web" Assembly="DevExpress.Web.v19.1" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent1" runat="server">
    <script>
        function OnSelectAllCheckedChanged(s, e) {
            var gridView = s.GetGridView();
            var isSelectedCheckBoxes = gridView.GetEditorValues("IsRun");

            for (var i = 0; i < isSelectedCheckBoxes.length; i++) {
                isSelectedCheckBoxes[i] = s.GetChecked();
            }

            gridView.UpdateEdit();
        }

        function OnGridFocusedRowChanged() {
            //alert(GridRealTimeReportSubscriptions.GetFocusedRowIndex()); --keep this for reference
            cmbSubscriptionName.PerformCallback(GridRealTimeReportSubscriptions.GetFocusedRowIndex());
            ////gridMainCashProjections.PerformCallback(gridMainCashProjections.GetFocusedRowIndex())
            //gridUpperDetailCashProjections.PerformCallback(gridMainCashProjections.GetFocusedRowIndex());
            ////gridLowerDetailCashProjections.Refresh();
            //gridLowerDetailCashProjections.PerformCallback('clear');
        }

        function OnCustomButtonClick(s, e) {
            rowVisibleIndex = e.visibleIndex;
            s.GetRowValues(e.visibleIndex, 'SubscriptionName', ShowMesssage);
        }

        function ShowMesssage(SubscriptionName) {
            lblMessage.SetText(SubscriptionName + " Subscription has been intitiated.");
        }
    </script>
    <div>
    </div>

    <div>
        <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        </asp:ScriptManagerProxy>
    </div>

    <dx:ASPxCallback ID="ASPxCallback1" runat="server" ClientInstanceName="Callback">
        <ClientSideEvents CallbackComplete="function(s, e) { LoadingPanel.Hide(); }" />
    </dx:ASPxCallback>
    <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Width="100%" Height="900px" EnableHierarchyRecreation="false" ShowCollapseBackwardButton="True" ShowCollapseForwardButton="True" Orientation="Vertical" Style="margin-bottom: 16px;">
        <Panes>
            <dx:SplitterPane>
                <ContentCollection>
                    <dx:SplitterContentControl ID="SplitterContentControl2" runat="server">
                        <asp:UpdatePanel ID="upUserPreference" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
                            <ContentTemplate>
                                <div>
                                    <dx:ASPxFormLayout ID="ScUserPreference" runat="server" ColCount="5" ColumnCount="5" EncodeHtml="False" ShowItemCaptionColon="False">
                                        <SettingsItemCaptions Location="Top" />
                                        <Items>

                                            <dx:LayoutGroup Caption="Real Time Report Subscription & Log(s)" ColCount="2" RowSpan="2">
                                                <Items>
                                                    <dx:LayoutItem Caption="" ColSpan="2" RowSpan="1" Height="50px" VerticalAlign="Top">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer8" runat="server">
                                                                <dx:ASPxGridView ID="GridRealTimeReportSubscriptions" runat="server" Width="975px" VisibleRowCount="true" AutoGenerateColumns="False"
                                                                    ClientInstanceName="GridRealTimeReportSubscriptions" KeyFieldName="UserSubscriptionId" OnCustomButtonCallback="GridRealTimeReportSubscriptions_CustomButtonCallback">

                                                                    <Settings ShowGroupPanel="false" ShowFooter="false" ShowFilterRow="false" ShowHeaderFilterButton="false" />
                                                                    <SettingsCustomizationDialog Enabled="True" />
                                                                    <SettingsText Title="<b>Real Time Report Subscription(s)</b>" />
                                                                    <SettingsBehavior AllowSort="false" AllowGroup="false" AllowSelectSingleRowOnly="true" AllowSelectByRowClick="true" AllowFocusedRow="true" />
                                                                    <SettingsPager Mode="ShowAllRecords" />
                                                                    <Settings VerticalScrollableHeight="250" VerticalScrollBarMode="Auto" HorizontalScrollBarMode="Auto" ShowFooter="false" ShowGroupFooter="VisibleAlways" ShowTitlePanel="true" UseFixedTableLayout="true" />
                                                                    <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />
                                                                    <SettingsPopup>
                                                                        <HeaderFilter MinHeight="140px"></HeaderFilter>
                                                                    </SettingsPopup>
                                                                    <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" Landscape="true" />
                                                                    <SettingsSearchPanel Visible="true" CustomEditorID="tbToolbarSearch" />
                                                                    <SettingsResizing ColumnResizeMode="Control" Visualization="Live" />
                                                                    <ClientSideEvents FocusedRowChanged="function(s, e) { OnGridFocusedRowChanged(); }"
                                                                        CustomButtonClick="OnCustomButtonClick" />
                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="UserSubscriptionId" Caption="UserSubscriptionId" Width="190px" Visible="false" VisibleIndex="0">
                                                                            <Settings AllowEllipsisInText="True" />
                                                                            <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                                            <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="SubscriptionName" Caption="Subscription Name" Width="190px" Visible="True" VisibleIndex="1">
                                                                            <Settings AllowEllipsisInText="True" />
                                                                            <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                                            <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="IsActive" Caption="Is Active" Width="90px" Visible="True" VisibleIndex="2">
                                                                            <Settings AllowEllipsisInText="True" />
                                                                            <HeaderStyle CssClass="gridcolheader" HorizontalAlign="Center" />
                                                                            <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewCommandColumn ShowNewButton="false" ShowEditButton="false" VisibleIndex="3" ButtonRenderMode="Outline" Width="200px">
                                                                            <CustomButtons>
                                                                                <dx:GridViewCommandColumnCustomButton ID="cmdRunSubscription" Text="Run Subscription">
                                                                                </dx:GridViewCommandColumnCustomButton>
                                                                            </CustomButtons>
                                                                        </dx:GridViewCommandColumn>
                                                                    </Columns>
                                                                    <Styles>
                                                                        <Header Font-Bold="True" Font-Names="Arial" Font-Size="Small" ForeColor="Black" HorizontalAlign="Center">
                                                                        </Header>
                                                                        <AlternatingRow Enabled="True">
                                                                        </AlternatingRow>
                                                                        <TitlePanel Font-Bold="True" Font-Names="Arial" Font-Size="Large" ForeColor="Black" HorizontalAlign="Center">
                                                                        </TitlePanel>
                                                                    </Styles>
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="" ColSpan="2" RowSpan="1" Height="50px" VerticalAlign="Top">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer9" runat="server">
                                                                <dx:ASPxGridView ID="GridRealTimeReportSubscriptionlog" runat="server" Width="975px" VisibleRowCount="true" AutoGenerateColumns="False"
                                                                    ClientInstanceName="GridRealTimeReportSubscriptionlog" KeyFieldName="ReportId" OnCustomColumnDisplayText="gridMainSummary_CustomColumnDisplayText">
                                                                    <Settings ShowGroupPanel="false" ShowFooter="false" ShowFilterRow="false" ShowHeaderFilterButton="false" />
                                                                    <SettingsCustomizationDialog Enabled="True" />
                                                                    <SettingsText Title="<b>Real Time Report Subscription Log</b>" />
                                                                    <SettingsBehavior AllowSort="false" AllowGroup="false" />
                                                                    <SettingsPager Mode="ShowAllRecords" />
                                                                    <Settings VerticalScrollableHeight="360" VerticalScrollBarMode="Auto" HorizontalScrollBarMode="Auto" ShowFooter="false" ShowGroupFooter="VisibleAlways" ShowTitlePanel="true" UseFixedTableLayout="true" />
                                                                    <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />
                                                                    <SettingsPopup>
                                                                        <HeaderFilter MinHeight="140px"></HeaderFilter>
                                                                    </SettingsPopup>
                                                                    <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" Landscape="true" />
                                                                    <SettingsSearchPanel Visible="true" CustomEditorID="tbToolbarSearch" />
                                                                    <SettingsResizing ColumnResizeMode="Control" Visualization="Live" />

                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="SubscriptionName" Caption="Subscription Name" Width="150px" Visible="True" VisibleIndex="0">
                                                                            <Settings AllowEllipsisInText="True" />
                                                                            <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                                            <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="ReportName" Caption="Report Name" Width="100px" Visible="True" VisibleIndex="1">
                                                                            <Settings AllowEllipsisInText="True" />
                                                                            <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                                            <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Entity" Caption="Entity" Width="90px" Visible="True" VisibleIndex="2">
                                                                            <Settings AllowEllipsisInText="True" />
                                                                            <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                                            <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="SysDt" Caption="Date" Width="150px" Visible="True" VisibleIndex="3">
                                                                            <Settings AllowEllipsisInText="True" />
                                                                            <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                                            <CellStyle CssClass="gridcellStyle" HorizontalAlign="Left" Wrap="False"></CellStyle>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Report_Execution_status" Caption="Execution" Width="80px" Visible="True" VisibleIndex="4">
                                                                            <Settings AllowEllipsisInText="True" />
                                                                            <HeaderStyle CssClass="gridcolheader" HorizontalAlign="Center" />
                                                                            <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Report_Execution_status_indicator" Caption="#" Width="40px" VisibleIndex="5">
                                                                            <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                                            <CellStyle HorizontalAlign="Center" Wrap="True"></CellStyle>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="FTP_Execution_status" Caption="FTP Status" Width="90px" Visible="True" VisibleIndex="6">
                                                                            <Settings AllowEllipsisInText="True" />
                                                                            <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                                            <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="Email_Execution_status" Caption="Email Status" Width="100px" Visible="True" VisibleIndex="7">
                                                                            <Settings AllowEllipsisInText="True" />
                                                                            <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                                            <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataTextColumn FieldName="filepath" Caption="File Path" Width="250px" Visible="True" VisibleIndex="8">
                                                                            <Settings AllowEllipsisInText="True" />
                                                                            <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                                            <CellStyle CssClass="gridcellStyle" HorizontalAlign="Left" Wrap="False"></CellStyle>
                                                                        </dx:GridViewDataTextColumn>


                                                                    </Columns>
                                                                    <FormatConditions>
                                                                        <%--<dx:GridViewFormatConditionIconSet FieldName="S/D Cash Bal (CCY)" Format="Triangles3" />--%>
                                                                        <dx:GridViewFormatConditionIconSet FieldName="Report_Execution_status_indicator" Format="TrafficLights3Unrimmed" />
                                                                        <%--  <dx:GridViewFormatConditionIconSet FieldName="FTP_Execution_status" Format="TrafficLights3Unrimmed" />
                                                                         <dx:GridViewFormatConditionIconSet FieldName="Email_Execution_status" Format="TrafficLights3Unrimmed" />--%>
                                                                    </FormatConditions>
                                                                    <Styles>
                                                                        <Header Font-Bold="True" Font-Names="Arial" Font-Size="Small" ForeColor="Black" HorizontalAlign="Center">
                                                                        </Header>
                                                                        <AlternatingRow Enabled="True">
                                                                        </AlternatingRow>
                                                                        <TitlePanel Font-Bold="True" Font-Names="Arial" Font-Size="Large" ForeColor="Black" HorizontalAlign="Center">
                                                                        </TitlePanel>
                                                                    </Styles>
                                                                </dx:ASPxGridView>

                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>

                                            </dx:LayoutGroup>

                                            <dx:LayoutGroup Caption="User Report Subscription" ColSpan="1" ColCount="1" VerticalAlign="Top">
                                                <Items>
                                                    <dx:LayoutItem Caption="Subscription Name" Height="50px" Paddings-PaddingLeft="30px">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer6" runat="server">
                                                                <dx:ASPxComboBox ID="cmbSubscriptionName" runat="server" ClientInstanceName="cmbSubscriptionName" DropDownStyle="DropDown"
                                                                    OnSelectedIndexChanged="cmbSubscriptionName_SelectedIndexChanged" OnCallback="cmbSubscriptionName_Callback"
                                                                    AutoPostBack="true" Width="100%">
                                                                </dx:ASPxComboBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                        <CaptionSettings VerticalAlign="Middle" />
                                                        <Paddings PaddingLeft="10px" />
                                                    </dx:LayoutItem>


                                                    <dx:LayoutItem Caption="Entity Code" Height="50px" Paddings-PaddingLeft="30px">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer3" runat="server">
                                                                <dx:ASPxListBox ID="lbEntityCodeList" runat="server" Width="100%" SelectionMode="CheckColumn" EnableSelectAll="true" Height="405px"
                                                                    TextField="EntityCode" ValueField="EntityCode" EnableCheckBoxes="true" OnDataBound="lbEntityCodeList_DataBound">
                                                                    <CaptionSettings Position="Top" />
                                                                </dx:ASPxListBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                        <CaptionSettings VerticalAlign="Middle" />
                                                        <Paddings PaddingLeft="10px" />
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem FieldName="ScheduleTime" Caption="Schedule Time" Height="50px" Paddings-PaddingLeft="30px">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer30" runat="server">
                                                                <dx:ASPxTimeEdit ID="dtScheduleTime" runat="server" EditFormat="Custom" DisplayFormatString="HH:mm:ss"
                                                                    EditFormatString="HH:mm:ss" TimeSectionProperties-Visible="true" Width="150" ClientInstanceName="dtScheduleTime">
                                                                </dx:ASPxTimeEdit>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                        <CaptionSettings VerticalAlign="Middle" />
                                                        <Paddings PaddingLeft="10px" />
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem FieldName="IsEnabled" Caption="Status" Width="50px" Paddings-PaddingLeft="30px">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer10" runat="server">
                                                                <dx:ASPxCheckBox ID="chkIsEnabled" runat="server" Height="25px" ClientInstanceName="chkIsEnabled" Text="Active">
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                        <CaptionSettings VerticalAlign="Middle" />
                                                        <Paddings PaddingLeft="10px" />
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>

                                            <dx:LayoutGroup Caption="Real Time Reports" ColCount="2">
                                                <Items>
                                                    <dx:LayoutItem Caption="" ColSpan="2" RowSpan="1" Height="50px" VerticalAlign="Top">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer4" runat="server">
                                                                <dx:ASPxGridView ID="GridRealTimeReports" runat="server" Width="675px" VisibleRowCount="true" AutoGenerateColumns="False"
                                                                    ClientInstanceName="GridRealTimeReports" KeyFieldName="ReportId">
                                                                    <Settings ShowGroupPanel="false" ShowFooter="false" ShowFilterRow="false" ShowHeaderFilterButton="false" />
                                                                    <SettingsCustomizationDialog Enabled="True" />
                                                                    <SettingsText Title="<b>Real Time Report Subscription Setting(s)</b>" />
                                                                    <SettingsBehavior AllowSort="false" AllowGroup="false" />
                                                                    <SettingsPager Mode="ShowAllRecords" />
                                                                    <Settings VerticalScrollableHeight="510" VerticalScrollBarMode="Auto" HorizontalScrollBarMode="Auto" ShowFooter="false" ShowGroupFooter="VisibleAlways" ShowTitlePanel="true" UseFixedTableLayout="true" />
                                                                    <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />
                                                                    <SettingsPopup>
                                                                        <HeaderFilter MinHeight="140px"></HeaderFilter>
                                                                    </SettingsPopup>
                                                                    <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" Landscape="true" />
                                                                    <SettingsSearchPanel Visible="true" CustomEditorID="tbToolbarSearch" />
                                                                    <SettingsResizing ColumnResizeMode="Control" Visualization="Live" />

                                                                    <Columns>
                                                                        <dx:GridViewDataTextColumn FieldName="ReportId" Caption="Report Id" Width="100px" Visible="false" SettingsHeaderFilter-Mode="CheckedList">
                                                                            <Settings AllowEllipsisInText="True" />
                                                                            <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                                            <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                                        </dx:GridViewDataTextColumn>
                                                                        <dx:GridViewDataColumn FieldName="IsRun" Caption="Run" Visible="false">
                                                                            <HeaderStyle CssClass="hide" />
                                                                            <EditCellStyle CssClass="hide" />
                                                                            <CellStyle CssClass="hide" />

                                                                            <DataItemTemplate>
                                                                                <asp:CheckBox ID="chkIsRun" AutoPostBack="false" runat="server" Checked='<%# Eval("IsRun") %>' />
                                                                                <%--<dx:ASPxCheckBox ID="chkIsRun" runat="server" Checked='<%# Bind("IsRun") %>' />--%>
                                                                            </DataItemTemplate>
                                                                        </dx:GridViewDataColumn>
                                                                        <dx:GridViewDataColumn FieldName="IsFtp" Caption="Ftp">
                                                                            <DataItemTemplate>
                                                                                <asp:CheckBox ID="chkIsFtp" AutoPostBack="false" runat="server" Checked='<%# Eval("IsFtp") %>' />
                                                                            </DataItemTemplate>
                                                                        </dx:GridViewDataColumn>
                                                                        <dx:GridViewDataColumn FieldName="IsSchedule" Caption="Schedule">
                                                                            <DataItemTemplate>
                                                                                <asp:CheckBox ID="chkIsSchedule" AutoPostBack="false" runat="server" Checked='<%# Eval("IsSchedule") %>' />
                                                                            </DataItemTemplate>
                                                                        </dx:GridViewDataColumn>
                                                                        <dx:GridViewDataColumn FieldName="IsEmail" Caption="Email">
                                                                            <DataItemTemplate>
                                                                                <asp:CheckBox ID="chkIsEmail" AutoPostBack="false" runat="server" Checked='<%# Eval("IsEmail") %>' />
                                                                            </DataItemTemplate>
                                                                        </dx:GridViewDataColumn>

                                                                        <dx:GridViewDataTextColumn FieldName="ReportName" Caption="Report Name" Width="250px" Visible="True" VisibleIndex="0" SettingsHeaderFilter-Mode="CheckedList">
                                                                            <Settings AllowEllipsisInText="True" />
                                                                            <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                                            <CellStyle CssClass="gridcellStyle" HorizontalAlign="Left" Wrap="False"></CellStyle>
                                                                        </dx:GridViewDataTextColumn>
                                                                    </Columns>
                                                                    <Styles>
                                                                        <Header Font-Bold="True" Font-Names="Arial" Font-Size="Small" ForeColor="Black" HorizontalAlign="Center">
                                                                        </Header>
                                                                        <AlternatingRow Enabled="True">
                                                                        </AlternatingRow>
                                                                        <TitlePanel Font-Bold="True" Font-Names="Arial" Font-Size="Large" ForeColor="Black" HorizontalAlign="Center">
                                                                        </TitlePanel>
                                                                    </Styles>
                                                                </dx:ASPxGridView>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>


                                                </Items>

                                            </dx:LayoutGroup>



                                            <dx:LayoutGroup Caption="Email Details" ColumnSpan="3" ColumnCount="3">
                                                <Items>

                                                    <dx:LayoutItem Caption="To Email Address" Height="20px" Paddings-PaddingLeft="30px" VerticalAlign="Bottom" HorizontalAlign="Left" Width="100%">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxTextBox ID="txtToEmailAddress" runat="server" Width="250px" MaxLength="250" ClientInstanceName="ToEmailAddress">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                        <Paddings PaddingLeft="10px" />
                                                    </dx:LayoutItem>



                                                    <dx:LayoutItem Caption="Email Subject" Height="30px" Paddings-PaddingLeft="30px" VerticalAlign="Bottom" HorizontalAlign="left" Width="100%">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer7" runat="server">
                                                                <dx:ASPxTextBox ID="txtEmailSubject" runat="server" Width="250px" MaxLength="250" ClientInstanceName="EmailSubject">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                        <Paddings PaddingLeft="10px" />
                                                    </dx:LayoutItem>


                                                    <dx:LayoutItem Caption="" Height="30px" Paddings-PaddingLeft="30px" VerticalAlign="Bottom" HorizontalAlign="Left">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer5" runat="server">
                                                                <dx:ASPxButton ID="btnUpdateReportPreference" runat="server" Height="30px" Width="150px" Text="Add/Update" OnClick="btnUpdate2_Click" AutoPostBack="true">
                                                                </dx:ASPxButton>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                        <Paddings PaddingLeft="10px" />
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="CC Email Address" Height="30px" Paddings-PaddingLeft="30px" VerticalAlign="Bottom" HorizontalAlign="Left" Width="100%">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer2" runat="server">
                                                                <dx:ASPxTextBox ID="txtCCEmailAddress" runat="server" Width="250px" MaxLength="250" ClientInstanceName="CCEmailAddress">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                        <Paddings PaddingLeft="10px" />
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="" Height="30px" Paddings-PaddingLeft="30px" VerticalAlign="Bottom" HorizontalAlign="Left" Width="100%">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer11" runat="server">
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                        <Paddings PaddingLeft="10px" />
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="" Height="30px" Paddings-PaddingLeft="30px" VerticalAlign="Bottom" HorizontalAlign="Right">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer1" runat="server">
                                                                <dx:ASPxButton ID="btnRunSubscription" runat="server" Height="30px" Width="150px" Text="Refresh" OnClick="btnUpdate2_Click" AutoPostBack="true">
                                                                    <ClientSideEvents Click="function(s, e) {
                                                                                            Callback.PerformCallback();
                                                                                            LoadingPanel.Show();
                                                                                        }" />
                                                                </dx:ASPxButton>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                        <Paddings PaddingLeft="10px" />
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="" ColumnSpan="3" Height="20px" Paddings-PaddingLeft="30px" VerticalAlign="Bottom" HorizontalAlign="Left" Width="100%">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer runat="server">
                                                                <dx:ASPxLabel ID="lblMessage" runat="server" Text="" ForeColor="Red" ClientInstanceName="lblMessage" Width="100%"></dx:ASPxLabel>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                        <Paddings PaddingLeft="10px" />
                                                    </dx:LayoutItem>

                                                </Items>
                                            </dx:LayoutGroup>

                                            <dx:LayoutGroup Caption="" ColumnSpan="3" ColumnCount="3" Visible="false">
                                                <Items>
                                                </Items>
                                            </dx:LayoutGroup>

                                        </Items>
                                    </dx:ASPxFormLayout>
                                </div>
                                <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
                                    Modal="True">
                                </dx:ASPxLoadingPanel>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>
        </Panes>
    </dx:ASPxSplitter>



</asp:Content>
