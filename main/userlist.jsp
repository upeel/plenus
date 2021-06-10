<%-- 
    Document   : userlist
    Created on : Aug 31, 2010, 10:42:18 AM
    Author     : Hnaye
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import = "com.bizmann.product.entity.OrgUnit"
         import = "com.bizmann.product.entity.*"
         import = "com.bizmann.product.controller.*"
         import = "com.bizmann.product.resources.*"
         import = "java.util.ArrayList"
         import = "java.lang.*" %>
<%
    UserOUDesignationController useroudesignationCtrl = new UserOUDesignationController();
    OrgUnitController orgunitCtrl = new OrgUnitController();
    OrgChartController ocCtrl = new OrgChartController();
    UserController uCtrl = new UserController();

    String chkAdmin = "";
    if (request.getParameter("ckadmin") != null) {
        chkAdmin = request.getParameter("ckadmin");
    }
    String action = "";
    String parentid = "0";
    String childid = "0";
    if (request.getParameter("action") != null) {
        action = request.getParameter("action");
    }
    if (action.equals("Submit")) {
        parentid = request.getParameter("hidParentId");
        childid = request.getParameter("hidChildId");
    }
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
        <style type="text/css">
            .icon-orgunit { display:block; height: 23px; padding-left: 0px; background: transparent 0 0px no-repeat; }
            .icon-user { display:block; height: 23px; padding-left: 20px; background: transparent url(images/user-icon.png) 0 0px no-repeat; }
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

                OrgUnit orgunit = (OrgUnit) parentOrgUnitList.get(i);
                String orgunitname = orgunit.getName();
        %>
                var tmpSubNode = new YAHOO.widget.TextNode({label:"<%=ResourceUtil.convertSymbol(orgunit.getName())%>", id:"O<%=orgunit.getId()%>"}, tmpNode);
                tmpSubNode.labelStyle = "icon-orgunit";
        <%
            ArrayList userList = useroudesignationCtrl.getAllUserOU();
            for (int j = 0; j < userList.size(); j++) {
                UserOUDesignation useroudes = (UserOUDesignation) userList.get(j);
                int orgid = orgunit.getId();
                int manager = orgunit.getManager();
                int uorgid = useroudes.getOrgUnitid();
                int userid = useroudes.getUserid();
                String staffname = uCtrl.getUserNameById(userid);
                if (orgid == uorgid) {%>
                        var tmpFirstUSubNode = new YAHOO.widget.TextNode({label: "<%=ResourceUtil.convertSymbol(staffname)%>", id: "U<%=useroudes.getUserid()%>"}, tmpSubNode);
                        tmpFirstUSubNode.labelStyle = "icon-user";
        <%
                }
            }%>
        <%
            ArrayList secondChildList = orgunitCtrl.getChildOrgUnit(orgunit.getId());
            for (int j = 0; j < secondChildList.size(); j++) {

                OrgUnit secondlorgunit = (OrgUnit) secondChildList.get(j);
                orgunitname = secondlorgunit.getName();
        %>
                var tmpSecondSubNode = new YAHOO.widget.TextNode({label:"<%=ResourceUtil.convertSymbol(secondlorgunit.getName())%>", id:"O<%=secondlorgunit.getId()%>"}, tmpSubNode);
                tmpSecondSubNode.labelStyle = "icon-orgunit";
        <%
            ArrayList seconduserList = useroudesignationCtrl.getAllUserOU();
            for (int k = 0; k < seconduserList.size(); k++) {
                UserOUDesignation seconduseroudes = (UserOUDesignation) seconduserList.get(k);
                int orgid = secondlorgunit.getId();
                int manager = secondlorgunit.getManager();
                int uorgid = seconduseroudes.getOrgUnitid();
                int userid = seconduseroudes.getUserid();
                String staffname = uCtrl.getUserNameById(userid);
                if (orgid == uorgid) {%>
                        var tmpSecondUSubNode = new YAHOO.widget.TextNode({label: "<%=ResourceUtil.convertSymbol(staffname)%>", id: "U<%=seconduseroudes.getUserid()%>"}, tmpSecondSubNode);
                        tmpSecondUSubNode.labelStyle = "icon-user";
        <%
                }
            }

            ArrayList thirdChildList = orgunitCtrl.getChildOrgUnit(secondlorgunit.getId());
            for (int k = 0; k < thirdChildList.size(); k++) {

                OrgUnit thirdlorgunit = (OrgUnit) thirdChildList.get(k);
                orgunitname = thirdlorgunit.getName();
        %>
                var tmpThirdSubNode = new YAHOO.widget.TextNode({label:"<%=ResourceUtil.convertSymbol(thirdlorgunit.getName())%>", id:"O<%=thirdlorgunit.getId()%>"}, tmpSecondSubNode);
                tmpThirdSubNode.labelStyle = "icon-orgunit";
        <%
            ArrayList thirduserList = useroudesignationCtrl.getAllUserOU();
            for (int l = 0; l < thirduserList.size(); l++) {
                UserOUDesignation useroudes = (UserOUDesignation) thirduserList.get(l);
                int orgid = thirdlorgunit.getId();
                int manager = thirdlorgunit.getManager();
                int uorgid = useroudes.getOrgUnitid();
                int userid = useroudes.getUserid();
                String staffname = uCtrl.getUserNameById(userid);
                if (orgid == uorgid) {%>
                        var tmpThirdUSubNode = new YAHOO.widget.TextNode({label: "<%=ResourceUtil.convertSymbol(staffname)%>", id: "U<%=useroudes.getUserid()%>"}, tmpThirdSubNode);
                        tmpThirdUSubNode.labelStyle = "icon-user";
        <%
                }
            }%>
        <%
            ArrayList fourthChildList = orgunitCtrl.getChildOrgUnit(thirdlorgunit.getId());
            for (int l = 0; l < fourthChildList.size(); l++) {

                OrgUnit fourthlorgunit = (OrgUnit) fourthChildList.get(l);
                orgunitname = fourthlorgunit.getName();
        %>
                var tmpFourthSubNode = new YAHOO.widget.TextNode({label:"<%=ResourceUtil.convertSymbol(orgunitname)%>", id:"O<%=fourthlorgunit.getId()%>"}, tmpThirdSubNode);
                tmpFourthSubNode.labelStyle = "icon-orgunit";
        <%
            ArrayList fourthuserList = useroudesignationCtrl.getAllUserOU();
            for (int m = 0; m < fourthuserList.size(); m++) {
                UserOUDesignation useroudes = (UserOUDesignation) fourthuserList.get(m);
                int orgid = fourthlorgunit.getId();
                int manager = fourthlorgunit.getManager();
                int uorgid = useroudes.getOrgUnitid();
                int userid = useroudes.getUserid();
                String staffname = uCtrl.getUserNameById(userid);
                if (orgid == uorgid) {%>
                        var tmpFourthUSubNode = new YAHOO.widget.TextNode({label: "<%=ResourceUtil.convertSymbol(staffname)%>", id: "U<%=useroudes.getUserid()%>"}, tmpFourthSubNode);
                        tmpFourthUSubNode.labelStyle = "icon-user";
        <%
                }
            }%>
        <%
            ArrayList fifthChildList = orgunitCtrl.getChildOrgUnit(fourthlorgunit.getId());
            for (int m = 0; m < fifthChildList.size(); m++) {

                OrgUnit fifthlorgunit = (OrgUnit) fifthChildList.get(m);
                orgunitname = fifthlorgunit.getName();
        %>
                var tmpFifthSubNode = new YAHOO.widget.TextNode({label:"<%=ResourceUtil.convertSymbol(orgunitname)%>", id:"O<%=fifthlorgunit.getId()%>"}, tmpFourthSubNode);
                tmpFifthSubNode.labelStyle = "icon-orgunit";
        <%
            ArrayList fifthuserList = useroudesignationCtrl.getAllUserOU();
            for (int n = 0; n < fifthuserList.size(); n++) {
                UserOUDesignation useroudes = (UserOUDesignation) fifthuserList.get(n);
                int orgid = fifthlorgunit.getId();
                int manager = fifthlorgunit.getManager();
                int uorgid = useroudes.getOrgUnitid();
                int userid = useroudes.getUserid();
                String staffname = uCtrl.getUserNameById(userid);
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
                        var username=node.data.label;
                        var ouname=node.parent.label;                        
                        document.getElementById("hidChildId").value= childId;
                        document.getElementById("hidParentId").value = parentId;
                        document.getElementById("hidusername").value=username;
                        document.getElementById("hidouname").value=ouname;
                        //document.location.href="userlist.jsp?action=Submit&parentid="+parentId+"&childid="+childId;
                    }
                    else if(node.data.id == 0){
                        var childId = node.data.id;
                        var parentId = 0;
                        var username=node.data.label;
                        var ouname="";                       
                        document.getElementById("hidChildId").value = childId;
                        document.getElementById("hidParentId").value = parentId;
                        document.getElementById("hidusername").value=username;
                        document.getElementById("hidouname").value=ouname;
                        //document.location.href="userlist.jsp?action=Submit&parentid="+parentId+"&childid="+childId;
                    }
                });

                tree.subscribe("collapse", function(node) {
                    if(node.data.id != 0){
                        var childId = node.data.id;
                        var parentId = node.parent.data.id;
                        var username=node.data.label;
                        var ouname=node.parent.label;                       
                        document.getElementById("hidChildId").value= childId;
                        document.getElementById("hidParentId").value = parentId;
                        document.getElementById("hidusername").value=username;
                        document.getElementById("hidouname").value=ouname;
                        //document.location.href="userlist.jsp?action=Submit&parentid="+parentId+"&childid="+childId;
                    }
                    else if(node.data.id == 0){
                        var childId = node.data.id;
                        var parentId = 0;
                        var username=node.data.label;
                        var ouname="";                        
                        document.getElementById("hidChildId").value = childId;
                        document.getElementById("hidParentId").value = parentId;
                        document.getElementById("hidusername").value=username;
                        document.getElementById("hidouname").value=ouname;
                        //document.location.href="userlist.jsp?action=Submit&parentid="+parentId+"&childid="+childId;
                    }
                });          
            }        
        
            function fnOnload(){
           
            }
            function fnSubmit(){
                var vckadmin="<%=chkAdmin%>";            
                var pId=document.getElementById("hidParentId").value;
                var cId=document.getElementById("hidChildId").value;
                var firstcId=cId.charAt(0);            
                var orgname=document.getElementById("hidouname").value;            
                var uname=document.getElementById("hidusername").value;
                if(vckadmin=="true"){               
                    if(pId=="0"){
                        alert("Select User to forward process");
                        window.focus();
                    }else{
                        if(firstcId=="O"){
                            alert("Please select user");
                        }else{
                            opener.fnSetUserForAdmin(cId,pId,uname,orgname);
                            window.close();
                        }
                        // alert(pId+" "+cId+" "+uname+" "+orgname);
                    }
                }else{
                    if(pId=="0"){
                        alert("Select User to forward process");
                        window.focus();
                    }else{
                        if(firstcId=="O"){
                            alert("Please select user");
                        }else{
                            opener.fnSetUser(cId,pId,uname,orgname);
                            window.close();
                        }
                        //alert(pId+" "+cId+" "+uname+" "+orgname);                
                    }
                }
            }
            YAHOO.util.Event.onDOMReady(init);
    </script>
    <body onload="fnOnload()">
        <form action="userlist.jsp" method="post" name="frmuserlist">
            <input type="hidden" name="hidParentId" id="hidParentId" value=""/>
            <input type="hidden" name="hidChildId" id="hidChildId" value=""/>
            <input type="hidden" name="hidouname" id="hidouname" value=""/>
            <input type="hidden" name="hidusername" id="hidusername" value=""/>
            <div align="center" style="vertical-align: top">
                <table width="100%" height="500px" background="../images/background.png">
                    <tr>
                        <td valign="top">
                            <div id="treediv" class="treediv"></div>
                        </td>
                    </tr>
                    <tr>
                        <td align="right"><input type="button" value="Submit" name="action" onclick="fnSubmit()" /></td>
                    </tr>
                </table>
            </div>
        </form>
    </body>
</html>
