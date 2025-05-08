<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccountAccess.aspx.cs" Inherits="ICBCFS.Admin.AccountAccess" %>

<%@ Register Assembly="DevExpress.Web.v19.1, Version=19.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">

        var normalurl = '../Content/Images/forward.png',
            selectedurl = '../Content/Images/backward.png';
        function OnClick(s, e) {

            var el = s.GetMainElement();



            return false;
        }


        function OnGridFocusedRowChanged(s, e) {
            gridAccountDetailAccountAccess.PerformCallback(gridMainAccountAccess.GetFocusedRowIndex());
        }

        var all = false;
        var nextArgument = "";

        function OnGridViewSelectionChanged(s, e) {

            e.cancel = true;
            if (!e.isChangedOnServer) {
                var key = s.GetRowKey(e.visibleIndex);
                if (all) {
                    nextArgument = key + '|' + e.isSelected;
                }
                else {
                    cb.PerformCallback(key + '|' + e.isSelected + '|' + e.visibleIndex);
                }

                if (e.isAllRecordsOnPage)
                    all = true;
            }
        }

        function onStratEditing(s, e) {
            s.batchEditApi.StartEdit(e.visibleIndex, e.focusedColumn.index);
        }

        function OnBatchEditEndEditing(s, e) {
            setTimeout(function () {
                if (s.batchEditApi.HasChanges()) {

                    s.UpdateEdit();
                }
            }, 0);

        }

        function onBatchEditEndEdit(s, e) {
            var cellInfo = s.batchEditApi.GetEditCellInfo();
            setTimeout(function () {
                if (s.batchEditApi.HasChanges(cellInfo.rowVisibleIndex, cellInfo.column.index))
                    UpdateEdit(createObject(s, s.GetRowKey(e.visibleIndex), e.rowValues), cellInfo);
            }, 0);
        }

        function OnCallbackComplete(s, e) {
            if (all) {
                all = false;
                s.PerformCallback(nextArgument);
            }
            // the block below for the demo only
            else {
                //grid1.Refresh();
                gridAccountDetailAccountAccess.Refresh();
            }
        }

        var filterCondition = "";

        function hasAccess() {
            //var filterCondition = ""; // the block comment might require.
            if (chkHasAccess.GetChecked() == true) {
                filterCondition = "[HasAccess] = " + 1;
                //gridAccountDetailAccountAccess.ApplyFilter(filterCondition);
            }
            else {
                filterCondition = "[HasAccess] = " + 0;
                //gridAccountDetailAccountAccess.ApplyFilter(filterCondition);
            }
            gridAccountDetailAccountAccess.ApplyFilter(filterCondition);
        }

        function removeFilterCondition() {

            if (chkAll.GetChecked() == true) {
                //filterCondition = "[HasAccess] = " + 1;
                //gridAccountDetailAccountAccess.ApplyFilter(filterCondition);
                gridAccountDetailAccountAccess.ClearFilter();
            }
            else {
                filterCondition = "[HasAccess] = " + 0;
                //gridAccountDetailAccountAccess.ApplyFilter(filterCondition);
                gridAccountDetailAccountAccess.ApplyFilter(filterCondition);
            }

        }

        function OnCBLSelectedIndexChanged(s, e) {
            s.UnselectAll();
            if (e.isSelected) {
                s.SetSelectedIndex(e.index);

                if (e.index == 1) {
                    filterCondition = "[HasAccess] = " + 1;
                    gridAccountDetailAccountAccess.ApplyFilter(filterCondition);
                }
                else if (e.index == 2) {
                    filterCondition = "[HasAccess] = " + 0;
                    gridAccountDetailAccountAccess.ApplyFilter(filterCondition);
                }
                else {
                    gridAccountDetailAccountAccess.ClearFilter();
                }
                //gridAccountDetailAccountAccess.ApplyFilter(filterCondition);

            }
            else {
                s.UnselectIndices(e.index);
            }
        }

        function OnCBLInit(s, e) {
            s.SetSelectedIndex(0);
            gridAccountDetailAccountAccess.ClearFilter();
        }
    </script>
    <style>
        .MyClass {
            background: none;
        }

        .treeList {
            width: 215px;
        }

        .reportColumnHeader {
            width: 100px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <dx:ASPxCallback ID="ASPxCallback2" runat="server" ClientInstanceName="Callback">
                <ClientSideEvents CallbackComplete="function(s, e) { LoadingPanel.Hide(); }" />
            </dx:ASPxCallback>

            <dx:ASPxCallback ID="cb" runat="server" ClientInstanceName="cb" OnCallback="cb_Callback">
                <ClientSideEvents CallbackComplete="function(s,e) {  gridAccountDetailAccountAccess.Refresh();}" />
            </dx:ASPxCallback>
            <div>
                <asp:ScriptManager runat="server"></asp:ScriptManager>
                <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
                </asp:ScriptManagerProxy>
            </div>
            <div>
                <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Width="100%" Height="610px" EnableHierarchyRecreation="false" ShowCollapseBackwardButton="True" ShowCollapseForwardButton="True" Orientation="Vertical" Style="margin-bottom: 16px; margin-right: 0px; padding-right: 0px">
                    <Panes>
                        <dx:SplitterPane Size="17%" PaneStyle-Paddings-Padding="0">
                            <ContentCollection>
                                <dx:SplitterContentControl ID="SplitterContentControl1" runat="server">
                                    <div>
                                        <dx:ASPxFormLayout ID="ASPxFormLayout1" runat="server" ColCount="8" ColumnCount="8">
                                            <Items>

                                                <dx:LayoutGroup Caption="Access" ColSpan="1" ColCount="3" ColumnCount="3" ColumnSpan="1" Paddings-Padding="0">
                                                    <Items>

                                                        <dx:LayoutItem Caption=" " ColSpan="1">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxCheckBoxList ID="cblOptionType" runat="server" ValueType="System.String" ValueField="ID" TextField="Name" RepeatLayout="Flow" RepeatDirection="Horizontal" ClientInstanceName="cblOptionType" Width="320px">
                                                                        <ClientSideEvents SelectedIndexChanged="OnCBLSelectedIndexChanged" Init="OnCBLInit" />
                                                                        <%-- keep it for sometime it was creating issue with the theme   <CheckedImage SpriteProperties-CssClass="dxEditors_edtRadioButtonChecked_DevEx"></CheckedImage>
                                                                <UncheckedImage SpriteProperties-CssClass="dxEditors_edtRadioButtonUnchecked_DevEx"></UncheckedImage>--%>
                                                                        <Items>
                                                                            <dx:ListEditItem Text="All" />
                                                                            <dx:ListEditItem Text="Has Access" />
                                                                            <dx:ListEditItem Text="Doesn't Have Access" />
                                                                        </Items>
                                                                    </dx:ASPxCheckBoxList>

                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                            <CaptionSettings Location="Top" />
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
                                    <asp:UpdatePanel ID="upAccountAccess" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
                                        <ContentTemplate>
                                            <div>

                                                <dx:ASPxFormLayout ID="ASPxFormLayout3" runat="server" ColCount="2" ColumnCount="2" Paddings-Padding="0">

                                                    <Items>
                                                        <dx:LayoutItem ColSpan="1" Caption="" VerticalAlign="Top" HorizontalAlign="Left" Paddings-Padding="0">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">

                                                                    <dx:ASPxGridView ID="gridMainAccountAccess" runat="server" AutoGenerateColumns="False" ClientInstanceName="gridMainAccountAccess" KeyFieldName="Branch" Style="margin: -10px 0 0px -10px;"  EnableRowsCache="false" >
                                                                        <Settings ShowFilterRow="True" ShowTitlePanel="true" UseFixedTableLayout="true" />
                                                                        <ClientSideEvents FocusedRowChanged="OnGridFocusedRowChanged" />
                                                                        <SettingsPager PageSize="500"></SettingsPager>
                                                                        <Settings VerticalScrollableHeight="380" VerticalScrollBarMode="Auto" ShowFooter="True" ShowGroupFooter="VisibleAlways" />
                                                                        <SettingsBehavior AllowSelectSingleRowOnly="true" AllowSelectByRowClick="true" AllowFocusedRow="true" />
                                                                        <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />
                                                                        <SettingsPopup>
                                                                            <HeaderFilter MinHeight="140px"></HeaderFilter>
                                                                        </SettingsPopup>
                                                                        <SettingsResizing ColumnResizeMode="Control" Visualization="Live" />
                                                                        <Columns>
                                                                            <dx:GridViewDataTextColumn FieldName="Branch" Caption="Branch" VisibleIndex="0" Visible="True" Width="80px">
                                                                                <CellStyle CssClass="gridcellstyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                                            </dx:GridViewDataTextColumn>
                                                                        </Columns>
                                                                        <Styles>
                                                                            <Header Font-Bold="True" Font-Names="Arial" Font-Size="Small" ForeColor="Black" HorizontalAlign="Center">
                                                                            </Header>
                                                                            <AlternatingRow Enabled="True"></AlternatingRow>
                                                                            <TitlePanel Font-Bold="True" Font-Names="Arial" Font-Size="Large" ForeColor="Black" HorizontalAlign="Center"></TitlePanel>
                                                                        </Styles>
                                                                    </dx:ASPxGridView>

                                                                    <dx:ASPxHiddenField ID="ASPxHiddenField1" runat="server" ClientInstanceName="hf">
                                                                    </dx:ASPxHiddenField>

                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                            <CaptionSettings Location="Top" />
                                                            <Paddings Padding="0px" />
                                                        </dx:LayoutItem>

                                                        <dx:LayoutItem ColSpan="1" Caption="" VerticalAlign="Top" HorizontalAlign="Right" Paddings-Padding="0">
                                                            <LayoutItemNestedControlCollection>
                                                                <dx:LayoutItemNestedControlContainer runat="server">
                                                                    <dx:ASPxGridView ID="gridAccountDetailAccountAccess" runat="server" Width="100%" AutoGenerateColumns="False" KeyFieldName="Branch;AccountNo;HasAccess" Style="margin: -10px 0 0 -10px;" ClientInstanceName="gridAccountDetailAccountAccess" OnCustomCallback="gridAccountDetailAccountAccess_CustomCallback" EnableRowsCache="False" VisibleRowCount="true" OnDataBound="gridAccountDetailAccountAccess_DataBound"  OnRowUpdating="gridAccountDetailAccountAccess_RowUpdating">
                                                                        <Settings ShowGroupPanel="False" ShowFooter="True" ShowFilterRow="True" ShowTitlePanel="true" UseFixedTableLayout="true" ShowStatusBar="Hidden" />
                                                                        <SettingsContextMenu Enabled="True" EnableFooterMenu="True" EnableGroupFooterMenu="True" EnableGroupPanelMenu="True" EnableRowMenu="True" EnableColumnMenu="True"></SettingsContextMenu>
                                                                        <SettingsCustomizationDialog Enabled="True" />
                                                                        <SettingsPager PageSize="500"></SettingsPager>
                                                                        <Settings VerticalScrollableHeight="380" VerticalScrollBarMode="Auto" ShowFooter="True" ShowGroupFooter="VisibleAlways" />
                                                                        <SettingsDataSecurity AllowDelete="False" AllowEdit="true" AllowInsert="False" />
                                                                        <SettingsPopup>
                                                                            <HeaderFilter MinHeight="140px"></HeaderFilter>
                                                                        </SettingsPopup>
                                                                        <SettingsResizing ColumnResizeMode="Control" Visualization="Live" />
                                                                        <SettingsEditing Mode="Batch">
                                                                            <BatchEditSettings ShowConfirmOnLosingChanges="true" EditMode="Cell" />
                                                                        </SettingsEditing>
                                                                        <SettingsBehavior AllowGroup="false" AllowDragDrop="false" ProcessSelectionChangedOnServer="false" />

                                                                        <ClientSideEvents SelectionChanged="OnGridViewSelectionChanged" BatchEditEndEditing="OnBatchEditEndEditing" />

                                                                        <Columns>
                                                                            <dx:GridViewCommandColumn ShowSelectCheckbox="True" ShowClearFilterButton="true" VisibleIndex="0" Width="80px" />

                                                                            <dx:GridViewDataTextColumn FieldName="Branch" Caption="Branch" VisibleIndex="1" Visible="False">
                                                                                <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                                                <CellStyle CssClass="gridcellstyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataComboBoxColumn FieldName="ReadWriteAccess" Caption="Read / Write" VisibleIndex="2" Width="100px">


                                                                                <HeaderStyle CssClass="gridcolheader" HorizontalAlign="Center" />
                                                                                <CellStyle CssClass="gridcellstyle" HorizontalAlign="Center" Wrap="False"></CellStyle>

                                                                            </dx:GridViewDataComboBoxColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="AccountNo" Caption="Account No" VisibleIndex="2" Width="100px" Visible="True">
                                                                                <Settings AllowEllipsisInText="True" />
                                                                                <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                                                <CellStyle CssClass="gridcellstyle" HorizontalAlign="Left" Wrap="False"></CellStyle>
                                                                            </dx:GridViewDataTextColumn>
                                                                            <dx:GridViewDataTextColumn FieldName="HasAccess" Caption="Has Access" VisibleIndex="3" Width="100px" Visible="True">
                                                                                <HeaderStyle CssClass="gridcolheader" HorizontalAlign=" Center" />
                                                                                <CellStyle CssClass="gridcellstyle" HorizontalAlign="Center" Wrap="False"></CellStyle>
                                                                            </dx:GridViewDataTextColumn>

                                                                        </Columns>

                                                                        <Styles>

                                                                            <Header Font-Bold="True" Font-Names="Arial" Font-Size="Small" ForeColor="Black" HorizontalAlign="Center">
                                                                            </Header>
                                                                            <AlternatingRow Enabled="True"></AlternatingRow>
                                                                            <TitlePanel Font-Bold="True" Font-Names="Arial" Font-Size="Large" ForeColor="Black" HorizontalAlign="Center"></TitlePanel>
                                                                        </Styles>
                                                                    </dx:ASPxGridView>

                                                                </dx:LayoutItemNestedControlContainer>
                                                            </LayoutItemNestedControlCollection>
                                                            <CaptionSettings Location="Top" />
                                                            <Paddings Padding="0px" />
                                                        </dx:LayoutItem>


                                                    </Items>
                                                    <Paddings Padding="0px" />
                                                </dx:ASPxFormLayout>


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
        </div>
    </form>
</body>
</html>




