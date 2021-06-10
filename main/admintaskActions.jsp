<%-- 
    Document   : admintaskActions
    Created on : Jul 7, 2014, 5:07:06 PM
    Author     : SOE HTIKE
--%>
<%@page import="java.io.*,java.util.*"
        import="com.bizmann.diy.admin.controller.*"
        import="com.bizmann.diy.admin.entity.*"
        import="java.util.ArrayList"
        import = "com.bizmann.product.controller.*" %>
<%@ include file="helper/sessioncheck.jsp" %>
<%
    try {
        int userId = 0;

        if (ssid == null || ssid.equals("")) {
        } else {
            UserController userCtrl = new UserController();
            userId = userCtrl.getUserIdByLoginId(ssid);
        }

        String toDoAction = request.getParameter("action");
        if (toDoAction == null) {
            toDoAction = "";
        }

        String strHeaderId = request.getParameter("headerId");
        if (strHeaderId == null) {
            strHeaderId = "0";
        }
        strHeaderId = strHeaderId.trim();
        if (strHeaderId.equals("")) {
            strHeaderId = "0";
        }
        int headerId = Integer.parseInt(strHeaderId);

        String strId = request.getParameter("Id");
        if (strId == null) {
            strId = "0";
        }
        strId = strId.trim();
        if (strId.equals("")) {
            strId = "0";
        }
        int Id = Integer.parseInt(strId);

        ArrayList<AdminDetailValue> adValueList = new ArrayList<AdminDetailValue>();
        AdminModController adminModCtrl = new AdminModController();

        Enumeration paramValueList = request.getParameterNames();
        while (paramValueList.hasMoreElements()) {
            String name = (String) paramValueList.nextElement();
            if (adminModCtrl.isNumeric(name)) {
                int detailId = adminModCtrl.convertStringToInt(name);
                if (detailId > 0) {
                    String value = request.getParameter(name);
                    AdminDetailValue adValue = new AdminDetailValue();
                    adValue.setHeader_id(headerId);
                    adValue.setDetail_id(detailId);
                    adValue.setValue(value);

                    adValueList.add(adValue);
                }
            }
        }


        if (toDoAction.equalsIgnoreCase("list")) {
            String jTableResult = adminModCtrl.getAllEntryValues(headerId);
            out.println(jTableResult);
            //System.out.println(jTableResult);
        } else if (toDoAction.equalsIgnoreCase("create")) {
            int latestId = adminModCtrl.insertEntryValue(adValueList, headerId, userId);
            String jTableResult = adminModCtrl.getEntryById(latestId, headerId);
            out.println(jTableResult);
            //System.out.println(jTableResult);
        } else if (toDoAction.equalsIgnoreCase("update")) {
            String jTableResult = adminModCtrl.updateEntry(Id, adValueList, headerId, userId);
            out.println(jTableResult);
            //System.out.println(jTableResult);
        } else if (toDoAction.equalsIgnoreCase("delete")) {
            String jTableResult = adminModCtrl.deleteEntryById(Id, headerId);
            out.println(jTableResult);
            //System.out.println(jTableResult);
        }
    } catch (Exception e) {
        Map jTableResult = new HashMap();
        jTableResult.put("Result", "ERROR");
        jTableResult.put("Message", e.getMessage());
        out.println(jTableResult);
        //System.out.println(jTableResult);
    }
%>