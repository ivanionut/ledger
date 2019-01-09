component name="schedular" output="false" accessors=true {
    property eventGeneratorService;
    property accountService;
    property categoryService;
    property alertService;
    property schedularService;

    public void function init(fw){
        variables.fw = arguments.fw;
    }

    public void function autoPaymentList(required struct rc){
        rc.generators = eventGeneratorService.getEventGenerators();
        rc.accounts = accountService.getAccounts();
        rc.categories = categoryService.getCategories();
        rc.transactionGenerator = eventGeneratorService.createTransactionGenerator();
        rc.transferGenerator = eventGeneratorService.createTransferGenerator();
        rc.schedularTypes = schedularService.getSchedularTypes;
    }

    public void function validateTransactionGeneratorForm(required struct rc){
        var response = getValidateTransactionGeneratorResponse(arguments.rc);
        variables.fw.renderData().data( response ).type( 'json' );
    }

    public void function validateTransferGeneratorForm(required struct rc){
        var response = getValidateTransferGeneratorResponse(arguments.rc);
        variables.fw.renderData().data( response ).type( 'json' );
    }

    public void function saveTransactionGeneratorForm(required struct rc) {
        var validateResponse = getValidateTransactionGeneratorResponse(arguments.rc);
        abortSaveGeneratorOnFailedResponse(validateResponse);

        //save the transaction generator
        var newTransactionGenerator = eventGeneratorService.createTransactionGenerator();
        variables.fw.populate(newTransactionGenerator);
        
        eventGeneratorService.saveEventGenerator(newTransactionGenerator);
        alertService.add('success','Your auto payment "#rc.eventName#" has been saved.');

        //redirect back to list
        variables.fw.redirect('schedular.autoPaymentList');
        
    }

    public void function saveTransferGeneratorForm(required struct rc) {
        var validateResponse = getValidateTransferGeneratorResponse(arguments.rc);
        abortSaveGeneratorOnFailedResponse(validateResponse);

        //save the transaction generator
        var newTransferGenerator = eventGeneratorService.createTransferGenerator();
        variables.fw.populate(newTransferGenerator);
        eventGeneratorService.saveEventGenerator(newTransferGenerator);
        alertService.add('success','Your auto transfer "#rc.eventName#" has been saved.');

        //redirect back to list
        variables.fw.redirect('schedular.autoPaymentList');
    }

    /**
     * If there are validation errors when saving the generators, then abort and redirect to the list
     */
    private void function abortSaveGeneratorOnFailedResponse(required component response) {
        if (!arguments.response.isSuccess()){ 
            arguments.response.generateAlerts();
            variables.fw.setView('schedular.autoPaymentList');
            variables.fw.abortController();
        }
    }

    private component function getValidateTransactionGeneratorResponse(required struct rc){
        var response = new beans.response();
        if (!len(rc.eventName)) {
            response.addError("Please provide a name for this automatic transaction");
        }
        return response;
    }

    private component function getValidateTransferGeneratorResponse(required struct rc){
        var response = new beans.response();
        if (!len(rc.eventName)) {
            response.addError("Please provide a name for this automatic transaction");
        }
        return response;
    }
}