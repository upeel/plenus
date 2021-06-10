/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

$(document).ready(function ()
{
    initializeDataTableEvent("dtItemMasterLogDetail");
    bindStartFiler();
    
});

function bindStartFiler(){
    $("#selStatus").on("change", function(){
        $("#frm").submit();
    });
}

function bindOpenSMSTemplateDetails(smsHeaderId, outletId) {
    if(smsHeaderId === null || outletId === "" || Number(smsHeaderId) === 0 || Number(outletId) === 0){
        alert("Open SMS Template Fail");
    }else{
        openMaxWindow("../../admintask/SMSTemplate/SMSTemplateDetail?outletId=" + outletId + "&smsTempHeaderId=" +smsHeaderId+"");
    }
}

function openMaxWindow(URL, Name) {
//    var wihe = 'width='+screen.availWidth+',height='+screen.availHeight; 
    var wihe = 'width=' + screen.width + ',height=' + screen.height;
    window.open(URL, Name, 'scrollbars=yes,toolbar=no,menubar=no,screenX=1,screenY=1,left=1,top=1,' + wihe).focus();
}