<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Mapping.aspx.cs" Inherits="ICBCFS.Admin.Mapping" %>

<%@ Register Assembly="DevExpress.Web.v19.1, Version=19.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="bcMapping" ContentPlaceHolderID="MainContent1" runat="server">
    <script type="text/javascript">
       
        function SetStandardValues() {
            cmbEnumType.SetSelectedIndex(0);
            return false;
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
        <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Width="100%" Height="862" EnableHierarchyRecreation="false" ShowCollapseBackwardButton="True" ShowCollapseForwardButton="True" Orientation="Vertical" Style="margin-bottom: 16px;">
            <Panes>
                <dx:SplitterPane Size="12%" PaneStyle-Paddings-Padding="0">
                    <ContentCollection>
                        <dx:SplitterContentControl ID="SplitterContentControl1" runat="server">

                            <dx:ASPxFormLayout ID="ASPxFormLayout3" runat="server" ColCount="2" ColumnCount="2" EncodeHtml="False" ShowItemCaptionColon="False">
                                <Items>

                                    <dx:LayoutGroup Caption="Mapping Information" ColCount="1" ColSpan="1" ColumnCount="1" ColumnSpan="1" Paddings-PaddingRight="0">
                                        <Items>

                                            <dx:LayoutItem Caption="Enum Type" ColSpan="1">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server">
                                                        <dx:ASPxComboBox ID="cmbEnumType" runat="server" Width="100" ClientInstanceName="cmbEnumType">
                                                            <ClientSideEvents Init="function(s, e) {s.Focus();}" />
                                                        </dx:ASPxComboBox>
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                                <CaptionSettings Location="Top" />

                                            </dx:LayoutItem>
                                        </Items>
                                    </dx:LayoutGroup>

                                    <dx:LayoutGroup Caption="" ColCount="2" ColumnCount="2" ColSpan="1" ColumnSpan="1" RowSpan="8" Width="80px" HorizontalAlign="Left" GroupBoxStyle-Border-BorderStyle="None">

                                        <Items>
                                            <dx:LayoutItem Caption="" ColSpan="1" Paddings-PaddingTop="20">
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
                                                        <dx:ASPxButton ID="btnReset" runat="server" Height="30px" Width="45px" Text="Reset" AutoPostBack="false">

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

                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>
                <dx:SplitterPane>
                    <ContentCollection>
                        <dx:SplitterContentControl ID="SplitterContentControl2" runat="server">
                            <asp:UpdatePanel ID="upAccountActivity" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">

                                <ContentTemplate>
                                    <div>

                                        <dx:ASPxGridView ID="gridMainMapping" runat="server" Width="100%" VisibleRowCount="true" AutoGenerateColumns="False" KeyFieldName="enum_key" OnRowInserting="gridMainMapping_RowInserting" OnRowUpdating="gridMainMapping_RowUpdating" OnCellEditorInitialize="gridMainMapping_CellEditorInitialize">
                                            <SettingsEditing Mode="Inline" />
                                            <Settings ShowGroupPanel="True" ShowFooter="True" ShowFilterRow="True" />
                                            <SettingsContextMenu Enabled="True" EnableFooterMenu="True" EnableGroupFooterMenu="True" EnableGroupPanelMenu="True" EnableRowMenu="True" EnableColumnMenu="True">
                                            </SettingsContextMenu>
                                            <SettingsCustomizationDialog Enabled="True" />
                                            <SettingsPager PageSize="500"></SettingsPager>
                                            <Settings VerticalScrollableHeight="550" VerticalScrollBarMode="Auto" HorizontalScrollBarMode="Auto" ShowFooter="True" ShowGroupFooter="VisibleAlways" ShowTitlePanel="true" UseFixedTableLayout="true" />

                                            <SettingsPopup>
                                                <HeaderFilter MinHeight="140px"></HeaderFilter>
                                            </SettingsPopup>
                                            <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" />
                                            <SettingsResizing ColumnResizeMode="Control" Visualization="Live" />

                                            <Columns>
                                                <dx:GridViewCommandColumn ShowEditButton="True" ShowNewButtonInHeader="True" VisibleIndex="0">
                                                </dx:GridViewCommandColumn>


                                                <dx:GridViewDataColumn FieldName="enum_key" Caption="Enum Key" VisibleIndex="1" Width="150px" Visible="False">
                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Left" Wrap="False"></CellStyle>
                                                </dx:GridViewDataColumn>
                                                <dx:GridViewDataColumn FieldName="enum_type" Caption="Enum Type" VisibleIndex="2" Width="150px" Visible="True">
                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                </dx:GridViewDataColumn>
                                                <dx:GridViewDataColumn FieldName="Enum_value" Caption="Enum Value" VisibleIndex="3" Width="150px" Visible="True">
                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                </dx:GridViewDataColumn>
                                                <dx:GridViewDataColumn FieldName="Enum_value_desc" Caption="Enum Value Desc" VisibleIndex="4" Width="150px" Visible="True">
                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                </dx:GridViewDataColumn>
                                                <dx:GridViewDataColumn FieldName="Enable_flag" Caption="Enable Flag" VisibleIndex="5" Width="150px" Visible="True">
                                                    <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                    <CellStyle CssClass="gridcellStyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                </dx:GridViewDataColumn>

                                            </Columns>




                                            <FormatConditions>
                                                <dx:GridViewFormatConditionHighlight ApplyToRow="False" Expression="[SDCashBalCCY] &lt; 0" FieldName="SDCashBalCCY">
                                                    <RowStyle BackColor="#CC0000" ForeColor="White" />
                                                </dx:GridViewFormatConditionHighlight>
                                            </FormatConditions>
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
