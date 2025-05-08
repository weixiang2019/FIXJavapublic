<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MenuAccess.aspx.cs" Inherits="ICBCFS.Admin.MenuAccess" %>

<%@ Register Assembly="DevExpress.Web.v19.1, Version=19.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">


        var all = false;
        var nextArgument = "";

        function OnGridViewSelectionChanged(s, e) {


            if (!e.isChangedOnServer) {
                var key = s.GetRowKey(e.visibleIndex);
                //alert(key)

                if (all) {
                    nextArgument = key + '|' + e.isSelected;
                    //alert(nextArgument)
                }
                else {
                    cb.PerformCallback(key + '|' + e.isSelected);
                    //alert("else")
                }

                if (e.isAllRecordsOnPage)
                    all = true;
            }
        }

        function OnCallbackComplete(s, e) {
            if (all) {
                all = false;
                s.PerformCallback(nextArgument);
            }
            // the block below for the demo only
            else {
                grid1.Refresh();
                grid2.Refresh();
            }
        }


    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <dx:ASPxCallback ID="cb" runat="server" ClientInstanceName="cb" OnCallback="cb_Callback">
                <ClientSideEvents CallbackComplete="OnCallbackComplete" />
            </dx:ASPxCallback>
        </div>
        <div>
            <asp:ScriptManager runat="server"></asp:ScriptManager>
            <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
            </asp:ScriptManagerProxy>

        </div>
        <div>
            <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Width="100%" Height="448px" EnableHierarchyRecreation="false" ShowCollapseBackwardButton="True" ShowCollapseForwardButton="True" Orientation="Vertical" Style="margin-bottom: 16px;">
                <Panes>

                    <dx:SplitterPane>
                        <ContentCollection>
                            <dx:SplitterContentControl ID="SplitterContentControl2" runat="server">
                                <asp:UpdatePanel ID="upMenuAccess" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">

                                    <ContentTemplate>
                                        <div>
                                            <dx:ASPxGridView ID="gridMainMenuAccess" runat="server" Width="100%" VisibleRowCount="true" AutoGenerateColumns="False" KeyFieldName="Menu ID;AccessType" ClientInstanceName="gridMainMenuAccess" EnableRowsCache="false" OnDataBound="gridMainMenuAccess_DataBound">
                                                <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                                                <Settings VerticalScrollableHeight="400" VerticalScrollBarMode="Auto" HorizontalScrollBarMode="Auto" ShowFooter="True" ShowGroupFooter="VisibleAlways" ShowTitlePanel="true" UseFixedTableLayout="true" />
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
                                                <SettingsText Title="<b>Menu Access</b>" />
                                                <SettingsPopup EditForm-HorizontalAlign="Center" EditForm-VerticalAlign="WindowCenter"></SettingsPopup>
                                                <SettingsResizing ColumnResizeMode="Control" Visualization="Live" />

                                                <Settings ShowFilterRow="true" ShowFilterBar="Auto" />
                                                <SettingsBehavior AllowGroup="false" AllowDragDrop="false" ProcessSelectionChangedOnServer="false" />
                                                <ClientSideEvents SelectionChanged="OnGridViewSelectionChanged" />

                                                <Columns>


                                                    <dx:GridViewDataTextColumn FieldName="Parent Menu" Caption="Parent Menu" VisibleIndex="1" Width="150px" Visible="True">
                                                        <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                        <CellStyle CssClass="gridcellStyle" HorizontalAlign="Left" Wrap="False"></CellStyle>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="Menu" Caption="Menu" VisibleIndex="2" Width="230px" Visible="True">
                                                        <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                        <CellStyle CssClass="gridcellStyle" HorizontalAlign="Left" Wrap="False"></CellStyle>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="Menu ID" Caption="Menu ID" VisibleIndex="3" Width="150px" Visible="False">
                                                        <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                        <CellStyle CssClass="gridcellStyle" HorizontalAlign="Left" Wrap="False"></CellStyle>
                                                    </dx:GridViewDataTextColumn>
                                                    <dx:GridViewDataTextColumn FieldName="AccessType" Caption="Access Type" VisibleIndex="4" Width="130px" Visible="False">
                                                        <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                        <CellStyle CssClass="gridcellStyle" HorizontalAlign="Left" Wrap="False"></CellStyle>
                                                    </dx:GridViewDataTextColumn>




                                                    <dx:GridViewCommandColumn ShowSelectCheckbox="True" ShowClearFilterButton="true" SelectAllCheckboxMode="Page" VisibleIndex="5" Width="80px" />





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



                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </dx:SplitterContentControl>
                        </ContentCollection>
                    </dx:SplitterPane>
                </Panes>
            </dx:ASPxSplitter>
        </div>
    </form>
</body>
</html>


