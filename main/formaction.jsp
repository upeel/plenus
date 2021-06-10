<%-- 
    Document   : formaction
    Created on : Jan 20, 2014, 2:32:32 PM
    Author     : SOE HTIKE
--%>
<% request.setCharacterEncoding("UTF-8");%>
<%@page import="com.bizmann.servlet.upload.FileMeta"%>
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
<%@ include file="helper/formsessioncheck.jsp" %>
<%    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("Expires", "0");

    String closingmessage = "";

    String fhFlowChartId = request.getParameter("flowChartId");
    if (fhFlowChartId == null)
    {
        fhFlowChartId = "0";
    }
    String fhActionId = request.getParameter("actionId");
    if (fhActionId == null)
    {
        fhActionId = "0";
    }

    String fhProcessId = request.getParameter("processId");
    if (fhProcessId == null)
    {
        fhProcessId = "0";
    }

    String fhUserId = request.getParameter("userId");
    if (fhUserId == null)
    {
        fhUserId = "0";
    }

    NewEngineController newEngineCtrl = new NewEngineController();
    if (!newEngineCtrl.isUserCorrectAction(Integer.parseInt(fhActionId), Integer.parseInt(fhUserId), Integer.parseInt(fhProcessId)))
    {
        closingmessage = "alert('Hey! This form does not belong to you. What are you trying to do?');window.close();self.close();";
        //this message will never be alerted out!!!

        out.println("<script>alert('Hey! This form does not belong to you. What are you trying to do?');window.close();self.close();</script>");
        return;
    }

    GenController gCtrl = new GenController();
    String generatedNumber = gCtrl.getGeneratedNumberByProcessId(Integer.parseInt(fhProcessId));
    EngineResponseController fhEngineResponseCtrl = new EngineResponseController();
    //System.out.println("1 : " + System.currentTimeMillis() / 1000L);
    ArrayList fhResponseList = fhEngineResponseCtrl.getResponses(Integer.parseInt(fhActionId));
    //System.out.println("2 : " + System.currentTimeMillis() / 1000L);

    response.addHeader("REFRESH", request.getSession().getMaxInactiveInterval() + ";URL=../include/redirect.jsp");

    FormActionController frmActCtrl = new FormActionController();
    //System.out.println("3 : " + System.currentTimeMillis() / 1000L);
    ArrayList<ActionData> cellValuesList = frmActCtrl.getDataByProcessId(Integer.parseInt(fhProcessId));
    //System.out.println("4 : " + System.currentTimeMillis() / 1000L);

    FileAttachmentController faCtrl = new FileAttachmentController();
    //System.out.println("5 : " + System.currentTimeMillis() / 1000L);
    ArrayList<FileMeta> fmList = faCtrl.getAttachmentsByProcessId(Integer.parseInt(fhProcessId));
    //System.out.println("6 : " + System.currentTimeMillis() / 1000L);

    CommentUtil commUtil = new CommentUtil();
    //System.out.println("7 : " + System.currentTimeMillis() / 1000L);
    ArrayList<com.bizmann.product.entity.Comment> commList = commUtil.getCommentsByProcesId(Integer.parseInt(fhProcessId));
    //System.out.println("8 : " + System.currentTimeMillis() / 1000L);

    try
    {
        FormController frmCtrl = new FormController();
        FieldController fieldCtrl = new FieldController();
        //System.out.println("9 : " + System.currentTimeMillis() / 1000L);
        int formId = frmActCtrl.getFormIdByFlowchartId(Integer.parseInt(fhFlowChartId));
        //System.out.println("10 : " + System.currentTimeMillis() / 1000L);

        //System.out.println("11 : " + System.currentTimeMillis() / 1000L);
        com.bizmann.poi.entity.Form form = frmCtrl.getFormById(formId);
        //System.out.println("12 : " + System.currentTimeMillis() / 1000L);

        String formName = form.getName();
        String fileName = form.getPath();

        String baseExcelPath = Application.getAPPLICATION_EXCEL_CONTAINER_FILE_PATH();
        File xlsFile = new File(baseExcelPath + fileName);
        Workbook workbook = WorkbookFactory.create(xlsFile);
        int sheetCount = workbook.getNumberOfSheets();
        sheetCount = 1;

        //System.out.println("13 : " + System.currentTimeMillis() / 1000L);
        HashMap<String, FieldDetails> fDetailsList = fieldCtrl.getFieldDetailsByFormIdByActionId(formId, Integer.parseInt(fhActionId), Integer.parseInt(fhUserId));
        //System.out.println("14 : " + System.currentTimeMillis() / 1000L);
        ArrayList<Field> formulaList = new ArrayList<Field>();
        ArrayList<FieldDetails> autocomList = new ArrayList<FieldDetails>();
        ArrayList<FieldDetails> signatureList = new ArrayList<FieldDetails>();

        String cbResponse = request.getParameter("cbResponse");
        if (cbResponse == null)
        {
            cbResponse = "0";
        }
        cbResponse = cbResponse.trim();
        if (cbResponse.equals(""))
        {
            cbResponse = "0";
        }
        if (!cbResponse.equals("0"))
        {
            //response has been made

            Enumeration paramValueList = request.getParameterNames();
            ArrayList<ActionData> adList = new ArrayList<ActionData>();
            while (paramValueList.hasMoreElements())
            {
                String name = (String) paramValueList.nextElement();
                if (!name.equals("cbResponse") && !name.equals("flowChartId") && !name.equals("actionId")
                        && !name.equals("processId") && !name.equals("userId") && !name.equals("mainSubBtn"))
                {
                    String value = "";
                    String[] checkboxArr = request.getParameterValues(name);
                    if (checkboxArr != null && checkboxArr.length > 1)
                    {
                        for (int a = 0; a < checkboxArr.length; a++)
                        {
                            value = value + checkboxArr[a] + ",";
                        }
                        if (value.contains(","))
                        {
                            value = value.substring(0, value.length() - 1);
                        }
                    }
                    else
                    {
                        value = (String) request.getParameter(name);
                    }
                    //System.out.println(name + " : " + value);
                    ActionData ad = new ActionData();
                    ad.setCellId(name);
                    ad.setValue(value);
                    adList.add(ad);
                }
            }

            boolean success = false;
            if (adList.size() > 0)
            {
                //System.out.println("15 : " + System.currentTimeMillis() / 1000L);
                success = frmActCtrl.insertData(Integer.parseInt(fhFlowChartId), Integer.parseInt(fhActionId), Integer.parseInt(fhProcessId), Integer.parseInt(fhUserId), adList);
                //System.out.println("16 : " + System.currentTimeMillis() / 1000L);
                if (success)
                {
                    generatedNumber = frmActCtrl.doRouting(Integer.parseInt(fhFlowChartId), Integer.parseInt(fhActionId), Integer.parseInt(fhProcessId), Integer.parseInt(fhUserId), Integer.parseInt(cbResponse));
                }
            }
            if (success)
            {
                if (generatedNumber != null && !generatedNumber.equals(""))
                {
                    closingmessage += "alert('Document Number : " + generatedNumber + "!');FloReload();window.close();self.close();";
                }
                else
                {
                    closingmessage += "alert('Form Data Submitted Successfully!');FloReload();window.close();self.close();";
                }
            }
            else
            {
                closingmessage = "alert('Error! Data Submission Failed! Try again or Contact the Site Admin!');FloReload();window.close();self.close();";
            }
        }

        //customizing address auto-populate - when no response is made yet
        boolean autoPopAddress = false;
        //if (Integer.parseInt(fhFlowChartId) == 1 && Integer.parseInt(fhActionId) == 1 && Integer.parseInt(cbResponse) == 0) {
        //    autoPopAddress = true;
        //}
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script>
            var vuploaduserid = '<%=fhUserId%>';
            var vuploadprocessid = '<%=fhProcessId%>';
            var vuploadflowchartid = '<%=fhFlowChartId%>';
            var vuploadactionid = '<%=fhActionId%>';
        </script>
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

        <script src="../include/js/vendor/jquery.ui.widget.js"></script>
        <script src="../include/js/jquery.iframe-transport.js"></script>
        <script src="../include/js/jquery.fileupload.js"></script>
        <script src="../include/js/jquery.fileupload-ui.js"></script>
        <script src="../include/bootstrap/js/bootstrap.min.js"></script>
        <!--                <link href="../include/bootstrap/css/bootstrap.css" type="text/css" rel="stylesheet" />-->
        <link href="../include/css/myuploadcss.css" type="text/css" rel="stylesheet" />
        <link href="../include/css/mycommentcss.css" type="text/css" rel="stylesheet" />
        <link rel="stylesheet" href="../include/css/jquery.fileupload-ui.css">
        <link href="../include/css/dropzone.css" type="text/css" rel="stylesheet" />
        <script src="../include/js/myuploadfunction.js"></script>
        <script type="text/javascript" src="../include/js/pdfobject.js"></script>

        <title>bmFLO</title>
        <style>

            #container{
                width: 100%;
                white-space: nowrap;
                overflow: hidden;
            }

            #formdata{
                /*                position: relative;*/
                white-space:nowrap;
                overflow:hidden;
                text-overflow:ellipsis;
                -ms-text-overflow:ellipsis;
                /*                text-align: right;*/
                width:auto;
                float:left;
            }

            #pdfbox {
                width: 530px;
                height: 530px;

                white-space:nowrap;
                overflow:hidden;
                text-overflow:ellipsis;
                -ms-text-overflow:ellipsis;
                float: left;
                position:absolute;
                max-width:inherit;

                z-index: 10;
            }

            #pdf {
                width: 510px !important;;
                height: 510px !important;;
                margin: 2em auto;
                border: 10px solid #6699FF;

                white-space:nowrap;
                overflow:hidden;
                text-overflow:ellipsis;
                -ms-text-overflow:ellipsis;
                float: left;
                position:absolute;
                max-width:inherit;
            }

            #pdf p {
                padding: 1em;
            }

            #pdf object {
                width: 510px;
                height: 510px;
                display: block;
                border: solid 1px #666;
            }
            /*            input[type=number]{
                            width:100px;
                        }*/
            body { font: 12px arial,helvetica,clean,sans-serif; background-color: #f4f4f4; }

            input[type=submit] {
                background: url(images/submit.gif);
                border: 0;
                /*                display: block;*/
                /*                height: _the_image_height;
                                width: _the_image_width;*/
            }
            div.savestatus{ /* Style for the "Saving Form Contents" DIV that is shown at the top of the form */
                width:200px;
                padding:2px 5px;
                border:1px solid gray;
                background:#fff6e5;
                -webkit-box-shadow: 0 0 8px #818181;
                box-shadow: 0 0 8px #818181;
                -moz-border-radius: 5px;
                -webkit-border-radius: 5px;
                border-radius:5px;
                color:red;
                position:absolute;
                top:-10px;
            }

            #subfooter {
                z-index: 10;
                position:fixed;
                bottom:0;
            }
        </style>
        <script>
            function closePdf() {
                $('#pdfbox').hide();
                $("#pdf").hide();
                $('#closePdfButton').hide();
                //document.getElementById("formdata").style.marginLeft = "0";
                $("#formdata").css('marginLeft', '0px');
                //                $("#formdata").css("margin-left") = "0px";
            }

            function embedPdfBtnClicked(vrelativeurl) {
                var myPDF = new PDFObject({
                    url: "../GetAttachmentFile?attachmentFilePath=" + vrelativeurl,
                    pdfOpenParams: {view: 'Fit', pagemode: 'none', scrollbars: '1', toolbar: '1', statusbar: '1', messages: '1', navpanes: '1'}
                }).embed('pdf');
                $('#pdfbox').show();
                $("#pdf").show();
                $('#closePdfButton').show();
                //document.getElementById("formdata").style.marginLeft = "550";
                $("#formdata").css('marginLeft', '550px');
                //                $("#formdata").css("margin-left") = "550px";
                // Be sure your document contains an element with the ID 'aa' 
            }

            function getScrollTop() {
                if (typeof window.pageYOffset !== 'undefined') {
                    // Most browsers
                    return window.pageYOffset;
                }

                var d = document.documentElement;
                if (d.clientHeight) {
                    // IE in standards mode
                    return d.scrollTop;
                }

                // IE in quirks mode
                return document.body.scrollTop;
            }

            function getScrollLeft() {
                if (typeof window.pageXOffset !== 'undefined') {
                    // Most browsers
                    return window.pageXOffset;
                }

                var d = document.documentElement;
                if (d.clientWidth) {
                    // IE in standards mode
                    return d.scrollLeft;
                }

                // IE in quirks mode
                return document.body.scrollLeft;
            }

            window.onscroll = function () {
                var box = document.getElementById('pdfbox'),
                        scroll = getScrollTop();
                scrollLeft = getScrollLeft();

                if (scroll <= 4) {
                    box.style.top = "5px";
                } else {
                    box.style.top = (scroll + 2) + "px";
                }
                if (scrollLeft <= 4) {
                    box.style.left = "5px";
                } else {
                    box.style.left = (scrollLeft + 2) + "px";
                }
            }

            var formsave1 = new autosaveform({
                formid: 'frmAction',
                pause: 1000 //<--no comma following last option!
            })

            function clearAll() {
                formsave1.savefields("clear");
                document.location.reload(); //or resubmit if needed.
            }

            function FloReload() {
                //FloSleep(3000);
                //opener.location.reload(true);
                //                setTimeout(function () {
                //                    opener.location.reload(true); 
                //                }, 3000);
                //                setTimeout(opener.location.reload(true), 100000);
                opener.location.reload(true);
                //var URL = unescape(window.opener.location.pathname);
                //window.opener.location.href = URL; 
            }

            function formatDecimal(elem, decimals) {
                elem.value = parseFloat(elem.value).toFixed(decimals);
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

            $(document).ready(function () {
                var vwidth = document.getElementById("formdata").offsetWidth;
                var vheight = document.getElementById("formdata").offsetHeight;
                document.getElementById('pdf').setAttribute("style", "height:" + vheight + "px");
                document.getElementById('pdfbox').setAttribute("style", "height:" + parseFloat(vheight) + 20 + "px");
                $('#pdfbox').hide();
                $('#pdf').hide();
                $('#closePdfButton').hide();


            <% if (autoPopAddress)
                {%>
                $('#B9').focusout(function () {
                    $.ajax({
                        url: 'helper/getAddressByName.jsp',
                        data: 'name=' + fnURLEncode(document.getElementById("B9").value),
                        success: function (data) {
                            var cData = eval(data);
                            //alert(data);
                            //console.log(cData[0].txtAddress);
                            $('#E10').val(cData[0].txtAddress);
                        }
                    });
                });
            <% }%>
            <% if (closingmessage.equals(""))
                {%>
                $('#plainwhite').hide();
            <%}%>
                //                $('#excelUpload').show();
                $('#dvLoading').hide();
                $('#overlay').hide();
                //                $('#excelDesign').hide();
                //                $('.sigPad').signaturePad({drawOnly : true, validateFields: false});
                $(window).bind('beforeunload', function (e) {
                    $('#dvLoading').show();
                    $('#overlay').show();
                });

                //                    $(window).bind('unload', function(e) {
                //                        FloReload();
                //                    });

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
            });
        </script>
    </head>
    <body style="padding-bottom: 2cm;">
        <div id="plainwhite" class="web_dialog_cover"></div>
        <div id="dvLoading">
            <!--            vertical-align:middle; height:800px; width:800px; margin:0 auto;-->
            <div style="position:absolute; top:54%; left:30%;">
                <i style="color:red"><b>Please do NOT refresh, back or resubmit the form!</b></i>
            </div>
        </div>
        <div id="overlay" class="web_dialog_overlay"></div>
        <form id="frmAction" name="frmAction" method="POST" action="formaction.jsp" data-ajax="false">
            <div style="width: 100%" id="subfooter" name="subfooter" bgcolor="E4EFF3">
                <table width="100%" bgcolor="E4EFF3">
                    <tr>
                        <td>
                            <table>
                                <tr>
                                    <td>
                                        <select size="1" id="cbResponse" name="cbResponse" style="font:12px arial,helvetica,clean,sans-serif">
                                            <%
                                                for (int i = 0; i < fhResponseList.size(); i++)
                                                {
                                                    Response res = (Response) fhResponseList.get(i);
                                                    int responseId = res.getId();
                                                    String responseName = res.getName();
                                            %>
                                            <option value="<%=responseId%>"><%=responseName%></option>

                                            <%}%>
                                        </select>
                                    </td>
                                    <td>
                                        <input type="hidden" id="flowChartId" name="flowChartId" value="<%=fhFlowChartId%>"/>
                                        <input type="hidden" id="actionId" name="actionId" value="<%=fhActionId%>"/>
                                        <input type="hidden" id="processId" name="processId" value="<%=fhProcessId%>"/>
                                        <input type="hidden" id="userId" name="userId" value="<%=fhUserId%>"/>
                                        &nbsp;
                                        <input name="mainSubBtn" id="mainSubBtn" type="image" src="images/submit.gif" style="cursor:pointer"/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
            <h2>
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
                <div float="left" align="left">
                    <input type="button" id="clearAutoSaveBtn" name="clearAutoSaveBtn" onclick="clearAll()" value="Clear Autosaved Data" />
                    For Process: <%=fhProcessId%>
                </div>
            </h2>
            <div id="container" name="container">
                <div id="pdfbox" name="pdfbox">
                    <div float="right" align="right" id="closePdfButton" name="closePdfButton">
                        <input type="button" id="closeEmbeddedPdf" name="closeEmbeddedPdf" onclick="closePdf()" value="Close PDF" />
                    </div>
                    <div id="pdf" class="one" style="height: 530px; display: block;">
                        It appears you don't have Adobe Reader or PDF support in this web browser.
                    </div>
                </div>
                <div id="formdata" name="formdata" class="two">
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
                                                        formulaList.add(fformula.getField());
                                                        //out.println(fieldCtrl.renderUIByFieldDetails(fformula));
                                                        out.println(frmActCtrl.renderUIByFieldDetailsWithData(fformula, cellValuesList, Integer.parseInt(fhProcessId), Integer.parseInt(fhUserId)));
                                                        break;
                                                    default:
                                                        FieldDetails fd = fDetailsList.get(cellIdentifier);
                                                        if (fd != null)
                                                        {
                                                            if (fd.getField().getField_type_id() == 11)
                                                            {
                                                                autocomList.add(fd);
                                                            }
                                                            else if (fd.getField().getField_type_id() == 14)
                                                            {
                                                                signatureList.add(fd);
                                                            }
                                                            out.println(frmActCtrl.renderUIByFieldDetailsWithData(fd, cellValuesList, Integer.parseInt(fhProcessId), Integer.parseInt(fhUserId)));
                                                        }
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
                                                    else if (fd.getField().getField_type_id() == 14)
                                                    {
                                                        signatureList.add(fd);
                                                    }
                                                    out.println(frmActCtrl.renderUIByFieldDetailsWithData(fd, cellValuesList, Integer.parseInt(fhProcessId), Integer.parseInt(fhUserId)));
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
                </div>
            </div>
        </form>
        <br/>
        <br/>
        <div style="width:60%; float: left;">
            <fieldset>
                <legend>
                    <div>
                        <b>&nbsp;Attach Files&nbsp;&nbsp;</b>
                    </div>
                </legend>
                <form id="file_upload" action="../upload" method="POST" enctype="multipart/form-data">
                    <input type="hidden" id="factionid" name="factionid" value="<%=fhActionId%>" />
                    <input type="hidden" id="fprocessid" name="fprocessid" value="<%=fhProcessId%>" />
                    <input type="hidden" id="fuserid" name="fuserid" value="<%=fhUserId%>" />
                    <div id="dropzone" class="fade well">
                        <input id="file_1" type="file" name="file_1" multiple>
                        <div>Drop Files Here</div>
                    </div>
                    <h5 style="text-align:center">
                        <i style="color:blue"><small>Please do NOT navigate away from the page until the File Upload is finished!</small></i>
                        <br/>
                        <i style="color:red"><small>WARNING: Deleting Files will reload the page & Any unsaved data will be lost!</small></i>
                    </h5>
                    <table id="uploaded-files" class="table">
                        <tr>
                            <th>File Name</th>
                            <th>File Size</th>
                            <th>File Type</th>
                            <th>Uploaded By</th>
                            <th>&nbsp;</th>
                            <th>&nbsp;</th>
                        </tr>
                        <%
                            for (int a = 0; a < fmList.size(); a++)
                            {
                                FileMeta fm = fmList.get(a);
                        %>
                        <tr>
                            <td><a href="../GetAttachmentFile?attachmentFilePath=<%=StringEscapeUtils.escapeHtml(fm.getFileUrl())%>" target='_blank'><%=fm.getFileName()%></a></td>
                            <td><%=fm.getFileSize()%></td>
                            <td><%=fm.getFileType()%></td>
                            <td>@<%=fm.getUploadedBy()%></td>
                            <td><input type="button" id="embedPdfBtn" name="embedPdfBtn" onclick='embedPdfBtnClicked("<%=StringEscapeUtils.escapeHtml(fm.getFileUrl())%>")' value="Embed PDF" /></td>
                            <td>
                                <% if (fm.getUserId() == Integer.parseInt(fhUserId))
                                    {%>
                                <a href='attachementdelete.jsp?flowChartId=<%=fhFlowChartId%>&actionId=<%=fhActionId%>&userId=<%=fhUserId%>&processId=<%=fhProcessId%>&fileName=<%=fm.getFileName()%>' target='_self'>Delete</a>
                                <% }
                                else
                                {%>
                                &nbsp;
                                <% }%>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </table>
                </form>
            </fieldset>
        </div>
        <div style="width:40%; float: left;">
            <fieldset>
                <legend>
                    <div>
                        <b>&nbsp;Comments&nbsp;&nbsp;</b>
                    </div>
                </legend>
                <form id="frmComment" name="frmComment">
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
                    <input type="text" id="txtComment" name="txtComment" style="width:350px;" maxlength="200"/>
                    <input type="hidden" id="cactionid" name="cactionid" value="<%=fhActionId%>" />
                    <input type="hidden" id="cprocessid" name="cprocessid" value="<%=fhProcessId%>" />
                    <input type="hidden" id="cuserid" name="cuserid" value="<%=fhUserId%>" />
                    <input type="button" id="btnComment" name="btnComment" value="Add Comment">
                </form>
            </fieldset>
        </div>
        <br/>
    </body>
    <script>
        function cleardata(eleid) {
            eleid.value = "";
        }

        function enableForm(form) {
            var length = form.elements.length,
                    i;
            for (i = 0; i < length; i++) {
                form.elements[i].disabled = false;
            }
        }

        $(function () {
            $('#btnComment').click(function (e) {
                //$('#frmComment').submit(function(){
                if ($('#txtComment').val() != '') {
                    $('#dvLoading').show();
                    $('#overlay').show();
                    var posting = $.post("formcomment.jsp", $('#frmComment').serialize());
                    posting.done(function (res) {
                        console.log(res);
                        var data = eval(res);
                        $("#tblComment").append(
                                $('<tr/>')
                                .append($('<td/>').html(data[0].txtCommentedBy))
                                .append($('<td/>').text(data[0].txtComment))
                                .append($('<td/>').text(data[0].txtCommentedOn))
                                );
                        $('#dvLoading').hide();
                        $('#overlay').hide();
                        document.getElementById("txtComment").value = "";
                    });
                }
            });

            $('#frmAction, #frmAction, #frmComment').bind("keyup keypress", function (e) {
                var code = e.keyCode || e.which;
                if (code == 13) {
                    e.preventDefault();
                    return false;
                }
            });

        <%=closingmessage%>
            jQuery("#frmAction").validationEngine();
            $(".data-datepicker").datepicker({
                showOtherMonths: false,
                changeMonth: true,
                changeYear: true,
                dateFormat: 'yy-mm-dd'
            });
            $.timeEntry.setDefaults({show24Hours: true});
            $('.data-timepicker').timeEntry();

            $("#mainSubBtn").on("click", function (event) {
                //event.preventDefault ? event.preventDefault() : event.returnValue = false;
                //$("#mainSubBtn").attr("disabled", "disabled");
                enableForm(document.getElementById("frmAction"));
                //$("#frmAction").submit();
                //document.frmAction.submit();
            });
        <%=fieldCtrl.setUpSignatures(signatureList)%>
        <%=frmActCtrl.populateData(signatureList, Integer.parseInt(fhFlowChartId), Integer.parseInt(fhActionId), Integer.parseInt(fhProcessId), Integer.parseInt(fhUserId))%>
        <%=fieldCtrl.setUpOnChangeListener(fileName, formulaList)%>
        <%=fieldCtrl.setUpAutoComListener(autocomList)%>
        });
    </script>
</html>
<%
    }
    catch (Exception e)
    {
        System.out.println("Exception in formaction : " + e);
    }
%>
