<%-- 
    Document   : user.jsp
    Created on : Feb 20, 2009, 5:01:33 PM
    Author     : Tan Chiu Ping
    Co-author  : Ella
--%>

<%@ page import = "com.bizmann.product.entity.OrgUnit"
         import = "com.bizmann.product.entity.UserOUDesignation"
         import = "com.bizmann.product.controller.OrgUnitController"
         import = "com.bizmann.product.controller.OrgChartController"
         import = "com.bizmann.product.controller.UserOUDesignationController"
         import = "com.bizmann.product.controller.UserController"
         import = "com.bizmann.product.resources.*"
         import = "java.util.ArrayList"
         import = "java.lang.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/menu.jsp" %>
<%
    //System.out.println("1: " + System.currentTimeMillis() / 1000L);
    UserOUDesignationController useroudesignationCtrl = new UserOUDesignationController();
    OrgUnitController orgunitCtrl = new OrgUnitController();
    OrgChartController ocCtrl = new OrgChartController();
    UserController uCtrl = new UserController();
    ArrayList mainuserList = useroudesignationCtrl.getAllUserOU();
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
        <script src="../include/js/jquery-1.10.2.js"></script>
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
            
        function init(){
            tree = new YAHOO.widget.TreeView("treediv");
            root = tree.getRoot();
            tmpNode = new YAHOO.widget.TextNode({ label: "<b><%=ResourceUtil.convertSymbol(ocCtrl.getActiveOC())%></b>", id:"0" }, root, true);
            tmpNode.labelStyle="icon-orgunit";

        <%
            ArrayList parentOrgUnitList = orgunitCtrl.getChildOrgUnit(0);
            for (int i = 0; i < parentOrgUnitList.size(); i++) {
                OrgUnit orgunit = (OrgUnit) parentOrgUnitList.get(i);
        %>
                        var tmpSubNode = new YAHOO.widget.TextNode({label:"<%=ResourceUtil.convertSymbol(orgunit.getName())%>", id:"O<%=orgunit.getId()%>"}, tmpNode);
                        tmpSubNode.labelStyle = "icon-orgunit";
        <%
            ArrayList userList = mainuserList; //useroudesignationCtrl.getAllUserOU();
            for (int j = 0; j < userList.size(); j++) {
                UserOUDesignation useroudes = (UserOUDesignation) userList.get(j);
                int orgid = orgunit.getId();
                int manager = orgunit.getManager();
                int uorgid = useroudes.getOrgUnitid();
                int userid = useroudes.getUserid();
                String staffname = useroudes.getUserName();
                //String staffname = uCtrl.getUserNameById(userid);

                if (orgid == uorgid) {%>
                        var tmpFirstUSubNode = new YAHOO.widget.TextNode({label: "<%=ResourceUtil.convertSymbol(staffname)%>", id: "U<%=useroudes.getUserid()%>"}, tmpSubNode);
                        tmpFirstUSubNode.labelStyle = "icon-user";
        <%
                }
            }%>
        <%
            ArrayList secondChildList = orgunitCtrl.getChildOrgUnit(orgunit.getId());
            for (int j = 0; j < secondChildList.size(); j++) {

                OrgUnit secondlorgunit = (OrgUnit) secondChildList.get(j);%>
                        var tmpSecondSubNode = new YAHOO.widget.TextNode({label:"<%=ResourceUtil.convertSymbol(secondlorgunit.getName())%>", id:"O<%=secondlorgunit.getId()%>"}, tmpSubNode);
                        tmpSecondSubNode.labelStyle = "icon-orgunit";
        <%
            ArrayList seconduserList = mainuserList; //useroudesignationCtrl.getAllUserOU();
            for (int k = 0; k < seconduserList.size(); k++) {
                UserOUDesignation seconduseroudes = (UserOUDesignation) seconduserList.get(k);
                int orgid = secondlorgunit.getId();
                int manager = secondlorgunit.getManager();
                int uorgid = seconduseroudes.getOrgUnitid();
                int userid = seconduseroudes.getUserid();
                String staffname = seconduseroudes.getUserName();
                //String staffname = uCtrl.getUserNameById(userid);

                if (orgid == uorgid) {%>
                        var tmpSecondUSubNode = new YAHOO.widget.TextNode({label: "<%=ResourceUtil.convertSymbol(staffname)%>", id: "U<%=seconduseroudes.getUserid()%>"}, tmpSecondSubNode);
                        tmpSecondUSubNode.labelStyle = "icon-user";
        <%
                }
            }

            ArrayList thirdChildList = orgunitCtrl.getChildOrgUnit(secondlorgunit.getId());
            for (int k = 0; k < thirdChildList.size(); k++) {

                OrgUnit thirdlorgunit = (OrgUnit) thirdChildList.get(k);%>
                        var tmpThirdSubNode = new YAHOO.widget.TextNode({label:"<%=ResourceUtil.convertSymbol(thirdlorgunit.getName())%>", id:"O<%=thirdlorgunit.getId()%>"}, tmpSecondSubNode);
                        tmpThirdSubNode.labelStyle = "icon-orgunit";
        <%
            ArrayList thirduserList = mainuserList; // useroudesignationCtrl.getAllUserOU();
            for (int l = 0; l < thirduserList.size(); l++) {
                UserOUDesignation useroudes = (UserOUDesignation) thirduserList.get(l);
                int orgid = thirdlorgunit.getId();
                int manager = thirdlorgunit.getManager();
                int uorgid = useroudes.getOrgUnitid();
                int userid = useroudes.getUserid();
                String staffname = useroudes.getUserName();
                //String staffname = uCtrl.getUserNameById(userid);

                if (orgid == uorgid) {%>
                        var tmpThirdUSubNode = new YAHOO.widget.TextNode({label: "<%=ResourceUtil.convertSymbol(staffname)%>", id: "U<%=useroudes.getUserid()%>"}, tmpThirdSubNode);
                        tmpThirdUSubNode.labelStyle = "icon-user";
        <%
                }
            }%>
        <%
            ArrayList fourthChildList = orgunitCtrl.getChildOrgUnit(thirdlorgunit.getId());
            for (int l = 0; l < fourthChildList.size(); l++) {

                OrgUnit fourthlorgunit = (OrgUnit) fourthChildList.get(l);%>
                        var tmpFourthSubNode = new YAHOO.widget.TextNode({label:"<%=ResourceUtil.convertSymbol(fourthlorgunit.getName())%>", id:"O<%=fourthlorgunit.getId()%>"}, tmpThirdSubNode);
                        tmpFourthSubNode.labelStyle = "icon-orgunit";
        <%
            ArrayList fourthuserList = mainuserList; //useroudesignationCtrl.getAllUserOU();
            for (int m = 0; m < fourthuserList.size(); m++) {
                UserOUDesignation useroudes = (UserOUDesignation) fourthuserList.get(m);
                int orgid = fourthlorgunit.getId();
                int manager = fourthlorgunit.getManager();
                int uorgid = useroudes.getOrgUnitid();
                int userid = useroudes.getUserid();
                String staffname = useroudes.getUserName();
                //String staffname = uCtrl.getUserNameById(userid);

                if (orgid == uorgid) {%>
                        var tmpFourthUSubNode = new YAHOO.widget.TextNode({label: "<%=ResourceUtil.convertSymbol(staffname)%>", id: "U<%=useroudes.getUserid()%>"}, tmpFourthSubNode);
                        tmpFourthUSubNode.labelStyle = "icon-user";
        <%
                }
            }%>
        <%
            ArrayList fifthChildList = orgunitCtrl.getChildOrgUnit(fourthlorgunit.getId());
            for (int m = 0; m < fifthChildList.size(); m++) {

                OrgUnit fifthlorgunit = (OrgUnit) fifthChildList.get(m);%>
                        var tmpFifthSubNode = new YAHOO.widget.TextNode({label:"<%=ResourceUtil.convertSymbol(fifthlorgunit.getName())%>", id:"O<%=fifthlorgunit.getId()%>"}, tmpFourthSubNode);
                        tmpFifthSubNode.labelStyle = "icon-orgunit";
        <%
            ArrayList fifthuserList = mainuserList; //useroudesignationCtrl.getAllUserOU();
            for (int n = 0; n < fifthuserList.size(); n++) {
                UserOUDesignation useroudes = (UserOUDesignation) fifthuserList.get(n);
                int orgid = fifthlorgunit.getId();
                int manager = fifthlorgunit.getManager();
                int uorgid = useroudes.getOrgUnitid();
                int userid = useroudes.getUserid();
                String staffname = useroudes.getUserName();
                //String staffname = uCtrl.getUserNameById(userid);

                if (orgid == uorgid) {%>
                        var tmpFifthUSubNode = new YAHOO.widget.TextNode({label: "<%=ResourceUtil.convertSymbol(staffname)%>", id: "U<%=useroudes.getUserid()%>"}, tmpFifthSubNode);
                        tmpFifthUSubNode.labelStyle = "icon-user";
        <%
                }
            }%>
        <% }
                        }
                    }
                }
            }
        %>


                tree.draw();

                tree.subscribe("expand", function(node) {
                    if(node.data.id != 0){
                        var childId = node.data.id;
                        var parentId = node.parent.data.id;
                        document.getElementById("hidChildId").value= childId;
                        document.getElementById("hidParentId").value = parentId;
                        $('#iuser').attr('src', "userdetail.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId);
                        //window.frames["iuser"].location.href = "userdetail.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId;
                        //document.frames("iuser").location.href = "userdetail.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId;
                    }
                    else if(node.data.id == 0){
                        var childId = node.data.id;
                        var parentId = 0;
                        document.getElementById("hidChildId").value = childId;
                        document.getElementById("hidParentId").value = parentId;
                        $('#iuser').attr('src', "userdetail.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId);
                        //window.frames["iuser"].location.href = "userdetail.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId;
                        //document.frames("iuser").location.href = "userdetail.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId;
                    }
                });

                tree.subscribe("collapse", function(node) {
                    if(node.data.id != 0){
                        var childId = node.data.id;
                        var parentId = node.parent.data.id;
                        document.getElementById("hidChildId").value= childId;
                        document.getElementById("hidParentId").value = parentId;
                        $('#iuser').attr('src', "userdetail.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId);
                        //window.frames["iuser"].location.href = "userdetail.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId;
                        //document.frames("iuser").location.href = "userdetail.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId;
                    }
                    else if(node.data.id == 0){
                        var childId = node.data.id;
                        var parentId = 0;
                        document.getElementById("hidChildId").value = childId;
                        document.getElementById("hidParentId").value = parentId;
                        $('#iuser').attr('src', "userdetail.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId);
                        //window.frames["iuser"].location.href = "userdetail.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId;
                        //document.frames("iuser").location.href = "userdetail.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId;
                    }
                });
            }

            YAHOO.util.Event.onDOMReady(init);

    </script>
<!--onload="hideDivs()" onbeforeunload="showDivs();"-->
    <body  >
<!--        <div id="dvLoading"></div>
        <div id="overlay" class="web_dialog_overlay"></div>-->
        <div align="center" valign="top">
            <table width="980px" height="420px" background="../images/background.png">
                <tr>
                    <td class="orgtable" valign="top" width="300">
                        <%@ include file="../include/tmenu.jsp" %>
                        <div id="treediv" class="treediv"></div>
                    </td>
                    <td class="orgtable" valign="top">
                        <iframe ID="iuser" MARGINHEIGHT="0" MARGINWIDTH="0" FRAMEBORDER="0" SRC="designationdetail.jsp" width=100% height="420px"></iframe>
                    </td>
                </tr>
            </table>
        </div>
        <!-- Store the value of the selected footer id -->
        <input type="hidden" id="hidParentId" name="hidParentId" value=""></input>
        <input type="hidden" id="hidChildId" name="hidChildId" value=""></input>
    </body>
</html>
<% //System.out.println("last: " + System.currentTimeMillis() / 1000L);%>
<%@ include file="../include/footer.jsp" %>