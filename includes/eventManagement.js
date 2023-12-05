<cfoutput>

    function eventMgmt(source_id,eventsource){
        $.get("#event.buildLink('eventManagement:EventManagement/info')#", { source_id: source_id,source:eventsource}, function (data) {
            evt_load_data(data,eventsource)

        });
    }

    function evt_load_data(data,eventsource){
        
        #getCache().get('ValidateThis').getValidationNonDataScript(objectType="evtMgmt.info",Context="Save",locale="en_US"  )#
        if(eventsource == 'customer'){
            $('##customerModalContent').empty();
            
            if($('##eventMgmtModal').length){
                $('##eventMgmtModal').remove();
                $('.modal-backdrop.fade.show').remove();
            }
            $('##customerModalContent').append(data);
        }else{
            
            if($('##eventMgmtModal').length){
                $('##eventMgmtModal').remove();
                $('.modal-backdrop.fade.show').remove();
            }
            if($('##customerModalContent ##eventMgmtFrm').length){
                $('##customerModalContent ##eventMgmtFrm').empty().remove()
            }
            $('body').append(data);
            $('##eventMgmtModal').modal({
                show: true,
                backdrop:false
            }); 
            draggableModal('##eventMgmtModal');
        }
    }


    function evt_clearSubject(){
        $('##eventMgmtFrm ##emailSubject').val('');
    }

    function evt_addToSubject(option){
        var subject =$('##eventMgmtFrm ##emailSubject').val()

        subject = subject +' ' + option;
        $('##eventMgmtFrm ##emailSubject').val(subject)
    }

    function evt_save(){
        var source = $('##eventMgmtFrm ##source').val();
         $.post("#event.buildLink('eventManagement:EventManagement/info')#", $('##eventMgmtFrm').serialize(), function (data) {
            evt_load_data(data,source);
            if(source =='order'){
                $('##evtMgmtBtn').empty().prepend('<i class="fas fa-exclamation" ></i> Event Mgmt')
                $('##detailFrm ##eventMgmtCheck').val(1)
            }
         });
    }
    


</cfoutput>