<%--
    Document   : orgunit
    Created on : Jul 2, 2009, 3:53:43 PM
    Author     : NooNYUki
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%@page import = "com.bizmann.product.entity.OrgUnit"
        import = "com.bizmann.product.controller.OrgUnitController"
        import = "com.bizmann.product.controller.OrgChartController"
        import = "com.bizmann.product.resources.*"
        import = "java.util.ArrayList"
        import = "java.lang.*" %>
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/menu.jsp" %>
<%
    OrgUnitController orgunitCtrl= new OrgUnitController();
    OrgChartController ocCtrl = new OrgChartController();
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
        <script src="../include/js/jquery-1.10.2.js"></script>
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
            tmpNode = new YAHOO.widget.TextNode({ label: "<b><%=ResourceUtil.convertSymbol(ocCtrl.getActiveOC())%></b>", id:"0" }, root, true);
            tmpNode.labelStyle="icon-orgunit";
        <%
                        ArrayList parentOrgUnitList = orgunitCtrl.getChildOrgUnit(0);
                        for (int i = 0; i < parentOrgUnitList.size(); i++) {
                            OrgUnit orgunit = (OrgUnit)parentOrgUnitList.get(i);%>
                                    var tmpSubNode = new YAHOO.widget.TextNode({label:"<%=ResourceUtil.convertSymbol(orgunit.getName())%>", id:"<%=orgunit.getId()%>"}, tmpNode);
                                    tmpSubNode.labelStyle = "icon-orgunit";
        <%
                            ArrayList secondChildList = orgunitCtrl.getChildOrgUnit(orgunit.getId());
                            for (int j=0; j< secondChildList.size(); j++){
                            
                                OrgUnit secondlorgunit = (OrgUnit)secondChildList.get(j); %>
                                        var tmpSecondSubNode = new YAHOO.widget.TextNode({label:"<%=ResourceUtil.convertSymbol(secondlorgunit.getName())%>", id:"<%=secondlorgunit.getId()%>"}, tmpSubNode);
                                        tmpSecondSubNode.labelStyle = "icon-orgunit";
        <% 
                                ArrayList thirdChildList = orgunitCtrl.getChildOrgUnit(secondlorgunit.getId());
                                for (int k=0; k< thirdChildList.size(); k++){
                                
                                    OrgUnit thirdlorgunit = (OrgUnit)thirdChildList.get(k); %>
                                            var tmpThirdSubNode = new YAHOO.widget.TextNode({label:"<%=ResourceUtil.convertSymbol(thirdlorgunit.getName())%>", id:"<%=thirdlorgunit.getId()%>"}, tmpSecondSubNode);
                                            tmpThirdSubNode.labelStyle = "icon-orgunit";
        <%
                                    ArrayList fourthChildList = orgunitCtrl.getChildOrgUnit(thirdlorgunit.getId());
                                    for (int l=0; l<fourthChildList.size(); l++){
                                    
                                        OrgUnit fourthlorgunit = (OrgUnit)fourthChildList.get(l); %>
                                                var tmpFourthSubNode = new YAHOO.widget.TextNode({label:"<%=ResourceUtil.convertSymbol(fourthlorgunit.getName())%>", id:"<%=fourthlorgunit.getId()%>"}, tmpThirdSubNode);
                                                tmpFourthSubNode.labelStyle = "icon-orgunit";
        <%  
                                        ArrayList fifthChildList = orgunitCtrl.getChildOrgUnit(fourthlorgunit.getId());
                                        for(int m=0; m<fifthChildList.size(); m++){
                                        
                                            OrgUnit fifthlorgunit = (OrgUnit)fifthChildList.get(m); %>
                                                    var tmpFifthSubNode = new YAHOO.widget.TextNode({label:"<%=ResourceUtil.convertSymbol(fifthlorgunit.getName())%>", id:"<%=fifthlorgunit.getId()%>"}, tmpFourthSubNode);
                                                    tmpFifthSubNode.labelStyle = "icon-orgunit";
        <% }
                                }
                            }}}
        %>
                tree.draw();

                tree.subscribe("expand", function(node) {
                    if(node.data.id != 0){
                        var orgunitId = node.data.id;
                        document.getElementById("hidOrgUnitId").value= orgunitId;
                        $('#iorgunit').attr('src', "orgunitdetail.jsp?type="+type+"&subtype="+subtype+"&orgunitId="+orgunitId);
                        //window.frames["iorgunit"].location.href = "orgunitdetail.jsp?type="+type+"&subtype="+subtype+"&orgunitId="+orgunitId;
                    }
                    else if(node.data.id == 0){
                        var orgunitId = "0";
                        document.getElementById("hidOrgUnitId").value= "0";
                        $('#iorgunit').attr('src', "orgunitdetail.jsp?type="+type+"&subtype="+subtype+"&orgunitId="+orgunitId);
                        //window.frames["iorgunit"].location.href = "orgunitdetail.jsp?type="+type+"&subtype="+subtype+"&orgunitId="+orgunitId;
                    }
                });

                tree.subscribe("collapse", function(node) {
                    if(node.data.id != 0){
                        var orgunitId = node.data.id;
                        document.getElementById("hidOrgUnitId").value= orgunitId;
                        $('#iorgunit').attr('src', "orgunitdetail.jsp?type="+type+"&subtype="+subtype+"&orgunitId="+orgunitId);
                        //window.frames["iorgunit"].location.href = "orgunitdetail.jsp?type="+type+"&subtype="+subtype+"&orgunitId="+orgunitId;
                    }
                    else if(node.data.id == 0){
                        var orgunitId = "0";
                        document.getElementById("hidOrgUnitId").value= "0";
                        $('#iorgunit').attr('src', "orgunitdetail.jsp?type="+type+"&subtype="+subtype+"&orgunitId="+orgunitId);
                        //window.frames["iorgunit"].location.href = "orgunitdetail.jsp?type="+type+"&subtype="+subtype+"&orgunitId="+orgunitId;
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
                        <input type="hidden" id="hidOrgUnitId" name="hidOrgUnitId" value=""></input>
                    </td>
                    <td class="orgtable" valign="top">
                        <iframe id="iorgunit" name="iorgunit" MARGINHEIGHT="0" MARGINWIDTH="0" FRAMEBORDER="0" SRC="orgunitdetail.jsp" width=100% height="420px"></iframe>
                    </td>
                </tr>
            </table>
        </div>
    </body>
</html>
<%@ include file="../include/footer.jsp" %>
