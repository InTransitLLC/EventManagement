component {
    
    property name="dsn" inject="coldbox:moduleSettings:EventManagement:datasources";
    property name="auth" inject="authenticationService@cbauth";

    public any function save(required any arr, required any eventBean){

        var eventID = 0;
        var result = '';
        cfstoredproc( procedure="CCV2_Event_Save",datasource="#dsn.TILT#" ) {
            cfprocparam( cfsqltype="CF_SQL_VARCHAR", type="in", value="#arguments.eventBean.getSource_id()#");
            cfprocparam( cfsqltype="CF_SQL_VARCHAR", type="in", value="#arguments.eventBean.getSource()#");
            cfprocparam( cfsqltype="CF_SQL_VARCHAR", type="in", value="#arguments.eventBean.getemailSubject()#");
            cfprocparam( cfsqltype="CF_SQL_VARCHAR", type="in", value="#auth.getUser().getgivenName()# #auth.getUser().getsn()#");
            cfprocresult( name="eventID", resultset=1);
        }
        eventID = eventID.event_ID;
        for(a in arguments.arr){
            cfstoredproc( procedure="CCV2_Event_Status_Save",datasource="#dsn.TILT#" ) {
                cfprocparam( cfsqltype="CF_SQL_VARCHAR", type="in", value="#eventID#");
                cfprocparam( cfsqltype="CF_SQL_VARCHAR", type="in", value="#a.getstatus()#");
                cfprocparam( cfsqltype="CF_SQL_VARCHAR", type="in", value="#a.getemail1()#");
                cfprocparam( cfsqltype="CF_SQL_VARCHAR", type="in", value="#a.getemail2()#");
                cfprocparam( cfsqltype="CF_SQL_VARCHAR", type="in", value="#a.getemail3()#");
                cfprocparam( cfsqltype="CF_SQL_VARCHAR", type="in", value="#arguments.eventBean.getSource()#");
                cfprocparam( cfsqltype="CF_SQL_VARCHAR", type="in", value="#arguments.eventBean.getSource_id()#");
                cfprocresult( name="result", resultset=1);
            }
        }
        return result;
    }

    public any function get(required any bean){
        var result = {};
        cfstoredproc( procedure="CCV2_Event_Management_Get",datasource="#dsn.TILT#" ) {
            cfprocparam( cfsqltype="CF_SQL_VARCHAR", type="in", value="#arguments.bean.getSource_id()#");
            cfprocparam( cfsqltype="CF_SQL_VARCHAR", type="in", value="#arguments.bean.getSource()#");
            cfprocresult( name="result", resultset=1);
        }
        return result
    }


}