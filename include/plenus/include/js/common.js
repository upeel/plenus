/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

// get numbers with commas
function getQuantityFormattedNumber(number, numberOfDecimalPlaces)
{
    numberOfDecimalPlaces = parseInt(numberOfDecimalPlaces);
    var roundingFactor = Math.pow(10, numberOfDecimalPlaces);
    number = removeNumberFormat(number);
    //round up, and set to 4 decimal places (Eg. 1.34567 -> 1.3457)
    //add a small epsilon number (0.00000001) 
    //in cases where 554144.445 * 100 = 55414444.49999999
    //that will result in an inaccurate rounding, 
    //adding the epsilon value after mulitpling will fix that
    number = (Math.round((number * roundingFactor) + (0.0001 / roundingFactor)) / roundingFactor).toFixed(numberOfDecimalPlaces);
    var parts = number.toString().split(".");
    parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    return parts.join(".");
}

//get price formatted numbers
function getPriceFormattedNumber(number, numberOfDecimalPlaces)
{
    number = removeNumberFormat(number);
    var roundingFactor = Math.pow(10, numberOfDecimalPlaces);
    //round up, and set to 4 decimal places (Eg. 1.34567 -> 1.3457)
    //add a small epsilon number (0.00000001) 
    //in cases where 554144.445 * 100 = 55414444.49999999
    //that will result in an inaccurate rounding, 
    //adding the epsilon value after mulitpling will fix that
    number = (Math.round((number * roundingFactor) + (0.0001 / roundingFactor)) / roundingFactor).toFixed(numberOfDecimalPlaces);
    //format numbers with commas
    var parts = number.toString().split(".");
    parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    return "$" + parts.join(".");
}

//remove all '$' and ',' from the number
function removeNumberFormat(number)
{
    number = number.toString();
    number = number.replace(/,/g, "");
    number = number.replace(/\$/g, "");

    return number;
}

function bindTxtPriceOnChangeEvent(elementId, numberOfDecimalPlaces)
{
    var $txt_price = $("#" + elementId);
    $txt_price.on("blur", function ()
    {
        this.value = getPriceFormattedNumber(this.value, numberOfDecimalPlaces);
    });

    var previousPrice = 0;
    $txt_price.on("focus", function () {
        previousPrice = this.value;
    }).on("change", function ()
    {
        var currentPrice = this.value;
        currentPrice = removeNumberFormat(currentPrice);

        //check if price is valid
        if (isNaN(currentPrice) === true || currentPrice < 0)
        {
            //use previous correct value
            this.value = previousPrice;
            alert("Invalid Value!");
        } else
        {
            this.value = currentPrice;
        }
    });
}

function bindTxtQuantityOnChangeEvent(elementId, numberOfDecimalPlaces)
{
    var $txt_quantity = $("#" + elementId);
    $txt_quantity.on("blur", function ()
    {
        this.value = getQuantityFormattedNumber(this.value, numberOfDecimalPlaces);
    });

    var previousQuantity = 0;
    $txt_quantity.on("focus", function () {
        previousQuantity = this.value;
    }).on("change", function ()
    {
        var currentQuantity = this.value;
        currentQuantity = removeNumberFormat(currentQuantity);

        //check if quantity is valid
        if (isNaN(currentQuantity) === true || currentQuantity < 0)
        {
            //use previous correct value
            this.value = previousQuantity;
            alert("Invalid Value!");
        } else
        {
            this.value = currentQuantity;
        }
    });
}

function bindInputTextCharacterCountdownEvent()
{
    $("input[type=text], textarea").each(function ()
    {
        var $inputText = $(this);
        $inputText.on("input", function ()
        {
            var maxLength = this.maxLength;

            if (maxLength < 0)
            {
                //if there is no max length defined in the attribute, do not count down.
                return;
            }

            var spanElementId = "span_" + this.id;
            //check if the span element exist
            var $span_character_countdown = $("#" + spanElementId);

            //if not create it
            if ($span_character_countdown.length <= 0)
            {
                $(this).after("<small><i><span class='characterCountDown' id='" + spanElementId + "'></span></i></small>");
            }

            //if exist, change the text.
            $span_character_countdown = $("#" + spanElementId);
            var currentLength = this.value.length;
            $span_character_countdown.text((maxLength - currentLength) + " characters remaining.");
        });
    });
}

function fnOpenPopUpWindow(windowName, URL)
{
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
    newwindow = window.open(URL, windowName, arguments);
    newwindow.moveTo(0, 0);

    return newwindow;
}

function initializeDataTableEvent(dataTableElementId)
{
    var $datatable = $('#' + dataTableElementId).DataTable({
        "dom": '<"toolbar">frBtip',
        "aLengthMenu": [[10, 25, 50, 75, -1], [10, 25, 50, 75, "All"]],
        "iDisplayLength": 10,
        "order": [[0, "asc"]],
        "buttons": [
            'colvis', 'copy', 'csv', 'excel', 'print',
            {
                extend: 'pdfHtml5',
                orientation: 'landscape'
            }
        ],
        "responsive": true,
        "colReorder": true,
        "initComplete": function (settings, json) {
            //show the datatable after initializing
            //In cases where the data to load into the datatable is huge, 
            //it will cause the browser to incur an expensive rendering time
            //only after the data is completely loaded, then show the datatable.
            $('#' + dataTableElementId).show();
        }
    });

    // Setup - add a text input to each footer cell
    $('#' + dataTableElementId + ' tfoot th').each(function () {
        var title = $('#' + dataTableElementId + 'thead th').eq($(this).index()).text();
        $(this).html('<input type="text" placeholder="Search ' + title + ' "/>');
    });

    // Apply the search
    $datatable.columns().every(function () {
        var that = this;
        $('input', this.footer()).on('keyup change', function () {
            that
                    .search(this.value)
                    .draw();
        });
    });

    //Move the footer to the top, just below the title of each column
    $('#' + dataTableElementId + ' tfoot tr').appendTo('#' + dataTableElementId + ' thead');

    //rearrange the search all input text to the right and the extension buttons to the left of the table
    $("#dt_searchAndButtonContainer_" + dataTableElementId + " .dataTables_filter").css("float", "left");
    $("#dt_searchAndButtonContainer_" + dataTableElementId + " .dataTables_filter").css("padding-right", "5px");
    $("#dt_searchAndButtonContainer_" + dataTableElementId + " .dt-buttons").css("float", "left");
    $("#dt_searchAndButtonContainer_" + dataTableElementId).css("float", "right");

    //make sure that the datatable is scaled correctly
    $('#' + dataTableElementId).css("width", "100%");
}

function initializeDatePicker(datePickedElementId)
{
    $("#" + datePickedElementId).datepicker({
        dateFormat: "dd/mm/yy"
    });
}

function promptMessageEvent()
{
    var message = $("#message").val();

    if (message === undefined)
    {
        return;
    }

    message = message.trim();

    if (message !== undefined && message !== null && message !== "")
    {
        alert(message.replace("\\n", "\n"));
    }
}

function showLoading()
{
    $("#dvLoading").show();
    $("#overlay").show();
}

function hideLoading()
{
    $("#dvLoading").hide();
    $("#overlay").hide();
}


function injectIntentionInputElementIntoForm(intention)
{
    //clear existing intention
    $("#txtIntention").remove();

    //define the intention
    var $intentionInput = $("<input>")
            .attr("id", "txtIntention")
            .attr("name", "txtIntention")
            .attr("type", "text")
            .attr("hidden", true)
            .val(intention);

    //attach the intention to the form element, so that server side knows which operation to perform
    $intentionInput.appendTo("#frm");
}

$(document).ready(function ()
{
    bindInputTextCharacterCountdownEvent();

    //hide the loading overlay when the page is ready.
    $("#dvLoading").hide();
    $("#overlay").hide();

    //when there a message from the server side, prompt it.
    promptMessageEvent();
});