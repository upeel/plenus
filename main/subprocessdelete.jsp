<%-- 
    Document   : subprocessdelete
    Created on : Jul 16, 2014, 2:56:29 PM
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
    
    String action = request.getParameter("todoaction");
    if (action == null) {
        action = "";
    }
    
    boolean deleted = false;
    if (action.equalsIgnoreCase("delete")) {
        subProc.setModified_by(userId);
        deleted = subProcCtrl.deleteSubProcess(subProc);
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
            var vdeleted = <%=deleted%>;
            
            function fnOnLoad(){
                if(vdeleted){
                    if(subtype == "null"){
                        parent.document.location.href = "subprocessdesigner.jsp?type="+type;
                    }
                    else{
                        parent.document.location.href = "subprocessdesigner.jsp?type="+type+"&subtype="+subtype;
                    }
                }
            }
            
            function fnbtnDelete(){
                document.fmrSubProcDetail.method = "post";
                document.fmrSubProcDetail.action = "subprocessdelete.jsp?todoaction=delete";
                document.fmrSubProcDetail.submit();
            }
        </script>
    </head>
    <body onload="fnOnLoad()">
        <%
            if (parentId.equals("") || parentId.equals("0")) {%>
        <!-- Leave it blank -->
        <%} else {
        %>
        <form id="fmrSubProcDetail" name="fmrSubProcDetail" action="subprocessdelete.jsp" method="POST" >
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
                                            <br>
                                            <input type="hidden" id="parentId" name="parentId" value="<%=parentId%>">
                                            <input type="hidden" id="action" name="action" value="<%=request.getParameter("action")%>">
                                            <input type="hidden" id="type" name="type" value="<%=request.getParameter("type")%>">
                                            <input type="hidden" id="subtype" name="subtype" value="<%=request.getParameter("subtype")%>">
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
                                                        <%if (!subProc.isIs_activated()) {%>
                                                        <tr>
                                                            <td colspan="6" align="center">
                                                                &nbsp;<input type="button" value="Delete" id="btnDelete" name="btnDelete" class="psadbutton" width="100" onclick="fnbtnDelete()"></input>
                                                            </td>
                                                        </tr>
                                                        <% } %>
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
