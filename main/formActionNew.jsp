<%-- 
    Document   : formActionNew
    Created on : May 18, 2018, 1:47:49 PM
    Author     : Lwin Lwin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <table width="100%" bgcolor="E4EFF3">
            <tr>
                <td>
                    <table>
                        <tr>
                            <td>
                                <select size="1" id="cbResponse" name="cbResponse" style="font:12px arial,helvetica,clean,sans-serif">
                                    <c:forEach var="response" items="${fhResponseList}">
                                        <option value="${response.id}">${response.name}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td>

                                &nbsp;
                                <input name="mainSubBtn" id="mainSubBtn" onclick="fnProcessFormSubmit();" type="image" src="../main/images/submit.gif" style="cursor:pointer"/>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
</html>
