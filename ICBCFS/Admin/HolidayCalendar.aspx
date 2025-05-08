<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HolidayCalendar.aspx.cs" Inherits="ICBCFS.Admin.HolidayCalendar" MasterPageFile="~/Site.Master" %>

<%@ Register Assembly="DevExpress.Web.v19.1, Version=19.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>



<asp:Content ID="bcHolidayCalendar" ContentPlaceHolderID="MainContent1" runat="server">

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
                <dx:SplitterPane Size="12%" PaneStyle-Paddings-Padding="0">
                    <PaneStyle>
                        <Paddings Padding="0px"></Paddings>
                    </PaneStyle>
                    <ContentCollection>
                        <dx:SplitterContentControl ID="SplitterContentControl1" runat="server">
                            <div>
                                <dx:ASPxFormLayout ID="ASPxFormLayout3" runat="server" ColCount="5" ColumnCount="5" EncodeHtml="false" ShowItemCaptionColon="False">
                                    <Items>

                                        <dx:LayoutGroup Caption="" ColSpan="1" ColumnCount="3" ColumnSpan="1" Width="0px">

                                            <Items>
                                                <dx:LayoutItem Caption="Year" ColSpan="1">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxComboBox ID="cmbYear" runat="server" Width="125px" ClientInstanceName="cmbYear">
                                                            </dx:ASPxComboBox>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                    <CaptionSettings Location="Top" />
                                                </dx:LayoutItem>


                                                <dx:LayoutItem Caption="IsHoliday" ColSpan="1">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxComboBox ID="cmbIsHoliday" runat="server" Width="125px" ClientInstanceName="cmbIsHoliday">
                                                            </dx:ASPxComboBox>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>
                                                    <CaptionSettings Location="Top" />
                                                </dx:LayoutItem>

                                            </Items>
                                        </dx:LayoutGroup>

                                        <dx:LayoutGroup Caption="" ColCount="2" ColSpan="2" ColumnCount="2" ColumnSpan="2" Width="120px" GroupBoxStyle-Border-BorderStyle="None">


                                            <GroupBoxStyle Border-BorderStyle="None"></GroupBoxStyle>

                                            <Items>
                                                <dx:LayoutItem Caption="" ColSpan="1" Paddings-PaddingLeft="0" Paddings-PaddingTop="20">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxButton ID="btnSearch" runat="server" Height="30px" Width="45px" OnClick="btnSearch_Click" Text="Search">
                                                                <ClientSideEvents Click="function(s, e) {
                                    Callback.PerformCallback();
                                    LoadingPanel.Show();
                                }" />
                                                            </dx:ASPxButton>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>

                                                    <Paddings PaddingTop="20px"></Paddings>

                                                </dx:LayoutItem>
                                                <dx:LayoutItem Caption="" ColSpan="1" Paddings-PaddingTop="20">
                                                    <LayoutItemNestedControlCollection>
                                                        <dx:LayoutItemNestedControlContainer runat="server">
                                                            <dx:ASPxButton ID="btnClear" runat="server" Height="30px" Width="45px" Text="Clear" AutoPostBack="false">

                                                                <ClientSideEvents Click="function(s, e) {
                                      SetStandardValues();
                                }" />
                                                            </dx:ASPxButton>
                                                        </dx:LayoutItemNestedControlContainer>
                                                    </LayoutItemNestedControlCollection>

                                                    <Paddings PaddingTop="20px"></Paddings>
                                                </dx:LayoutItem>
                                            </Items>
                                        </dx:LayoutGroup>

                                    </Items>

                                </dx:ASPxFormLayout>
                            </div>
                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>
                <dx:SplitterPane>
                    <ContentCollection>
                        <dx:SplitterContentControl ID="SplitterContentControl2" runat="server">
                            <asp:UpdatePanel ID="upAccountMapping" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">

                                <ContentTemplate>
                                    <div>
                                        <dx:ASPxGridView ID="gridHolidayCalendar" runat="server" Width="100%"
                                            ClientInstanceName="gridHolidayCalendar" VisibleRowCount="true" AutoGenerateColumns="False"
                                            OnToolbarItemClick="gridHolidayCalendar_ToolbarItemClick"
                                            KeyFieldName="Id"
                                            OnRowUpdating="gridHolidayCalendar_RowUpdating" OnRowInserting="gridHolidayCalendar_RowInserting"
                                            OnRowDeleting="gridHolidayCalendar_RowDeleting"
                                            OnDataBinding="grid_DataBinding"
                                            EnableRowsCache="True">

                                            <Settings ShowGroupPanel="True" ShowFooter="True" ShowFilterRow="True" ShowHeaderFilterButton="true" />
                                            <ClientSideEvents ToolbarItemClick="function(s, e) { 
                                                
                                                 if (e.item.name === 'tbResetSorting') 
                                                    {
                                                        e.processOnServer = true;
                                                    }}" />
                                            <SettingsContextMenu Enabled="True" EnableFooterMenu="True" EnableGroupFooterMenu="True" EnableGroupPanelMenu="True" EnableRowMenu="True" EnableColumnMenu="True">
                                            </SettingsContextMenu>
                                            <SettingsCustomizationDialog Enabled="True" />
                                            <SettingsPager PageSize="100"></SettingsPager>
                                            <Settings VerticalScrollableHeight="536" VerticalScrollBarMode="Auto" HorizontalScrollBarMode="Auto" ShowFooter="True" ShowGroupFooter="VisibleAlways" ShowTitlePanel="true" UseFixedTableLayout="true" />
                                            <SettingsDataSecurity AllowDelete="true" AllowEdit="true" AllowInsert="true" />
                                            <SettingsPopup>
                                                <HeaderFilter MinHeight="140px"></HeaderFilter>
                                            </SettingsPopup>
                                            <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" Landscape="true" PaperKind="CSheet" FileName="Account Mapping" />
                                            <SettingsSearchPanel Visible="true" CustomEditorID="tbToolbarSearch" />
                                            <SettingsResizing ColumnResizeMode="Control" Visualization="Live" />

                                            <Columns>
                                                <dx:GridViewCommandColumn ShowEditButton="true" VisibleIndex="0" />
                                                <dx:GridViewDataTextColumn FieldName="CalendarDate" Caption="CalendarDate" VisibleIndex="1" Width="170px" Visible="True">
                                                    <PropertiesTextEdit DisplayFormatString="MM/dd/yyyy"></PropertiesTextEdit>
                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="CheckedList"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="1" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="DOM_SYSDATE" Caption="DOM_SYSDATE" VisibleIndex="1" Width="170px" Visible="True">
                                                    <PropertiesTextEdit DisplayFormatString="MM/dd/yyyy"></PropertiesTextEdit>
                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="CheckedList"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="1" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="DOM_PREVDATE" Caption="DOM_PREVDATE" VisibleIndex="2" Width="160px" Visible="True">
                                                    <PropertiesTextEdit DisplayFormatString="MM/dd/yyyy"></PropertiesTextEdit>
                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="CheckedList"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="2" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="DOM_TradeDay" Caption="DOM_TradeDay" VisibleIndex="3" Width="200px" Visible="True">
                                                    <PropertiesTextEdit DisplayFormatString="F0"></PropertiesTextEdit>
                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <SettingsHeaderFilter Mode="CheckedList"></SettingsHeaderFilter>
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <EditFormSettings VisibleIndex="3" />
                                                </dx:GridViewDataTextColumn>

                                                <dx:GridViewDataTextColumn FieldName="DOM_SettleDay" Caption="DOM_SettleDay" VisibleIndex="4" Width="130px" Visible="True" ShowInCustomizationForm="False" Settings-FilterMode="DisplayText" CellStyle-HorizontalAlign="Center">
                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="CheckedList"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="4" />
                                                </dx:GridViewDataTextColumn>

                                                <dx:GridViewDataTextColumn FieldName="INTL_SYSDATE" Caption="INTL_SYSDATE" VisibleIndex="5" Width="110px" Visible="True">
                                                    <PropertiesTextEdit DisplayFormatString="MM/dd/yyyy"></PropertiesTextEdit>
                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="DateRangeCalendar"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="5" />
                                                </dx:GridViewDataTextColumn>

                                                <dx:GridViewDataTextColumn FieldName="INTL_PREVDATE" Caption="INTL_PREVDATE" VisibleIndex="6" Width="160px" Visible="True">
                                                    <PropertiesTextEdit DisplayFormatString="MM/dd/yyyy"></PropertiesTextEdit>
                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="DateRangeCalendar"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="6" />
                                                </dx:GridViewDataTextColumn>

                                                <dx:GridViewDataTextColumn FieldName="INTL_TradeDay" Caption="INTL_TradeDay" VisibleIndex="7" Width="155px" Visible="True">

                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="DateRangeCalendar"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="7" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="INTL_SettleDay" Caption="INTL_SettleDay" VisibleIndex="8" Width="125px" Visible="True">

                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="DateRangeCalendar"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="8" />
                                                </dx:GridViewDataTextColumn>

                                                <dx:GridViewDataTextColumn FieldName="isWeekend" Caption="isWeekend" VisibleIndex="9" Width="200px" Visible="True" ShowInCustomizationForm="False" Settings-FilterMode="DisplayText" CellStyle-HorizontalAlign="Center">

                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="DateRangeCalendar"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="9" />
                                                </dx:GridViewDataTextColumn>

                                                <dx:GridViewDataTextColumn FieldName="cDayNameShort" Caption="cDayNameShort" VisibleIndex="10" Width="100px" Visible="True">
                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="CheckedList"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="10" />
                                                </dx:GridViewDataTextColumn>


                                                <dx:GridViewDataTextColumn FieldName="isHoliday" Caption="isHoliday" VisibleIndex="11" Width="110px" Visible="True">

                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="DateRangeCalendar"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="11" />
                                                </dx:GridViewDataTextColumn>

                                                <dx:GridViewDataTextColumn FieldName="HolidayDescr" Caption="HolidayDescr" VisibleIndex="12" Width="110px" Visible="True">

                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="DateRangeCalendar"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="12" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="cDay" Caption="cDay" VisibleIndex="13" Width="160px" Visible="True">

                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="DateRangeCalendar"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="13" />
                                                </dx:GridViewDataTextColumn>

                                                <dx:GridViewDataTextColumn FieldName="cDaySuffix" Caption="cDaySuffix" VisibleIndex="13" Width="160px" Visible="True">

                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="DateRangeCalendar"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="13" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="cDayOfWeek" Caption="cDayOfWeek" VisibleIndex="13" Width="160px" Visible="True">

                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="DateRangeCalendar"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="13" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="cDayOfYear" Caption="cDayOfYear" VisibleIndex="13" Width="160px" Visible="True">

                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="DateRangeCalendar"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="13" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="cDayName" Caption="cDayName" VisibleIndex="13" Width="160px" Visible="True">

                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="DateRangeCalendar"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="13" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="cWeek" Caption="cWeek" VisibleIndex="13" Width="160px" Visible="True">

                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="DateRangeCalendar"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="13" />
                                                </dx:GridViewDataTextColumn>

                                                <dx:GridViewDataTextColumn FieldName="cWeekOfYear" Caption="cWeekOfYear" VisibleIndex="13" Width="160px" Visible="True">

                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="DateRangeCalendar"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="13" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="cMonth" Caption="cMonth" VisibleIndex="13" Width="160px" Visible="True">

                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="DateRangeCalendar"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="13" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="cMonthNameShort" Caption="cMonthNameShort" VisibleIndex="13" Width="160px" Visible="True">

                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="DateRangeCalendar"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="13" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="cMonthName" Caption="cMonthName" VisibleIndex="13" Width="160px" Visible="True">

                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="DateRangeCalendar"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="13" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="cYear" Caption="cYear" VisibleIndex="13" Width="160px" Visible="True">

                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="DateRangeCalendar"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="13" />
                                                </dx:GridViewDataTextColumn>

                                                <dx:GridViewDataTextColumn FieldName="isLeapYear" Caption="isLeapYear" VisibleIndex="13" Width="160px" Visible="True">

                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="DateRangeCalendar"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="13" />
                                                </dx:GridViewDataTextColumn>

                                                <dx:GridViewDataTextColumn FieldName="HolidayComment" Caption="HolidayComment" VisibleIndex="13" Width="160px" Visible="True">

                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="DateRangeCalendar"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="13" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="Euroclear_holiday_Flag" Caption="Euroclear_holiday_Flag" VisibleIndex="13" Width="160px" Visible="True">

                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="DateRangeCalendar"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="13" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="Clearstram_holiday_Flag" Caption="Clearstram_holiday_Flag" VisibleIndex="13" Width="160px" Visible="True">

                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="DateRangeCalendar"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="13" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="Kass_holiday_Flag" Caption="Kass_holiday_Flag" VisibleIndex="13" Width="160px" Visible="True">

                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="DateRangeCalendar"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="13" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="Local_holiday_Flag" Caption="Local_holiday_Flag" VisibleIndex="13" Width="160px" Visible="True">

                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                    <SettingsHeaderFilter Mode="DateRangeCalendar"></SettingsHeaderFilter>
                                                    <EditFormSettings VisibleIndex="13" />
                                                </dx:GridViewDataTextColumn>

                                            </Columns>


                                            <EditFormLayoutProperties ColCount="8">
                                                <Items>
                                                    <dx:GridViewColumnLayoutItem ColumnName="DOM_SYSDATE" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="DOM_PREVDATE" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="DOM_TradeDay" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="DOM_SettleDay" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="INTL_SYSDATE" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="INTL_PREVDATE" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="INTL_TradeDay" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="INTL_SettleDay" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="isHoliday" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="HolidayDescr" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="HolidayComment" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="Euroclear_holiday_Flag" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="Clearstram_holiday_Flag" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="Kass_holiday_Flag" />
                                                    <dx:GridViewColumnLayoutItem ColumnName="Local_holiday_Flag" />
                                                    <dx:EditModeCommandLayoutItem Width="100%" HorizontalAlign="Right" />
                                                </Items>
                                                <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="700" />
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

                                                <Header Font-Bold="True" Font-Names="Arial" Font-Size="Small" ForeColor="Black" HorizontalAlign="Center">
                                                </Header>
                                                <AlternatingRow Enabled="True">
                                                </AlternatingRow>
                                                <TitlePanel Font-Bold="True" Font-Names="Arial" Font-Size="Large" ForeColor="Black" HorizontalAlign="Center"></TitlePanel>
                                            </Styles>
                                        </dx:ASPxGridView>


                                        <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
                                            Modal="True">
                                        </dx:ASPxLoadingPanel>

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
