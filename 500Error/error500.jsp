<%-- 
    Document   : error500
    Created on : Aug 1, 2014, 3:24:16 PM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="javax.servlet.http.HttpServletRequest"
        import="com.bizmann.product.properties.PropProcessor"
        import="java.io.*,java.util.*"
        import="com.bizmann.product.entity.ActionData" 
        import="com.bizmann.admin.controller.ErrorHandlerController" 
        import="com.bizmann.utility.Application"
        %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
    Throwable ex = (Throwable) request.getAttribute("javax.servlet.error.exception");

    if (ex != null)
    {
        String loginid = (String) session.getAttribute("user");
        String instancename = Application.getAPPLICATION_NAME();

        String prevUrl1 = (String) request.getAttribute("javax.servlet.forward.request_uri");
        String prevUrl2 = request.getHeader("Referer");

        String requestURL = request.getRequestURL().toString();
        String requestQuery = "";
        if (request.getQueryString() != null)
        {
            requestQuery = request.getQueryString().toString();
            System.out.println("requestURL: " + requestURL);
            System.out.println("requestQuery: " + requestQuery);
        }

        Enumeration paramValueList = request.getParameterNames();
        ArrayList<ActionData> adList = new ArrayList<ActionData>();
        while (paramValueList.hasMoreElements())
        {
            String name = (String) paramValueList.nextElement();
            String value = "";
            String[] checkboxArr = request.getParameterValues(name);
            if (checkboxArr != null && checkboxArr.length > 1)
            {
                for (int a = 0; a < checkboxArr.length; a++)
                {
                    value = value + checkboxArr[a] + ",";
                }
                if (value.contains(","))
                {
                    value = value.substring(0, value.length() - 1);
                }
            }
            else
            {
                value = (String) request.getParameter(name);
            }
            System.out.println(name + " : " + value);
            ActionData ad = new ActionData();
            ad.setCellId(name);
            ad.setValue(value);
            adList.add(ad);
        }

        new ErrorHandlerController().initiateLogging(prevUrl1, prevUrl2, instancename, requestURL, requestQuery, loginid, ex, adList);
    }
%>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>500 Server Error Message</title>
    </head>

    <body  bgcolor="#28292a">

        <div > <img id="500error" src="${pageContext.request.contextPath}/500Error/500error.png" width="1200" height="500px" /> </div>

        <div style="height:115px; background-color:#3d3f42"></div>

    </body>
</html>
