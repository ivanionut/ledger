component extends="framework.one" output="false" {

	this.name = 'ledger';
	this.version = "0.0.1";
	this.dbmigration = "2018091201";
	this.applicationTimeout = createTimeSpan(0, 2, 0, 0);
	this.setClientCookies = true;
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan(0, 0, 30, 0);

	this.mappings["/framework"] = "/framework";
	this.mappings["/migrations"] = "/database/migrations";
	this.mappings["/services"] = "/model/services";
	this.mappings["/beans"] = "/model/beans";

	// FW/1 settings
	variables.framework = {
		action = 'action',
		baseURL = "useRequestURI",
		defaultSection = 'account',
		defaultItem = 'list',
		diEngine = "aop1",
		diComponent = "framework.aop",
		diLocations = "./model/beans,./model/services,./model/interceptors",
        diConfig = {
			interceptors = [
				{beanName = "transaction", interceptorName = "authorize"},
				{beanName = "transaction", interceptorName = "summaryRounding", methods="deleteTransaction,save"}
			]
		 }
	};

	variables.framework.environments = {
		dev = { 
				reloadApplicationOnEveryRequest = true, 
				error = "main.error_dev" },
		prod = { 
			reloadApplicationOnEveryRequest = false, 
			error = "main.error" }
	};
	
	//enable and set up ORM
	this.datasources["appds"] = {
		type: 'mysql',
		database: this.getEnvVar('MYSQL_DATABASE'),
		host: "db",
		port: "3306",
		username: this.getEnvVar('MYSQL_USER'),
		password: this.getEnvVar('MYSQL_PASSWORD')
	};
	this.datasource = "appds";
	
	this.ormEnabled = true;
	this.ormsettings = {
		cfclocation="model/beans",
		dbcreate = "none",	//using migrations for db table creation instead of letting hibernate create the tables
		dialect="MySQL",         
		eventhandling="true",
		eventhandler="model.beans.eventhandler",
		logsql="true",
		flushatrequestend=false
	};

	public string function getEnvironment(){
		return this.getEnvVar('TIER');
	}

	/**
	 * Put any custom configuration that we don't want to get reloaded when the framework reloads, 
	 * for example, if we have reloadApplicationOnEveryRequest set to true in dev, but want to have dev toggles that we don't want
	 * to be cleared on every request, set those up here.
	 */
	public void function onApplicationStart(){
		super.onApplicationStart();

		application.devToggles = {
			showTemplateWrappers: false
		}
	}

	/**
	 * The setupApplication function is called each time the framework is reloaded.
	 */
	public void function setupApplication(){
		
		lock scope="application" timeout="3"{
			application.root_path = "#getPageContext().getRequest().getScheme()#://#cgi.server_name#:#this.getEnvVar('LUCEE_PORT')#/src";
			application.src_dir = "#expandPath(".")#";
			application.version = "#this.version#";
			application.facebook = createobject("component","model/services/facebook").init(
				this.getEnvVar('FACEBOOK_APPID'),
				this.getEnvVar('FACEBOOK_APPSECRET'),
				"#application.root_path#/"
			);
			application.beanfactory = this.getBeanFactory();
		}
	}
	public void function setupSession() {  
		lock scope="session" timeout="5"{
			session.state = createUUID();
			session.loggedin = false;
		}
	}

	public void function setupRequest() {  
	
		if(structKeyExists(url, "init")) { // use index.cfm?init to reload ORM
			setupApplication();
			StructClear(Session);
			setupSession();
			if(this.getEnvironment() eq 'dev'){
				migrate();
			}
			ormReload();
			location(url="index.cfm",addToken=false);
			
		} else if(structkeyexists(url,"ormreload") or this.getEnvironment() eq 'dev') {
			
			ormReload();
		}

		if(structkeyexists(url,"reloadSession")){
			StructClear(Session);
			setupSession();
		}

		if(session.loggedin){
			request.user = this.getBeanFactory().getBean("userService").getUserByid(session.userid);
		}
	
	}

	public void function setupView( struct rc) {  
		include 'lib/viewHelpers.cfm';
	}

	public void function before(struct rc){
		//user is used in most controllers and views
		if(session.loggedin){
			rc.user = request.user;
		} else if (getSection() != 'auth') {
			redirect("auth.login","all");
		}
	}

	public void function setupResponse() {  }

	public string function onMissingView(struct rc = {}) {
		return "Error 404 - Page not found.";
	}

	/**
	 * Override the customTemplateEngine to provide view/layout wrapper
	 */
	public any function customTemplateEngine( string type, string path, struct args ) {
		var response = '';

		//create a view/layout id
		var templateId = arguments.type & randrange(1,10000000); 

		//populate the local struct needed for the view/layout
		structAppend( local, arguments.args );

		//Load the view/layout UI 
		savecontent variable="response" {
			include '#arguments.path#';
		}

		//Create a custom id and wrap all views and layouts
		if (findnocase("default.cfm", arguments.path) == 0 && not local.keyExists('noHtml') ) {
			var response = '<div id="#templateId#" class="template-wrapper template-#type#-wrapper" data-template-type="#arguments.type#" data-template-path="#arguments.path#">#response#</div>';
		}
		return response;	

	}
	
	public void function migrate(){
		
		if(this.getEnvironment() eq 'dev'){	
			local.migrate = new migrations.migrate("_mg,_dev");	
			local.migrate.refresh_migrations();
		} else {
			local.migrate = new migrations.migrate();
			local.migrate.run_migrations(this.dbmigration);
		}
		
	}
}