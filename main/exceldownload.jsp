<%-- 
    Document   : exceldownload
    Created on : Apr 8, 2014, 1:51:29 PM
    Author     : SOE HTIKE
--%>
<%@ page import = "java.util.*"
         import = "java.lang.*"
         import = "java.io.*"
         import = "com.bizmann.poi.resource.PropProcessor"
         import = "com.bizmann.product.controller.*" 
         import = "com.bizmann.utility.Application"
         %>
<%@ include file="helper/sessioncheck.jsp" %>
<%    try
    {
        String basePath = Application.getAPPLICATION_EXCEL_CONTAINER_FILE_PATH();;

        String vname = request.getParameter("name");
        if (vname == null)
        {
            vname = "";
        }
        vname = vname.trim();
        if (!vname.equals(""))
        {
            String vpath = request.getParameter("path");
            if (vpath == null)
            {
                vpath = "";
            }
            vpath = vpath.trim();
            if (!vpath.equals(""))
            {
                InputStream fr = new FileInputStream(basePath + vpath);
                byte[] b = new byte[fr.available()];
                fr.read(b, 0, b.length);
                fr.close();

                HttpServletResponse resp = (HttpServletResponse) pageContext.getResponse();

                resp.resetBuffer();
                resp.setHeader("Content-Type", "application/octet-stream");
                resp.setHeader("Content-Length", String.valueOf(b.length));
                resp.setHeader("Content-Disposition", "attachment; filename=" + vname + ".xls");
                resp.getOutputStream().write(b, 0, b.length);
                resp.flushBuffer();
            }
        }
    }
    catch (Exception e)
    {
        System.out.println("Exception at exceldownload.jsp : " + e);
    }
%>