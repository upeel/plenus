<%--
    Document   : designation.jsp
    Created on : Dec 11, 2013, 10:04:20 AM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import = "com.bizmann.product.entity.*"
         import = "com.bizmann.product.controller.*"
         import = "com.bizmann.product.resources.*"
         import = "java.util.*"
         import = "org.apache.commons.lang.StringEscapeUtils"
         import = "java.lang.*" %>
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/menu.jsp" %>
<%
    DesignationController designationCtrl= new DesignationController();
    OrgChartController ocCtrl = new OrgChartController();
    ArrayList list = designationCtrl.getAllDesignation();
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Language" content="en-us">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <title>bmFLO</title>
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/treeview/assets/skins/sam/treeview.css" />
        <script type="text/javascript" src="../include/js/yui/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="../include/js/yui/treeview/treeview-min.js"></script>
        <style type="text/css">
            .icon-orgunit { display:block; height: 23px; padding-left: 0px; background: transparent 0 0px no-repeat; }
            .icon-user { display:block; height: 23px; padding-left: 0px; background: transparent 0 0px no-repeat; }
            .icon-mgr { display:block; height: 23px; padding-left: 0px; background: transparent 0 0px no-repeat; }

            .treediv{
                position: relative;
                text-align: left;
            }

            .orgtable {
                border-left:1px solid #cbcbcb;
                border-right:1px solid #cbcbcb;
                border-top:1px solid #cbcbcb;
                border-bottom:1px solid #cbcbcb;
                border:1px solid #cbcbcb;
            }
        </style>
    </head>
    <script type="text/javascript">
        var tree;
        var tmpNode;

        function init(){
            tree = new YAHOO.widget.TreeView("treediv");
            root = tree.getRoot();
            tmpNode = new YAHOO.widget.TextNode({ label: "<b><%=StringEscapeUtils.escapeJavaScript(StringEscapeUtils.escapeHtml(ocCtrl.getActiveOC()))%></b>", id: "0" }, root, true);
            tmpNode.labelStyle="icon-orgunit";
        <% for(int i=0; i<list.size() ; i++){
                   Designation designation = (Designation)list.get(i);
        %>
                var tmpSubNode = new YAHOO.widget.TextNode({label: "<%=StringEscapeUtils.escapeJavaScript(StringEscapeUtils.escapeHtml(designation.getName()))%>", id: "<%=designation.getDesignationId()%>"}, tmpNode);
                tmpSubNode.labelStyle = "icon-orgunit";
        <%}%>
                tree.draw();
                tree.subscribe("expand", function(node) {
                    if(node.data.id != 0){
                        var designationId = node.data.id;
                        document.getElementById("hidDesId").value= designationId;
                        $('#idesignation').attr('src', "designationdetail.jsp?type="+type+"&subtype="+subtype+"&designationId="+designationId);
                        //window.frames["idesignation"].location.href = "designationdetail.jsp?type="+type+"&subtype="+subtype+"&designationId="+designationId;
                    }
                    else if(node.data.id == 0){
                        var designationId = "0";
                        document.getElementById("hidDesId").value= "0";
                        $('#idesignation').attr('src', "designationdetail.jsp?type="+type+"&subtype="+subtype+"&designationId="+designationId);
                        //window.frames["idesignation"].location.href = "designationdetail.jsp?type="+type+"&subtype="+subtype+"&designationId="+designationId;
                    }
                });

                tree.subscribe("collapse", function(node) {
                    if(node.data.id != 0){
                        var designationId = node.data.id;
                        document.getElementById("hidDesId").value= designationId;
                        $('#idesignation').attr('src', "designationdetail.jsp?type="+type+"&subtype="+subtype+"&designationId="+designationId);
                        //window.frames["idesignation"].location.href = "designationdetail.jsp?type="+type+"&subtype="+subtype+"&designationId="+designationId;
                    }
                    else if(node.data.id == 0){
                        var designationId = "0";
                        document.getElementById("hidDesId").value= "0";
                        $('#idesignation').attr('src', "designationdetail.jsp?type="+type+"&subtype="+subtype+"&designationId="+designationId);
                        //window.frames["idesignation"].location.href = "designationdetail.jsp?type="+type+"&subtype="+subtype+"&designationId="+designationId;
                    }
                });
            }
            YAHOO.util.Event.onDOMReady(init);
    </script>
    <body>

        <div align="center" valign="top">
            <table width="980px" height="420px" background="../images/background.png">
                <tr>
                    <td class="orgtable" valign="top" width="300">
                        <%@ include file="../include/tmenu.jsp" %>
                        <div id="treediv" class="treediv"></div>
                    </td>
                    <td class="orgtable" valign="top">
                        <iframe ID="idesignation" MARGINHEIGHT="0" MARGINWIDTH="0" FRAMEBORDER="0" SRC="designationdetail.jsp" width=100% height="420px"></iframe>
                    </td>
                </tr>
            </table>
        </div>
        <input type="hidden" id="hidDesId" name="hidDesId" value=""></input>
    </body>
</html>
<%@ include file="../include/footer.jsp" %>