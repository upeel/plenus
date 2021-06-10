<%--
   Document   : authgrpchart.jsp
   Created on : Jul 23, 2009, 3:27:40 PM
   Author     : NooNYUki
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<%@ include file="../include/header.jsp" %>
<%@ include file="../include/menu.jsp" %>
<%@ page import = "com.bizmann.product.entity.Subfunc"
         import = "com.bizmann.product.entity.AuthGrp"
         import = "com.bizmann.product.controller.SubfuncController"
         import = "com.bizmann.product.controller.AuthGrpFuncController"
         import = "com.bizmann.product.controller.AuthGrpController"
         import = "java.util.ArrayList"
         import = "java.lang.*" %>
<%
        AuthGrpFuncController authgrpfuncCtrl = new AuthGrpFuncController();
        SubfuncController subfuncCtrl = new SubfuncController();
        Subfunc org = new Subfunc();
        Subfunc design = new Subfunc();
        Subfunc proses = new Subfunc();
        Subfunc dash = new Subfunc();

        ArrayList orgmgmtlist = subfuncCtrl.getSubfuncByFuncid(1);
        ArrayList designmgmtlist = subfuncCtrl.getSubfuncByFuncid(2);
        ArrayList prosesmgmtlist = subfuncCtrl.getSubfuncByFuncid(3);
        ArrayList dashmgmtlist = subfuncCtrl.getSubfuncByFuncid(4);

        ArrayList orgauthlist = authgrpfuncCtrl.getAuthGrpByFunc(1);
        ArrayList designauthlist = authgrpfuncCtrl.getAuthGrpByFunc(2);
        ArrayList prosesauthlist = authgrpfuncCtrl.getAuthGrpByFunc(3);
        ArrayList dashboardauthlist = authgrpfuncCtrl.getAuthGrpByFunc(4);

        //for first table
        int[] intarr = {orgmgmtlist.size(), designmgmtlist.size(), prosesmgmtlist.size(), dashmgmtlist.size()};
        int largest = 0;

        //get largest size of four arrays.
        for(int i = 0; i<intarr.length; i++){
            if(intarr[i]>largest){
                largest = intarr[i];
            }
        }

        int diff = 0;
        if(orgmgmtlist.size()<largest){
            diff = largest - orgmgmtlist.size();
            for (int i = 0; i<diff; i++){
                org = new Subfunc();
                orgmgmtlist.add(org);
            }
        }

        if(designmgmtlist.size()<largest){
            diff = largest - designmgmtlist.size();
            for (int i = 0; i<diff; i++){
                design = new Subfunc();
                designmgmtlist.add(design);
            }
        }

        if(prosesmgmtlist.size()<largest){
            diff = largest - prosesmgmtlist.size();
            for (int i = 0; i<diff; i++){
                proses = new Subfunc();
                prosesmgmtlist.add(proses);
            }
        }

        if(dashmgmtlist.size()<largest){
            diff = largest - dashmgmtlist.size();
            for (int i = 0; i<diff; i++){
                dash = new Subfunc();
                dashmgmtlist.add(proses);
            }
        }

        //for second table
        int[] iarray = {orgauthlist.size(), designauthlist.size(), prosesauthlist.size(), dashboardauthlist.size()};
        int max = 0;

        //get largest size of four arrays.
        for(int i = 0; i<iarray.length; i++){
            if(iarray[i]>max){
                max = iarray[i];
            }
        }

        int excess = 0;
        if(orgauthlist.size()<max){
            excess = max - orgauthlist.size();
            for (int i = 0; i<excess; i++){
                String str = " ";
                orgauthlist.add(str);
            }
        }

        if(designauthlist.size()<max){
            excess = max - designauthlist.size();
            for (int i = 0; i<excess; i++){
                String str = " ";
                designauthlist.add(str);
            }
        }

        if(prosesauthlist.size()<max){
            excess = max - prosesauthlist.size();
            for (int i = 0; i<excess; i++){
                String str = " ";
                prosesauthlist.add(str);
            }
        }

         if(dashboardauthlist.size()<max){
            excess = max - dashboardauthlist.size();
            for (int i = 0; i<excess; i++){
                String str = " ";
                dashboardauthlist.add(str);
            }
        }
        
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>bmFLO</title>
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/datatable.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/datatable/assets/skins/sam/datatable.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/paginator/assets/skins/sam/paginator.css" />
        <script type="text/javascript" src="../include/js/yui/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="../include/js/yui/element/element-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/datasource/datasource-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/datatable/datatable-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/paginator/paginator-min.js"></script>
        <style>
            .tasktodotable{
                align:center;
            }
        </style>
    </head>

    <body class=" yui-skin-sam">
        <div align="center">
            <table border="0" width="980px" height="420px" background="../images/background.png">
                <tr>
                    <td><br><br>
                        <div class="psadheader" >
                            <b>Functions Chart</b>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td valign="top">
                        <!-- Function Chart -->
                        <div id="taskinit" class="datatable">
                            <table id="taskinittable" class="taskinittable" align="center">
                                <thead>
                                    <tr align="center">
                                        <th>Organization Mgmt</th>
                                        <th>Design Mgmt</th>
                                        <th>Dashboard Mgmt</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                            for(int i =0; i<largest; i++){

                                               org = (Subfunc)orgmgmtlist.get(i);
                                               design = (Subfunc)designmgmtlist.get(i);
                                               dash = (Subfunc)dashmgmtlist.get(i);
                                    %>
                                    <tr>
                                        <td><%=org.getName()%></td>
                                        <td><%=design.getName()%></td>
                                        <td><%=dash.getName()%></td>
                                    </tr>
                                    <%}
                                    %>
                                </tbody>
                            </table>
                        </div>
                        <script type="text/javascript">

                            YAHOO.util.Event.addListener(window, "load", function() {
                                YAHOO.example.EnhanceFromMarkup = function() {
                                    var myColumnDefs = [
                                        {key:"org",label: "Organization Mgmt", sortable:false},
                                        {key:"design",label:"Design Mgmt",sortable:false},
                                        {key:"dashboard", label:"Dashboard Mgmt"}
                                    ];

                                    var taskInitSource = new YAHOO.util.DataSource(YAHOO.util.Dom.get("taskinittable"));
                                    taskInitSource.responseType = YAHOO.util.DataSource.TYPE_HTMLTABLE;
                                    taskInitSource.responseSchema = {
                                        fields: [
                                            {key:"org"},
                                            {key:"design"},
                                            {key:"dashboard"}
                                        ]
                                    };



                                    var taskInitTable = new YAHOO.widget.DataTable("taskinit", myColumnDefs, taskInitSource);

                                    taskInitTable.subscribe("rowMouseoverEvent", taskInitTable.onEventHighlightRow);
                                    taskInitTable.subscribe("rowMouseoutEvent", taskInitTable.onEventUnhighlightRow);
                                    taskInitTable.subscribe("rowClickEvent", taskInitTable.onEventSelectRow);


                                    return {
                                        oDS: taskInitSource,
                                        oDT: taskInitTable
                                    };
                                }();
                            });
                        </script>
                    </td>
                </tr>
                <tr>
                    <td><br><br>
                        <div class="psadheader" >
                            <b>Access Control</b>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <!-- Access Control List -->
                        <div id="tasktodo" class="datatable">
                            <table id="tasktodotable" class="tasktodotable">
                                <thead>
                                    <tr>
                                        <th>Functions/Authority Group</th>
                                        <th>General Administrator</th>
                                        <th>Designer</th>
                                        <th>User</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <tr>
                                        <td>Organization Management</td>
                                        <td>Yes</td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td>Design Management</td>
                                        <td>Yes</td>
                                        <td>Yes</td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td>Dashboard Management</td>
                                        <td>Yes</td>
                                        <td>Yes</td>
                                        <td>Yes</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>


                        <script type="text/javascript">
                            YAHOO.util.Event.addListener(window, "load", function() {
                                YAHOO.example.EnhanceFromMarkup = function() {
                                    var myColumnDefs = [
                                        {key:"functions",label:"Functions/Authority Group"},
                                        {key:"admin",label:"General Administrator"},
                                        {key:"businessadmin",label:"Designer"},
                                        {key:"user",label:"User"}
                                    ];

                                    var taskToDoSource = new YAHOO.util.DataSource(YAHOO.util.Dom.get("tasktodotable"));
                                    taskToDoSource.responseType = YAHOO.util.DataSource.TYPE_HTMLTABLE;
                                    taskToDoSource.responseSchema = {
                                        fields: [
                                            {key:"functions"},
                                            {key:"admin"},
                                            {key:"businessadmin"},
                                            {key:"user"}
                                        ]
                                    };
                                    var taskToDoTable = new YAHOO.widget.DataTable("tasktodo", myColumnDefs, taskToDoSource);

                                    taskToDoTable.subscribe("rowMouseoverEvent", taskToDoTable.onEventHighlightRow);
                                    taskToDoTable.subscribe("rowMouseoutEvent", taskToDoTable.onEventUnhighlightRow);
                                    taskToDoTable.subscribe("rowClickEvent", taskToDoTable.onEventSelectRow);


                                    return {
                                        oDS: taskToDoSource,
                                        oDT: taskToDoTable
                                    };
                                }();
                            });
                        </script>
                        <br><br><br><br>
                    </td>
                </tr>
            </table>
        </div>
    </body>
</html>

<%@ include file="../include/footer.jsp" %>