<%-- 
    Document   : flochartlibrary.jsp
    Created on : Feb 20, 2009, 5:01:33 PM
    Author     : Tan Chiu Ping
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<%@page import = "java.util.*"
        import = "java.lang.*"
        import = "com.bizmann.product.controller.*"
        import = "com.bizmann.product.entity.*"
        import = "com.bizmann.product.resources.*" %>
<%!    EngineFlowChartController engineFlowChartCtrl = new EngineFlowChartController();
%>
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/menu.jsp" %>

<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>bmFLO</title>
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/treeview/assets/skins/sam/treeview.css" />

        <script type="text/javascript" src="../include/js/yui/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="../include/js/yui/treeview/treeview-min.js"></script>

        <style type="text/css">
            .icon-form { display:block; height: 23px; padding-left: 0px; background: transparent 0 0px no-repeat; }
            .icon-orgunit { display:block; height: 23px; padding-left: 0px; background: transparent 0 0px no-repeat; }
            .icon-orgunit2line { display:block; height: 33px; padding-left: 0px; background: transparent 0 0px no-repeat; }
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

        var type = "<%=request.getParameter("type")%>";
        var subtype = "<%=request.getParameter("subtype")%>"

        function init(){
            tree = new YAHOO.widget.TreeView("treediv");
            root = tree.getRoot();
            tmpNode = new YAHOO.widget.TextNode({ label: "<b>Flow Chart Library</b>", id:"0" }, root);
            tmpNode.labelStyle="icon-orgunit";

            //show all the available flow charts
        <%
        ArrayList flowChartList = engineFlowChartCtrl.getAllFlowCharts();
        for (int i = 0; i < flowChartList.size(); i++) {
            EngineFlowChart engineFlowChart = (EngineFlowChart)flowChartList.get(i);
        %>
                var tmpSubNode = new YAHOO.widget.TextNode({label:"<%=engineFlowChart.getName()%>", id:"<%=engineFlowChart.getId()%>"}, tmpNode);
                //tmpSubNode.labelStyle = "icon-form";
                if(tmpSubNode.label.length > 40){
                    tmpSubNode.labelStyle = "icon-orgunit2line";
                }else{
                    tmpSubNode.labelStyle = "icon-orgunit";
                }
        <%}%>
                tree.draw();

                tree.subscribe("expand", function(node) {
                    if(node.data.id != 0){
                        var flowChartId = node.data.id;
                        document.getElementById("hidFlowChartId").value= flowChartId;
                        $('#iflowchartlibrary').attr('src', "flowchartlibrarydetail.jsp?type="+type+"&subtype="+subtype+"&flowChartId="+flowChartId);
                        //window.frames["iflowchartlibrary"].location.href = "flowchartlibrarydetail.jsp?type="+type+"&subtype="+subtype+"&flowChartId="+flowChartId;
                        //document.frames("iflowchartlibrary").location.href = "flowchartlibrarydetail.jsp?type="+type+"&subtype="+subtype+"&flowChartId="+flowChartId;
                    }
                    else{
                        document.getElementById("hidFlowChartId").value= "";
                        $('#iflowchartlibrary').attr('src', "flowchartlibrarydetail.jsp?type="+type+"&subtype="+subtype+"");
                        //window.frames["iflowchartlibrary"].location.href = "flowchartlibrarydetail.jsp?type="+type+"&subtype="+subtype+"";
                        //document.frames("iflowchartlibrary").location.href = "flowchartlibrarydetail.jsp?type="+type+"&subtype="+subtype+"";
                    }
                });

                tree.subscribe("collapse", function(node) {
                    if(node.data.id != 0){
                        var flowChartId = node.data.id;
                        document.getElementById("hidFlowChartId").value= flowChartId;
                        $('#iflowchartlibrary').attr('src', "flowchartlibrarydetail.jsp?type="+type+"&subtype="+subtype+"&flowChartId="+flowChartId);
                        //window.frames["iflowchartlibrary"].location.href = "flowchartlibrarydetail.jsp?type="+type+"&subtype="+subtype+"&flowChartId="+flowChartId;
                        //document.frames("iflowchartlibrary").location.href = "flowchartlibrarydetail.jsp?type="+type+"&subtype="+subtype+"&flowChartId="+flowChartId;
                    }
                    else{
                        document.getElementById("hidFlowChartId").value= "";
                        $('#iflowchartlibrary').attr('src', "flowchartlibrarydetail.jsp?type="+type+"&subtype="+subtype+"");
                        //window.frames["iflowchartlibrary"].location.href = "flowchartlibrarydetail.jsp?type="+type+"&subtype="+subtype+"";
                        //document.frames("iflowchartlibrary").location.href = "flowchartlibrarydetail.jsp?type="+type+"&subtype="+subtype+"";
                    }
                });
            }
            YAHOO.util.Event.onDOMReady(init);

    </script>

    <script>
    </script>

    <body>

        <div align="center" valign="top">
            <table width="980px" height="420px" background="../images/background.png">
                <tr>
                    <td class="orgtable" valign="top" width="300px">
                        <%@ include file="../include/tmenu.jsp" %>
                        <div id="treediv" class="treediv"></div>
                    </td>
                    <td class="orgtable" valign="top">
                        <iframe ID="iflowchartlibrary" MARGINHEIGHT="0" MARGINWIDTH="0" FRAMEBORDER="0" SRC="flowchartlibrarydetail.jsp" width=100% height="420px"></iframe>
                    </td>
                </tr>
            </table>
        </div>
        <!-- Store the value of the selected form id -->
        <input type="hidden" id="hidFlowChartId" name="hidFlowChartId" value=""></input>
    </body>
</html>

<%@ include file="../include/footer.jsp" %>
