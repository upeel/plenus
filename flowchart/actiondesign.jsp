<%-- 
    Document   : actiondesign
    Created on : Dec 10, 2013, 4:33:58 PM
    Author     : SOE HTIKE
--%>
<%

    String strflowchartId = request.getParameter("flowchartId");
    if (strflowchartId == null) {
        strflowchartId = "0";
    }
    strflowchartId = strflowchartId.trim();
    if (strflowchartId.equals("")) {
        strflowchartId = "0";
    }

    int flowchartId = Integer.parseInt(strflowchartId);
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="../include/js/jquery.ui.touch-punch.min.js"></script>
        <script src="../include/js/jquery-1.10.2.js"></script>
        <script src="../include/jquery-ui-1.10.3/ui/jquery-ui.js"></script>
        <link rel="stylesheet" href="../include/jquery-ui-1.10.3/themes/base/jquery-ui.css" type="text/css" />
        <link rel="stylesheet" href="../include/css/loading.css" type="text/css" />
        <link href="../include/jtable/themes/metro/blue/jtable.min.css" rel="stylesheet" type="text/css" />
        <script src="../include/jtable/jquery.jtable.min.js" type="text/javascript"></script>
        <title>Define Actions</title>
        <script type="text/javascript">
            $(document).ready(function () {
                var vflowChartId = <%=flowchartId%>;
                
                $("#btnActionContinue").click(function() {
                    $( "#btnActionContinue" ).button({ disabled: true });
                    var posting = $.post("createflow.jsp", { flowChartId: vflowChartId} );
                    posting.done(function(data) {
                        $( "#result" ).empty().append( data );
                    });
                });
                
                $('#ActionTableContainer').jtable({
                    title: 'Action List',
                    actions: {
                        listAction: 'actionActions.jsp?action=list&flowChartId='+vflowChartId,
                        createAction: 'actionActions.jsp?action=create&flowChartId='+vflowChartId,
                        updateAction: 'actionActions.jsp?action=update&flowChartId='+vflowChartId,
                        deleteAction: 'actionActions.jsp?action=delete&flowChartId='+vflowChartId
                    },
                    fields: {
                        ActionId: {
                            key: true,
                            create: false,
                            edit: false,
                            list: false
                        },
                        ActionName: {
                            title: 'Action Name',
                            width: '30%'
                        },
                        ActionType: {
                            title: 'Type',
                            width: '10%',
                            options: { 'Decision': 'Decision', 'Null': 'Null', 'BusinessProcess': 'BusinessProcess' }
                        },
                        Participant: {
                            title: 'Participant',
                            width: '20%'
                        },
                        ParticipantRule: {
                            title: 'Participant Rule',
                            width: '10%',
                            options: { 'Individual': 'Individual', 'Group': 'Group' }
                        },
                        ActionForm: {
                            title: 'Form Name',
                            width: '30%'
                        }
                    }
                });
                $('#ActionTableContainer').jtable('load');
            });
        </script>
    </head>
    <body>
        <% if (flowchartId != 0) {%>
        <div id="ActionTableContainer"></div>
        <button id="btnActionContinue" name="btnActionContinue">Continue</button>
        <% } else {%>
        <p>Invalid Access! Access Denied!</p>
        <% }%>
    </body>
</html>
