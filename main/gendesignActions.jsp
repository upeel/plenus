<%-- 
    Document   : gendesignActions
    Created on : Nov 18, 2013, 2:31:45 PM
    Author     : SOE HTIKE
--%>
<%@page import="java.util.HashMap"
        import="java.util.Map"
        import="com.bizmann.gen.controller.GenController"
        import="java.util.ArrayList" %>
<%
    try {
        String toDoAction = request.getParameter("action");
        if (toDoAction == null) {
            toDoAction = "";
        }

        String strGenId = request.getParameter("genId");
        if (strGenId == null || strGenId.equals("")) {
            strGenId = "0";
        }
        int GenId = Integer.parseInt(strGenId);

        String strDetailId = request.getParameter("DetailId");
        if (strDetailId == null || strDetailId.equals("")) {
            strDetailId = "0";
        }
        int DetailId = Integer.parseInt(strDetailId);

        String strDetailType = request.getParameter("DetailType");
        if (strDetailType == null || strDetailType.equals("")) {
            strDetailType = "0";
        }
        int DetailType = Integer.parseInt(strDetailType);

        String DetailValue = request.getParameter("DetailValue");
        if (DetailValue == null || DetailValue.equals("")) {
            DetailValue = "";
        }

        System.out.println("GenId : " + GenId);
        System.out.println("DetailId : " + DetailId);
        System.out.println("DetailType : " + DetailType);
        System.out.println("DetailValue : " + DetailValue);

        GenController gCtrl = new GenController();

        if (toDoAction.equalsIgnoreCase("list")) {
            String jTableResult = gCtrl.getAllGenDetailsByIdInJson(GenId);
            out.println(jTableResult);
            System.out.println(jTableResult);
        } else if (toDoAction.equalsIgnoreCase("create")) {
            int latestDetailId = gCtrl.insertGenDetailsForJson(GenId, DetailType, DetailValue);
            String jTableResult = gCtrl.getGenDetailByIdInJson(latestDetailId);
            out.println(jTableResult);
            System.out.println(jTableResult);
        } else if (toDoAction.equalsIgnoreCase("update")) {
            String jTableResult = gCtrl.updateGenDetailsForJson(GenId, DetailId, DetailType, DetailValue);
            out.println(jTableResult);
            System.out.println(jTableResult);
        } else if (toDoAction.equalsIgnoreCase("delete")) {
            String jTableResult = gCtrl.deleteGenDetailForJson(DetailId);
            out.println(jTableResult);
            System.out.println(jTableResult);
        }
    } catch (Exception e) {
        //Return error message
        Map jTableResult = new HashMap();
        jTableResult.put("Result", "ERROR");
        jTableResult.put("Message", e.getMessage());
        out.println(jTableResult);
        System.out.println(jTableResult);
    }
%>