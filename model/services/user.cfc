component {

    function getOrCreate( string email ) {
        local.user = entityLoad( "user", {email: arguments.email},true);
        if( not structKeyExists(local,"user")){
            local.user = entityNew( "user" );
            local.user.setEmail(arguments.email);
            local.user.setUserName(arguments.email);
            EntitySave(local.user);
        } 
        return local.user;
    }

    
}