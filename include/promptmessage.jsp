<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8">
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/button/assets/skins/sam/button.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/container/assets/skins/sam/container.css" />
        <script type="text/javascript" src="../include/js/yui/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="../include/js/yui/element/element-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/button/button-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/container/container-min.js"></script>
<!--        <script src="../include/js/jquery-1.10.2.js"></script>-->
        <style>
            #container {
                height:0px;
                width:0px;
            }

            #messagebody{
                height:0px;
                width:0px;
            }
        </style>
    </head>

    <body id="messagebody" class=" yui-skin-sam">

        <script>
            YAHOO.namespace("example.container");

            function promptMessage(type, subtype, action, message) {
                var handleYes = function() {
                    if(type == "Design"){
                        if(subtype == "flowchartlibrary" || subtype == "null"){
                            //redirect the user to the page
                            flowChartId = parent.frames.document.getElementById("hidFlowChartId").value;
                            $('#iflowchartlibrary').attr('src', "flowchartlibrarydelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&flowChartId="+flowChartId);
                            //window.frames["iflowchartlibrary"].location.href="flowchartlibrarydelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&flowChartId="+flowChartId;
                            //document.frames("iflowchartlibrary").location.href="flowchartlibrarydelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&flowChartId="+flowChartId;
                        }
                        else if(subtype == "flowchartpermission"){
                            iniProId = parent.frames.document.getElementById("hidIniProId").value;
                            $('#inipro').attr('src', "initiateprocessdelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&iniProId="+iniProId);
                            //window.frames["inipro"].location.href="initiateprocessdelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&iniProId="+iniProId;
                            //document.frames("inipro").location.href="initiateprocessdelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&iniProId="+iniProId;
                        }
                        else if(subtype == "externalreport"){
                            externalReportId = parent.frames.document.getElementById("hidExternalReportId").value;
                            $('#iexternalreport').attr('src', "externalreportdelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&externalReportId="+externalReportId);
                            //window.frames["iexternalreport"].location.href="externalreportdelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&externalReportId="+externalReportId;
                            //document.frames("iexternalreport").location.href="externalreportdelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&externalReportId="+externalReportId;
                        }
                        else if(subtype == "admintask"){
                            adminTaskId = parent.frames.document.getElementById("hidAdminTaskId").value;
                            $('#iadmintask').attr('src', "admintaskdelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&adminTaskId="+adminTaskId);
                            //window.frames["iadmintask"].location.href="admintaskdelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&adminTaskId="+adminTaskId;
                            //document.frames("iadmintask").location.href="admintaskdelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&adminTaskId="+adminTaskId;
                        }
                        else if(subtype == "externaladmintask"){
                            adminTaskId = parent.frames.document.getElementById("hidAdminTaskId").value;
                            $('#iadmintask').attr('src', "externaladmintaskdelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&adminTaskId="+adminTaskId);
                            //window.frames["iadmintask"].location.href="admintaskdelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&adminTaskId="+adminTaskId;
                            //document.frames("iadmintask").location.href="admintaskdelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&adminTaskId="+adminTaskId;
                        }
                        else if(subtype == "externalformlibrary"){
                            formId = parent.frames.document.getElementById("hidFormId").value;
                            $('#iformlibrary').attr('src', "externalformlibrarydelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&formId="+formId);
                            //window.frames["iformlibrary"].location.href="externalformlibrarydelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&formId="+formId;
                            //document.frames("iformlibrary").location.href="externalformlibrarydelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&formId="+formId;
                        }
                        else{
                            //it is the default
                            if(action == "delete"){
                                //redirect the user to the page
                                formId = parent.frames.document.getElementById("hidFormId").value;
                                $('#iformlibrary').attr('src', "formlibrarydelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&formId="+formId);
                                //window.frames["iformlibrary"].location.href="formlibrarydelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&formId="+formId;
                                //document.frames("iformlibrary").location.href="formlibrarydelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&formId="+formId;
                            }
                            else if(action == "deleteall"){
                                //redirect the user to the page
                                formId = parent.frames.document.getElementById("hidFormId").value;
                                $('#iformlibrary').attr('src', "formlibrarydelete.jsp?type="+type+"&subtype="+subtype+"&action=deleteall&formId="+formId);
                                //window.frames["iformlibrary"].location.href="formlibrarydelete.jsp?type="+type+"&subtype="+subtype+"&action=deleteall&formId="+formId;
                                //document.frames("iformlibrary").location.href="formlibrarydelete.jsp?type="+type+"&subtype="+subtype+"&action=deleteall&formId="+formId;
                            }
                        }
                    }
                    else if(type == "Organization"){
                    	if(subtype == "designation"){
                            if(action == "delete"){
                                designationId = parent.frames.document.getElementById("hidDesId").value;
                                $('#idesignation').attr('src', "designationdelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&designationId="+designationId);
                                //window.frames["idesignation"].location.href="designationdelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&designationId="+designationId;
                                //document.frames("idesignation").location.href="designationdelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&designationId="+designationId;
                            }
                        }
                        else if(subtype == "orgunit"){
                             if(action == "delete"){
                                 orgunitId = parent.frames.document.getElementById("hidOrgUnitId").value;
                                 $('#iorgunit').attr('src', "orgunitdelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&orgunitId="+orgunitId);
                                 //window.frames["iorgunit"].location.href="orgunitdelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&orgunitId="+orgunitId;
                                 //document.frames("iorgunit").location.href="orgunitdelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&orgunitId="+orgunitId;
                             }

                        }
                        else if(subtype == "user"){
                            if(action == "delete"){

                                parentId = parent.frames.document.getElementById("hidParentId").value;
                                childId = parent.frames.document.getElementById("hidChildId").value;
                                $('#iuser').attr('src', "userdelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&parentId="+parentId+"&childId="+childId);
                                //parent.frames["iuser"].location.href="userdelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&parentId="+parentId+"&childId="+childId;
                                //parent.document.frames("iuser").location.href="userdelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&parentId="+parentId+"&childId="+childId;

                            }
                            else if(action == "deletefromOU"){
                                 parentId = parent.frames.document.getElementById("hidParentId").value;
                                 childId = parent.frames.document.getElementById("hidChildId").value;
                                 $('#iuser').attr('src', "userdelete.jsp?type="+type+"&subtype="+subtype+"&action=deletefromOU&parentId="+parentId+"&childId="+childId);
                                 //window.frames["iuser"].location.href="userdelete.jsp?type="+type+"&subtype="+subtype+"&action=deletefromOU&parentId="+parentId+"&childId="+childId;
                                 //document.frames("iuser").location.href="userdelete.jsp?type="+type+"&subtype="+subtype+"&action=deletefromOU&parentId="+parentId+"&childId="+childId;
                             }
                        }
                        else{
                            //it is for the default tab
                            if(action == "delete"){
                                //redirect the user to the page
                                orgunitId = parent.frames.document.getElementById("hidOrgUnitId").value;
                                $('#iorgunit').attr('src', "orgunitdelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&orgunitId="+orgunitId);
                                //window.frames["iorgunit"].location.href="orgunitdelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&orgunitId="+orgunitId;
                                //document.frames("iorgunit").location.href="orgunitdelete.jsp?type="+type+"&subtype="+subtype+"&action=delete&orgunitId="+orgunitId;
                            }

                        }
                    }
                    else if(type == "Dashboard"){
                        if(subtype == "userprofile"){
                            if(action=="save"){
                                $('#userprofile').attr('src', "userprofile.jsp?type="+type+"&subtype="+subtype);
                                //window.frames["userprofile"].location.href = "userprofile.jsp?type="+type+"&subtype="+subtype;
                                //document.frames("userprofile").location.href = "userprofile.jsp?type="+type+"&subtype="+subtype;
                            }
                        }
                    }
                    this.hide();
                }

                var handleNo = function() {
                    this.hide();
                };


                YAHOO.example.container.alertdialog = new YAHOO.widget.SimpleDialog("promptdialog",
                {   width: "300px",
                    fixedcenter: true,
                    visible: false,
                    draggable: false,
                    close: false,
                    text: message,
                    modal: true,
                    icon: YAHOO.widget.SimpleDialog.ICON_WARN,
                    constraintoviewport: true,
                    buttons: [ { text:"No",  handler:handleNo, isDefault:true}, { text:"Yes", handler:handleYes }]
                } );
                YAHOO.example.container.alertdialog.setHeader("bmFLO Prompt: ");
                YAHOO.example.container.alertdialog.render("container");
                YAHOO.example.container.alertdialog.show();

            }
        </script>

        <div id="container"></div>
    </body>
</html>