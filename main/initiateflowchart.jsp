<%--
    Document   : initiate
    Created on : Nov 6, 2009, 2:59:34 PM
    Author     : Joryn
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%@page import = "com.bizmann.product.controller.*"
        import = "com.bizmann.product.resources.*"
        import = "com.bizmann.product.entity.*"
        import = "com.bizmann.external.form.controller.*"
        import = "java.util.ArrayList"%>

<%
    String userId = request.getParameter("userId");
    if (userId == null) {
        userId = "";
    }

    String flowChartName = request.getParameter("flowChartName");
    if (flowChartName == null) {
        flowChartName = "";
    }

    String orgUnitId = request.getParameter("orgUnitId");
    if (orgUnitId == null) {
        orgUnitId = "";
    }

    String action = request.getParameter("action");
    if (action == null) {
        action = "";
    }

    String processId = request.getParameter("processId");
    if (processId == null) {
        processId = "";
    }

    EngineFlowChartController engineFlowChartCtrl = new EngineFlowChartController();
    NewEngineController newEngineCtrl = new NewEngineController();

    int flowChartId = engineFlowChartCtrl.getFlowChartId(flowChartName);

    String toclose = "";
    int oustanding_count = newEngineCtrl.getOustandingCount(Integer.parseInt(userId), flowChartId);
    //System.out.println(oustanding_count);
    if (oustanding_count < 1) {
        if (action.equals("initiateflowchart")) {
            //Insert record into process table
            ProcessController processCtrl = new ProcessController();
            processId = Integer.toString(processCtrl.insertProcessInfo(flowChartId, Integer.parseInt(userId), Integer.parseInt(orgUnitId)));

            String currentActivity = newEngineCtrl.getStartAction(flowChartId);
            EngineActionController engineActionCtrl = new EngineActionController();
            EngineAction engineAction = engineActionCtrl.getAction(currentActivity, flowChartId);
            int actionId = engineAction.getId();

            //Insert record into activity table
            NewActivityController activityCtrl = new NewActivityController();
            ArrayList participantList = new ArrayList();
            participantList.add(userId);
            activityCtrl.insertActivity(participantList, Integer.parseInt(userId), Integer.parseInt(orgUnitId), Integer.parseInt(processId), actionId);
            //activityCtrl.addActivity(participant, Integer.parseInt(userId), Integer.parseInt(orgUnitId), Integer.parseInt(processId), actionId, 0, "Complete");

            boolean isforward = false;
            ForwardController fwCtrl = new ForwardController();
            for (int i = 0; i < participantList.size(); i++) {
                String tempUserId = (String) participantList.get(i);
                String fwuserid = fwCtrl.checkForward(Integer.parseInt(tempUserId), Integer.parseInt(processId));

                if (!fwuserid.equals("0")) {
                    isforward = true;
                    activityCtrl.updateActivityForForward(Integer.parseInt(tempUserId), fwuserid, Integer.parseInt(processId));
                }
                if (isforward) {

                    Activity act = new Activity();
                    act.setActionId(actionId);
                    act.setFrom(Integer.parseInt(tempUserId));
                    fwCtrl.setForward(act, fwuserid, Integer.parseInt(processId));
                    isforward = false;
                }
            }

            //forward process
            //based on the list of next participant, check who are absent and assign the task to the designated person as well
            for (int i = 0; i < participantList.size(); i++) {
                String tempUserId = (String) participantList.get(i);
                AbsenceController absenceCtrl = new AbsenceController();
                boolean isAbsence = absenceCtrl.checkAbsence(Integer.parseInt(tempUserId));

                if (isAbsence) {
                    //update the designatedid in activity table
                    activityCtrl.updateActivityForAbsentee(Integer.parseInt(tempUserId), Integer.parseInt(processId), actionId);
                }
            }

            String externalFormPath = new ExternalFormController().isExternalForm(flowChartId, actionId);
            if (externalFormPath != null) {
                response.sendRedirect("../externalform/" + externalFormPath + "?processId=" + processId + "&flowChartId=" + flowChartId + "&actionId=" + actionId + "&userId=" + userId);
            } else {
                response.sendRedirect("formaction.jsp?processId=" + processId + "&flowChartId=" + flowChartId + "&actionId=" + actionId + "&userId=" + userId);
            }
        }
    } else {
        toclose = "alert('Please use the oustanding empty process first!');self.close();";
    }
%>

<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>bmFLO</title>
    </head>
    <body>
    </body>
    <script>
        <%=toclose%>
    </script>
</html>