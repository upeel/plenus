<%-- 
    Document   : formadd
    Created on : Nov 27, 2013, 10:35:45 AM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,com.jenkov.servlet.multipart.MultipartEntry,com.bizmann.poi.resource.PropProcessor" 
         import="com.bizmann.poi.controller.FormController"
         import="org.apache.commons.lang.StringEscapeUtils" 
         import="com.bizmann.utility.Application"
         import="java.io.File"
         %>

<%@ include file="../include/header.jsp" %>
<%@ include file="../include/menu.jsp" %>
<!DOCTYPE html>
<%
    try
    {
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Cache-Control", "no-store");
        response.setHeader("Expires", "0");

        String feedbackmsg = "";
        FormController frmCtrl = new FormController();
        String basePath = Application.getAPPLICATION_EXCEL_CONTAINER_FILE_PATH();

        File fileSaveDir = new File(basePath);
        if (!fileSaveDir.exists())
        {
            fileSaveDir.mkdirs();
        }

        ArrayList<com.bizmann.poi.entity.Form> formList = new ArrayList<com.bizmann.poi.entity.Form>();
        if (authGrpId == 1)
        {
            System.out.println("auth group 1");
            formList = frmCtrl.getAllForms();
        }
        else if (authGrpId == 3)
        {
            System.out.println("auth group 3");
            formList = frmCtrl.getFormsByUserId(userId);
        }
        System.out.println("formList : " + formList.size());
        //System.out.println(request.getMethod());
        //&& action.equalsIgnoreCase("xlsupload")
        if ("POST".equalsIgnoreCase(request.getMethod()))
        {

            String action = request.getParameter("action");
            if (action == null)
            {
                action = "";
            }

            String xlsName = request.getParameter("xlsName");
            if (xlsName == null)
            {
                xlsName = "";
            }
            //System.out.println(action);
            //System.out.println(xlsName);
            //System.out.println("1");
            Map multipartEntries = (Map) request.getAttribute("multipart.entries");
            if (multipartEntries != null)
            {
                MultipartEntry entry = (MultipartEntry) multipartEntries.get("xlsFile");

                if (entry == null)
                {
                }
                else
                {
                    File xlsFile = entry.getTempFile();
                    String strfilePath = xlsFile.toString();
                    strfilePath = strfilePath.replaceAll("'", "''");
                    String fileNameOnly = request.getParameter("xlsName");
                    //System.out.println("3");
                    if (fileNameOnly != null || !(fileNameOnly.equals(fileNameOnly)))
                    {
                        if (fileNameOnly.equals(""))
                        {
                        }
                        else
                        {
                            //System.out.println("4");
                            try
                            {
                                InputStream inputStream = new FileInputStream(xlsFile);
                                String tmpExt = fileNameOnly;
                                String extension = "";
                                int i = tmpExt.lastIndexOf('.');
                                int p = Math.max(tmpExt.lastIndexOf('/'), tmpExt.lastIndexOf('\\'));
                                if (i > p)
                                {
                                    extension = tmpExt.substring(i + 1);
                                }
                                String justName = fileNameOnly.substring(p + 1, fileNameOnly.length());
                                //System.out.println(justName);
                                if (extension.equalsIgnoreCase("xls"))
                                {
                                    String formName = request.getParameter("frmName");
                                    if (formName == null)
                                    {
                                        formName = "";
                                    }
                                    if (!frmCtrl.checkDupForm(formName))
                                    {
                                        long length = xlsFile.length();
                                        byte[] xlsBytesArr = new byte[(int) length];
                                        int offset = 0;
                                        int numRead = 0;
                                        while ((offset < xlsBytesArr.length) && ((numRead = inputStream.read(xlsBytesArr, offset, xlsBytesArr.length - offset)) >= 0))
                                        {
                                            offset += numRead;
                                        }
                                        if (offset < xlsBytesArr.length)
                                        {
                                            throw new IOException("Could not completely read file" + xlsFile.getName());
                                        }
                                        inputStream.close();
                                        long unixTime = System.currentTimeMillis() / 1000L;
                                        String unixTimeStamp = "" + unixTime;

                                        String newXlsFileName = unixTimeStamp + "-" + justName;

                                        //convert array of bytes into file
                                        FileOutputStream fileOuputStream = new FileOutputStream(basePath + newXlsFileName);
                                        fileOuputStream.write(xlsBytesArr);
                                        fileOuputStream.close();
                                        feedbackmsg = "";

                                        int formId = frmCtrl.insertNewForm(formName, newXlsFileName, xlsBytesArr, userId, userId);
                                        // hide excelUpload
                                        //response.sendRedirect("formdesign.jsp?formId=" + formId);
                                        feedbackmsg = "window.open('formdesign.jsp?formId=" + formId + "');document.location.href = 'formadd.jsp?type=Design';";
                                    }
                                    else
                                    {
                                        feedbackmsg = "alert('Unable to create Duplicate Form Name!');";
                                    }
                                }
                                else
                                {
                                    feedbackmsg = "alert('ONLY xls files allowed!');";
                                }
                            }
                            catch (Exception e)
                            {
                                feedbackmsg = "alert('File upload Failed! Please try again.');";
                                e.printStackTrace();
                            }
                        }
                    }
                    else
                    {
                        feedbackmsg = "alert('Please refrain from refreshing the page!');";
                        //System.out.println("multipart entry is null");
                    }
                }
            }
            else
            {
                feedbackmsg = "alert('File is empty! Please try again.');";
                System.out.println("multipart entry is null");
            }
        }
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="../include/js/jquery-1.10.2.js"></script>
        <script src="../include/js/url.js"></script>
        <script src="../include/jquery-ui-1.10.3/ui/jquery-ui.js"></script>
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" href="../include/jquery-ui-1.10.3/themes/base/jquery-ui.css" type="text/css" />
        <link rel="stylesheet" href="../include/css/loading.css" type="text/css" />
        <title>Add Form</title>
        <style type="text/css" media="screen">
            /*            body { font: 15px Helvetica, Arial; overflow-x: hidden; 
                               display: table-cell;
                               vertical-align: middle;white-space-collapsing:preserve;
                        }*/

            /*            html, body {
                            height: 100%;
                        }
            
                        html {
                            display: table;
                            margin: auto;
                        }*/
            #frmListTbl tr:hover {background-color:darkgrey}

            #deleteBtn {
                display: block;
                width: 60px;
                height: 15px;
                background: #666666;
                padding: 2px;
                text-align: center;
                border-radius: 2px;
                color: whitesmoke;
                font-weight: bold;
            }
            #frmOpenBtn {
                display: block;
                /*                width: 55px;*/
                /*                height: 15px;*/
                /*                background: #666666;*/
                /*                padding: 2px;*/
                /*                text-align: center;*/
                /*                border-radius: 2px;*/
                color: #666666;
                font-weight: bold;
            }

        </style>
        <script>

            var vformid;

            function updateFormName(vid, vname) {
                $.post("formname.jsp", {formId: vid, formName: vname}, function (data, status) {
                    var cData = eval(data);
                    if (cData[0].txtResult == 'true') {
                        document.location.reload(true);
                    } else {
                        alert('Updating Form Name Failed! Please contact your site admin!');
                        document.location.reload(true);
                    }
                });
            }

            function fnEditForm(index, vid) {
                var vname = $("#txtnewname" + index).val();
                updateFormName(vid, vname);
            }


            function fnshowedit(index, vid) {
                vformid = vid;
                $(".frmOpenBtn").css("display", "block");
                $(".txtnewname").css("display", "none");
                document.getElementById('frmOpenBtn' + index).style.display = 'none';
                document.getElementById('txtnewname' + index).style.display = 'block';
            }

            function fnDownloadExcel(vname, vpath) {
                window.open("exceldownload.jsp?name=" + fnURLEncode(vname) + "&path=" + fnURLEncode(vpath), "download", "");
            }

            function fnxlsupload() {
                var vname = document.getElementById("xlsFile").value;
                var fname = document.getElementById("frmName").value;
                //                var vv = document.getElementById("action").value;
                if (vname != null && vname != '' && fname != null && fname != '') {
                    //getxlsname();
                    document.xlsForm.method = "POST";
                    document.xlsForm.submit();
                } else {
                    alert("Please provide both Form Name and the XLS file.");
                }
            }

            function fnopensesame(vfid) {
                var vurl = 'formdesign.jsp?formId=' + vfid;
                fnOpenWindow(vurl);
            }

            /*Added by JIAN HUA*/
            function fnopenPreview(vfid)
            {
                var vurl = 'formpreview.jsp?formId=' + vfid;
                fnOpenWindow(vurl);
            }

            function fnCopyForm(vfid) {
                var vurl = 'formcopy.jsp?formId=' + vfid;
                fnOpenWindow(vurl);
            }

            function fnOpenWindow(URL) {
                var availHeight = screen.availHeight;
                var availWidth = screen.availWidth;
                var x = 0, y = 0;
                if (document.all) {
                    x = window.screentop;
                    y = window.screenLeft;
                } else if (document.layers) {
                    x = window.screenX;
                    y = window.screenY;
                }
                var arguments = 'resizable=1,toolbar=0,location=0,directories=0,addressbar=0,scrollbars=1,status=1,menubar=0,top=0,left=0, screenX=' + x + ',screenY=' + y + ',width=' + availWidth + ',height=' + availHeight;
                newwindow = window.open(URL, 'mywindow', arguments);
                newwindow.moveTo(0, 0);
            }

            function getxlsname() {
                var vname = document.getElementById("xlsFile").value;
                document.getElementById("xlsName").value = vname;
            }

            $(document).ready(function () {
                //                $('#excelUpload').show();
                $('#dvLoading').hide();
                //                $('#excelDesign').hide();

                $(window).bind('beforeunload', function (e) {
                    $('#dvLoading').show();
                });

                $('.txtnewname').keyup(function (e) {
                    if (e.keyCode === 13) {
                        updateFormName(vformid, $(this).val());
                    }
                });
            });
        </script>
    </head>
    <!--    style="align:center"-->
    <body>
        <div id="dvLoading"></div>
        <div align="center" valign="top">
            <table width="980px" height="420px" background="../images/background.png">
                <tr>
                    <td>

                        <div id="excelUpload">
                            <!--            -->
                            <form id="xlsForm" name="xlsForm" method="POST" action="formadd.jsp" ENCTYPE="multipart/form-data">
                                <table background="../images/background.png" cellpadding="2px" style="text-align:left;font-family: arial;border-collapse:collapse;table-layout:auto" width="500px">
                                    <tr>
                                        <td><label for="frmName">Form Name:</label></td>
                                        <td><input type="text" id="frmName" name="frmName"/></td>
                                    </tr>
                                    <tr>
                                        <td><label for="xlsFile">Upload Excel File:</label></td>
                                        <td><input type="file" id="xlsFile" name="xlsFile" onchange="getxlsname()"/></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <input type="hidden" id="xlsName" name="xlsName"/>
                                            <!--                                            <input type="hidden" id="action" name="action" value="xlsupload" />-->
                                            <input type="hidden" id="type" name="type" value="Design" />
                                            <input type="hidden" id="subtype" name="subtype" value="formdesigner" />
                                            <input type="button" value="Upload" onclick="fnxlsupload()"/>
                                            <!--                            onclick="fnxlsupload()"-->
                                        </td>
                                    </tr>
                                </table>
                            </form>
                        </div>
                        <div>
                            <table id="frmListTbl" name="frmListTbl" background="../images/background.png" border="1" cellpadding="2px" style="text-align:left;font-family: arial;border-collapse:collapse;table-layout:auto" width="850px">
                                <tr style="background-color:grey">
                                    <td><font color="white"><b>No.</b></font></td>
                                    <td><font color="white"><b>Name</b></font></td>
                                    <td><font color="white"><b>Created Date</b></font></td>
                                    <td><font color="white"><b>Modify Name</b></font></td>
                                    <td><font color="white"><b>Copy Form</b></font></td>
                                    <td><font color="white"><b>Download XLS File</b></font></td>
                                    <td><font color="white"><b>Delete Form</b></font></td>
                                    <td><font color="white"><b>Preview</b></font></td> <!--JIAN HUA-->
                                    <!--                                    <td><font color="white"><b>Modified Date</b></font></td>-->
                                </tr>
                                <%
                                    for (int a = 0; a < formList.size(); a++)
                                    {
                                        com.bizmann.poi.entity.Form tmpForm = formList.get(a);
                                %>
                                <tr>
                                    <td><%=a + 1%></td>
                                    <td>
                                        <a id="frmOpenBtn<%=a%>" class="frmOpenBtn" href="#" onclick="fnopensesame(<%=tmpForm.getId()%>)"><%=tmpForm.getName()%></a>
                                        <input style="display:none;" size="30" class="txtnewname" type="text" id="txtnewname<%=a%>" value="<%=tmpForm.getName()%>" name="txtnewname<%=a%>" />
                                        <!--                                        onchange="fnEditForm(<=a%>, <=tmpForm.getId()%>)"-->
                                    </td>
                                    <td><%=tmpForm.getCreated_date()%></td>
                                    <td>
                                        <button id="editBtn" name="editBtn" onclick="fnshowedit(<%=a%>, <%=tmpForm.getId()%>)">Modify</button>
                                    </td>
                                    <td><button id="copyBtn" name="copyBtn" onclick="fnCopyForm(<%=tmpForm.getId()%>)">Copy</button></td>
                                    <td><button id="downloadBtn" name="downloadBtn" onclick="fnDownloadExcel('<%=StringEscapeUtils.escapeJavaScript(tmpForm.getName())%>', '<%=StringEscapeUtils.escapeJavaScript(tmpForm.getPath())%>')">Download</button></td>
                                    <td>
                                        <% if (tmpForm.isHas_flowchart())
                                            {%>
                                        <p id="deleteBtn"><font color="grey"><u>[ Delete ]</u></font></p>
                                                <% }
                                            else
                                            {%>
                                        <a id="deleteBtn" href="formdelete.jsp?formId=<%=tmpForm.getId()%>">[ Delete ]</a>
                                        <% }%>
                                    </td>
                                    <td>
                                        <button id= "PreviewBtn" name = "PreviewBtn" onclick ="fnopenPreview(<%=tmpForm.getId()%>)">Preview</button>
                                    </td> <!--JIAN HUA-->
                                </tr>
                                <% }%>
                            </table>
                        </div>

                    </td>
                </tr>
            </table>
        </div>
        <script>
            <%=feedbackmsg%>
        </script>
    </body>
</html>
<%
    }
    catch (Exception e)
    {
        System.out.println("Exception in formadd.jsp : " + e);
    }
%>
<%@ include file="../include/footer.jsp" %>