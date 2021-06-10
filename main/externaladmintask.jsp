<%-- 
    Document   : externaladmintask
    Created on : Jan 21, 2015, 3:12:32 PM
    Author     : SOE HTIKE
--%>

<%@page import = "java.util.*"
    import = "java.lang.*"
    import = "com.bizmann.product.controller.*"
    import = "com.bizmann.product.entity.*"
    import = "com.bizmann.product.resources.*" %>

<%!    AdminTaskController adminTaskCtrl = new AdminTaskController();
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%@ include file="../include/header.jsp" %>
<%@ include file="../include/menu.jsp" %>

<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>bmFLO</title>
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/treeview/assets/skins/sam/treeview.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <script type="text/javascript" src="../include/js/yui/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="../include/js/yui/treeview/treeview-min.js"></script>

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
        ArrayList list = adminTaskCtrl.getAllAdminTask();
    %>

    <script type="text/javascript">
        var tree;
        var tmpNode;

        function init(){
            tree = new YAHOO.widget.TreeView("treediv");
            root = tree.getRoot();
            tmpNode = new YAHOO.widget.TextNode({ label: "<b>External Admin Task</b>", id:"0" }, root);
            tmpNode.labelStyle="icon-orgunit";
            <% for(int i=0; i<list.size() ; i++){
               AdminTask adminTask = (AdminTask)list.get(i);
               %>
               var tmpSubNode = new YAHOO.widget.TextNode({label: "<%=adminTask.getName()%>", id: "<%=adminTask.getId()%>"}, tmpNode);
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
                        var adminTaskId = node.data.id;
                        document.getElementById("hidAdminTaskId").value= adminTaskId;
                        $('#iadmintask').attr('src', "externaladmintaskdetail.jsp?type="+type+"&subtype="+subtype+"&adminTaskId="+adminTaskId);
                        //window.frames["iadmintask"].location.href = "externaladmintaskdetail.jsp?type="+type+"&subtype="+subtype+"&adminTaskId="+adminTaskId;
                        //document.frames("iadmintask").location.href = "admintaskdetail.jsp?type="+type+"&subtype="+subtype+"&adminTaskId="+adminTaskId;
                    }
                    else{
                        document.getElementById("hidAdminTaskId").value= "";
                        $('#iadmintask').attr('src', "externaladmintaskdetail.jsp?type="+type+"&subtype="+subtype+"");
                        //window.frames["iadmintask"].location.href = "externaladmintaskdetail.jsp?type="+type+"&subtype="+subtype+"";
                        //document.frames("iadmintask").location.href = "admintaskdetail.jsp?type="+type+"&subtype="+subtype+"";
                    }
                });

                tree.subscribe("collapse", function(node) {
                    if(node.data.id != 0){
                        var adminTaskId = node.data.id;
                        document.getElementById("hidAdminTaskId").value= adminTaskId;
                        $('#iadmintask').attr('src', "externaladmintaskdetail.jsp?type="+type+"&subtype="+subtype+"&adminTaskId="+adminTaskId);
                        //window.frames["iadmintask"].location.href = "externaladmintaskdetail.jsp?type="+type+"&subtype="+subtype+"&adminTaskId="+adminTaskId;
                        //document.frames("iadmintask").location.href = "admintaskdetail.jsp?type="+type+"&subtype="+subtype+"&adminTaskId="+adminTaskId;
                    }
                    else{
                        document.getElementById("hidAdminTaskId").value= "";
                        $('#iadmintask').attr('src', "externaladmintaskdetail.jsp?type="+type+"&subtype="+subtype+"");
                        //window.frames["iadmintask"].location.href = "externaladmintaskdetail.jsp?type="+type+"&subtype="+subtype+"";
                        //document.frames("iadmintask").location.href = "admintaskdetail.jsp?type="+type+"&subtype="+subtype+"";
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
                        <iframe ID="iadmintask" MARGINHEIGHT="0" MARGINWIDTH="0" FRAMEBORDER="0" SRC="externaladmintaskdetail.jsp" width=100% height="420px"></iframe>
                    </td>
                </tr>
            </table>
        </div>
        <!-- Store the value of the selected footer id -->
        <input type="hidden" id="hidAdminTaskId" name="hidAdminTaskId" value=""></input>
    </body>
</html>

<%@ include file="../include/footer.jsp" %>
