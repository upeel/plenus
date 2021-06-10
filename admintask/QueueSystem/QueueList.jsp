<%-- 
    Document   : QueueList
    Created on : 9 Apr, 2019, 9:57:18 AM
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

        <!--Data table css-->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/include/plenus/include/jquery/jquery-ui-1.12.1.custom/jquery-ui.min.css"  />
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/include/plenus/include/DataTables/datatables.min.css" />
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/include/plenus/include/DataTables/Responsive-2.2.0/css/responsive.dataTables.min.css" />

        <!--Data table js file-->
        <script type="text/javascript" src="${pageContext.request.contextPath}/include/plenus/include/DataTables/datatables.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/include/plenus/include/DataTables/Buttons-1.4.2/js/dataTables.buttons.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/include/plenus/include/DataTables/Buttons-1.4.2/js/buttons.flash.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/include/plenus/include/DataTables/Buttons-1.4.2/js/buttons.html5.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/include/plenus/include/DataTables/Buttons-1.4.2/js/buttons.print.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/include/plenus/include/DataTables/Responsive-2.2.0/js/dataTables.responsive.min.js"></script>

        <link href="${pageContext.request.contextPath}/include/plenus/include/css/common.css?v=${Version.VERSION}" rel="stylesheet" type="text/css"/>
        <script src="${pageContext.request.contextPath}/include/plenus/include/js/common.js?v=${Version.VERSION}" type="text/javascript"></script>
        
        <script src="include/js/QueueList.js?v=${Version.VERSION}" type="text/javascript"></script>
        <link href="include/css/QueueList.css?v=${Version.VERSION}" rel="stylesheet" type="text/css"/>
        <title>Queue List</title>
    </head>
    <body>
        <div class="alert alert-success" id="alertmessage" name="alertmessage" hidden>
            <button type="button" class="close" data-dismiss="alert" id="closeAlertButton">x</button>
            <a id="thisAlert"></a>
        </div>
        <input type="text" id="outletStatus" value="${outletStatus}" name="outletStatus" hidden/>
        <script>
            var bufferTime = 0;
            if(${bufferTime} !== 0 || ${bufferTime} > 0){
                bufferTime = ${bufferTime};
            }
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
                    Queue List
                </td>
            </tr>
        </table>
            

        <div class="container" style="padding-bottom: 5px !important">
            <div class="margins">
            <form id="frm" method="GET" action="QueueList" class="form-inline" role="form" class="formPadding">
                <div class="flex">
            <div class="col-35">
                <label for="location">Location</label>
                <input type="text" id="location" value="${outlet.outlateName}" readonly>
          
            </div>
            <div class="col-35">
                <label for="date">Date</label>
                <input type="text" id="date" value="<javatime:format value="${date}" pattern="dd/MM/yyyy"/>" readonly>
            </div>
            <div class="col-35">
                <label for="status">Status</label>
                <select id="selStatus" name="selStatus" class="selStatus" >
                    <option value="Queue" ${param.selStatus eq 'Queue' ? 'SELECTED':''} selected>Queue</option>
                    <option value="Skipped" ${param.selStatus eq 'Skipped' ? 'SELECTED':''}>Skipped</option>
                    <option value="Arrived" ${param.selStatus eq 'Arrived' ? 'SELECTED':''}>Arrived</option>
                    <option value="Canceled" ${param.selStatus eq 'Canceled' ? 'SELECTED':''}>Canceled</option>
                    <option value="All" ${param.selStatus eq 'All' ? 'SELECTED':''} >All</option>
                </select>
            </div>
            </div>
      </form>
            </div>
            <br/>
            <br/>
            <br/>
            <br/>
            <br/>
         
            <div class="row">
                <input type="submit" value="Add" onclick="fnOpenPopUpWindow('OpenAddQueue','AddQueue?')">
            </div>
    </div>
      <table class="formTable compact hover" id="dtQueue" hidden>
            <thead style="background-color: #ffe7e7;">
          
                <tr>
                    <th class="formFieldText" hidden>
                        Id
                    </th>
                    <th class="formFieldText">
                        No.
                    </th>
                    <th class="formFieldText">
                        Contact
                    </th>
                    <th class="formFieldText">
                        Pax
                    </th>
                    <th class="formFieldText">
                        Special Request
                    </th>
                    <th class="formFieldText">
                        Total Pax
                    </th>
                    <th class="formFieldText">
                        Action
                    </th>
                </tr>
            </thead>
            
            <tfoot>
                <tr>
                    <th class="formFieldText" hidden>
                        Id
                    </th>
                    <th class="formFieldText">
                        No.
                    </th>
                    <th class="formFieldText">
                        Contact
                    </th>
                    <th class="formFieldText">
                        Pax
                    </th>
                    <th class="formFieldText">
                        Special Request
                    </th>
                    <th class="formFieldText">
                        Total Pax
                    </th>
                    <th class="formFieldText">
                        Action
                    </th>
                </tr>
                  
            </tfoot>
            <tbody>
                <c:forEach items="${listOfQueue}" var="queue" varStatus="loop">
                    <tr>
                        <td class="formFieldInput" hidden>
                            <c:out value="${queue.queueDetail.id}"/>
                            <form id="actionQueue" action="QueueList" method="POST">
                                <input type="text" id="queueDtId" name="queueDtId" class="queueDtId" value="${queue.queueDetail.id}" >
                                <input type="text" id="queueNumbers" name="queueNumbers" class="queueNumbers" value="${queue.queueDetail.queueNo}" >
                            </form>
                        </td>
  
                        <td class="formFieldInput" onclick="fnOpenPopUpWindowsQueueList(this, ${queue.queueDetail.id})">
                            <fmt:formatNumber pattern="000" value="${queue.queueDetail.queueNo}" /> 
                        </td>
                        <td class="formFieldInput" onclick="fnOpenPopUpWindowsQueueList(this, ${queue.queueDetail.id})">
                            <c:out value="${queue.queueDetail.contactNo}" />
                        </td>
                        <td class="formFieldInput" onclick="fnOpenPopUpWindowsQueueList(this, ${queue.queueDetail.id})">
                            <c:out value="${queue.queueDetail.pax}" />
                        </td>
                        <td class="formFieldInput" onclick="fnOpenPopUpWindowsQueueList(this, ${queue.queueDetail.id})">
                            <c:choose>
                                <c:when test="${queue.queueDetail.baby eq '' || queue.queueDetail.baby eq null || queue.queueDetail.baby eq '0'}">
                                    <%--<c:out value="${queue.queueDetail.baby}" />--%>
                                </c:when>
                                <c:otherwise>
                                    Baby Chair: <c:out value="${queue.queueDetail.baby}" />
                                    <br>
                                </c:otherwise>
                            </c:choose>
                                    
                            <c:choose>
                                <c:when test="${queue.queueDetail.requestOption eq '' || queue.queueDetail.requestOption eq null || queue.queueDetail.requestOption eq '0'}">
                                    <%--<c:out value="${queue.queueDetail.requestOption}" />--%>
                                </c:when>
                                <c:otherwise>
                                    <c:out value="${queue.queueDetail.requestOption}" />
                                    <br>
                                </c:otherwise>
                            </c:choose>
                            <c:out value="${queue.queueDetail.specialReq}" />
                        </td>
                        <td class="formFieldInput">
                            <c:out value="${queue.queueDetail.pax + queue.queueDetail.baby}" />
                        </td>
                        <td class="formFieldInput">
                            <c:if test= "${queue.queueDetail.status == 'Queue'}" >
                            <input type="button" id="btnProcessQueue" value="<c:out value="${queue.listOfQueueDetailLog[0].action eq 'HERE' ? 'HERE':'SMS'}" />" class="btnProcessQueue" name="btnProcessQueue" onclick="change(this, ${loop.count}, ${queue.queueDetail.id})">
                            <input type="text" id="bufferTimes" class="bufferTimes" value="${queue.queueDetail.bufferTimes}" hidden>
                            <div style="font-size: 10px" id="mycounter_${queue.queueDetail.queueNo}"></div>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </body>
</html>
