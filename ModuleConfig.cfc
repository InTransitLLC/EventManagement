/**
 * * Monday - 4472755131 Created Module
 * 
 * Module Directives as public properties
 *
 * this.title 				= "Title of the module";
 * this.author 			= "Author of the module";
 * this.webURL 			= "Web URL for docs purposes";
 * this.description 		= "Module description";
 * this.version 			= "Module Version";
 * this.viewParentLookup   = (true) [boolean] (Optional) // If true, checks for views in the parent first, then it the module.If false, then modules first, then parent.
 * this.layoutParentLookup = (true) [boolean] (Optional) // If true, checks for layouts in the parent first, then it the module.If false, then modules first, then parent.
 * this.entryPoint  		= "" (Optional) // If set, this is the default event (ex:forgebox:manager.index) or default route (/forgebox) the framework will use to create an entry link to the module. Similar to a default event.
 * this.cfmapping			= "The CF mapping to create";
 * this.modelNamespace		= "The namespace to use for registered models, if blank it uses the name of the module."
 * this.dependencies 		= "The array of dependencies for this module"
 *
 * structures to create for configuration
 * - parentSettings : struct (will append and override parent)
 * - settings : struct
 * - interceptorSettings : struct of the following keys ATM
 * 	- customInterceptionPoints : string list of custom interception points
 * - interceptors : array
 * - layoutSettings : struct (will allow to define a defaultLayout for the module)
 * - wirebox : The wirebox DSL to load and use
 *
 * Available objects in variable scope
 * - controller
 * - appMapping (application mapping)
 * - moduleMapping (include,cf path)
 * - modulePath (absolute path)
 * - log (A pre-configured logBox logger object for this object)
 * - binder (The wirebox configuration binder)
 * - wirebox (The wirebox injector)
 *
 * Required Methods
 * - configure() : The method ColdBox calls to configure the module.
 *
 * Optional Methods
 * - onLoad() 		: If found, it is fired once the module is fully loaded
 * - onUnload() 	: If found, it is fired once the module is unloaded
 **/
component {

	// Module Properties
	this.title 				= "EventManagement";
	this.author 			= "";
	this.webURL 			= "";
	this.description 		= "";
	this.version			= "1.0.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "/EventManagement";
	// Inherit Entry Point
	this.inheritEntryPoint 	= false;
	// Model Namespace
	this.modelNamespace		= "EventManagement";
	// CF Mapping
	this.cfmapping			= "EventManagement";
	// Auto-map models
	this.autoMapModels		= true;
	// Module Dependencies
	this.dependencies 		= [];

	/**
	 * Configure the module
	 */
	function configure(){

		// parent settings
		parentSettings = {
		};

		// module settings - stored in modules.name.settings
		settings = {
			datasources = {
				TMWTII = "TMWTII",
				EntityStore = "EntityStore",
				Carrier = "Carrier",
				TILT = "TILT",
				TrinityImages = "TrinityImages"
			},
            modPath = modulePath
		};
        environments = {
            development = "^stg"
            ,alpha = "^alpha"
            ,production = "^172.21.1"
        };
		// Custom Declared Points
		interceptorSettings = {
			customInterceptionPoints = []
		};
		// Custom Declared Interceptors
		interceptors = [
		];
		// Binder Mappings
		

	}

	/**
	 * Fired when the module is registered and activated.
	 */
    function development(){
        
    }
    function alpha(){
        
    }

    function production(){
        
    }


	function onLoad(){
		/*On Load Set Parent Application ValidationThis To Include This Module Requirements*/
		var config = controller.getConfigSettings();
		for (i = 1; i <= arrayLen(config.INTERCEPTORCONFIG.INTERCEPTORS); i++) {
    		if(config.INTERCEPTORCONFIG.INTERCEPTORS[i].Name == "ColdBoxValidateThis")
    		{
    			config.INTERCEPTORCONFIG.INTERCEPTORS[i].PROPERTIES.DEFINITIONPATH = "#config.INTERCEPTORCONFIG.INTERCEPTORS[i].PROPERTIES.DEFINITIONPATH#,#expandPath(moduleMapping&"/VTModel")#";
			}
		}
	}

	/**
	 * Fired when the module is unregistered and unloaded
	 */
	function onUnload(){

	}

}