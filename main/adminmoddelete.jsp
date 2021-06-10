<%-- 
    Document   : adminmoddelete
    Created on : Jul 4, 2014, 5:42:09 PM
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
<%@ include file="helper/sessioncheck.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
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
    
    String action = request.getParameter("todoaction");
    if (action == null) {
        action = "";
    }
    
    AdminModController adminModCtrl = new AdminModController();
    AdminHeader adminHeader = adminModCtrl.getTableDetailsByHeaderId(intParentId);
    ArrayList<AdminDetail> detailList = new ArrayList<AdminDetail>();
    
    if (adminHeader.getId() > 0) {
        detailList = adminHeader.getDetailList();
    }
    
    boolean deleted = false;
    if (action.equalsIgnoreCase("delete")) {
        deleted = adminModCtrl.deleteAdminMod(intParentId);
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
                        parent.document.location.href = "adminmoddesigner.jsp?type="+type;
                    }
                    else{
                        parent.document.location.href = "adminmoddesigner.jsp?type="+type+"&subtype="+subtype;
                    }
                }
            }
            
            function fnbtnDel(){
                document.frmAdminModDetail.method = "post";
                document.frmAdminModDetail.action = "adminmoddelete.jsp?todoaction=delete";
                document.frmAdminModDetail.submit();
            }
        </script>
    </head>
    <body onload="fnOnLoad()">
        <% if (parentId.equals("") || parentId.equals("0")) {%>
        <!-- Leave it blank -->
        <% } else {%>
        <form id="frmAdminModDetail" name="frmAdminModDetail" action="adminmoddelete.jsp" method="POST" >
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
                                    <td colspan="2">
                                        <table>
                                            <tr>
                                                <td>
                                                    <table border="1" cellpadding="2px" style="text-align:left;font:80% arial,helvetica,clean,sans-serif;border-collapse:collapse;" width="95%">

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
                                                        <%if (!adminHeader.isActivated()) {%>
                                                        <tr>
                                                            <td colspan="6" align="center">
                                                                &nbsp;<input type="button" value="DELETE" id="btnDel" name="btnDel" class="psadbutton" width="100" onclick="fnbtnDel()"></input>
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
