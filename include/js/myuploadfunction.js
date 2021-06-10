$(function () {
    
    $('#file_upload').fileUploadUI({
    	
        dataType: 'json',
        namespace: 'file_upload',
        fileInputFilter: '#file_1',
        dropZone: $('#dropzone'), //only one dropzone
        uploadTable: $('#uploaded-files'),
        downloadTable: $('#uploaded-files'),
        buildDownloadRow: function (data) {
            //$("tr:has(td)").remove();
            var file = eval(data);
            for(var index = 0; index < file.length; index++){
                $("#uploaded-files").append(
                    $('<tr/>')
                    .append($('<td/>').html("<a href=\"../"+file[index].fileUrl+"\" target='_blank'>"+file[index].fileName+"</a>"))
                    .append($('<td/>').text(file[index].fileSize))
                    .append($('<td/>').text(file[index].fileType))
                    .append($('<td/>').text("@" + file[index].uploadedBy))
                    .append($('<td/>').html("<input type='button' id='embedPdfBtn' name='embedPdfBtn' onclick='embedPdfBtnClicked(\""+file[index].fileUrl+"\")' value=\"Embed PDF\" />"))
                    .append($('<td/>').html("<a href='attachementdelete.jsp?flowChartId="+vuploadflowchartid+"&actionId="+vuploadactionid+"&userId="+vuploaduserid+"&processId="+vuploadprocessid+"&fileName="+fnURLEncode(file[index].fileName)+"' target='_self'>Delete</a>"))
                    );
            }
        //            $("tr:has(td)").remove();
        //            $.each(data.result, function (index, file) {
        //                alert(index);
        //                alert(file.fileName);
        //                $("#uploaded-files").append(
        //                    $('<tr/>')
        //                    .append($('<td/>').text(file.fileName))
        //                    .append($('<td/>').text(file.fileSize))
        //                    .append($('<td/>').text(file.fileType))
        //                    .append($('<td/>').html("<a href='upload?f="+index+"'>Click</a>"))
        //                    .append($('<td/>').text("@SoeHtike"))
        //                    )//end $("#uploaded-files").append()
        //            }); 
        },
        
        buildUploadRow: function (files, index) {
            return $('<tr><td>' + files[index].name + '<\/td>' +
                '<td class="file_upload_progress"><div><\/div><\/td>' +
                '<td class="file_upload_cancel">' +
                '<button style="width:50px;" class="ui-state-default ui-corner-all" title="Cancel">' +
                '<span style="width:50px;" class="ui-icon ui-icon-cancel">Cancel<\/span>' +
                '<\/button><\/td><\/tr>');
        }
    }).bind('file_uploadsubmit', function (e, data) {
        // The example input, doesn't have to be part of the upload form:
        //        var twitter = $('#twitter');
        //        data.formData = {
        //            twitter: twitter.val()
        //        };        
        });
});