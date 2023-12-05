component {
    
    property name="eService" inject='emailService@EventManagement';

    function prehandler(event,rc,prc){

    }
    function index(event,rc,prc){

        event.setView(view="/service/index", nolayout="false");
    }


    function queryTest(){
        
        var result = eService.getUnsent();
        writedump(result);abort;
        event.renderData(type="json",data=result);
    }
}