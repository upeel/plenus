<%-- 
    Document   : iframelogo
    Created on : May 5, 2014, 10:46:26 AM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.*,java.util.*" %>
<%@page import="com.bizmann.poi.resource.*" %>
<%@page import="com.bizmann.poi.controller.*" %>
<%@page import="org.apache.poi.ss.usermodel.*" %>
<%@page import="org.apache.poi.ss.util.*" %>
<%@page import="com.bizmann.poi.entity.*"
        import = "com.bizmann.product.controller.*" 
        import = "com.bizmann.utility.Application" %>
<%@ include file="helper/sessioncheck.jsp" %>
<!DOCTYPE html>
<%    String strformid = request.getParameter("formid");
    if (strformid == null)
    {
        strformid = "0";
    }
    strformid = strformid.trim();
    if (strformid.equals(""))
    {
        strformid = "0";
    }
    int formid = Integer.parseInt(strformid);
    if (formid != 0)
    {
        String filename = request.getParameter("filename");
        if (filename == null)
        {
            filename = "";
        }
        filename = filename.trim();
        filename = new FormController().getFileNameById(formid);

        if (filename.equalsIgnoreCase(""))
        {
            // do nothing
        }
        else
        {
            String baseExcelPath = Application.getAPPLICATION_EXCEL_CONTAINER_FILE_PATH();
            File xlsFile = new File(baseExcelPath + filename);
            Workbook workbook = WorkbookFactory.create(xlsFile);
            List lst = workbook.getAllPictures();
            for (Iterator it = lst.iterator(); it.hasNext();)
            {
                PictureData pict = (PictureData) it.next();
                String ext = pict.suggestFileExtension();
                byte[] imageData = pict.getData();
                ServletOutputStream outprint = response.getOutputStream();
                if (ext.equals("jpeg") || ext.equals("jpg"))
                {
                    response.setContentType("image/jpeg");
                    outprint.write(imageData);
                    //FileOutputStream foutStream = new FileOutputStream("pict.jpg");
                    //foutStream.write(data);
                    //foutStream.close();
                }
                else
                {
                    response.setContentType("image/png");
                    outprint.write(imageData);
                }
                outprint.flush();
                out.clear();
                out = pageContext.pushBody();
            }
        }
    }
%>
