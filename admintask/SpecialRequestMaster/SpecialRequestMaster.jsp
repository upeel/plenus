<%-- 
    Document   : SpecialRequestMaster
    Created on : 18 Apr, 2019, 5:45:29 PM
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

        <script src="include/js/SpecialRequestMaster.js?v=${Version.VERSION}" type="text/javascript"></script>
        <link href="include/css/SpecialRequestMaster.css?v=${Version.VERSION}" rel="stylesheet" type="text/css"/>
        <title>Special Request</title>
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
                    Special Request
                </td>
            </tr>
            <tr>
                <td colspan="2" class="formTitleTableCellForQueue"/>
            </tr>
        </table>
        <!--<br/>-->
        <table class="" style="border: none !important">
            <thead style="border: none !important">
                <tr>
                    <th style="width: 7%; text-align: left">
                    Location
                    </th>
                    <th style="width: 30%; text-align: left">
                        <input type="text" class="" id="txtLocation" value="${queueSetting.outlateName}" readonly/>
                        <input type="text" id="txtOutletId" name="txtOutletId" value="${queueSetting.outletId}" hidden/>
                    </th>

                    <th style="width: 6%"/>

                    <th style="width: 7%; text-align: left">
                        Status
                    </th>
                    <th style="width: 20%; text-align: left">
                        <form id="frms" name="frms" method="GET" action="SpecialRequestMaster">
                        <select id="selStatus" name="selStatus" class="selStatus option" style="height: 20px">
                            <option value="ACTIVE" selected ${param.selStatus eq 'ACTIVE' ? 'selected':''}>ACTIVE</option>
                            <option value="INACTIVE" ${param.selStatus eq 'INACTIVE' ? 'selected':''}>INACTIVE</option>
                        </select>
                        </form> 
                    </th>
                    <th/>
                    <th style="width: 30%; text-align: left; padding-left: 15px"/>
                        <!--<input type="submit" value="Filter" id="filterBtn" style="width: 30%" />-->
                    </th>
                </tr>
            </head>
        </table>
        <br/>
        <form id="frm" name="frm" method="POST" action="SpecialRequestMaster">
            <div id="dialogSpecialRequestMaster" title="Add Special Request" hidden>
                <table class="formTable">
                    <thead>
                        <tr>
                            <th class="formTableHeader" colspan="3">
                                Special Request 
                                
                                <input type="text" id="txtSpecialReqId" name="txtSpecialReqId" value="" readonly hidden />
                            </th>
                        </tr>
                    </thead>

                    <tbody>
                        <tr>
                            <td class="formFieldText formFieldTextRequired formTableCellFormat">
                                Request Name
                            </td>

                            <td class="formFieldInput">
                                <input type="text" id="txtRequestName" name="txtRequestName" maxlength="100" />
                            </td>
                        </tr>
                        
                        <tr>
                            <td class="formFieldText formTableCellFormat">
                                Description
                            </td>

                            <td class="formFieldInput">
                                <input type="text" id="txtDescription" name="txtDescription" maxlength="300" />
                            </td>
                        </tr>
                        
                        <tr id="statusRow">
                            <td class="formFieldText formTableCellFormat">
                                Status
                            </td>

                            <td class="formFieldInput">
                                <select id="txtStatus" name="txtStatus">
                                    <option value="ACTIVE" selected>ACTIVE</option>
                                    <option value="INACTIVE">INACTIVE</option>
                                </select>
                            </td>
                        </tr>

                    </tbody>
                </table>
            </div>
        </form>
        
        <table class="formTable compact hover" id="dtSpecialRequest" hidden>
            <thead style="background-color: #ffe7e7">
                <tr>
                    <th colspan="4">Special Request&nbsp;<img src="${pageContext.request.contextPath}/images/add.png" style="width: 20px; cursor: pointer" id="addBtn"></th>
                </tr>
                <tr>
                    <th class="formFieldText thTableColorBlack" style="width: 5%">
                        #
                    </th>
                    <th class="formFieldText" hidden>
                        Id
                    </th>
                    <th class="formFieldText thTableColorBlack" style="width: 30%">
                        Request Name
                    </th>
                    <th class="formFieldText thTableColorBlack" style="width: 40%">
                        Description
                    </th>
                    <th class="formFieldText thTableColorBlack" style="width: 25%">
                        Status
                    </th>
                </tr>
            </thead>

            <tfoot>
                <tr>
                    <th class="formFieldText">
                        #
                    </th>
                    <th class="formFieldText" hidden>
                        Id
                    </th>
                    <th class="formFieldText">
                        Request Name
                    </th>
                    <th class="formFieldText">
                        Description
                    </th>
                    <th class="formFieldText">
                        Status
                    </th>
                </tr>
            </tfoot>

            <tbody>
                <c:forEach items="${listOfSpecialReq}" var="specReq" varStatus="loop">
                    <tr>
                        <td class="formFieldInput">
                           ${loop.count}
                        </td>
                        <td class="formFieldInput" hidden>
                           ${specReq.id}
                        </td>
                        
                        <td class="formFieldInput">
                           ${specReq.name}
                        </td>

                        <td class="formFieldInput">
                           ${specReq.description}
                        </td>

                        <td class="formFieldInput">
                            ${specReq.status}
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </body>
</html>
