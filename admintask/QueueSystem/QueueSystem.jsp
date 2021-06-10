<%-- 
    Document   : QueueSystem
    Created on : 8 Apr, 2019, 9:53:20 AM
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://sargue.net/jsptags/time" prefix="javatime" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ page import="com.bizmann.utility.Version" %>
<!DOCTYPE html>
<html>
    <head>
        <link rel="icon" href="${pageContext.request.contextPath}/favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="height=device-height,width=device-width">

        <script type="text/javascript" src="${pageContext.request.contextPath}/include/plenus/include/jquery/jquery-ui-1.12.1.custom/external/jquery/jquery.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/include/plenus/include/jquery/jquery-ui-1.12.1.custom/jquery-ui.min.js"></script>
        <link href="${pageContext.request.contextPath}/include/css/loading.css?v=${Version.VERSION}" rel="stylesheet" type="text/css"/>

        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/include/plenus/include/jquery/jquery-ui-1.12.1.custom/jquery-ui.min.css"  />
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/include/plenus/include/DataTables/datatables.min.css" />
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/include/plenus/include/DataTables/Responsive-2.2.0/css/responsive.dataTables.min.css" />

        <script type="text/javascript" src="${pageContext.request.contextPath}/include/plenus/include/DataTables/datatables.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/include/plenus/include/DataTables/Buttons-1.4.2/js/dataTables.buttons.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/include/plenus/include/DataTables/Buttons-1.4.2/js/buttons.flash.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/include/plenus/include/DataTables/Buttons-1.4.2/js/buttons.html5.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/include/plenus/include/DataTables/Buttons-1.4.2/js/buttons.print.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/include/plenus/include/DataTables/Responsive-2.2.0/js/dataTables.responsive.min.js"></script>

        <link href="${pageContext.request.contextPath}/include/plenus/include/css/common.css?v=${Version.VERSION}" rel="stylesheet" type="text/css"/>
        <script src="${pageContext.request.contextPath}/include/plenus/include/js/common.js?v=${Version.VERSION}" type="text/javascript"></script>
      
        
        <script src="include/js/QueueSystem.js?v=${Version.VERSION}" type="text/javascript"></script>
        <link href="include/css/QueueSystem.css?v=${Version.VERSION}" rel="stylesheet" type="text/css"/>
        <title>Queue System</title>
    </head>
    <body>
        <input type="text" id="outletStatus" value="${outletStatus}" name="outletStatus" hidden/>
        <script>
            var maxPax = ${maxPax};
        </script>
<!--        <input type="text" id="message" name="message" value="<c:out value="${param.message}"/>" />-->
        <c:choose>
            <c:when test="${param.message eq null}">
                
            </c:when>
            <c:otherwise>
                <div class="alert alert-success" id="message" name="message" hidden>
                    <button type="button" class="close" data-dismiss="alert">x</button>
                    ${param.message}
                </div>
            </c:otherwise>
        </c:choose>
        
        <div class="formLogo">
            <img class="formLogoImg" src="${pageContext.request.contextPath}/images/yayoi.jpg" alt="Logo" style="width: 50%;"/>
        </div>
    
        <div class="container">
        <form id="frm" method="POST" action="QueueSystem" class="tablePadding">
            <input type="text" id="queueId" name="queueId" value="" readonly hidden>
            <input type="text" id="queueHeaderId" name="queueHeaderId" value="${queueHeaderId}" readonly hidden>
            <input type="text" id="queueNo" name="queueNo" value="" readonly hidden>
            <input type="text" id="outletId" name="outletId" value="${outletId}" hidden>
            <input type="text" id="reqOption" name="reqOption" value="" hidden>
            <select id="status" name="status" hidden>
                <option value="Queue">Queue</option>
            </select>
            <select id="sms" name="sms" hidden>
                <option value="Yes" selected>Yes</option>
            </select>
            <input type="text" id="datenow" name="datenow" value="<javatime:format value="${date}" pattern="dd/MM/yyyy" />" hidden>
            <div class="row">
                <div class="col-25">
                    <label for="contact">Contact No.</label>
                </div>
                <div class="col-75">
                    <input onblur="if(!/^([89])/.test(this.value)) if(!alert('Must be started with 8 or 9')) this.value=''" type="text" pattern="\d*" id="contact" name="contact" maxlength="8" onkeypress="validate(event)">
                  
                </div>
            </div>
            <div class="row">
                <div class="col-25 ">
                    <label for="pax">Pax (Max: ${maxPax})</label>
                </div>
                <div class="col-75">
                    <select id="pax" name="pax" onmouseover="looping()"> 
                        <option value="1">1</option>
                    </select>
                </div>
            </div>
            <div class="row">
                <div class="col-25">
                    <label for="baby">Baby Chair</label>
                </div>
                <div class="col-75">
                    <select id="baby" name="baby" onmouseover="asw()">
                        <option value="0">0</option>
 
                    </select>
                </div>
            </div>
            <br/>
              <div class="textAlign">If you have any special request not indicated above, please approach our service crew.</div>
              <div class="textAlign">Please be informed that Queue no. may not be called in order.</div>
              <br/>
            <div class="buttons" id="buttons">
                <input type="button" value="Submit" onclick="submitButtonClick()">
            </div>
        </form>  
        </div>
    </body>
</html>
