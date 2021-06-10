/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/* global maxPax, contactV */

$(document).ready(function(){
    
});
function validate(evt)
{
    var theEvent = evt || window.event;
    
    if (theEvent.type === 'paste'){
        key = event.clipboardData.getData('text/plain');
    } else{
        var key = theEvent.keyCode || theEvent.which;
        key = String.fromCharCode(key);
    }
    var regex = /[0-9]/;
    if(!regex.test(key)){
        theEvent.returnValue = false;
        if(theEvent.preventDefault) theEvent.prefentDefault();
    }
}
$(document).ready (function(){
    var outletStatusVal = document.getElementById("outletStatus").value;
    if(outletStatusVal === "OFF"){
        alert("The Queue System is currently unavailable.\n\Please approach our staff instead");
        window.opener.location.reload();
        close();
        
    }
    window.scrollTo(0,1);
    $("#message").hide();
                $("#message").fadeTo(5000, 500).slideUp(500, function(){
               $("#message").slideUp(500);
                });   
 });

function looping(){
var select = '';
for(i=1;i<=maxPax;i++){
    select += '<option val=' + i + '>' + i + '</option>';
}
$('#pax').html(select);
}
function asw(){
var select = '';
for(i=0;i<maxPax;i++){
    select += '<option val=' + i + '>' + i + '</option>';
}
$('#baby').html(select);
}
function clearDialogFormData()
{
    $("#frm") [0].reset();
    $("#dialogItemMasterForm span.characterCountDown").remove();
}

function submitButtonClick()
{
    if(validationCheck()){
        showLoading();
        injectIntentionInputElementIntoForm("CREATE");
        $("#frm").submit();
    }
}

function validationCheck(){
    var isValid = true;
    var paxE = document.getElementById("pax");
    var paxV = paxE.value;
    var babyE = document.getElementById("baby");
    var babyV = babyE.value;
    
    var contactE = document.getElementById("contact");
    var contactV = contactE.value;
    var sendSMSE = document.getElementById("sms");
    var sendSMSV = sendSMSE.value;
    
    if(paxV > maxPax){
        alert("Total Max Pax is "+maxPax+"!");
        isValid = false;
        
    }
    else if(sendSMSV === "Yes"){
        if(contactV === "" || contactV === 0 || contactV === "0" || contactV < 0){
            alert("Contact Number is required to fill!");
            isValid = false;
        }
    } if((parseInt(paxV)+parseInt(babyV)>maxPax)){
        alert("Max Pax is "+maxPax+"!\n\Total Pax cannot be more than Max Pax.");
        isValid = false;
    }
    
    return isValid;
}
