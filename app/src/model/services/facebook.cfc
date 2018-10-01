component{

    property appid;
    property secret;
    property redirecturl;
    
    public function init (appid, secret, redirecturl){
        this.appid = arguments.appid;
        this.secret = arguments.secret;
        this.redirecturl = arguments.redirecturl;
        return this;
    }

    public function getAccessToken(code){
        cfhttp(url="https://graph.facebook.com/oauth/access_token?client_id=#this.appid#&redirect_uri=#urlEncodedFormat(this.redirecturl)#&client_secret=#this.secret#&code=#arguments.code#");
        
        if(findNoCase("access_token", cfhttp.filecontent)){
            local.results =  deserializejson(cfhttp.filecontent);
            return local.results.access_token;
        }
    }

    public function getAuthURL(scope, state){
        return   "https://www.facebook.com/dialog/oauth?client_id=#this.appid#&redirect_uri=#urlEncodedFormat(this.redirecturl)#&state=#arguments.state#&scope=#arguments.scope#";
    }

    public function getMe(accesstoken){
        cfhttp(url="https://graph.facebook.com/me?access_token=#arguments.accesstoken#&fields=id,name,email", result="local.httpResult");
        return deserializeJSON(httpResult.filecontent);
    }

}
