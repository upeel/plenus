/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/* global maxPax */

function validate(evt)
{
    var theEvent = evt || window.event;
    
    if (theEvent.type === 'paste'){
        key = event.clipboardData.getData('text/plain');
    } else{
        var key = theEvent.keyCode || theEvent.which;
        key = String.fromCharCode(key);
    }
    var regex = /[0-9]|\./;
    if(!regex.test(key)){
        theEvent.returnValue = false;
        if(theEvent.preventDefault) theEvent.prefentDefault();
    }
}

window.onunload = function(){
  window.opener.location.reload();
};
function clearDialogFormData()
{
    $("#frm") [0].reset();
    $("#dialogItemMasterForm span.characterCountDown").remove();
}

function closeWindow(){
    if(confirm("Are you sure want to close this window?")){
        close();
        window.opener.location.reload();
    }
}

function updateButtonClick()
{
    if(validationCheck()){
        showLoading();
        injectIntentionInputElementIntoForm("ADD");
        $("#frm").submit();
    }
}

function validationCheck(){
    var isValid = true;
    var paxE = document.getElementById("pax");
    var paxV = paxE.value;
    
    var contactE = document.getElementById("contact");
    var contactV = contactE.value;
    var sendSMSE = document.getElementById("sms");
    var sendSMSV = sendSMSE.value;
    
    if(paxV === "" || paxV === 0 || paxV === "0" || paxV < 0){
        alert("Total Pax is required to fill!");
        isValid = false;
    }else if(sendSMSV === "Yes"){
        if(contactV === "" || contactV === 0 || contactV === "0" || contactV < 0){
            alert("Contact Number is required to fill set Send SMS 'YES'!");
            isValid = false;
        }
    }else if(paxV > maxPax){
        alert("Total Max Pax is "+maxPax+"!");
        isValid = false;
    }
    
    return isValid;
}