<%-- 
    Document   : QueueDetail
    Created on : 9 Apr, 2019, 1:50:12 PM
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

        <script type="text/javascript" src="${pageContext.request.contextPath}/include/plenus/include/jquery/jquery-ui-1.12.1.custom/external/jquery/jquery.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/include/plenus/include/jquery/jquery-ui-1.12.1.custom/jquery-ui.min.js"></script>
        <link href="${pageContext.request.contextPath}/include/css/loading.css?v=${Version.VERSION}" rel="stylesheet" type="text/css"/>

        <link href="${pageContext.request.contextPath}/include/plenus/include/css/common.css?v=${Version.VERSION}" rel="stylesheet" type="text/css"/>
        <script src="${pageContext.request.contextPath}/include/plenus/include/js/common.js?v=${Version.VERSION}" type="text/javascript"></script>
        
        <script src="include/js/QueueList.js?v=${Version.VERSION}" type="text/javascript"></script>
        <link href="include/css/QueueDetail.css?v=${Version.VERSION}" rel="stylesheet" type="text/css"/>
        <title>Queue Detail</title>
    </head>
    <body>
        <script>
            var maxPax = ${maxPax};
        </script>
        <div id="dvLoading"></div>
        <div id="overlay" class="web_dialog_overlay"></div>
        <input type="text" id="message" name="message" value="<c:out value="${param.message}"/>" hidden />
        <table class="formTableForLogoAndTable">
            <tr>
                <td class="formLogoTableCell">
                    <img class="formLogoImage" src="${pageContext.request.contextPath}/images/yayoi.jpg" alt="Logo" style="width: 50%; height: auto"/>
                </td>
                <td class="formTitelName">
                    Queue Detail
                </td>
            </tr>
        </table>
            <div class="margs"> 
            <form id="frm" method="POST" action="QueueDetail" role="form" class="formPadding">
          
                    <div class="form-row">
                        <div class="form-group col-35" style="margin-right: 90px">
                        <input type="text" id="queueHeaderId" name="queueHeaderId" value="${queueHeaderId}" hidden>
                        <input type="text" id="queueId" name="queueId" value="${txtQueueDetailId}" hidden>
                <label for="location">Location</label>
                <input type="text" id="location" name="location" value="${outlet.outlateName}" readonly>
            </div>
            <div class="form-group col-35">
                <label for="date">Date</label>
                <input type="text" id="date" name="date" value="<javatime:format value="${date}" pattern="dd/MM/yyyy"/>" readonly>
            </div>
                    </div>
            <div class="form-row">
                <div class="form-group col-35" style="margin-right: 90px">
                <label for="contact">Contact No.</label>
                <input onblur="if(!/^([89])/.test(this.value)) if(!alert('Must be started with 8 or 9')) this.value=''" type="text" pattern="\d*" id="contact" name="contact" maxlength="8" onkeypress="validate(event)" value="${contactNo}">
            </div>
            <div class="form-group col-35">
                <label for="queueNo">Queue No.</label>
                <input type="text" id="queueNo" name="queueNo" value="${queueNo}" readonly>
            </div>
            </div>
            <div class="form-row">
                <div class="form-group col-35" style="margin-right: 90px">
                <label for="pax">Pax (Max: ${maxPax})</label>
                <select id="pax" name="pax" onmouseover="looping()">
                    <option value="${totPax}">${totPax}</option>
                </select>
            </div>
            <div class="form-group col-35">
                <label for="baby">Baby Chair</label>
                <select id="baby" name="baby" onmouseover="asw()">
                    <option value="${babyChair}">${babyChair}</option>
                </select>
            </div>
            </div>
           
            <div class="form-row">
                 <div class="col-35" style="margin-right: 90px">
                <label for="specialReqOption">Special Req</label>
                <select id="specialReqOption" name="specialReqOption">
                    <option value="" disabled selected>Please select a Special Request</option>
                    <c:forEach items="${listOfRequestMasters}" var="request" varStatus="loop">
                        <option value="${request.id}" ${request.id eq specialReqOptionId ? 'SELECTED' : ''}>${request.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group col-35">
                <label for="status">Status</label>
                <select id="status" name="status">
<!--                    <option value="Queue" hidden>${status}</option>-->
                    <option value="Queue" ${status eq "Queue" ? 'SELECTED':''}>Queue</option>
                    <option value="Skipped" ${status eq "Skipped" || status eq "SKIPPED" ? 'SELECTED':''}>Skipped</option>
                    <option value="Arrived" ${status eq "Arrived" || status eq "ARRIVED" ? 'SELECTED':''}>Arrived</option>
                    <option value="Canceled" ${status eq "Canceled" ? 'SELECTED':''}>Canceled</option>
                </select>
            </div>
            </div>
                <div class="form-row">
                    <div class="form-group col-35" style="margin-right: 90px">
                        <textarea type="text" id="specialReq" maxlength="500" name="specialReq" class="area" >${specialReq}</textarea>
            </div>
            <div class="form-group col-35">
                <label for="sendSms">Send SMS</label>
                <select id="sms" name="sms">
                    <!--<option value="Yes" hidden>${sendSms}</option>-->
                    <option value="Yes" ${sendSms eq "Yes" ? 'SELECTED':''}>Yes</option>
                    <option value="No"  ${sendSms eq "No" ? 'SELECTED':''}>No</option>
                </select>
            </div>
                </div>
       
    
            
            <div class="btn-group"  style="margin-right: 90px">
                
                    <input type="button" value="Back" onclick="closeWindow();return false;" style="margin-top: 20px; width: 12%">
                
                    <input type="button" value="Update" onclick="updatebtnOnClick()" style="width: 12%; margin-left: 5px">
                    <c:if test="${status == 'Queue'}">
                    <input type="button" value="Cancel" onclick="cancelWindow()" id="cancelbtn"  class="btnCancel" style="margin-left: 5px">
                    </c:if>
                </div>
            </form>
             </div>
             
    </body>
</html>
