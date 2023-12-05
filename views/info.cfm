<cfoutput>
    <style>
    ##eventHeader{
        border-bottom:2px solid black !important;
    }
    </style>
    <cfif rc.source neq 'customer'>
        <div class="modal fade" id="eventMgmtModal"  role="dialog" aria-hidden="true" style="min-width:77rem;">
            <div class="modal-dialog modal-xl modal-dialog-scrollable" style="min-width:118rem !important;"><!--- Monday 5265434746 style change---->
                <div class="modal-content">
                    <div class="modal-header default-color-dark white-text pt-1 pb-1">
                        <h5 class="modal-title ">
                            Event Mangement - #rc.evtMgmtBean.getsource_id()#
                        </h5>
                        <button  class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">
                                &times;
                            </span>
                        </button>
                    </div>
                    <div class="modal-body" >
    </cfif>
    <cfif rc.source neq 'customer'>
        <div class='alert alert-warning font-weight-bold'> This will override customer default notifications.</div>
    </cfif>
    <cfif len(rc.evtMgmtBean.geterror()) gt 0>
        <div class="alert alert-danger">
            #rc.evtMgmtBean.geterror()#
        </div>
    </cfif>
    <cfif rc.evtSavedStatus eq 'Saved'>
        <div class="alert alert-success">
            Events saved!
        </div>
    </cfif>
    <form id="eventMgmtFrm" name="eventMgmtFrm">
        <div class="row p-3" >
            <div class="form-row w-100 mb-2">
                <div class="col-2">
                    <input type="hidden" id="source" name="source" value="#rc.source#">
                    <input type="hidden" id="source_id" name="source_id" value="#rc.source_id#">
                    <a href="##" class="btn btn-sm btn-secondary" onclick="evt_clearSubject(); return false;"> Clear Subject</a>
                </div>
                <div class="col-10">
                    
                    <label for="emailSubject">Email Subject #prc.ValidationObject.isRequired('emailSubject')#</label>
                    <input type="text" class="form-control form-control-sm" id="emailSubject" name="emailSubject" value='#rc.evtMgmtBean.getEmailSubject()#'> 
                    #prc.ValidationObject.isErrorMsg(rc.validationErrors,'emailSubject')#
                </div>
            </div>
            <div class="row w-100">
                <div class="col-2">
                    <div class="card">
                    <div class="card-header default-color-dark white-text">
                        Click Options to Add to Subject
                    </div>
                    <div class="card-body pt-0 pr-0 pl-0">
                        <div class="alert alert-danger mb-0 pt-0 pb-0">
                            Templates must stay intact.
                        </div>
                        <cfloop array="#rc.templateOptions#" index='opt'>
                            <div class="pl-4 pr-1">
                                <!--- <cfif opt eq 'Username'>
                                    <a onclick="evt_addToSubject('#auth().getUser().getgivenName()# #auth().getUser().getsn()#');return false;"> {#opt#} </a>
                                <cfelse> --->
                                <a onclick="evt_addToSubject('#opt#');return false;"> #opt# </a>
                                <!--- </cfif> --->
                            </div>
                        </cfloop>
                    </div>
                    </div>
                </div>
                <div class="col-10">
                    <div class="form-row pt-1" id="eventHeader">
                        <div class="col-1 font-weight-bolder">
                            Detailed
                        </div>
                        <div class="col-1 font-weight-bolder">
                            Classic
                        </div>
                        <div class="col-1 font-weight-bolder">
                            
                        </div>
                        <div class="col-3 font-weight-bolder">
                            Email 1
                        </div>
                        <div class="col-3 font-weight-bolder">
                            Email 2
                        </div>
                        <div class="col-3 font-weight-bolder">
                            Email 3
                        </div>
                    </div>
                    <!--- loop over eventManagement.json to dynamically construct fields--->
                    <!--- <cfdump var="#rc.result#" abort> --->
                    <cfloop array="#rc.eventOptions#" index="evt">
                        
                        <cfquery name="data" dbtype="query">
                            select email1,email2,email3 from rc.result where status=<cfqueryparam value=#evt.status#  cfsqltype="CF_sql_varchar">
                        </cfquery>
                        <!--- <cfdump var="#data.email1#" abort> --->
                        <div class="form-row pt-1" id="#evt.status#Row" <cfif (arrayFind(rc.eventoptions,evt)%2) eq 1>style="background-color:rgba(200, 200, 200,0.5)" </cfif>>
                            <div class="col-1">
                                #evt.status_label#
                            </div>
                            <div class="col-1">
                                #evt.classic_label#
                            </div>
                            <div class="col-1">
                            </div>
                            <div class="col-3">
                                <input type="text" id="#evt.status#_email1" name="#evt.status#_email1" class="form-control form-control-sm" value="#data.email1#">
                            </div>
                            <div class="col-3">
                                <input type="text" id="#evt.status#_email2" name="#evt.status#_email2" class="form-control form-control-sm" value="#data.email2#">
                            </div>
                            <div class="col-3">
                                <input type="text" id="#evt.status#_email3" name="#evt.status#_email3" class="form-control form-control-sm" value="#data.email3#">
                            </div>
                        </div>
                    </cfloop>
                    
                </div>
            </div>
            <cfif rc.source eq 'customer'>
                <div class="row w-100 mt-2 d-flex justify-content-end">
                    <a class="btn btn-sm btn-success" onclick="evt_save();return false;">Save</a>
                    <a data-dismiss="modal" class="btn btn-sm btn-dark">Close</a>
                </div>
            </cfif>
        </div>
    </form>

    <cfif rc.source neq 'customer'>
                </div><!--- closes modal-body--->
                <div class="modal-footer" >
                    <div class="d-flex justify-content-end">
                        <a class="btn btn-sm btn-success" onclick="evt_save();return false;">Save</a>
                        <a data-dismiss="modal" class="btn btn-sm btn-dark">Close</a>
                    </div>
                </div>
            </div><!--- closes modal-dialog--->
        </div> <!--- closes modal wrapper--->
    </cfif>

</cfoutput>