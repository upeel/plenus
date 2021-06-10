<%--
    Document   : formpermission.jsp
    Created on : Feb 20, 2009, 5:01:33 PM
    Author     : Nilar
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/menu.jsp" %>
<%@ page import = "java.util.*"
         import = "java.lang.*"
         import = "com.bizmann.product.controller.*"
         import = "com.bizmann.product.entity.*"
         import = "com.bizmann.product.resources.*" %>
<%!    InitiateProcessController iCtrl = new InitiateProcessController();
    ReportController rCtrl = new ReportController();
    SearchController sCtrl = new SearchController();
    MonitorController mCtrl = new MonitorController();
    ExternalReportController eCtrl = new ExternalReportController();
    AdminTaskController aCtrl = new AdminTaskController();
%>

<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>bmFLO</title>
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/treeview/assets/skins/sam/treeview.css" />
        <script type="text/javascript" src="../include/js/yui/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="../include/js/yui/treeview/treeview-min.js"></script>
        <script type="text/javascript" src="include/jquery-ui-1.10.3.custom/js/jquery-1.10.2.min.js"></script>
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />

        <style type="text/css">
            .icon-orgunit { display:block; height: 23px; padding-left: 0px; background: transparent 0 0px no-repeat; }
            .icon-orgunit2line { display:block; height: 33px; padding-left: 0px; background: transparent 0 0px no-repeat; }
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

    <%
        ArrayList list = iCtrl.getInitAccess();
        //ArrayList listReport = rCtrl.getReportAccess();
        //ArrayList listSearch = sCtrl.getSearchAccess();
        ArrayList listMonitor = mCtrl.getMonitorAccess();
        //ArrayList listExternalReport = eCtrl.getExternalReportAccess();
        ArrayList listAdminTask = aCtrl.getAdminTaskAccess();
%>

    <script type="text/javascript">
        var tree;
        var tmpNode;

        function init(){
            tree = new YAHOO.widget.TreeView("treediv");
            root = tree.getRoot();
            
            tmpNode = new YAHOO.widget.TextNode({ label: "<b>Initiate Process</b>", id:"0" }, root);
            tmpNode.labelStyle="icon-orgunit";
        <% for (int i = 0; i < list.size(); i++) {
                InitAccess initAccess = (InitAccess) list.get(i);
        %>
                var tmpSubNode = new YAHOO.widget.TextNode({label: "<%=ResourceUtil.convertSymbol(initAccess.getName())%>", id: "<%=initAccess.getId()%>"}, tmpNode);
                //tmpSubNode.labelStyle = "icon-orgunit";
                if(tmpSubNode.label.length > 40){
                    tmpSubNode.labelStyle = "icon-orgunit2line";
                }else{
                    tmpSubNode.labelStyle = "icon-orgunit";
                }
        <%}%>
            tmpNode = new YAHOO.widget.TextNode({ label: "<font><b>Admin Task</b></font>", id:"5"}, root);
                    tmpNode.labelStyle="icon-orgunit";
            <% for (int i = 0; i < listAdminTask.size(); i++) {
            AdminTaskAccess adminTaskAccess = (AdminTaskAccess) listAdminTask.get(i);
               %>
                       var tmpSubNode = new YAHOO.widget.TextNode({label:"<%=ResourceUtil.convertSymbol(adminTaskAccess.getName())%>", id: "<%=adminTaskAccess.getId()%>"}, tmpNode);
                       //tmpSubNode.labelStyle = "icon-orgunit";
                        if(tmpSubNode.label.length > 40){
                        tmpSubNode.labelStyle = "icon-orgunit2line";
                        }else{
                        tmpSubNode.labelStyle = "icon-orgunit";
                        }
            <%}%>
//                tmpNode = new YAHOO.widget.TextNode({ label: "<b>Search Process</b>", id:"2" }, root);
//                tmpNode.labelStyle="icon-orgunit";
//        < for (int i = 0; i < listSearch.size(); i++) {
//                SearchAccess searchAccess = (SearchAccess) listSearch.get(i);
//        %>//
//                var tmpSubNode = new YAHOO.widget.TextNode({label:"<=ResourceUtil.convertSymbol(searchAccess.getName())%>", id: "<=searchAccess.getId()%>"}, tmpNode);
//                //tmpSubNode.labelStyle = "icon-orgunit";
//                if(tmpSubNode.label.length > 40){
//                    tmpSubNode.labelStyle = "icon-orgunit2line";
//                }else{
//                    tmpSubNode.labelStyle = "icon-orgunit";
//                }
//        <}%>
                tmpNode = new YAHOO.widget.TextNode({ label: "<b>Audit Trail</b>", id:"3" }, root);
                tmpNode.labelStyle="icon-orgunit";
        <% for (int i = 0; i < listMonitor.size(); i++) {
                MonitorAccess monitorAccess = (MonitorAccess) listMonitor.get(i);
        %>
                var tmpSubNode = new YAHOO.widget.TextNode({label:"<%=ResourceUtil.convertSymbol(monitorAccess.getName())%>", id: "<%=monitorAccess.getId()%>"}, tmpNode);
                //tmpSubNode.labelStyle = "icon-orgunit";
                if(tmpSubNode.label.length > 40){
                    tmpSubNode.labelStyle = "icon-orgunit2line";
                }else{
                    tmpSubNode.labelStyle = "icon-orgunit";
                }
        <%}%>
                tree.draw();

                tree.subscribe("expand", function(node) {
                    if(node.data.id != 0){
                        var iniProId = node.data.id;
                        var parentId=node.parent.data.id;
                        document.getElementById("hidIniProId").value= iniProId;
                        $('#inipro').attr('src', "initiateprocessdetail.jsp?type="+type+"&subtype="+subtype+"&iniProId="+iniProId+"&parentId="+parentId);
                        //window.frames["inipro"].location.href = "initiateprocessdetail.jsp?type="+type+"&subtype="+subtype+"&iniProId="+iniProId+"&parentId="+parentId;
                        //document.frames("inipro").location.href = "initiateprocessdetail.jsp?type="+type+"&subtype="+subtype+"&iniProId="+iniProId+"&parentId="+parentId;
                    }
                    else{
                        document.getElementById("hidIniProId").value= "";
                        $('#inipro').attr('src', "initiateprocessdetail.jsp?type="+type+"&subtype="+subtype+"");
                        //window.frames["inipro"].location.href = "initiateprocessdetail.jsp?type="+type+"&subtype="+subtype+"";
                        //document.frames("inipro").location.href = "initiateprocessdetail.jsp?type="+type+"&subtype="+subtype+"";
                    }
                });

                tree.subscribe("collapse", function(node) {
                    if(node.data.id != 0){
                        var iniProId = node.data.id;
                        var parentId=node.parent.data.id;
                        document.getElementById("hidIniProId").value= iniProId;
                        $('#inipro').attr('src', "initiateprocessdetail.jsp?type="+type+"&subtype="+subtype+"&iniProId="+iniProId+"&parentId="+parentId);
                        //window.frames["inipro"].location.href = "initiateprocessdetail.jsp?type="+type+"&subtype="+subtype+"&iniProId="+iniProId+"&parentId="+parentId;
                        //document.frames("inipro").location.href = "initiateprocessdetail.jsp?type="+type+"&subtype="+subtype+"&iniProId="+iniProId+"&parentId="+parentId;
                    }
                    else{
                        document.getElementById("hidIniProId").value= "";
                        $('#inipro').attr('src', "initiateprocessdetail.jsp?type="+type+"&subtype="+subtype+"");
                        //window.frames["inipro"].location.href = "initiateprocessdetail.jsp?type="+type+"&subtype="+subtype+"";
                        //document.frames("inipro").location.href = "initiateprocessdetail.jsp?type="+type+"&subtype="+subtype+"";
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
                        <iframe ID="inipro" MARGINHEIGHT="0" MARGINWIDTH="0" FRAMEBORDER="0" SRC="initiateprocessdetail.jsp" width=100% height="420px"></iframe>
                    </td>
                </tr>
            </table>
        </div>
        <!-- Store the value of the selected footer id -->
        <input type="hidden" id="hidIniProId" name="hidIniProId" value=""></input>
    </body>
</html>

<%@ include file="../include/footer.jsp" %>
