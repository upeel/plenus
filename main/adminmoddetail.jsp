<%-- 
    Document   : adminmoddetail
    Created on : Jul 4, 2014, 11:43:26 AM
    Author     : SOE HTIKE
--%>

<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ page import = "java.util.*"
         import = "java.lang.*"
         import = "com.bizmann.product.controller.*"
         import = "com.bizmann.product.entity.*"
         import = "com.bizmann.product.resources.*"
         import = "com.bizmann.diy.admin.controller.AdminModController"
         import = "com.bizmann.diy.admin.entity.*" 
         import = "com.bizmann.flowchart.controller.ConsolidationController"
         import = "com.bizmann.flowchart.entity.ConsolidationDetail" 
         import = "com.bizmann.poi.entity.Field" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="helper/sessioncheck.jsp" %>
<%
    /*
     * 1. general 
    2. text area
    3. date
    4. email
    5. combo box
    6. check box
    7. radio button
     * */
    int userId = 0;
    if (ssid == null || ssid.equals("")) {
    } else {
        UserController userCtrl = new UserController();
        userId = userCtrl.getUserIdByLoginId(ssid);
    }
    String parentId = request.getParameter("parentId");

    if (parentId == null) {
        parentId = "0";
    }
    parentId = parentId.trim();
    if (parentId.equalsIgnoreCase("")) {
        parentId = "0";
    }

    int intParentId = Integer.parseInt(parentId);

    AdminModController adminModCtrl = new AdminModController();
    AdminHeader adminHeader = adminModCtrl.getTableDetailsByHeaderId(intParentId);
    ArrayList<AdminDetail> detailList = new ArrayList<AdminDetail>();

    if (adminHeader.getId() > 0) {
        detailList = adminHeader.getDetailList();
        
        if(detailList == null){
            detailList = new ArrayList<AdminDetail>();
        }
    }

    //System.out.println("detailList.size() : " + detailList.size());
    //System.out.println("adminHeader.getId() : " + adminHeader.getId());
    int noOfAction = 1;
    if (detailList.size() > 0) {
        noOfAction = detailList.size();
    }

    String deleteRowIndex = request.getParameter("deleteRow");
    if (deleteRowIndex == null) {
        deleteRowIndex = "";
    }

    String action = request.getParameter("todoaction");
    if (action == null) {
        action = "";
    }

    String strnoOfAction = request.getParameter("noOfAction");
    if (strnoOfAction != null) {
        noOfAction = Integer.parseInt(strnoOfAction);
    }

    String[] txtDetailId = new String[noOfAction];
    String[] txtDetailName = new String[noOfAction];
    String[] txtDetailType = new String[noOfAction];
    String[] txtEditable = new String[noOfAction];
    String[] txtListable = new String[noOfAction];
    String[] txtMandatory = new String[noOfAction];
    String[] txtValues = new String[noOfAction];

    int tempIndex = 0;
    for (int i = 0; i < noOfAction; i++) {
        AdminDetail adDetail = new AdminDetail();
        if (detailList.size() > i) {
            adDetail = detailList.get(i);
        }

        String strDetailId = request.getParameter("txtDetailId" + i);
        txtDetailId[tempIndex] = strDetailId;
        if (txtDetailId[tempIndex] == null) {
            if (adDetail.getId() == 0) {
                txtDetailId[tempIndex] = "0";
            } else {
                txtDetailId[tempIndex] = Integer.toString(adDetail.getId());
            }
        }

        String strDetailName = request.getParameter("txtDetailName" + i);
        txtDetailName[tempIndex] = strDetailName;
        if (txtDetailName[tempIndex] == null) {
            if (adDetail.getName() == null) {
                txtDetailName[tempIndex] = "";
            } else {
                txtDetailName[tempIndex] = adDetail.getName();
            }
        }

        String strDetailType = request.getParameter("txtDetailType" + i);
        txtDetailType[tempIndex] = strDetailType;
        if (txtDetailType[tempIndex] == null) {
            if (adDetail.getType() == 0) {
                txtDetailType[tempIndex] = "0";
            } else {
                txtDetailType[tempIndex] = Integer.toString(adDetail.getType());
            }
        }

        String strEditable = request.getParameter("txtEditable" + i);
        txtEditable[tempIndex] = strEditable;
        if (txtEditable[tempIndex] == null) {
            if (adDetail.isEditable() == false) {
                txtEditable[tempIndex] = "false";
            } else {
                txtEditable[tempIndex] = Boolean.toString(adDetail.isEditable());
            }
        }

        String strListable = request.getParameter("txtListable" + i);
        txtListable[tempIndex] = strListable;
        if (txtListable[tempIndex] == null) {
            if (adDetail.isListable() == false) {
                txtListable[tempIndex] = "false";
            } else {
                txtListable[tempIndex] = Boolean.toString(adDetail.isListable());
            }
        }

        String strMandatory = request.getParameter("txtMandatory" + i);
        txtMandatory[tempIndex] = strMandatory;
        if (txtMandatory[tempIndex] == null) {
            if (adDetail.isMandatory() == false) {
                txtMandatory[tempIndex] = "false";
            } else {
                txtMandatory[tempIndex] = Boolean.toString(adDetail.isMandatory());
            }
        }

        String strValues = request.getParameter("txtValues" + i);
        txtValues[tempIndex] = strValues;
        if (txtValues[tempIndex] == null) {
            ArrayList<AdminDetailValue> tmpAdValueList = new ArrayList<AdminDetailValue>();
            if (adDetail.getId() > 0) {
                tmpAdValueList = adDetail.getValueList();
            }
            if (tmpAdValueList.size() <= 0) {
                txtValues[tempIndex] = "";
            } else {
                StringBuffer tmpSbf = new StringBuffer();
                for (int a = 0; a < tmpAdValueList.size(); a++) {
                    AdminDetailValue adValue = tmpAdValueList.get(a);
                    String tmpValue = adValue.getValue();
                    tmpSbf.append(tmpValue);
                    tmpSbf.append(",");
                }
                String tmpValueList = tmpSbf.toString();
                if (tmpValueList.length() > 0) {
                    tmpValueList = tmpValueList.substring(0, tmpValueList.length() - 1);
                }
                txtValues[tempIndex] = tmpValueList;
            }
        }

        if (!deleteRowIndex.equals(Integer.toString(i))) { //if deleteRowIndex != current index
            tempIndex++;
        }
    }

    if (!deleteRowIndex.equals("")) {
        noOfAction -= 1;
    }
    //System.out.println("action : " + action);
    if (action.equalsIgnoreCase("update")) {
        //System.out.println(action);
        ArrayList<AdminDetail> toInsertList = new ArrayList<AdminDetail>();
        for (int i = 0; i < noOfAction; i++) {
            AdminDetail adDetailToInsert = new AdminDetail();
            //System.out.println(txtDetailName[i]);
            if (txtDetailName[i] != null && !txtDetailName[i].equals("")) {
                //System.out.println(txtDetailName[i]);
                adDetailToInsert.setName(txtDetailName[i]);
                adDetailToInsert.setType(Integer.parseInt(txtDetailType[i]));
                adDetailToInsert.setEditable(Boolean.parseBoolean(txtEditable[i]));
                adDetailToInsert.setListable(Boolean.parseBoolean(txtListable[i]));
                adDetailToInsert.setMandatory(Boolean.parseBoolean(txtMandatory[i]));
                adDetailToInsert.setCreated_by(userId);
                adDetailToInsert.setModified_by(userId);

                String txtValuesToInsert = txtValues[i];
                String[] arrValuesToInsert = txtValuesToInsert.split(",");
                ArrayList<AdminDetailValue> adValueListToInsert = new ArrayList<AdminDetailValue>();
                for (int a = 0; a < arrValuesToInsert.length; a++) {
                    if (arrValuesToInsert[a] != null && !arrValuesToInsert[a].equals("")) {
                        AdminDetailValue adValueToInsert = new AdminDetailValue();
                        adValueToInsert.setHeader_id(intParentId);
                        adValueToInsert.setValue(arrValuesToInsert[a]);
                        adValueListToInsert.add(adValueToInsert);
                    }
                }
                adDetailToInsert.setValueList(adValueListToInsert);

                toInsertList.add(adDetailToInsert);
            }
        }
        adminModCtrl.insertAdminDetailList(intParentId, toInsertList);
        response.sendRedirect("adminmoddetail.jsp?parentId=" + intParentId + "&todoaction=success");
    } else if (action.equalsIgnoreCase("activate")) {
        adminModCtrl.setupActivation(intParentId, userId);
        response.sendRedirect("adminmoddetail.jsp?parentId=" + intParentId + "&todoaction=success");
    } else if (action.equalsIgnoreCase("deactivate")) {
        adminModCtrl.setupDeactivation(intParentId, userId);
        response.sendRedirect("adminmoddetail.jsp?parentId=" + intParentId + "&todoaction=success");
    }
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" href="../include/css/loading.css" type="text/css" />
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <!--        <link rel="stylesheet" type="text/css" href="../include/css/layout.css" />-->
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/menu/assets/skins/sam/menu.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/button/assets/skins/sam/button.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/container/assets/skins/sam/container.css" />
        <script type="text/javascript" src="../include/js/url.js"></script>
        <script type="text/javascript" src="../include/js/jquery-1.10.2.js"></script>
        <title>bmFLO</title>
        <style>
            .selected{
                background:#ACD6F5;
                border:1px solid grey;
            }
        </style>
        <script>
            var action = "<%=request.getParameter("action")%>";
            var type = "<%=request.getParameter("type")%>";
            var subtype = "<%=request.getParameter("subtype")%>";
            
            function hideDivs(){
                document.getElementById('dvLoading').style.visibility = 'hidden';
                document.getElementById('overlay').style.visibility = 'hidden';
                //                $('#dvLoading').hide();
                //                $('#overlay').hide();
            }
            
            function showDivs(){
                document.getElementById('dvLoading').style.visibility = 'visible';
                document.getElementById('overlay').style.visibility = 'visible';
                //                $('#dvLoading').show();
                //                $('#overlay').show();
            }
            
            function fnAddCashIn(){
                var noOfCashIn = parseInt(document.getElementById("noOfAction").value);
                document.getElementById("noOfAction").value = noOfCashIn + 1;
               
                document.frmAdminModDetail.method = "POST";
                document.frmAdminModDetail.action = "adminmoddetail.jsp?todoaction=edit";
                document.frmAdminModDetail.submit();
            }
        
            function fnRemoveCashIn(){
                var selectedIndex = document.getElementById("selectedRow").value;
                document.frmAdminModDetail.method = "post";
                document.frmAdminModDetail.action = "adminmoddetail.jsp?todoaction=edit&deleteRow="+selectedIndex;
                document.frmAdminModDetail.submit();
            }
            
            function fnSelectRow(index){
                fnUnSelectRow();
                document.getElementById("rowDetailName"+index).className ="selected";
                document.getElementById("rowDetailType"+index).className ="selected";
                document.getElementById("rowEditable"+index).className ="selected";
                document.getElementById("rowListable"+index).className ="selected";
                document.getElementById("rowMandatory"+index).className ="selected";
                document.getElementById("rowValues"+index).className ="selected";
                document.getElementById("selectedRow").value=index;
            }
            
            function fnUnSelectRow(){
                for(var i=0;document.getElementById("rowDetailName"+i) != null; i++){
                    document.getElementById("rowDetailName"+i).className ="cellcontent";
                    document.getElementById("rowDetailType"+i).className ="cellcontent";
                    document.getElementById("rowEditable"+i).className ="cellcontent";
                    document.getElementById("rowListable"+i).className ="cellcontent";
                    document.getElementById("rowMandatory"+i).className ="cellcontent";
                    document.getElementById("rowValues"+i).className ="cellcontent";
                }
            }
            
            function fnBtnUpdateClicked(){
                document.frmAdminModDetail.method = "post";
                document.frmAdminModDetail.action = "adminmoddetail.jsp?todoaction=update";
                document.frmAdminModDetail.submit();
            }
            
            function fnActivate(){
                document.frmAdminModDetail.method = "post";
                document.frmAdminModDetail.action = "adminmoddetail.jsp?todoaction=activate";
                document.frmAdminModDetail.submit();
            }
            
            function fnDeactivate(){
                document.frmAdminModDetail.method = "post";
                document.frmAdminModDetail.action = "adminmoddetail.jsp?todoaction=deactivate";
                document.frmAdminModDetail.submit();
            }
        </script>
    </head>
    <body onload="hideDivs()" onbeforeunload="showDivs();" background="../images/background.png" style="width:650px">
        <div id="dvLoading"></div>
        <div id="overlay" class="web_dialog_overlay"></div>
        <%
            if (parentId.equals("") || parentId.equals("0")) {%>
        <!-- Leave it blank -->
        <%} else {
        %>
        <form id="frmAdminModDetail" name="frmAdminModDetail" action="adminmoddetail.jsp" method="POST" >
            <div align="center" valign="top">
                <table>
                    <tr>
                        <td class="orgtable" valign="top" align="center">
                            <br>
                            <table cellpadding="0">
                                <tr>
                                    <td colspan="2">
                                        <div class="psadtitle">
                                            <br>Admin Task Details For <%=adminHeader.getName()%><br>
                                            <%if (action.equals("success")) {
                                            %>
                                            <label style="color:red">The Admin Task Details are updated!</label>
                                            <%}%>
                                            <br>
                                            <input type="hidden" id="parentId" name="parentId" value="<%=parentId%>">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2"><hr/>
                                    </td>
                                </tr>
                                <tr>
                                    <td width=150 align="right">&nbsp;</td>
                                    <td width=350 align="left">&nbsp;</td>
                                </tr>
                                <!--                            //insert here-->
                                <tr>
                                    <td colspan="2">
                                        <table>
                                            <tr>
                                                <td>
                                                    <table border="1" cellpadding="2px" style="text-align:left;font:80% arial,helvetica,clean,sans-serif;border-collapse:collapse;" width="95%">
                                                        <%if (!adminHeader.isActivated()) {%>
                                                        <tr>
                                                            <td colspan="6">
                                                                <a href="#" onclick="fnAddCashIn()">[add]</a>
                                                                <a href="#" onclick="fnRemoveCashIn()">[delete]</a>
                                                                <input type="hidden" id="noOfAction" name="noOfAction" value="<%=noOfAction%>">
                                                                <input type="hidden" id="selectedRow" name="selectedRow" value=""/>
                                                            </td>
                                                        </tr>
                                                        <tr style="background-color:#cccccc">
                                                            <td><b>Names</b></td>
                                                            <td><b>Type</b></td>
                                                            <td><b>Editable</b></td>
                                                            <td><b>Listable</b></td>
                                                            <td><b>Mandatory</b></td>
                                                            <td><b>Values</b></td>
                                                        </tr>
                                                        <%
                                                            for (int i = 0; i < noOfAction; i++) {
                                                        %>
                                                        <tr onclick="fnSelectRow(<%=i%>)" style="background-color:white">
                                                            <td class="cellcontent" id="rowDetailName<%=i%>">
                                                                <input type="text" id="txtDetailName<%=i%>" name="txtDetailName<%=i%>" value="<%=txtDetailName[i]%>"/>
                                                                <input type="hidden" id="txtDetailId<%=i%>" name="txtDetailId<%=i%>" value="<%=txtDetailId[i]%>"/>
                                                            </td>
                                                            <td class="cellcontent" id="rowDetailType<%=i%>">
                                                                <select id="txtDetailType<%=i%>" name="txtDetailType<%=i%>">
                                                                    <%
                                                                        String oneSelected = "";
                                                                        String twoSelected = "";
                                                                        String threeSelected = "";
                                                                        String fourSelected = "";
                                                                        String fiveSelected = "";
                                                                        String sixSelected = "";
                                                                        String sevenSelected = "";

                                                                        String detailType = txtDetailType[i];
                                                                        if (detailType.equalsIgnoreCase("2")) {
                                                                            twoSelected = "selected";
                                                                        } else if (detailType.equalsIgnoreCase("3")) {
                                                                            threeSelected = "selected";
                                                                        } else if (detailType.equalsIgnoreCase("4")) {
                                                                            fourSelected = "selected";
                                                                        } else if (detailType.equalsIgnoreCase("5")) {
                                                                            fiveSelected = "selected";
                                                                        } else if (detailType.equalsIgnoreCase("6")) {
                                                                            sixSelected = "selected";
                                                                        } else if (detailType.equalsIgnoreCase("7")) {
                                                                            sevenSelected = "selected";
                                                                        } else {
                                                                            oneSelected = "selected";
                                                                        }
                                                                    %>
                                                                    <option value="1" <%=oneSelected%> >General</option>
                                                                    <option value="2" <%=twoSelected%> >Text Area</option>
                                                                    <option value="3" <%=threeSelected%> >Date</option>
                                                                    <option value="4" <%=fourSelected%> >Email</option>
                                                                    <option value="5" <%=fiveSelected%> >Combo Box</option>
                                                                    <!--                                                                    <option value="6" <=sixSelected%> >Check Box</option>
                                                                                                                                        <option value="7" <=sevenSelected%> >Radio Button</option>-->
                                                                </select>
                                                            </td>
                                                            <td class="cellcontent" id="rowEditable<%=i%>">
                                                                <select id="txtEditable<%=i%>" name="txtEditable<%=i%>">
                                                                    <%
                                                                        String editableYesSelected = "";
                                                                        String editableNoSelected = "";

                                                                        String editable = txtEditable[i];
                                                                        if (editable.equalsIgnoreCase("true")) {
                                                                            editableYesSelected = "selected";
                                                                        } else {
                                                                            editableNoSelected = "selected";
                                                                        }
                                                                    %>
                                                                    <option value="true" <%=editableYesSelected%> >YES</option>
                                                                    <option value="false" <%=editableNoSelected%> >NO</option>
                                                                </select>
                                                            </td>
                                                            <td class="cellcontent" id="rowListable<%=i%>">
                                                                <select id="txtListable<%=i%>" name="txtListable<%=i%>">
                                                                    <%
                                                                        String listableYesSelected = "";
                                                                        String listableNoSelected = "";

                                                                        String listable = txtListable[i];
                                                                        if (listable.equalsIgnoreCase("true")) {
                                                                            listableYesSelected = "selected";
                                                                        } else {
                                                                            listableNoSelected = "selected";
                                                                        }
                                                                    %>
                                                                    <option value="true" <%=listableYesSelected%> >YES</option>
                                                                    <option value="false" <%=listableNoSelected%> >NO</option>
                                                                </select>
                                                            </td>
                                                            <td class="cellcontent" id="rowMandatory<%=i%>">
                                                                <select id="txtMandatory<%=i%>" name="txtMandatory<%=i%>">
                                                                    <%
                                                                        String mandatory = txtMandatory[i];
                                                                        String mandatoryYesSelected = "";
                                                                        String mandatoryNoSelected = "";
                                                                        if (mandatory.equalsIgnoreCase("true")) {
                                                                            mandatoryYesSelected = "selected";
                                                                        } else {
                                                                            mandatoryNoSelected = "selected";
                                                                        }
                                                                    %>
                                                                    <option value="true" <%=mandatoryYesSelected%> >YES</option>
                                                                    <option value="false" <%=mandatoryNoSelected%> >NO</option>
                                                                </select>
                                                            </td>
                                                            <td class="cellcontent" id="rowValues<%=i%>">
                                                                <textarea id="txtValues<%=i%>" name="txtValues<%=i%>"><%=txtValues[i].trim()%></textarea>
                                                            </td>
                                                        </tr>
                                                        <% }%>
                                                        <tr>
                                                            <td colspan="3" align="left">
                                                                &nbsp;<input type="button" value="ACTIVATE" name="btnActivate" class="psadbutton" width="100" onclick="fnActivate()"></input>
                                                            </td>
                                                            <td colspan="3" align="right">
                                                                <input type="button" id="btnUpdate" name="btnUpdate" class="psadbutton" width="100" onclick="fnBtnUpdateClicked()" value="UPDATE"/>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="6" align="center">
                                                                <%if (action.equals("success")) {
                                                                %>
                                                                <label style="color:red">The Admin Task Details are updated!</label>
                                                                <%}%>
                                                            </td>
                                                        </tr>
                                                        <% } else {%>
                                                        <!--  what happens if the admin task is activated!-->
                                                        <tr style="background-color:#cccccc">
                                                            <td><b>Names</b></td>
                                                            <td><b>Type</b></td>
                                                            <td><b>Editable</b></td>
                                                            <td><b>Listable</b></td>
                                                            <td><b>Mandatory</b></td>
                                                            <td><b>Values</b></td>
                                                        </tr>
                                                        <%
                                                            for (int x = 0; x < detailList.size(); x++) {
                                                                AdminDetail tmpAdDetail = detailList.get(x);
                                                                String tmpname = StringEscapeUtils.escapeHtml(tmpAdDetail.getName());
                                                                int tmptype = tmpAdDetail.getType();
                                                                String tmptypename = "General";
                                                                if (tmptype == 1) {
                                                                    tmptypename = "General";
                                                                } else if (tmptype == 2) {
                                                                    tmptypename = "Text Area";
                                                                } else if (tmptype == 3) {
                                                                    tmptypename = "Date";
                                                                } else if (tmptype == 4) {
                                                                    tmptypename = "Email";
                                                                } else if (tmptype == 5) {
                                                                    tmptypename = "Combo Box";
                                                                }
                                                                boolean tmpEditable = tmpAdDetail.isEditable();
                                                                boolean tmpListable = tmpAdDetail.isListable();
                                                                boolean tmpMandatory = tmpAdDetail.isMandatory();
                                                                ArrayList<AdminDetailValue> tmpValueList = tmpAdDetail.getValueList();
                                                                String tmpValues = "";
                                                                if (tmpValueList != null) {
                                                                    if (tmpValueList.size() > 0) {
                                                                        StringBuffer tmpsbf = new StringBuffer();
                                                                        for (int y = 0; y < tmpValueList.size(); y++) {
                                                                            tmpsbf.append(StringEscapeUtils.escapeHtml(tmpValueList.get(y).getValue()));
                                                                            if (y < tmpValueList.size() - 1) {
                                                                                tmpsbf.append(",");
                                                                            }
                                                                        }
                                                                        tmpValues = tmpsbf.toString();
                                                                    }
                                                                }
                                                        %>
                                                        <tr>
                                                            <td><%=tmpname%></td>
                                                            <td><%=tmptypename%></td>
                                                            <td><%=tmpEditable%></td>
                                                            <td><%=tmpListable%></td>
                                                            <td><%=tmpMandatory%></td>
                                                            <td><%=tmpValues%></td>
                                                        </tr>
                                                        <% }%>
                                                        <tr>
                                                            <td colspan="6" align="center">
                                                                &nbsp;<input type="button" value="DEACTIVATE" name="btnActivate" class="psadbutton" width="100" onclick="fnDeactivate()"></input>
                                                            </td>
                                                        </tr>
                                                        <% }%>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </form>
        <%}%>
    </body>
</html>
