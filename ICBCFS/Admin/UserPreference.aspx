<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UserPreference.aspx.cs" Inherits="ICBCFS.Admin.UserPreference" %>

<%@ Register Assembly="DevExpress.Web.v19.1, Version=19.1.5.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>



<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent1" runat="server">
    
    <div>
    </div>

    <div>
        <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        </asp:ScriptManagerProxy>
    </div>


    <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Width="100%" Height="900px" EnableHierarchyRecreation="false" ShowCollapseBackwardButton="True" ShowCollapseForwardButton="True" Orientation="Vertical" Style="margin-bottom: 16px;">
        <Panes>
            <dx:SplitterPane ScrollBars="Auto">
                <ContentCollection>
                    <dx:SplitterContentControl ID="SplitterContentControl2" runat="server">
                        <asp:UpdatePanel ID="upUserPreference" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
                            <ContentTemplate>
                                <div>
                                    <dx:ASPxFormLayout ID="ScUserPreference" runat="server" ColCount="4" ColumnCount="4" EncodeHtml="False" ShowItemCaptionColon="False">
                                        <SettingsItemCaptions Location="Top" />
                                        <Items>
                                            <dx:LayoutGroup Caption="User Preference" ColSpan="3" ColCount="3" ColumnCount="3" ColumnSpan="3" VerticalAlign="Top">
                                                <Items>
                                                    <dx:LayoutItem FieldName="UserName" Caption="User Name" ColSpan="1" Height="50px" Paddings-PaddingLeft="30px">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer6" runat="server">
                                                                <dx:ASPxLabel ID="lblUserName" runat="server" Width="150px" ClientInstanceName="lblUserName"></dx:ASPxLabel>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                        <CaptionSettings VerticalAlign="Middle" />
                                                        <Paddings PaddingLeft="30px" />
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem FieldName="Phone_Number" Caption="Phone Number" ColSpan="1" Height="50px" Paddings-PaddingLeft="30px">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer30" runat="server">
                                                                <dx:ASPxTextBox ID="txtPhoneNumber" runat="server" Width="150px" MaxLength="30" ClientInstanceName="txtPhoneNumber">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                        <CaptionSettings VerticalAlign="Middle" />
                                                        <Paddings PaddingLeft="30px" />
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem FieldName="Email_Address" Caption="Email" ColSpan="1" Height="50px" Paddings-PaddingLeft="30px">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer27" runat="server">
                                                                <dx:ASPxTextBox ID="txtEmailAddress" runat="server" Width="200px" MaxLength="30" ClientInstanceName="EmailAddress">
                                                                </dx:ASPxTextBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                        <CaptionSettings VerticalAlign="Middle" />
                                                        <Paddings PaddingLeft="30px" />
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem FieldName="IsEnabled" Caption="IsEnabled" ColSpan="1" Height="50px" Width="50px" Paddings-PaddingLeft="30px">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer10" runat="server">
                                                                <dx:ASPxCheckBox ID="chkIsEnabled" runat="server" Height="25px" ClientInstanceName="chkIsEnabled">
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                        <CaptionSettings VerticalAlign="Middle" Location="Right" />
                                                        <Paddings PaddingLeft="30px" />
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem FieldName="Notification_TradeReject" Caption="Trade Reject Notification" ColSpan="1" Height="50px" Width="75px" Paddings-PaddingLeft="30px">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer11" runat="server">
                                                                <dx:ASPxCheckBox ID="chkTradeRejectNotification" runat="server" Height="25px" Font-Size="14px" ClientInstanceName="chkTradeRejectNotification">
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                        <CaptionSettings VerticalAlign="Middle" Location="Right" />
                                                        <Paddings PaddingLeft="30px" />
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem FieldName="Notification_UserAccssChange" Caption="UserAccss Change Notification" ColSpan="1" Height="50px" Width="75px" Paddings-PaddingLeft="30px">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer16" runat="server">
                                                                <dx:ASPxCheckBox ID="chkUserAccssChange" runat="server" Height="25px" Font-Size="14px" ClientInstanceName="chkUserAccssChange">
                                                                </dx:ASPxCheckBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                        <CaptionSettings VerticalAlign="Middle" Location="Right" />
                                                        <Paddings PaddingLeft="30px" />
                                                    </dx:LayoutItem>


                                                    <dx:LayoutItem FieldName="Default_Skin" Caption="Skin" ColSpan="1" Height="50px" Paddings-PaddingLeft="30px" VerticalAlign="Top">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer1" runat="server">
                                                                <dx:ASPxComboBox ID="cmbSkins" runat="server" AutoPostBack="false">
                                                                    <ClientSideEvents ValueChanged="function(s, e) { ASPxClientUtils.SetCookie('theme', s.GetText()); }" />
                                                                </dx:ASPxComboBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                        <CaptionSettings VerticalAlign="Top" />
                                                        <Paddings PaddingLeft="30px" />
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem FieldName="EntityCodeList" Caption="EntityCode" ColSpan="1" Height="50px" Paddings-PaddingLeft="30px">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer3" runat="server">
                                                                <dx:ASPxListBox ID="lbEntityCodeList" runat="server" SelectionMode="CheckColumn" EnableSelectAll="true" Width="300px">
                                                                    <CaptionSettings Position="Top" />
                                                                </dx:ASPxListBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                        <CaptionSettings VerticalAlign="Middle" />
                                                        <Paddings PaddingLeft="30px" />
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="" ColSpan="1" Height="50px" Paddings-PaddingLeft="30px" VerticalAlign="Bottom" HorizontalAlign="Right">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer28" runat="server">
                                                                <dx:ASPxButton ID="btnUpdate" runat="server" Height="30px" Width="150px" Text="Update" OnClick="btnUpdate_Click" AutoPostBack="true">
                                                                </dx:ASPxButton>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>

                                            

                                            <dx:LayoutGroup Caption="Screen" ColSpan="3" ColCount="3" ColumnCount="3" ColumnSpan="3" VerticalAlign="Top">
                                                <Items>
                                                    <dx:LayoutItem FieldName="Menu" Caption="Screen" ColSpan="1" Height="50px" Paddings-PaddingLeft="30px" VerticalAlign="Top">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer9" runat="server">
                                                                <dx:ASPxComboBox ID="cmbScreens" runat="server" ClientInstanceName="cmbScreens" OnSelectedIndexChanged="cmbScreens_SelectedIndexChanged" AutoPostBack="true">
                                                                </dx:ASPxComboBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                        <CaptionSettings VerticalAlign="Top" />
                                                        <Paddings PaddingLeft="30px" />
                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem FieldName="LayoutName" Caption="Layout" ColSpan="1" Height="50px" Paddings-PaddingLeft="0px">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer2" runat="server">
                                                                <dx:ASPxListBox ID="lstLayout" runat="server" Width="300px">
                                                                    <CaptionSettings Position="Top" />
                                                                </dx:ASPxListBox>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                        <CaptionSettings VerticalAlign="Middle" />

                                                    </dx:LayoutItem>

                                                    <dx:LayoutItem Caption="" ColSpan="1" Height="50px" Paddings-PaddingLeft="30px" VerticalAlign="Bottom" HorizontalAlign="Right">
                                                        <LayoutItemNestedControlCollection>
                                                            <dx:LayoutItemNestedControlContainer ID="LayoutItemNestedControlContainer12" runat="server">
                                                                <dx:ASPxButton ID="btnUpdate2" runat="server" Height="30px" Width="150px" Text="Update" OnClick="btnUpdate2_Click" AutoPostBack="true">
                                                                </dx:ASPxButton>
                                                            </dx:LayoutItemNestedControlContainer>
                                                        </LayoutItemNestedControlCollection>
                                                    </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>


                                        </Items>
                                    </dx:ASPxFormLayout>
                                </div>

                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>
        </Panes>
    </dx:ASPxSplitter>



</asp:Content>
