component{

    property name="dsn" inject="coldbox:moduleSettings:EventManagement:datasources";
    property name="environment" inject="coldbox:setting";

    function getUnsent(){

        var result ={};
        cfstoredproc( procedure="CCV2_Event_GetUnsent",datasource="#dsn.TILT#" ) {
            cfprocresult( name="result", resultset=1);
        }
        
        if(isQuery(result)){
            if(result.recordCount){
                //writedump(result);abort;
                for(var r in result){
                    //expandability for adding more TYPES to event management and notifications.
                    if(r.type eq 'load'){
                        order_sendEmail(r)
                    }
                }
            }
            return result;
        }else{
            return 'No emails to send';
        }
    }

    function order_sendEmail(required any entry){
        try{
            cfstoredproc( procedure="CCV2_Event_get_Status_and_order",datasource="#dsn.TILT#" ) {
                cfprocparam( cfsqltype="CF_SQL_VARCHAR", type="in", value="#arguments.entry.type_id#");
                cfprocresult( name="result", resultset=1);
                cfprocresult( name="order", resultset=2);
            }
            
            // writedump(result);
            var subject = replace(result.Emailsubject, "##", "####", "All");
            subject = replace(subject, "}", "##", "All");
            subject = replace(subject, "{", "##order.", "All");
            // writedump(order);

            var emailBody = '';
            /* if((order.ord_dispatch_status eq 'OPN') OR (order.ord_dispatch_status eq 'BKD')){ */
                
                emailBody="<b>Customer: </b>#order.customer#<br>
                            <b>Order Number: </b>#trim(order.load_number)#<br>
                            <b>Pickup Location: </b>#order.shipper# - #order.shipper_address# #order.shipper_nmstct# #order.shipper_zip#<br>
                            <b>Final Destination: </b>#order.consignee# - #order.consignee_address# #order.consignee_nmstct# #order.consignee_zip#<br>
                            <b>Status: </b>#order.status#<br>";
            /* }else{
                var stp_type = ''
                if(order.stp_type eq 'PUP'){
                    stp_type='Pickup'
                }else{
                    stp_type= 'Drop'
                }
                emailBody ="<b>Customer: </b>#order.customer#<br>
                            <b>Order Number: </b>#trim(order.load_number)#<br>
                            <b>#stp_type# Location: </b>#order.cmp_name# - #order.stp_address# #order.loc_nmstct# #order.zip#<br>
                            <b>Status: </b>#order.status#<br>";
                            
            } */
            
            var emailOne = '';
            var emailTwo = '';
            var emailThree = '';
            /* if(environment eq "production"){ */
                if(len(result.email1)){
                    emailOne = result.email1;
                cfmail( to = "#emailOne#", from = "noreply@bridgeway.io", subject = "#evaluate(De(subject))#",type="text/html" ) { 
                    WriteOutput(emailBody);
                    }
                }
                if(len(result.email2)){
                    emailTwo = result.email2;
                    cfmail( to = "#emailTwo#", from = "noreply@bridgeway.io", subject = "#evaluate(De(subject))#",type="text/html" ) { 
                        WriteOutput(emailBody);
                    }
                }
                if(len(result.email3)){
                    emailThree = result.email3;
                    cfmail( to = "#emailThree#", from = "noreply@bridgeway.io", subject = "#evaluate(De(subject))#",type="text/html" ) { 
                        WriteOutput(emailBody);
                    }
                } 
            /* } */
                
            cfstoredproc( procedure="CCV2_Event_Set_HasSent_byID",datasource="#dsn.TILT#" ) {
                cfprocparam( cfsqltype="CF_SQL_VARCHAR", type="in", value="#arguments.entry.en_id#");
            }
        }  catch(any e){
            return e;
        }
    }
}