<%-- 
    Document   : QueueSetting
    Created on : 8 Apr, 2019, 11:04:43 AM
    Author     : imam
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

        <script src="include/js/SMSTemplateDetail.js?v=${Version.VERSION}" type="text/javascript"></script>
        <link href="include/css/SMSTemplateDetail.css?v=${Version.VERSION}" rel="stylesheet" type="text/css"/>
        <title>SMS Template</title>
    </head>
    <body>
        <div id="dvLoading"></div>
        <div id="overlay" class="web_dialog_overlay"></div>

        <input type="text" id="message" name="message" value="<c:out value="${param.message}"/>" hidden />

        <table class="formTableForLogoAndTable">
            <tr>
                <td class="formLogoTableCell">
                    <img class="formLogoImage" src="${pageContext.request.contextPath}/images/yayoi.jpg" alt="Logo" style="width: 50%; height: auto"/>
                </td>
                <td class="formTitelName">
                    SMS Template
                </td>
            </tr>
            <tr>
                <td colspan="2" class="formTitleTableCellForQueue"/>
            </tr>
        </table>
        <!--<br/>-->
        <form id="frm" name="frm" method="POST" action="SMSTemplateDetail">
        <div style="margin-top: 5px; text-align: center">
        <table class="formTable smsTemplateDetails" border="1" style="border:1px solid black !important; max-width: 80%;">
            <thead>
                <tr>
                    <th class="titleHeadBackground" style="width: 7%; text-align: left">
                    Location
                    </th>
                    <th style="width: 30%; text-align: left">
                        <input type="text" class="" id="txtLocation" value="${sMSTemplate.location}" readonly/>
                        <input type="text" id="outletId" name="outletId" value="${param.outletId}" hidden/>
                        <input type="text" id="smsTempHeaderId" name="smsTempHeaderId" value="${param.smsTempHeaderId}" hidden/>
                    </th>

                    <th style="width: 10%" class="titleHeadBackground"/>

                    <th class="titleHeadBackground" style="width: 7%; text-align: left">
                        Status
                    </th>
                    <th style="width: 20%; text-align: left">
                        <select id="selStatus" name="selStatus" class="selStatus option" style="height: 20px">
                            <option value="ACTIVE" selected ${sMSTemplate.status eq 'ACTIVE' ? 'selected':''}>ACTIVE</option>
                            <option value="INACTIVE" ${sMSTemplate.status eq 'INACTIVE' ? 'selected':''}>INACTIVE</option>
                        </select>
                    </th>
                </tr>
                <tr>
                    <th class="titleHeadBackground" colspan="5">
                        <c:out value="${sMSTemplate.templateType}" />
                    </th> 
                </tr>
                <tr>
                    <th class="titleHeadBackground" style="width: 7%; text-align: left">
                        Usage
                    </th>
                    <th style="width: 30%; text-align: left" colspan="4">
                        <input type="text" class="txtUsage" id="txtUsage" name="txtUsage" value="${sMSTemplateDetail.usage}"/>
                    </th>
                </tr>
                <tr>
                    <th class="titleHeadBackground" style="width: 7%; text-align: left">
                        Response
                    </th>
                    <th style="width: 30%; text-align: left" colspan="4">
                        <input type="text" class="txtResponse" id="txtResponse" name="txtResponse" value="${sMSTemplateDetail.response}"/>
                    </th>
                </tr>
            </head>
        </table>
        <table class="formTable smsTemplateDetails" border="1" style="border:1px solid black !important; max-width: 80%;">
            <tbody>
                <tr>
                    <td class="titleHeadBackground" style="width: 28%; font-weight: 700; text-align: left">
                        Drag & Drop to the right side
                    </td>
                    <td class="titleHeadBackground" style="width: 52%; font-weight: 700">
                        Content
                    </td>
                </tr>
                <tr>
                    <td style="text-align: left; vertical-align: top">
                        <div id="buttons">
                            <p draggable="true" id="PLACEHOLDER_QUEUE_NUMBER"> ${PLACEHOLDER_QUEUE_NUMBER} </p>
                            <p draggable="true" id="PLACEHOLDER_CURRENT_QUEUE"> ${PLACEHOLDER_CURRENT_QUEUE} </p>
                            <p draggable="true" id="PLACEHOLDER_OUTLET_LOCATION"> ${PLACEHOLDER_OUTLET_LOCATION} </p>
                            <p draggable="true" id="PLACEHOLDER_REPLY_ONE">${PLACEHOLDER_REPLY_ONE} </p>
                            <p draggable="true" id="PLACEHOLDER_REPLY_TWO">${PLACEHOLDER_REPLY_TWO} </p>
                            <p draggable="true" id="PLACEHOLDER_REPLY_THREE">${PLACEHOLDER_REPLY_THREE} </p>
                        </div>
                    </td>
                    <td>
                        <div class="dropitems">
                            <c:choose>
                                <c:when test="${sMSTemplateDetail.messageContent eq null || sMSTemplateDetail.messageContent eq ''}">
                                    <textarea id="txtMessageContent" name="txtMessageContent" rows="18">Dear Customer,</textarea>
                                </c:when>
                                <c:otherwise>
                                    <textarea id="txtMessageContent" name="txtMessageContent" rows="18">${sMSTemplateDetail.messageContent}</textarea>
                                </c:otherwise>
                            </c:choose>
                            
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: right">
                        <input type="button" value="UPDATE" onclick="fnSubmit()" style="width: 15%">
                    </td>
                </tr>
            </tbody>
        </table>
        <br/>
        </div>
        </form>
    </body>
</html>
