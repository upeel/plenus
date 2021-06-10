/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

$(document).ready(function ()
{
    document.addEventListener('dragstart', function (event) {
      event.dataTransfer.setData('Text', event.target.innerHTML);
    });
    
    var txtUsage = document.getElementById("txtUsage");
    var txtResponse = document.getElementById("txtResponse");
    
    var txtUsageV = txtUsage.value;
    var txtResponseV = txtResponse.value;
    
    if(txtResponseV !== ""){
        txtResponse.setAttribute("readonly", "true");
    }
    
    if(txtUsageV !== ""){
        txtUsage.setAttribute("readonly", "true");
    }
});

function fnSubmit(){
    showLoading();
    injectIntentionInputElementIntoForm('Update');
    $("#frm").submit();
}
