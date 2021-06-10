<%-- 
    Document   : subprocessdetail
    Created on : Jul 16, 2014, 2:55:57 PM
    Author     : SOE HTIKE
--%>
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
         import = "com.bizmann.diy.subprocess.controller.*"
         import = "com.bizmann.diy.subprocess.entity.*" 
         import = "com.bizmann.flowchart.controller.ConsolidationController"
         import = "com.bizmann.flowchart.entity.ConsolidationDetail" 
         import = "com.bizmann.poi.entity.Field" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="helper/sessioncheck.jsp" %>
<%
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

    SubProcessController subProcCtrl = new SubProcessController();
    SubProcessHeader subProc = subProcCtrl.getSubProcessByHeaderId(intParentId);
    ArrayList<SubProcessDetail> fieldMappingList = new ArrayList<SubProcessDetail>();

    if (subProc.getId() > 0) {
        fieldMappingList = subProc.getFieldMappingList();
    }

    ArrayList<Field> oldFieldList = subProcCtrl.getOldFieldListByFlowChartId(subProc.getFlowchart_id(), intParentId);
    ArrayList<Field> newFieldList = subProcCtrl.getNewFieldListByFlowChartId(subProc.getSub_flowchart_id(), intParentId);

    //System.out.println("subProc.getId() : " + subProc.getId());
    //System.out.println("fieldMappingList.size() : " + fieldMappingList.size());
    //System.out.println("oldFieldList.size() : " + oldFieldList.size());
    //System.out.println("newFieldList.size() : " + newFieldList.size());

    String action = request.getParameter("todoaction");
    if (action == null) {
        action = "";
    }

    String cbOldField = request.getParameter("cbOldField");
    if (cbOldField == null) {
        cbOldField = "0";
    }
    cbOldField = cbOldField.trim();
    if (cbOldField.equalsIgnoreCase("")) {
        cbOldField = "0";
    }
    //int oldField = Integer.parseInt(cbOldField);

    String cbNewField = request.getParameter("cbNewField");
    if (cbNewField == null) {
        cbNewField = "0";
    }
    cbNewField = cbNewField.trim();
    if (cbNewField.equalsIgnoreCase("")) {
        cbNewField = "0";
    }
    //int newField = Integer.parseInt(cbNewField);

    String closingmsg = "";
    //System.out.println("action : " + action);
    if (action.equalsIgnoreCase("add")) {
        int idGenerated = subProcCtrl.insertFieldMapping(intParentId, userId, cbOldField, cbNewField);
        if (idGenerated > 0) {
            response.sendRedirect("subprocessdetail.jsp?parentId=" + intParentId);
        } else {
            closingmsg = "alert('Sorry! Field Mapping insertion failed! Please try again!');";
        }
    } else if (action.equalsIgnoreCase("activate")) {
        subProcCtrl.activateSubProcess(intParentId, userId);
        response.sendRedirect("subprocessdetail.jsp?parentId=" + intParentId + "&todoaction=success");
    } else if (action.equalsIgnoreCase("deactivate")) {
        subProcCtrl.deactivateSubProcess(intParentId, userId);
        response.sendRedirect("subprocessdetail.jsp?parentId=" + intParentId + "&todoaction=success");
    } else if (action.equalsIgnoreCase("del")) {
        String strDetailId = request.getParameter("detailId");
        if (strDetailId == null) {
            strDetailId = "0";
        }
        strDetailId = strDetailId.trim();
        if (strDetailId.equals("")) {
            strDetailId = "0";
        }
        int detailId = Integer.parseInt(strDetailId);
        if (detailId > 0) {
            subProcCtrl.deleteFieldMapping(detailId, intParentId, userId);
        }
        response.sendRedirect("subprocessdetail.jsp?parentId=" + intParentId);
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
            
            function fnDelBtnClicked(vDetailId){
                document.fmrSubProcDetail.method = "post";
                document.fmrSubProcDetail.action = "subprocessdetail.jsp?todoaction=del&detailId="+vDetailId;
                document.fmrSubProcDetail.submit();
            }
            
            function fnAddBtnClicked(){
                if(document.getElementById("cbOldField").value == '0' || document.getElementById("cbOldField").value == ''){
                    alert("Please select source field!");
                }else if(document.getElementById("cbNewField").value == '0' || document.getElementById("cbNewField").value == ''){
                    alert("Please select destination field!");
                }else{
                    document.fmrSubProcDetail.method = "post";
                    document.fmrSubProcDetail.action = "subprocessdetail.jsp?todoaction=add";
                    document.fmrSubProcDetail.submit();
                }
            }
            
            function fnActivate(){
                document.fmrSubProcDetail.method = "post";
                document.fmrSubProcDetail.action = "subprocessdetail.jsp?todoaction=activate";
                document.fmrSubProcDetail.submit();
            }
            
            function fnDeactivate(){
                document.fmrSubProcDetail.method = "post";
                document.fmrSubProcDetail.action = "subprocessdetail.jsp?todoaction=deactivate";
                document.fmrSubProcDetail.submit();
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
        <form id="fmrSubProcDetail" name="fmrSubProcDetail" action="subprocessdetail.jsp" method="POST" >
            <div align="center" valign="top">
                <table>
                    <tr>
                        <td class="orgtable" valign="top" align="center">
                            <br>
                            <table cellpadding="0">
                                <tr>
                                    <td colspan="2">
                                        <div class="psadtitle">
                                            <br>Field Mappings For <%=subProc.getName()%><br>
                                            <br>From <%=subProc.getFlowchart_name()%>'s <%=subProc.getTrigger_action_name()%> To <%=subProc.getSub_flowchart_name()%>!<br>
                                            <%if (action.equals("success")) {
                                            %>
                                            <label style="color:red">Field Mappings have been updated!</label>
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
                                    <td colspan="2" align="center">
                                        <table>
                                            <tr>
                                                <td align="center">
                                                    <table border="1" cellpadding="2px" style="text-align:left;font:80% arial,helvetica,clean,sans-serif;border-collapse:collapse;" width="95%">
                                                        <%if (!subProc.isIs_activated()) {%>
                                                        <!--                                                        add individual record here-->
                                                        <tr>
                                                            <td>Old Field: </td>
                                                            <td>
                                                                <select id="cbOldField" name="cbOldField">
                                                                    <%
                                                                        for (int i = 0; i < oldFieldList.size(); i++) {
                                                                            Field field = oldFieldList.get(i);
                                                                    %>
                                                                    <option value="<%=field.getCell_identifier()%>"><%=StringEscapeUtils.escapeHtml(field.getName() + "(" + field.getCell_identifier() + ")")%></option>
                                                                    <% }%>
                                                                </select>
                                                            </td>
                                                            <td>New Field: </td>
                                                            <td>
                                                                <select id="cbNewField" name="cbNewField">
                                                                    <%
                                                                        for (int i = 0; i < newFieldList.size(); i++) {
                                                                            Field field = newFieldList.get(i);
                                                                    %>
                                                                    <option value="<%=field.getCell_identifier()%>"><%=StringEscapeUtils.escapeHtml(field.getName() + "(" + field.getCell_identifier() + ")")%></option>
                                                                    <% }%>
                                                                </select>
                                                            </td>
                                                            <td colspan="2">
                                                                <input type="button" id="AddBtn" name="AddBtn" onclick="fnAddBtnClicked()" value="ADD" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th colspan="2">Main Form's Field</th>
                                                            <th colspan="2">Triggered Form's Field</th>
                                                            <th colspan="2">&nbsp;</th>
                                                        </tr>
                                                        <%
                                                            for (int i = 0; i < fieldMappingList.size(); i++) {
                                                                SubProcessDetail subProcDetail = fieldMappingList.get(i);
                                                        %>
                                                        <tr>
                                                            <td colspan="2"><%=StringEscapeUtils.escapeHtml(subProcDetail.getOld_field_name())%></td>
                                                            <td colspan="2"><%=StringEscapeUtils.escapeHtml(subProcDetail.getNew_field_name())%></td>
                                                            <td colspan="2"><input type="button" id="DelBtn" name="DelBtn" value="DEL" onclick="fnDelBtnClicked(<%=subProcDetail.getId()%>)" /></td>
                                                        </tr>
                                                        <% }%>
                                                        <tr>
                                                            <td colspan="6" align="left">
                                                                &nbsp;<input type="button" value="ACTIVATE" name="btnActivate" class="psadbutton" width="100" onclick="fnActivate()"></input>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="6" align="center">
                                                                <%if (action.equals("success")) {
                                                                %>
                                                                <label style="color:red">Field Mappings have been updated!</label>
                                                                <%}%>
                                                            </td>
                                                        </tr>
                                                        <% } else {%>
                                                        <tr>
                                                            <th colspan="3">Main Form's Field</th>
                                                            <th colspan="3">Triggered Form's Field</th>
                                                        </tr>
                                                        <%
                                                            for (int i = 0; i < fieldMappingList.size(); i++) {
                                                                SubProcessDetail subProcDetail = fieldMappingList.get(i);
                                                        %>
                                                        <tr>
                                                            <td colspan="3"><%=StringEscapeUtils.escapeHtml(subProcDetail.getOld_field_name())%></td>
                                                            <td colspan="3"><%=StringEscapeUtils.escapeHtml(subProcDetail.getNew_field_name())%></td>
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
    <script>
        <%=closingmsg%>
    </script>
</html>