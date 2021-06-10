<%-- 
    Document   : printpage
    Created on : Feb 21, 2014, 9:58:35 AM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.*,java.util.*" %>
<%@page import="com.bizmann.poi.resource.*" %>
<%@page import="com.bizmann.product.controller.*" %>
<%@page import="com.bizmann.product.entity.*" %>
<%@page import="com.bizmann.product.resources.CommentUtil" %>
<%@page import="com.bizmann.poi.controller.*" %>
<%@page import="org.apache.poi.ss.usermodel.*" %>
<%@page import="org.apache.poi.ss.util.*" %>
<%@page import="com.bizmann.poi.entity.*" %>
<%@page import="com.bizmann.servlet.upload.*" %>
<%@page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@page import="com.bizmann.gen.controller.GenController" %>
<%@page import="com.bizmann.utility.Application" %>
<!DOCTYPE html>
<%
    try
    {
        String ssid = (String) session.getAttribute("user");
        if (ssid == null || ssid.equals(""))
        {
            ssid = "";
        }
        UserController userCtrl = new UserController();
        int userId = userCtrl.getUserIdByLoginId(ssid);

        String strProcessId = request.getParameter("processId");
        if (strProcessId == null)
        {
            strProcessId = "0";
        }
        strProcessId = strProcessId.trim();

        if (strProcessId.equals(""))
        {
            strProcessId = "0";
        }
        strProcessId = strProcessId.replaceAll("P", "");

        int processId = Integer.parseInt(strProcessId);

        ArrayList<FieldDetails> signatureList = new ArrayList<FieldDetails>();

        FormController frmCtrl = new FormController();
        FieldController fieldCtrl = new FieldController();
        FormActionController frmActCtrl = new FormActionController();

        ArrayList<ActionData> cellValuesList = frmActCtrl.getDataByProcessId(processId);

        int formId = frmActCtrl.getFormIdByProcessId(processId);

        com.bizmann.poi.entity.Form form = frmCtrl.getFormById(formId);

        String formName = form.getName();
        String fileName = form.getPath();

        String baseExcelPath = Application.getAPPLICATION_EXCEL_CONTAINER_FILE_PATH();
        File xlsFile = new File(baseExcelPath + fileName);
        Workbook workbook = WorkbookFactory.create(xlsFile);
        int sheetCount = workbook.getNumberOfSheets();
        sheetCount = 1;

        HashMap<String, FieldDetails> fDetailsList = fieldCtrl.getFieldDetailsByFormIdForPrintPage(formId, userId);

        FileAttachmentController faCtrl = new FileAttachmentController();
        ArrayList<FileMeta> fmList = faCtrl.getAttachmentsByProcessId(processId);

        CommentUtil commUtil = new CommentUtil();
        ArrayList<com.bizmann.product.entity.Comment> commList = commUtil.getCommentsByProcesId(processId);

        String generatedNumber = new GenController().getGeneratedNumberByProcessId(processId);
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="../include/js/jquery.min.js"></script>
        <script src="../include/js/url.js"></script>
        <script src="../include/jquery-ui-1.10.3/ui/jquery-ui.js"></script>
        <script src="../include/time/jquery.timeentry.js"></script>
        <script type="text/javascript" src="../include/js/jquery.validationEngine-en.js" charset="utf-8"></script>
        <script type="text/javascript" src="../include/js/jquery.validationEngine.js"></script>
        <script type="text/javascript" src="../include/js/jquery.signaturepad.min.js"></script>
        <link rel="stylesheet" type="text/css" href="../include/css/jquery.signaturepad.css"/>
        <link rel="stylesheet" type="text/css" href="../include/css/validationEngine.jquery.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" href="../include/jquery-ui-1.10.3/themes/base/jquery-ui.css" type="text/css" />
        <link rel="stylesheet" href="../include/css/loading.css" type="text/css" />
        <link rel="stylesheet" href="../include/time/jquery.timeentry.css" type="text/css" />
        <link rel="stylesheet" href="../include/css/loading.css" type="text/css" />
        <link href="../include/css/myuploadcss.css" type="text/css" rel="stylesheet" />
        <link href="../include/css/mycommentcss.css" type="text/css" rel="stylesheet" />
        <title>Print Page</title>
        <!--        <script>
                    $(function(){
                        $('.sigPad').signaturePad({drawOnly : true, validateFields: false});
                    });
                </script>-->
        <style>
            /*            @font-face {
                            font-family: 'Arial';
                            src: url('font/arial.ttf');
                        }*/
            /*font-family: 'Arial';*/
            /*            body { font: 11px; background-color: #f4f4f4; }*/
            body { font: 13px arial,helvetica,clean,sans-serif; background-color: #f4f4f4; }

            input, textarea{
                background-color: transparent;
                border: 0px solid;
                /*                height: 20px;
                                width: 160px;
                                color: #CCC;*/
            }
        </style>
    </head>
    <body>
        <form id="printpage" name="printpage">
            <div style="width: 100%">
                <%
                    List lst = workbook.getAllPictures();
                    Iterator it = lst.iterator();
                %>
                <% if (it.hasNext())
                    {%>
                <img src="iframelogo.jsp?formid=<%=formId%>" height="90px"></img>
                <% }%>
                <font size="5.4">
                <u>
                    <b>
                        <%=formName%>
                        <%if (generatedNumber.length() > 0)
                            {%>
                        (<%=generatedNumber%>)
                        <%}%>
                    </b>
                </u>
                </font>
            </div>
            <%
                for (int a = 0; a < sheetCount; a++)
                {
                    ArrayList<CellProperties> mergeList = new ArrayList<CellProperties>();
                    ArrayList<CellProperties> heightList = new ArrayList<CellProperties>();
                    ArrayList<CellProperties> widthList = new ArrayList<CellProperties>();
                    Sheet sheet = workbook.getSheetAt(a);
                    out.println("<table style='border-collapse:collapse;border-spacing:0;table-layout:fixed;'>");
                    if (sheet != null)
                    {
                        int maxColCount = 0;
                        int maxRowCount = sheet.getLastRowNum();
                        int mergeCount = sheet.getNumMergedRegions();
                        for (int b = 0; b <= maxRowCount; b++)
                        {
                            Row row = sheet.getRow(b);
                            if (row != null)
                            {
                                int curColCount = row.getLastCellNum();
                                if (maxColCount < curColCount)
                                {
                                    maxColCount = curColCount;
                                }
                                CellProperties cp = new CellProperties();
                                cp.setHeight(row.getHeightInPoints());
                                heightList.add(cp);
                            }
                        }
                        out.println("<colgroup>\n\r<col>");
                        for (int d = 0; d < maxColCount; d++)
                        {
                            CellProperties cp = new CellProperties();
                            float tmpWidth = PixelUtil.widthUnits2Pixel(sheet.getColumnWidth(d));
                            out.println("<col width='" + tmpWidth + "'>");
                        }
                        out.println("</colgroup>");
                        //out.println("<thead>\n\r<th style='border:1px solid #FF0000;'></th>");
                        for (int d = 0; d < maxColCount; d++)
                        {
                            CellProperties cp = new CellProperties();
                            float tmpWidth = PixelUtil.widthUnits2Pixel(sheet.getColumnWidth(d));
                            cp.setWidth(tmpWidth);
                            widthList.add(cp);
                            String columnLetter = CellReference.convertNumToColString(d);
                        }
                        out.println("</thead>");
                        for (int c = 0; c < mergeCount; c++)
                        {
                            CellRangeAddress crAdd = sheet.getMergedRegion(c);
                            if (crAdd != null)
                            {
                                CellProperties cp = new CellProperties();
                                cp.setRowIndex(crAdd.getFirstRow());
                                cp.setColIndex(crAdd.getFirstColumn());
                                cp.setRowspan(frmCtrl.getRowSpan(crAdd));
                                cp.setColspan(frmCtrl.getColSpan(crAdd));
                                mergeList.add(cp);
                            }
                        }
                        for (int x = 0; x <= maxRowCount; x++)
                        {
                            Row row = CellUtil.getRow(x, sheet);

                            float rowHeight = 0;
                            if (row != null)
                            {
                                rowHeight = row.getHeightInPoints();
                            }
                            out.println("<tr>");;
                            for (int y = 0; y < maxColCount; y++)
                            {
                                if (row != null)
                                {
                                    Cell cell = CellUtil.getCell(row, y);
                                    CellProperties cpMerge = frmCtrl.isMerged(mergeList, x, y);
                                    if (cpMerge.getRowspan() > 0 || cpMerge.getColspan() > 0)
                                    {
                                        //style='border:1px solid #8e90ff;' 
                                        out.print("<td colspan='" + cpMerge.getColspan() + "'>");
                                        y += cpMerge.getColspan() - 1;
                                    }
                                    else
                                    {
                                        //style='border:1px solid #8e90ff;'
                                        out.print("<td >");
                                    }
                                    CellReference cellRef = new CellReference(row.getRowNum(), y);
                                    String cellIdentifier = cellRef.formatAsString();
                                    if (cell != null)
                                    {
                                        switch (cell.getCellType())
                                        {
                                            case Cell.CELL_TYPE_STRING:
                                                out.print(cell.getRichStringCellValue().getString());
                                                break;
                                            case Cell.CELL_TYPE_NUMERIC:
                                                if (org.apache.poi.ss.usermodel.DateUtil.isCellDateFormatted(cell))
                                                {
                                                    out.print(cell.getDateCellValue());
                                                }
                                                else
                                                {
                                                    out.print(cell.getNumericCellValue());
                                                }
                                                break;
                                            case Cell.CELL_TYPE_BOOLEAN:
                                                out.print(cell.getBooleanCellValue());
                                                break;
                                            case Cell.CELL_TYPE_FORMULA:
                                                FieldDetails fformula = fDetailsList.get(cellIdentifier);
                                                //out.println(fieldCtrl.renderUIByFieldDetails(fformula));
                                                out.println(frmActCtrl.renderUIByFieldDetailsWithDataForPrintPage(fformula, cellValuesList, processId, userId));
                                                break;
                                            default:
                                                FieldDetails fd = fDetailsList.get(cellIdentifier);
                                                if (fd != null)
                                                {
                                                    if (fd.getField().getField_type_id() == 14)
                                                    {
                                                        signatureList.add(fd);
                                                    }
                                                    //out.println(fieldCtrl.renderUIByFieldDetails(fd));
                                                    out.println(frmActCtrl.renderUIByFieldDetailsWithDataForPrintPage(fd, cellValuesList, processId, userId));
                                                }
                                        }
                                    }
                                    else
                                    {
                                        FieldDetails fd = fDetailsList.get(cellIdentifier);
                                        if (fd != null)
                                        {
                                            if (fd.getField().getField_type_id() == 14)
                                            {
                                                signatureList.add(fd);
                                            }
                                            //out.println(fieldCtrl.renderUIByFieldDetails(fd));
                                            out.println(frmActCtrl.renderUIByFieldDetailsWithDataForPrintPage(fd, cellValuesList, processId, userId));
                                        }
                                    }
                                    out.println("</td>");
                                }
                            }
                            out.println("</tr>");
                        }
                    }
                    out.print("</table>");
                }
            %>
            <br/>
            <br/>
            <div style="width:60%; float: left;">
                <fieldset>
                    <legend>
                        <div>
                            <b>&nbsp;Attached Files List&nbsp;&nbsp;</b>
                        </div>
                    </legend>
                    <table id="uploaded-files" class="table">
                        <tr>
                            <th>File Name</th>
                            <th>File Size</th>
                            <th>File Type</th>
                            <th>Uploaded By</th>
                        </tr>
                        <%
                            for (int a = 0; a < fmList.size(); a++)
                            {
                                FileMeta fm = fmList.get(a);
                        %>
                        <tr>
                            <td><a href='../<%=fm.getFileUrl()%>' target='_blank'><%=fm.getFileName()%></a></td>
                            <td><%=fm.getFileSize()%></td>
                            <td><%=fm.getFileType()%></td>
                            <td>@<%=fm.getUploadedBy()%></td>
                        </tr>
                        <%
                            }
                        %>
                    </table>
                </fieldset>
            </div>
            <div style="width:40%; float: left;">
                <fieldset>
                    <legend>
                        <div>
                            <b>&nbsp;Comments&nbsp;&nbsp;</b>
                        </div>
                    </legend>
                    <table id="tblComment" name="tblComment" class="table">
                        <tr>
                            <th>Commented By</th>
                            <th>Comment</th>
                            <th>Commented On</th>
                        </tr>
                        <%
                            for (int a = 0; a < commList.size(); a++)
                            {
                                com.bizmann.product.entity.Comment comm = commList.get(a);

                        %>
                        <tr>
                            <td><%=comm.getUsername()%></td>
                            <td><%=comm.getMessage()%></td>
                            <td><%=comm.getCommentdate()%></td>
                        </tr>
                        <%
                            }
                        %>
                    </table>
                </fieldset>
            </div>
            <br/>
        </form>
    </body>
    <script>

        function disableForm(form) {
            var length = form.elements.length,
                    i;
            for (i = 0; i < length; i++) {
                form.elements[i].disabled = true;
            }
        }

        $(function () {
        <%=fieldCtrl.setUpSignatures(signatureList)%>
        <%=frmActCtrl.populateData(signatureList, processId)%>
            disableForm(document.getElementById("printpage"));
        });
    </script>
</html>
<%
    }
    catch (Exception e)
    {
        System.out.println("Exception at print page : " + e);
    }
%>
