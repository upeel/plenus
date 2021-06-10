<%@page import="java.util.HashMap"
        import="java.util.Map"
        import="com.bizmann.flowchart.controller.FlowChartDesignerController"
        import="java.util.ArrayList" %>

<%
    try {
        String toDoAction = request.getParameter("action");
        if (toDoAction == null) {
            toDoAction = "";
        }

        String strflowChartId = request.getParameter("flowChartId");
        if (strflowChartId == null || strflowChartId.equals("")) {
            strflowChartId = "0";
        }
        int flowChartId = Integer.parseInt(strflowChartId);

        String strActionId = request.getParameter("ActionId");
        if (strActionId == null || strActionId.equals("")) {
            strActionId = "0";
        }
        int ActionId = Integer.parseInt(strActionId);

        String ActionName = request.getParameter("ActionName");
        if (ActionName == null) {
            ActionName = "";
        }
        String ActionType = request.getParameter("ActionType");
        if (ActionType == null) {
            ActionType = "";
        }
        String Participant = request.getParameter("Participant");
        if (Participant == null) {
            Participant = "";
        }
        String ParticipantRule = request.getParameter("ParticipantRule");
        if (ParticipantRule == null) {
            ParticipantRule = "";
        }
        String ActionForm = request.getParameter("ActionForm");
        if (ActionForm == null) {
            ActionForm = "";
        }
        //System.out.println("ActionId : " + ActionId);
        //System.out.println("ActionName : " + ActionName);
        //System.out.println("ActionType : " + ActionType);
        //System.out.println("Participant : " + Participant);
        //System.out.println("ParticipantRule : " + ParticipantRule);
        //System.out.println("ActionForm : " + ActionForm);
        int isStartAction = 0;

        FlowChartDesignerController flchdCtrl = new FlowChartDesignerController();

        if (toDoAction.equalsIgnoreCase("list")) {
            String jTableResult = flchdCtrl.getAllAction(flowChartId);
            out.println(jTableResult);
            //System.out.println(jTableResult);
        } else if (toDoAction.equalsIgnoreCase("create")) {
            int latestActionId = flchdCtrl.insertAction(ActionName, ActionType, Participant, ParticipantRule, flowChartId, isStartAction, ActionForm);
            String jTableResult = flchdCtrl.getActionById(latestActionId);
            out.println(jTableResult);
            //System.out.println(jTableResult);
        } else if (toDoAction.equalsIgnoreCase("update")) {
            String jTableResult = flchdCtrl.updateAction(ActionId, ActionName, ActionType, Participant, ParticipantRule, isStartAction, ActionForm);
            out.println(jTableResult);
            //System.out.println(jTableResult);
        } else if (toDoAction.equalsIgnoreCase("delete")) {
            String jTableResult = flchdCtrl.deleteAction(ActionId);
            out.println(jTableResult);
            //System.out.println(jTableResult);
        }
    } catch (Exception e) {
        //Return error message
        Map jTableResult = new HashMap();
        jTableResult.put("Result", "ERROR");
        jTableResult.put("Message", e.getMessage());
        out.println(jTableResult);
        //System.out.println(jTableResult);
    }
%>