<%-- 
    Document   : consolidationdelete
    Created on : Mar 7, 2014, 1:54:38 PM
    Author     : SOE HTIKE
--%>

<%@ page import = "java.util.*"
         import = "java.lang.*"
         import = "com.bizmann.product.controller.*"
         import = "com.bizmann.product.entity.*"
         import = "com.bizmann.product.resources.*" %>
<%@ page import = "com.bizmann.flowchart.controller.ConsolidationController" %>
<%@ page import = "com.bizmann.flowchart.entity.ConsolidationDetail" %>
<%@ page import = "com.bizmann.poi.entity.Field" %>

<%@ include file="helper/sessioncheck.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    String parentId = request.getParameter("parentId");
    String childId = request.getParameter("childId");
    if (parentId == null) {
        parentId = "0";
    }
    if (childId == null) {
        childId = "0";
    }
    String todoaction = request.getParameter("todoaction");
    if (todoaction == null) {
        todoaction = "";
    }
    ConsolidationController conCtrl = new ConsolidationController();
    ArrayList<com.bizmann.poi.entity.Field> fieldList = conCtrl.getFieldsByActionId(Integer.parseInt(childId));
    ConsolidationDetail conD = conCtrl.getConsolidationByFlowchartByActionId(Integer.parseInt(parentId), Integer.parseInt(childId));

    if (todoaction.equalsIgnoreCase("delete")) {
        conCtrl.deleteConsolidationByFlowchartByActionId(Integer.parseInt(parentId), Integer.parseInt(childId));
    }
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <title>bmFLO</title>
        <script>
            var action = "<%=todoaction%>";
            var type = "<%=request.getParameter("type")%>";
            var subtype = "<%=request.getParameter("subtype")%>";
            var childId = "<%=childId%>";
            var parentId = "<%=parentId%>";
            
            function delBtnClicked(){
                document.location.href="consolidationdelete.jsp?type="+type+"&subtype="+subtype+"&todoaction=delete&parentId="+parentId+"&childId="+childId;
            }
            
            function fnOnLoad(){
                if(action == "delete"){
                    if(subtype == "null"){
                        parent.document.location.href = "consolidationdesigner.jsp?type="+type;
                    }
                    else{
                        parent.document.location.href = "consolidationdesigner.jsp?type="+type+"&subtype="+subtype;
                    }
                }
            }                
        </script>
    </head>
    <body onload="fnOnLoad()" background="../images/background.png" style="width:650px">
        <%
            if (childId.equals("") || childId.equals("0") || parentId.equals("") || parentId.equals("0")) {%>
        <!-- Leave it blank -->
        <%} else {
        %>
        <div align="center" valign="top">
            <table>
                <tr>
                    <td class="orgtable" valign="top" align="center">
                        <br>
                        <table cellpadding="0">
                            <tr>
                                <td colspan="2">
                                    <div class="psadtitle">
                                        <br>Consolidated Dashboard Details For <%=conD.getAction_name()%><br><br>
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
                            <tr>
                                <td colspan="2">
                                    <div class="psadtitle">
                                        <br>Columns to be shown<br><br>
                                    </div>
                                </td>
                            </tr>
                            <%
                                for (int a = 0; a < fieldList.size(); a++) {
                                    com.bizmann.poi.entity.Field field = fieldList.get(a);
                                    String cell = field.getCell_identifier();
                                    String name = field.getName();
                                    String tmpCols = conD.getColumns();
                                    String[] colArr = tmpCols.split(",");
                                    ArrayList<String> arrayList = new ArrayList<String>(Arrays.asList(colArr));
                                    String isChecked = "";
                                    if (arrayList.contains(cell)) {
                                        isChecked = "checked";
                                    }
                            %>
                            <tr>
                                <td align="right" valign="middle"><input type="checkbox" id="chk-<%=a%>" name="chkcells" value="<%=cell%>" <%=isChecked%> disabled/></td>
                                <td align="left"><%="(" + cell + ") " + name%></td>
                            </tr>
                            <%
                                }
                            %>
                            <tr>
                                <td colspan="2" width=500 align="right"><input type="button" id="delBtn" name="delBtn" value="Delete" onclick="delBtnClicked()"/></td>
                            </tr>
                            <tr>
                                <td width=150 align="right">&nbsp;</td>
                                <td width=350 align="left">&nbsp;</td>
                            </tr>

                            <tr>
                                <td width=150 align="right">&nbsp;</td>
                                <td width=350 align="left">&nbsp;</td>
                            </tr>
                            <tr>
                                <td width=150 align="right">&nbsp;</td>
                                <td width=350 align="left">&nbsp;</td>
                            </tr>
                            <tr>
                                <td width=150 align="right">&nbsp;</td>
                                <td width=350 align="left">&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <%}%>
    </body>
</html>