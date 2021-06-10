/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

$(document).ready(function ()
{
    initializeDataTableEvent("dtSpecialRequest");
    bindStartFiler();
    bindBtnAddSpecialRequestOnClickEvent();
    bindDataTableRowOnClickEvent();
    
});

function bindStartFiler(){
    $("#selStatus").on("change", function(){
        $("#frms").submit();
    });
}

function clearDialogFormData()
{
    $("#frm")[0].reset();
    $("#dialogSpecialRequestMaster span.characterCountDown").remove();
}

function addButtonDialogOnClick()
{
    
    if(validationSubmit()){
        showLoading();
        injectIntentionInputElementIntoForm("Create");
        $("#frm").submit();
    }
    
}

function openEditDialogSpecialRequestFormEvent(dtRow)
{
    $("#statusRow")[0].hidden = false;
    var $dtTable = $("#dtSpecialRequest").DataTable();

    $dtTable.$('tr.selected').removeClass('selected');
    $(this).addClass('selected');

    var dtRowData = $dtTable.row(dtRow).data();

    $("#txtRequestName").val(dtRowData[2]);
    $("#txtDescription").val(dtRowData[3]);
    $("#txtStatus").val(dtRowData[4]);

    $("#txtSpecialReqId").val(dtRowData[1]);

    var dialog = $("#dialogSpecialRequestMaster").dialog({
        appendTo: "#frm",
        height: "auto",
        width: "auto",
        modal: true,
        buttons: {
            Update: function ()
            {
                updateButtonDialogOnClick();
            },
            Cancel: function () {
                dialog.dialog("close");
            }
        },
        close: function () {
            clearDialogFormData();
        }
    });

    dialog.width(dialog.width());
}

function openAddDialogSpecialRequestFormEvent()
{
    $("#statusRow")[0].hidden = true;
    var dialog = $("#dialogSpecialRequestMaster").dialog({
        appendTo: "#frm",
        height: "auto",
        width: "auto",
        modal: true,
        buttons: {
            Add: function () {
                addButtonDialogOnClick();
            },
            Cancel: function () {
                dialog.dialog("close");
            }
        },
        close: function () {
            clearDialogFormData();
        }
    });

    dialog.width(dialog.width());
}

function bindBtnAddSpecialRequestOnClickEvent()
{
    $("#addBtn").on("click", function ()
    {
        openAddDialogSpecialRequestFormEvent();
    });
}

function bindDataTableRowOnClickEvent()
{
    $('#dtSpecialRequest tbody').on('click', 'tr', function ()
    {
        openEditDialogSpecialRequestFormEvent(this);
    });
}

function updateButtonDialogOnClick()
{
    if(validationSubmit()){
        showLoading();
        injectIntentionInputElementIntoForm("Update");
        $("#frm").submit();
    }
}

function validationSubmit(){
    var result = true;
    
    var requestName = document.getElementById("txtRequestName").value;
//    var description = document.getElementById("txtDescription").value;
    if (requestName === '' || requestName === null || requestName === "0.0000" || requestName === undefined || requestName === "0" || requestName === "0.00")
    {
        alert("Request name is required to fill!");
        result = false;
    }
    
    return result;
}