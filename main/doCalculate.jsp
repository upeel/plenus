<%-- 
    Document   : doCalculate
    Created on : Nov 21, 2013, 3:25:36 PM
    Author     : SOE HTIKE
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.bizmann.poi.controller.*" %>
<%@page import="com.bizmann.poi.entity.*" %>
<%@page import = "java.util.*"
        import = "java.lang.*"
        import = "java.net.*"
        import="java.text.DecimalFormat" %>
<%
    ArrayList<Calculation> calList = new ArrayList<Calculation>();
    CalculationController calCtrl = new CalculationController();

    String fileName = request.getParameter("fileName");
    if (fileName == null) {
        fileName = "";
    }
    String mainCell = request.getParameter("mainCell");
    if (mainCell == null) {
        mainCell = "";
    }

    Enumeration paramValueList = request.getParameterNames();
    while (paramValueList.hasMoreElements()) {
        String name = (String) paramValueList.nextElement();
        if (!name.equalsIgnoreCase("fileName") && !name.equalsIgnoreCase("mainCell")) {
            String value = (String) request.getParameter(name);
            if (value == null) {
                value = "0";
            }
            value = value.trim();
            if (value.equals("")) {
                value = "0";
            }
            value = value.replace("$", "");
            value = value.replace(",", "");
            if (!calCtrl.isDouble(value)) {
                value = "0";
            }
            Calculation cal = new Calculation();
            cal.setCellIdentifier(name);
            cal.setCellValue(Double.parseDouble(value));
            calList.add(cal);
        }
    }
    double result = new CalculationController().doCalculate(fileName, mainCell, calList);
    DecimalFormat df = new DecimalFormat("#.00");
%>
[{"txtResult":"<%=df.format(result)%>"}]