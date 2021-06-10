<%-- 
    Document   : externalform
    Created on : Jan 21, 2015, 11:57:45 AM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*" 
         import="com.bizmann.external.form.controller.*"
         import="com.bizmann.external.form.entity.*"
         import="org.apache.commons.lang.StringEscapeUtils" %>

<%@ include file="../include/header.jsp" %>
<%@ include file="../include/menu.jsp" %>
<!DOCTYPE html>

<%
    ExternalFormController eFormCtrl = new ExternalFormController();
    ArrayList<EngineFlowChart> eFormList = eFormCtrl.getExternalFormFlowCharts();
    
    
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <title>bmFLO</title>
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/treeview/assets/skins/sam/treeview.css" />

        <script type="text/javascript" src="../include/js/yui/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="../include/js/yui/treeview/treeview-min.js"></script>
        <script src="../include/js/jquery-1.10.2.js"></script>

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
        
    <script type="text/javascript">
        var tree;
        var tmpNode;

        var type = "<%=request.getParameter("type")%>";
        var subtype = "<%=request.getParameter("subtype")%>"

        function init(){
            tree = new YAHOO.widget.TreeView("treediv");
            root = tree.getRoot();
            tmpNode = new YAHOO.widget.TextNode({ label: "<b>Customized Flow Chart Library</b>", id:"0" }, root);
            tmpNode.labelStyle="icon-orgunit";

            //show all the available flow charts
        <%
        for (int i = 0; i < eFormList.size(); i++) {
            EngineFlowChart engineFlowChart = (EngineFlowChart)eFormList.get(i);
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
                        $('#iflowchartlibrary').attr('src', "externalformdetail.jsp?type="+type+"&subtype="+subtype+"&flowChartId="+flowChartId);
                        //window.frames["iflowchartlibrary"].location.href = "flowchartlibrarydetail.jsp?type="+type+"&subtype="+subtype+"&flowChartId="+flowChartId;
                        //document.frames("iflowchartlibrary").location.href = "flowchartlibrarydetail.jsp?type="+type+"&subtype="+subtype+"&flowChartId="+flowChartId;
                    }
                    else{
                        document.getElementById("hidFlowChartId").value= "";
                        $('#iflowchartlibrary').attr('src', "externalformdetail.jsp?type="+type+"&subtype="+subtype+"");
                        //window.frames["iflowchartlibrary"].location.href = "flowchartlibrarydetail.jsp?type="+type+"&subtype="+subtype+"";
                        //document.frames("iflowchartlibrary").location.href = "flowchartlibrarydetail.jsp?type="+type+"&subtype="+subtype+"";
                    }
                });

                tree.subscribe("collapse", function(node) {
                    if(node.data.id != 0){
                        var flowChartId = node.data.id;
                        document.getElementById("hidFlowChartId").value= flowChartId;
                        $('#iflowchartlibrary').attr('src', "externalformdetail.jsp?type="+type+"&subtype="+subtype+"&flowChartId="+flowChartId);
                        //window.frames["iflowchartlibrary"].location.href = "flowchartlibrarydetail.jsp?type="+type+"&subtype="+subtype+"&flowChartId="+flowChartId;
                        //document.frames("iflowchartlibrary").location.href = "flowchartlibrarydetail.jsp?type="+type+"&subtype="+subtype+"&flowChartId="+flowChartId;
                    }
                    else{
                        document.getElementById("hidFlowChartId").value= "";
                        $('#iflowchartlibrary').attr('src', "externalformdetail.jsp?type="+type+"&subtype="+subtype+"");
                        //window.frames["iflowchartlibrary"].location.href = "flowchartlibrarydetail.jsp?type="+type+"&subtype="+subtype+"";
                        //document.frames("iflowchartlibrary").location.href = "flowchartlibrarydetail.jsp?type="+type+"&subtype="+subtype+"";
                    }
                });
            }
            YAHOO.util.Event.onDOMReady(init);
    </script>
    </head>
    <body>
        <div align="center" valign="top">
            <table width="980px" height="420px" background="../images/background.png">
                <tr>
                    <td class="orgtable" valign="top" width="300px">
                        <div id="treediv" class="treediv"></div>
                    </td>
                    <td class="orgtable" valign="top">
                        <iframe ID="iflowchartlibrary" MARGINHEIGHT="0" MARGINWIDTH="0" FRAMEBORDER="0" SRC="externalformdetail.jsp" width=100% height="420px"></iframe>
                    </td>
                </tr>
            </table>
        </div>
        <!-- Store the value of the selected form id -->
        <input type="hidden" id="hidFlowChartId" name="hidFlowChartId" value=""></input>
    </body>
</html>
<%@ include file="../include/footer.jsp" %>