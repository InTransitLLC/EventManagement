component {
    property name="settings" type="struct" inject="coldbox:moduleSettings:EventManagement";

	/**
	 * Configure the ColdBox Scheduler
	 */
	function configure() {
		/**
		 * --------------------------------------------------------------------------
		 * Configuration Methods
		 * --------------------------------------------------------------------------
		 * From here you can set global configurations for the scheduler
		 * - setTimezone( ) : change the timezone for ALL tasks
		 * - setExecutor( executorObject ) : change the executor if needed
		 */



		/**
		 * --------------------------------------------------------------------------
		 * Register Scheduled Tasks
		 * --------------------------------------------------------------------------
		 * You register tasks with the task() method and get back a ColdBoxScheduledTask object
		 * that you can use to register your tasks configurations.
		 */
        var serv = createObject( "java", "java.net.InetAddress" ).getLocalHost().getHostName();
        if(serv contains 'hqproc'){
            task( "getUnsent" )
                .call( function(){
                
                        var emailService =  getInstance('emailService@EventManagement')
                        
                        return emailService.getUnsent();
                    })
                .every(30,'seconds')
                .withNoOverlaps()
        }
	}

	/**
	 * Called before the scheduler is going to be shutdown
	 */
	function onShutdown(){
	}

	/**
	 * Called after the scheduler has registered all schedules
	 */
	function onStartup(){
		// writedump(#getModuleConfig('comdatafleet')#);abort;
	}

	/**
	 * Called whenever ANY task fails
	 *
	 * @task The task that got executed
	 * @exception The ColdFusion exception object
	 */
	function onAnyTaskError( required task, required exception ){
        var bugsnag =  getInstance('bugsnagService@BugSnag').sendException(
                                                    exception=arguments.exception)
		fileWrite("#settings.filePath#\logs\scheduler_error_#dateFormatter(now(),'yy-MM-dd-hh-mm')#.txt", serializeJSON(exception))
	}

	/**
	 * Called whenever ANY task succeeds
	 *
	 * @task The task that got executed
	 * @result The result (if any) that the task produced
	 */
	function onAnyTaskSuccess( required task, result ){
	}

	/**
	 * Called before ANY task runs
	 *
	 * @task The task about to be executed
	 */
	function beforeAnyTask( required task ){
	}

	/**
	 * Called after ANY task runs
	 *
	 * @task The task that got executed
	 * @result The result (if any) that the task produced
	 */
	function afterAnyTask( required task, result ){
	}

}
