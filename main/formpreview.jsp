<%-- 
    Document   : formpreview
    Created on : Nov 28, 2013, 11:43:19 AM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.*,java.util.*" %>
<%@page import="com.bizmann.poi.resource.*" %>
<%@page import="com.bizmann.poi.controller.*" %>
<%@page import="org.apache.poi.ss.usermodel.*" %>
<%@page import="org.apache.poi.ss.util.*" %>
<%@page import="com.bizmann.poi.entity.*"
        import = "com.bizmann.product.controller.*" %>
<%@page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@page import="com.bizmann.utility.Application" %>
<%@ include file="helper/sessioncheck.jsp" %>
<!DOCTYPE html>
<%    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("Expires", "0");

    try
    {
        FormController frmCtrl = new FormController();
        FieldController fieldCtrl = new FieldController();

        String strFormId = request.getParameter("formId");
        if (strFormId == null)
        {
            strFormId = "0";
        }
        strFormId = strFormId.trim();
        if (strFormId.equals(""))
        {
            strFormId = "0";
        }
        int formId = Integer.parseInt(strFormId);

        int userId = 0;
        int authGrpId = 0;
        if (ssid == null || ssid.equals(""))
        {
        }
        else
        {
            UserController userCtrl = new UserController();
            userId = userCtrl.getUserIdByLoginId(ssid);

            UserAuthGrpController authGrpCtrl = new UserAuthGrpController();
            authGrpId = authGrpCtrl.getAuthGrpIdByUserId(userId);
        }
        if (authGrpId == 1)
        {
        }
        else if (authGrpId == 3)
        {
            boolean doesBelong = frmCtrl.formBelongs2User(userId, formId);
            if (!doesBelong)
            {
                return;
            }
        }

        Form form = frmCtrl.getFormById(formId);

        String formName = form.getName();
        String fileName = form.getPath();

        String baseExcelPath = Application.getAPPLICATION_EXCEL_CONTAINER_FILE_PATH();
        File xlsFile = new File(baseExcelPath + fileName);
        Workbook workbook = WorkbookFactory.create(xlsFile);
        int sheetCount = workbook.getNumberOfSheets();
        sheetCount = 1;

        HashMap<String, FieldDetails> fDetailsList = fieldCtrl.getFieldDetailsByFormId(formId, userId);
        ArrayList<Field> formulaList = new ArrayList<Field>();
        ArrayList<FieldDetails> autocomList = new ArrayList<FieldDetails>();
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
        <link rel="stylesheet" type="text/css" href="../include/css/jquery.signaturepad.css"/>
        <link rel="stylesheet" type="text/css" href="../include/css/validationEngine.jquery.css" />
        <link rel="stylesheet" href="../include/jquery-ui-1.10.3/themes/base/jquery-ui.css" type="text/css" />
        <link rel="stylesheet" href="../include/css/loading.css" type="text/css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" href="../include/time/jquery.timeentry.css" type="text/css" />
        <title>Preview Form</title>
        <style>
            body { font: 12px arial,helvetica,clean,sans-serif; background-color: #f4f4f4; }
            /*            background: #d6d6d6;*/
            /*            body {background-image:url("../images/background.png");}*/
            #back {
                /*                background: #a999ff;*/
            }
        </style>
        <script>
            $(function () {
                $('.sigPad').signaturePad({drawOnly: true, validateFields: false});
                $("#back").button();
                $("#back").click(function () {
                    document.location.href = 'formdesign.jsp?formId=<%=formId%>';
                });
            });
        </script>
    </head>
    <body>
        <div><button id="back" name="back">Back</button></div>
        <div style="width:100%">
            <%
                List lst = workbook.getAllPictures();
                Iterator it = lst.iterator();
                if (it.hasNext())
                {%>
            <img src="iframelogo.jsp?formid=<%=formId%>" height="90px"></img>
            <% }%>
            <font size="5.4" ><u><b><%=formName%></b></u></font>
        </div>
        <form id="frmpreview" name="frmpreview">
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
                        //out.println("<colgroup>\n\r");
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

                            //out.print("<th style='border:1px solid #FF0000;'>");
                            //out.print(columnLetter);
                            //out.println("</th>");
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
                            out.println("<tr>");
                            //out.print("<th style='border:1px solid #FF0000; height: ");
                            //out.print(rowHeight);
                            //out.print("pt;'>");
                            //out.print(x + 1);
                            //out.println("</th>");
                            for (int y = 0; y < maxColCount; y++)
                            {
                                if (row != null)
                                {
                                    Cell cell = CellUtil.getCell(row, y);
                                    CellProperties cpMerge = frmCtrl.isMerged(mergeList, x, y);
                                    if (cpMerge.getRowspan() > 0 || cpMerge.getColspan() > 0)
                                    {
                                        //style='border:1px solid #191919;'
                                        out.print("<td  colspan='" + cpMerge.getColspan() + "'>");
                                        y += cpMerge.getColspan() - 1;
                                    }
                                    else
                                    {
                                        //style='border:1px solid #191919;'
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
                                                if (DateUtil.isCellDateFormatted(cell))
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
                                                formulaList.add(fformula.getField());
                                                out.println(fieldCtrl.renderUIByFieldDetails(fformula, userId));
                                                break;
                                            default:
                                                FieldDetails fd = fDetailsList.get(cellIdentifier);
                                                if (fd != null)
                                                {
                                                    if (fd.getField().getField_type_id() == 11)
                                                    {
                                                        autocomList.add(fd);
                                                    }
                                                    out.println(fieldCtrl.renderUIByFieldDetails(fd, userId));
                                                }
                                            //emptyList.add(cellIdentifier);
                                            //totalCount++;
                                            //out.print("<div id='dropTarget");
                                            //out.print(cellIdentifier);
                                            //out.print("' class='droppableContainer' ");
                                            //                                            sbf.append("style='width:");
                                            //                                            sbf.append(widthList.get(y).getWidth());
                                            //out.print("></div>");
                                        }
                                    }
                                    else
                                    {
                                        FieldDetails fd = fDetailsList.get(cellIdentifier);
                                        if (fd != null)
                                        {
                                            if (fd.getField().getField_type_id() == 11)
                                            {
                                                autocomList.add(fd);
                                            }
                                            out.println(fieldCtrl.renderUIByFieldDetails(fd, userId));
                                        }
                                        //emptyList.add(cellIdentifier);
                                        //totalCount++;
                                        //out.print("<div id='dropTarget");
                                        //out.print(cellIdentifier);
                                        //out.print("' class='droppableContainer' ");
                                        //                                    sbf.append("style='width:");
                                        //                                    sbf.append(widthList.get(y).getWidth());
                                        //out.print("></div>");
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
        </form>
    </body>
    <script>

        function cleardata(eleid) {
            eleid.value = "";
        }

        function formatDecimal(elem, decimals) {
            //var multiplier = 10000.0;
            //number = Math.round( number * multiplier ) / multiplier;    
            //multiplier = 100.0;
            elem.value = parseFloat(elem.value).toFixed(decimals);
            //number = Math.round( number * multiplier ) / multiplier;
            //return parseFloat(number);
        }

        function fnCommaCurrency(amount)
        {
            var delimiter = ",";
            var a = amount.split('.', 2)
            var d = a[1];
            var i = parseInt(a[0]);
            if (isNaN(i)) {
                return '';
            }
            var minus = '';
            if (i < 0) {
                minus = '-';
            }
            i = Math.abs(i);
            var n = new String(i);
            var a = [];
            while (n.length > 3)
            {
                var nn = n.substr(n.length - 3);
                a.unshift(nn);
                n = n.substr(0, n.length - 3);
            }
            if (n.length > 0) {
                a.unshift(n);
            }
            n = a.join(delimiter);
            if (d.length < 1) {
                amount = n;
            } else {
                amount = n + '.' + d;
            }
            amount = minus + amount;
            return amount;
        }

        function fnFormatCurrency(amount) {
            var i = parseFloat(amount);
            if (isNaN(i)) {
                i = 0.00;
            }
            var minus = '';
            if (i < 0) {
                minus = '-';
            }
            i = Math.abs(i);
            i = parseInt((i + .005) * 100);
            i = i / 100;
            s = new String(i);
            if (s.indexOf('.') < 0) {
                s += '.00';
            }
            if (s.indexOf('.') == (s.length - 2)) {
                s += '0';
            }
            s = minus + s;
            return s;
        }

        Number.prototype.format = function (n, x) {
            var re = '(\\d)(?=(\\d{' + (x || 3) + '})+' + (n > 0 ? '\\.' : '$') + ')';
            return this.toFixed(Math.max(0, ~~n)).replace(new RegExp(re, 'g'), '$1,');
        };

        function fnSetCurrency(comp, decimals) {
            //comp.value = "$"+fnCommaCurrency(fnFormatCurrency(comp.value));
            //comp.value = comp.value.replace("$", "");
            if (comp.value != '') {
                comp.value = '$' + parseFloat(comp.value.replace(/,/g, "").replace("$", "")).format(decimals, 3);
            }
            // comp.value = parseFloat(comp.value.replace(/,/g, "")).toFixed(decimals).toLocaleString();
            //        comp.value = '$' +  parseFloat(comp.value.replace(/,/g, ""))
            //        .toFixed(decimals)
            //        .toString()
            //        .replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }

        $(function () {
            jQuery("#frmpreview").validationEngine();
            $(".data-datepicker").datepicker({
                showOtherMonths: false,
                changeMonth: true,
                changeYear: true,
                dateFormat: 'yy-mm-dd'
                        //        showOn: "button",
                        //        buttonImage: "/hrss/calendar.gif",
                        //        buttonImageOnly: true
            });
            $.timeEntry.setDefaults({show24Hours: true});
            $('.data-timepicker').timeEntry();

            $(':radio').mousedown(function (e) {
                var $self = $(this);
                if ($self.is(':checked')) {
                    var uncheck = function () {
                        setTimeout(function () {
                            $self.removeAttr('checked');
                        }, 0);
                    };
                    var unbind = function () {
                        $self.unbind('mouseup', up);
                    };
                    var up = function () {
                        uncheck();
                        unbind();
                    };
                    $self.bind('mouseup', up);
                    $self.one('mouseout', unbind);
                }
            });

        <%=fieldCtrl.setUpOnChangeListener(fileName, formulaList)%>
        <%=fieldCtrl.setUpAutoComListener(autocomList)%>
        });
    </script>
</html>
<%
    }
    catch (Exception e)
    {
        System.out.println("Exception in formpreview : " + e);
    }
%>
