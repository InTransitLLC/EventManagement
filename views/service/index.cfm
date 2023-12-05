<cfoutput>

    <script>
        function queryTest(){
            $.get('#event.buildlink(to="EventManagement:service/queryTest")#',{}, function(data){
                
            });
        }
    </script>

    <div class="card w-25" >
        <div class="card-header">
            Event Services
        </div>
        <div class="card-body">
            
            <a href="##" class="btn btn-danger" onclick="queryTest();return false;">Query Test</a>
        </div>
    </div>
</cfoutput>