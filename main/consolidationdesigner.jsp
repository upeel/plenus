<%-- 
    Document   : consolidationdesigner
    Created on : Mar 7, 2014, 10:09:04 AM
    Author     : SOE HTIKE
--%>

<%@ page import = "com.bizmann.product.entity.OrgUnit"
         import = "com.bizmann.product.entity.UserOUDesignation"
         import = "com.bizmann.product.controller.OrgUnitController"
         import = "com.bizmann.product.controller.OrgChartController"
         import = "com.bizmann.product.controller.UserOUDesignationController"
         import = "com.bizmann.product.controller.UserController"
         import = "com.bizmann.product.resources.*"
         import = "com.bizmann.flowchart.controller.ConsolidationController"
         import = "com.bizmann.flowchart.entity.ConsolidationDetail"
         import = "java.util.ArrayList"
         import = "java.lang.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/menu.jsp" %>
<%
    EngineFlowChartController engineFlowChartCtrl = new EngineFlowChartController();
    ConsolidationController conCtrl = new ConsolidationController();
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>bmFLO</title>
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/treeview/assets/skins/sam/treeview.css" />
        <script type="text/javascript" src="../include/js/yui/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="../include/js/yui/treeview/treeview-min.js"></script>
        <link rel="stylesheet" href="../include/css/loading.css" type="text/css" />
        <style type="text/css">
            .icon-orgunit { display:block; height: 23px; padding-left: 0px; background: transparent 0 0px no-repeat; }
            .icon-user { display:block; height: 23px; padding-left: 20px; background: transparent url(../images/user-icon.png) 0 0px no-repeat; }
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

        function hideDivs(){
            $('#dvLoading').hide();
            $('#overlay').hide();
        }
            
        function showDivs(){
            $('#dvLoading').show();
            $('#overlay').show();
        }
        function init(){
            tree = new YAHOO.widget.TreeView("treediv");
            root = tree.getRoot();
            tmpNode = new YAHOO.widget.TextNode({ label: "<b>Process List</b>", id:"0" }, root);
            tmpNode.labelStyle="icon-orgunit";
        <%
            ArrayList flowChartList = engineFlowChartCtrl.getAllFlowCharts();
            for (int i = 0; i < flowChartList.size(); i++) {
                EngineFlowChart engineFlowChart = (EngineFlowChart) flowChartList.get(i);
        %>
                var tmpSubNode = new YAHOO.widget.TextNode({label:"<%=engineFlowChart.getName()%>", id:"<%=engineFlowChart.getId()%>"}, tmpNode);
                if(tmpSubNode.label.length > 40){
                    tmpSubNode.labelStyle = "icon-orgunit2line";
                }else{
                    tmpSubNode.labelStyle = "icon-orgunit";
                }
        <%
            ArrayList actList = conCtrl.getConsolidationByFlowchartId(engineFlowChart.getId());
            for (int j = 0; j < actList.size(); j++) {
                ConsolidationDetail conD = (ConsolidationDetail) actList.get(j);
                if (conD.getFlowchart_id() == engineFlowChart.getId()) {%>
                        var tmpFirstUSubNode = new YAHOO.widget.TextNode({label: "<%=conD.getAction_name()%>", id: "<%=conD.getAction_id()%>"}, tmpSubNode);
                        if(tmpFirstUSubNode.label.length > 40){
                            tmpFirstUSubNode.labelStyle = "icon-orgunit2line";
                        }else{
                            tmpFirstUSubNode.labelStyle = "icon-orgunit";
                        }
        <%
                    }
                }
            }
        %>
                tree.draw();

                tree.subscribe("expand", function(node) {
                    if(node.parent.data.id != 0){
                        var parentId = node.parent.data.id;
                        var childId = node.data.id;
                        document.getElementById("hidChildId").value= childId;
                        document.getElementById("hidParentId").value = parentId;
                        $('#iuser').attr('src', "consolidationdetail.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId);
                        //window.frames["iuser"].location.href = "consolidationdetail.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId;
                        //document.frames("iuser").location.href = "userdetail.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId;
                    }
                    else if(node.parent.data.id == 0){
                        var childId = 0;
                        var parentId = node.data.id;
                        document.getElementById("hidChildId").value = childId;
                        document.getElementById("hidParentId").value = parentId;
                        $('#iuser').attr('src', "consolidationdetail.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId);
                        //window.frames["iuser"].location.href = "consolidationdetail.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId;
                        //document.frames("iuser").location.href = "userdetail.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId;
                    }
                });

                tree.subscribe("collapse", function(node) {
                    if(node.data.id != 0){
                        var childId = node.data.id;
                        var parentId = node.parent.data.id;
                        document.getElementById("hidChildId").value= childId;
                        document.getElementById("hidParentId").value = parentId;
                        $('#iuser').attr('src', "consolidationdetail.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId);
                        //window.frames["iuser"].location.href = "consolidationdetail.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId;
                        //document.frames("iuser").location.href = "userdetail.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId;
                    }
                    else if(node.data.id == 0){
                        var childId = node.data.id;
                        var parentId = 0;
                        document.getElementById("hidChildId").value = childId;
                        document.getElementById("hidParentId").value = parentId;
                        $('#iuser').attr('src', "consolidationdetail.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId);
                        //window.frames["iuser"].location.href = "consolidationdetail.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId;
                        //document.frames("iuser").location.href = "userdetail.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId;
                    }
                });
            }

            YAHOO.util.Event.onDOMReady(init);

    </script>

    <body onload="hideDivs()">
        <div id="dvLoading"></div>
        <div id="overlay" class="web_dialog_overlay"></div>
        <div align="center" valign="top">
            <table width="980px" height="420px" background="../images/background.png">
                <tr>
                    <td class="orgtable" valign="top" width="300">
                        <%@ include file="../include/tmenu.jsp" %>
                        <div id="treediv" class="treediv"></div>
                    </td>
                    <td class="orgtable" valign="top">
                        <iframe ID="iuser" MARGINHEIGHT="0" MARGINWIDTH="0" FRAMEBORDER="0" SRC="consolidationdetail.jsp" width=100% height="420px" onload="hidDivs();" onbeforeunload="showDivs();"></iframe>
                    </td>
                </tr>
            </table>
        </div>
        <!-- Store the value of the selected footer id -->
        <input type="hidden" id="hidParentId" name="hidParentId" value=""></input>
        <input type="hidden" id="hidChildId" name="hidChildId" value=""></input>
    </body>
</html>

<%@ include file="../include/footer.jsp" %>