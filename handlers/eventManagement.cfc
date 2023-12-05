component extends="coldbox.system.EventHandler" {

    property name="mSettings" inject="coldbox:moduleSettings:EventManagement";
    property name='evtMgmtManager' inject='eventMgmtManager@EventManagement';

    
    function preHandler(event,rc,prc){
        prc.ValidationObject = populateModel("ValidationObject");
    }

    function info(event, rc, prc){
        event.paramValue('source_id','');
        event.paramvalue('source','');

        rc.evtMgmtBean = populateModel('eventMgmtBean@eventManagement');

        /*Template options are Written in a .txt file wrapped with {brackets} and comma separated
        
        Fields added for the subject ALSO need added to the TMWTII>CCV2_Event_get_Status_and_order stored proc
        */
        rc.templateOptions = fileRead(mSettings.modPath&'/includes/build/templateOptions.txt');
        rc.templateOptions = listToArray(rc.templateOptions,',');
        rc.eventOptions = fileRead(mSettings.modPath&'/includes/build/event.json')
        rc.eventOptions = deserializeJson(rc.eventOptions)
        /*===========================================*/
        rc.validationErrors={};
		rc.context = "Save";
		rc.objectType = "evtMgmt.info";
        rc.theObject = rc.evtMgmtBean;
        announceInterception("prepareValidationRequest");
		prc.ValidationObject.setRequiredFields(rc.ValidateRequired);
		rc.evtSavedStatus="";

        if(event.getHTTPMethod() == 'POST'){
            announceInterception("vtvalidate");
            var eventArr = []
            var errQuery = queryNew('status,email1,email2,email3')
            for(e in rc.eventOptions){
                //writedump(rc);abort;
                queryAddRow(errQuery,{"status"='#e.status#',"email1"='#rc["#e.status#_email1"]#',"email2"="#rc['#e.status#_email2']#","email3"="#rc['#e.status#_email3']#"})
                
                var pushBean = populateModel('eventMgmtBean@eventManagement');
                pushBean.setstatus(e.status)
                if(structKeyExists(rc,'#e.status#_email1')){
                    if(len(rc['#e.status#_email1']) ){
                        if(len(rc['#e.status#_email1']) gt 150){
                            var err = rc.evtmgmtbean.getError() & '#e.status_label# Email 1 must be less than 150 characters <br>';
                            rc.evtMgmtBean.setError(err)
                        }else{
                            pushBean.setemail1(rc['#e.status#_email1'])
                        }
                    }
                }
                if(structKeyExists(rc,'#e.status#_email2')){
                    if(len(rc['#e.status#_email2']) ){
                        if(len(rc['#e.status#_email2']) gt 150){
                            var err = rc.evtmgmtbean.getError() & '#e.status_label# Email 2 must be less than 150 characters <br>';
                            rc.evtMgmtBean.setError(err)
                        }else{
                            pushBean.setemail2(rc['#e.status#_email2'])
                        }
                    }
                }
                if(structKeyExists(rc,'#e.status#_email3')){
                    if(len(rc['#e.status#_email3'])){
                        if(len(rc['#e.status#_email3']) gt 150){
                            var err = rc.evtmgmtbean.getError() & '#e.status_label# Email 3 must be less than 150 characters <br>';
                            rc.evtMgmtBean.setError(err)
                        }else{
                            pushBean.setemail3(rc['#e.status#_email3'])
                        }
                    }
                }
                eventArr.push(pushBean);
            }
            if(rc.ValidationResult.getIsSuccess()){

                
                if(len(rc.evtMgmtBean.getError())){
                    rc.evtMgmtBean.setError('#rc.evtMgmtBean.getError()#')
                    rc.result = errQuery
                }else{
                    rc.result = evtMgmtManager.Save(arr=eventArr,bean=rc.evtMgmtBean);
                    if(rc.result.recordcount){
                        rc.evtMgmtBean = populateModel(model='eventMgmtBean@eventManagement',qry=rc.result)
                    }
                    rc.evtSavedStatus="saved";
                }
            }else{
                rc.validationErrors = rc.ValidationResult.getFailureMessagesByField(delimiter="<br>",locale="en_US");
                //only required field that is user controlled is subject
                rc.result = errQuery;
                rc.evtMgmtBean.setError(rc.evtMgmtBean.getError());
                
            }
        }else{
            
            rc.result = evtMgmtManager.get(bean=rc.evtMgmtBean);
            
            if(rc.result.recordCount){
                rc.evtMgmtBean = populateModel(model='eventMgmtBean@eventManagement',qry=rc.result)
            }
            //writedump(rc.evtMgmtBean);abort;
            //writedump(rc.result);abort;
        }

        event.setView(view="/info", nolayout="true");
    }

}