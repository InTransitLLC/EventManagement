component{

	function configure(){


		group( { pattern="/eventManagement", target="EventManagement."}, function(){
			route("/info", "info")
			.route("/", "info");
		})

        group( { pattern="/service", target="service."}, function(){
			route("/index", "index")
            .route("/queryTest","queryTest")
			.route("/", "index");
		})
	}
}