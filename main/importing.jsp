<%-- 
    Document   : importing
    Created on : Mar 14, 2014, 11:31:15 AM
    Author     : SOE HTIKE
--%>

<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,
         java.util.*,
         com.jenkov.servlet.multipart.MultipartEntry,
         com.bizmann.poi.resource.PropProcessor,
         com.bizmann.importing.helper.*" %>

<!DOCTYPE html>
<%
    String values = "";
    String message = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        Map multipartEntries = (Map) request.getAttribute("multipart.entries");
        if (multipartEntries != null) {
            MultipartEntry entry = (MultipartEntry) multipartEntries.get("importFile");
            if (entry == null) {
            } else {
                File xlsFile = entry.getTempFile();
                String fileNameOnly = request.getParameter("importFileName");
                if (fileNameOnly != null || !(fileNameOnly.equals(fileNameOnly))) {
                    if (fileNameOnly.equals("")) {
                    } else {
                        String extension = "";
                        String tmpExt = fileNameOnly;
                        int i = tmpExt.lastIndexOf('.');
                        int p = Math.max(tmpExt.lastIndexOf('/'), tmpExt.lastIndexOf('\\'));
                        if (i > p) {
                            extension = tmpExt.substring(i + 1);
                        }
                        ArrayList<String> valueList = new ArrayList<String>();
                        if (extension.equalsIgnoreCase("xls")) {
                            valueList = new XLSHelper().getAllValues(xlsFile);
                        } else if (extension.equalsIgnoreCase("xlsx")) {
                            valueList = new XLSXHelper().getAllValues(xlsFile);
                        } else if (extension.equalsIgnoreCase("csv")) {
                            valueList = new CSVHelper().getAllValues(xlsFile);
                        } else if (extension.equalsIgnoreCase("txt")) {
                            valueList = new TXTHelper().getAllValues(xlsFile);
                        } else {
                        }

                        if (valueList.size() > 0) {
                            StringBuffer sbf = new StringBuffer();
                            for (int a = 0; a < valueList.size(); a++) {
                                String tmpValue = valueList.get(a);
                                sbf.append(tmpValue);
                                if (a < valueList.size() - 1) {
                                    sbf.append(",");
                                }
                            }
                            values = sbf.toString();
                            message = "returnValues();";
                        } else {
                            message = "alert('Invalid File! ONLY XLS, XLSX, CSV & TXT files are allowed.');";
                        }
                    }
                }
            }
        }
    }
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>lesflo Import</title>
        <script>
            function importFileChanged(){
                document.getElementById("importFileName").value = document.getElementById("importFile").value;
                document.importFrm.submit();
            }
            
            function returnValues(){
                window.opener.assignValue('<%=StringEscapeUtils.escapeJavaScript(values)%>');
                self.close();
            }
        </script>
    </head>
    <body>
        <form id="importFrm" name="importFrm" action="importing.jsp" method="POST" ENCTYPE="multipart/form-data">
            <input type="hidden" id="importFileName" name="importFileName"/>
            <input type="file" id="importFile" name="importFile" onchange="importFileChanged()"/>
        </form>
        <script><%=message%></script>
    </body>
</html>
