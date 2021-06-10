<%-- 
    Document   : admintask
    Created on : Jul 7, 2014, 4:43:43 PM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap"
        import="java.util.Map"
        import="com.bizmann.diy.admin.controller.*"
        import="com.bizmann.product.controller.*"
        import="com.bizmann.diy.admin.entity.*"
        import="java.util.ArrayList"
        import="org.apache.commons.lang.StringEscapeUtils" %>
<!DOCTYPE html>
<%@ include file="helper/sessioncheck.jsp" %>
<%
    String strHeaderId = request.getParameter("headerId");
    if (strHeaderId == null) {
        strHeaderId = "0";
    }
    strHeaderId = strHeaderId.trim();
    if (strHeaderId.equals("")) {
        strHeaderId = "0";
    }
    int headerId = Integer.parseInt(strHeaderId);
    
    int userId = 0;
    if (ssid == null || ssid.equals("")) {
    } else {
        UserController userCtrl = new UserController();
        userId = userCtrl.getUserIdByLoginId(ssid);
    }
    if(!new AdminTaskPermissionController().checkIfUserHasPermissionDIY(headerId, userId)){
        return;
    }
    
    AdminModController adminModCtrl = new AdminModController();
    AdminHeader adminHeader = adminModCtrl.getTableDetailsByHeaderId(headerId);
    ArrayList<AdminDetail> detailList = new ArrayList<AdminDetail>();

    if (adminHeader.getId() > 0 && adminHeader.getPath().equals("")) {
        detailList = adminHeader.getDetailList();
    } else {
        response.sendRedirect("../admintask/" + adminHeader.getPath());
        return;
    }

    //System.out.println("detailList.size() : " + detailList.size());
    //System.out.println("adminHeader.getId() : " + adminHeader.getId());

    StringBuffer sbf = new StringBuffer();
    sbf.append("$('#AdminTableContainer').jtable({\n\r");
    sbf.append("title: '");
    sbf.append(adminHeader.getName());
    sbf.append("',\n\r");
    //sbf.append("paging: true, //Enable paging\n\r");
    //sbf.append("pageSize: 10, //Set page size (default: 10)\n\r");
    //sbf.append("sorting: true, //Enable sorting\n\r");
    sbf.append("actions: {\n\r");
    sbf.append("listAction: 'admintaskActions.jsp?headerId=");
    sbf.append(headerId);
    sbf.append("&action=list',\n\r");
    sbf.append("deleteAction: 'admintaskActions.jsp?headerId=");
    sbf.append(headerId);
    sbf.append("&action=delete',\n\r");
    sbf.append("updateAction: 'admintaskActions.jsp?headerId=");
    sbf.append(headerId);
    sbf.append("&action=update',\n\r");
    sbf.append("createAction: 'admintaskActions.jsp?headerId=");
    sbf.append(headerId);
    sbf.append("&action=create'\n\r");
    sbf.append("},\n\r");
    sbf.append("fields: {\n\r");
    sbf.append("Id: {\n\r");
    sbf.append(" key: true,\n\r");
    sbf.append(" create: false,\n\r");
    sbf.append(" edit: false,\n\r");
    sbf.append(" list: false\n\r");
    sbf.append("},\n\r"); //put a comma here <--
    //loop here ** last one is without comma

    for (int i = 0; i < detailList.size(); i++) {
        AdminDetail adDetail = detailList.get(i);
        int id = adDetail.getId();
        boolean editable = adDetail.isEditable();
        boolean listable = adDetail.isListable();
        boolean mandatory = adDetail.isMandatory();
        String description = adDetail.getName();
        int type = adDetail.getType();

        //sbf.append("A");
        sbf.append(id);
        //sbf.append("A");
        sbf.append(": {\n\r");
        sbf.append("title: '");
        sbf.append(StringEscapeUtils.escapeJavaScript(description));
        sbf.append("',\n\r");
        if (!editable) {
            sbf.append("edit: false,\n\r");
        }
        if (!listable) {
            sbf.append("list: false,\n\r");
        }

        if (type == 1) { // General
            if (mandatory) {
                sbf.append("inputClass: 'validate[required]'\n\r");
            }
        } else if (type == 2) { // Text Area
            sbf.append("type: 'textarea'");
            if (mandatory) {
                sbf.append(",\n\rinputClass: 'validate[required]'\n\r");
            }
        } else if (type == 3) { // Date
            sbf.append("type: 'date',\n\r");
            sbf.append("displayFormat: 'yy-mm-dd'");
            if (mandatory) {
                sbf.append(",\n\rinputClass: 'validate[required]'\n\r");
            }
        } else if (type == 4) { // Email
            if (mandatory) {
                sbf.append("inputClass: 'validate[required,custom[email]]'\n\r");
            } else {
                sbf.append("inputClass: 'validate[custom[email]]'\n\r");
            }
        } else if (type == 5) { // ComboBox
            sbf.append("options: { \n\r");
            ArrayList<AdminDetailValue> adValueList = adDetail.getValueList();
            for (int a = 0; a < adValueList.size(); a++) {
                sbf.append("'");
                sbf.append(StringEscapeUtils.escapeJavaScript(adValueList.get(a).getValue().trim()));
                sbf.append("': '");
                sbf.append(StringEscapeUtils.escapeJavaScript(adValueList.get(a).getValue().trim()));

                if (a >= (adValueList.size() - 1)) {
                    sbf.append("'\n\r");
                } else {
                    sbf.append("',\n\r");
                }
            }
            sbf.append("}");
            if (mandatory) {
                sbf.append(",\n\rinputClass: 'validate[required]'\n\r");
            }
        } else if (type == 6) { // CheckBox
            sbf.append("type: 'checkbox',\n\r");
            sbf.append("options: { \n\r");
            ArrayList<AdminDetailValue> adValueList = adDetail.getValueList();
            for (int a = 0; a < adValueList.size(); a++) {
                sbf.append("'");
                sbf.append(StringEscapeUtils.escapeJavaScript(adValueList.get(a).getValue().trim()));
                sbf.append("': '");
                sbf.append(StringEscapeUtils.escapeJavaScript(adValueList.get(a).getValue().trim()));

                if (a >= (adValueList.size() - 1)) {
                    sbf.append("'\n\r");
                } else {
                    sbf.append("',\n\r");
                }
            }
            sbf.append("}");
            if (mandatory) {
                sbf.append(",\n\rinputClass: 'validate[required]'\n\r");
            }
        } else if (type == 7) { // Radio Button
            sbf.append("type: 'radiobutton',\n\r");
            sbf.append("options: { \n\r");
            ArrayList<AdminDetailValue> adValueList = adDetail.getValueList();
            for (int a = 0; a < adValueList.size(); a++) {
                sbf.append("'");
                sbf.append(StringEscapeUtils.escapeJavaScript(adValueList.get(a).getValue().trim()));
                sbf.append("': '");
                sbf.append(StringEscapeUtils.escapeJavaScript(adValueList.get(a).getValue().trim()));

                if (a >= (adValueList.size() - 1)) {
                    sbf.append("'\n\r");
                } else {
                    sbf.append("',\n\r");
                }
            }
            sbf.append("}");
            if (mandatory) {
                sbf.append(",\n\rinputClass: 'validate[required]'\n\r");
            }
        }

        if (i >= (detailList.size() - 1)) {
            sbf.append("}\n\r");
        } else {
            sbf.append("},\n\r");
        }
    }

    sbf.append("},\n\r");
    sbf.append("formCreated: function (event, data) {\n\r");
    sbf.append("data.form.validationEngine();\n\r");
    sbf.append("},\n\r");
    sbf.append("formSubmitting: function (event, data) {\n\r");
    sbf.append("return data.form.validationEngine('validate');\n\r");
    sbf.append("},\n\r");
    sbf.append("formClosed: function (event, data) {\n\r");
    sbf.append("data.form.validationEngine('hide');\n\r");
    sbf.append("data.form.validationEngine('detach');\n\r");

    sbf.append("}\n\r");
    sbf.append("});\n\r");

    String tableScript = sbf.toString();
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <script src="../include/js/jquery-1.10.2.js"></script>
        <script src="../include/js/url.js"></script>
        <script src="../include/jquery-ui-1.10.3/ui/jquery-ui.js"></script>
        <script src="../include/time/jquery.timeentry.js"></script>
        <script type="text/javascript" src="../include/js/jquery.validationEngine-en.js" charset="utf-8"></script>
        <script type="text/javascript" src="../include/js/jquery.validationEngine.js"></script>
        <script type="text/javascript" src="../include/js/jquery.signaturepad.min.js"></script>
        <script type="text/javascript" src="include/js/autosaveform.js"></script>
        <link rel="stylesheet" type="text/css" href="../include/css/jquery.signaturepad.css"/>
        <link rel="stylesheet" type="text/css" href="../include/css/validationEngine.jquery.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" href="../include/jquery-ui-1.10.3/themes/base/jquery-ui.css" type="text/css" />
        <link rel="stylesheet" href="../include/time/jquery.timeentry.css" type="text/css" />
        <link rel="stylesheet" href="../include/css/loading.css" type="text/css" />

        <link rel="stylesheet" type="text/css" href="../include/css/demo.css" />
        <link href="../include/jtable/themes/metro/blue/jtable.min.css" rel="stylesheet" type="text/css" />
        <script src="../include/jtable/jquery.jtable.min.js" type="text/javascript"></script>
        <title>bmFLO</title>
        <script type="text/javascript">
 
            $(document).ready(function () {
                //                        RecordDate: {
                //                            title: 'Record date',
                //                            width: '15%',
                //                            type: 'date',
                //                            displayFormat: 'dd.mm.yy',
                //                            create: false,
                //                            edit: false,
                //                            sorting: false //This column is not sortable!
                //                        }
            <%=tableScript%>
                    $('#AdminTableContainer').jtable('load');
                });
        </script>
    </head>
    <body>
        <div id="AdminTableContainer"></div>
    </body>
</html>