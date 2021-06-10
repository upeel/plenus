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

        <script type="text/javascript" src="${pageContext.request.contextPath}/include/app/include/jquery/jquery-ui-1.12.1.custom/external/jquery/jquery.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/include/app/include/jquery/jquery-ui-1.12.1.custom/jquery-ui.min.js"></script>
        <link href="${pageContext.request.contextPath}/include/css/loading.css?v=${Version.VERSION}" rel="stylesheet" type="text/css"/>

        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/include/app/include/jquery/jquery-ui-1.12.1.custom/jquery-ui.min.css"  />
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/include/app/include/DataTables/datatables.min.css" />
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/include/app/include/DataTables/Responsive-2.2.0/css/responsive.dataTables.min.css" />

        <script type="text/javascript" src="${pageContext.request.contextPath}/include/app/include/DataTables/datatables.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/include/app/include/DataTables/Buttons-1.4.2/js/dataTables.buttons.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/include/app/include/DataTables/Buttons-1.4.2/js/buttons.flash.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/include/app/include/DataTables/Buttons-1.4.2/js/buttons.html5.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/include/app/include/DataTables/Buttons-1.4.2/js/buttons.print.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/include/app/include/DataTables/Responsive-2.2.0/js/dataTables.responsive.min.js"></script>

        <link href="${pageContext.request.contextPath}/include/app/include/css/common.css?v=${Version.VERSION}" rel="stylesheet" type="text/css"/>
        <script src="${pageContext.request.contextPath}/include/app/include/js/common.js?v=${Version.VERSION}" type="text/javascript"></script>

        <script src="include/js/QueueSetting.js?v=${Version.VERSION}" type="text/javascript"></script>
        <link href="include/css/QueueSetting.css?v=${Version.VERSION}" rel="stylesheet" type="text/css"/>
        <title>Queue Setting</title>
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
                    Queue Setting
                </td>
            </tr>
            <tr>
                <td colspan="2" class="formTitleTableCellForQueue"/>
            </tr>
        </table>
        
        <table class="formTable" border="0" style="border: 0px !important; background-color: #ffe7e7">
            <form id="QueueSettingfrm" name="QueueSettingfrm" method="POST" action="QueueSetting">
                <input type="text" id="txtQueueHeaderId" name="txtQueueHeaderId" value="${queueSetting.id}" hidden/>
            <tr>
                <td style="height: 5px"/>
            </tr>
            <tr>
                <td style="padding-left: 5px">
                    Location
                </td>
                <td>
                    <input type="text" class="formFieldInput" id="txtLocation" value="${queueSetting.outlateName}" readonly/>
                    <input type="text" id="txtOutletId" name="txtOutletId" value="${queueSetting.outletId}" hidden/>
                </td>
                
                <td style="width: 3%"/>
                
                <td>
                    Status
                </td>
                <td style="padding-right: 5px">
                    <select id="selStatus" class="selStatus" name="selStatus">
                        <option value="ON" ${queueSetting.status eq 'ON' ? 'SELECTED':''}>ON</option>
                        <option value="OFF" ${queueSetting.status eq 'OFF' ? 'SELECTED':''}>OFF</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td style="padding-left: 5px" class="formFieldTextRequired">
                    Buffer Before Skip
                </td>
                <td>
                    <input type="text" class="formFieldInput" value="${queueSetting.bufferBeforeSkip}" 
                           id="txtBufferBeforeSkip" name="txtBufferBeforeSkip" onkeypress="return fnNumbersOnly(this, event)" />  minutes
                </td>
                
                <td style="width: 3%"/>
                
                <td class="formFieldTextRequired">
                    Max Pax Allowed
                </td>
                <td style="padding-right: 5px">
                    <input type="text" class="formFieldInput" value="${queueSetting.maxPaxAllowed}" id="txtMaxPaxAllowed" name="txtMaxPaxAllowed" onkeypress="return fnNumbersOnly(this, event)" />
                </td>
            </tr>
            <tr>
                <td style="height: 5px"/>
            </tr>
            <tr style="background-color: #fff !important">
                <td colspan="5" style="height: 25px; text-align: left"/>
                    <c:choose>
                        <c:when test="${queueSetting.qrcode eq null || queueSetting.qrcode eq ''}">
                            <img class="formLogoImage" src="" id="QRCodeImage"/>
                        </c:when>
                        <c:otherwise>
                            <img class="formLogoImage" src="../../GetAttachmentFile?attachmentFilePath=${queueSetting.qrcode}" id="QRCodeImage"/>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
            
            <tr style="background-color: #fff !important">
                <td colspan="3" style="text-align: left">
                    <a href="#" id="generateQRCode">Generate QR Code</a>
                    <input type="text" id="txtQueueQRCode" name="txtQueueQRCode" value="${queueSetting.qrcode}" hidden/>
                </td>
                <td colspan="2" style="text-align: right">
                    <input type="button" value="Update" id="SubmitBtn" style="width: 30%"/>
                </td>
            </tr>
            </form>
        </table>
    </body>
</html>
