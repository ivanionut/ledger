<cfoutput>
    <form method="post" style="max-width:600px">

        <input type="hidden" name="account_id" value="#rc.account.getid()#">
        <input type="hidden" name="id" value="#rc.transaction.getid()#">
        
        <div class="row">
            <label class="col-3 col-form-label">Account:</label>
            <div class="col-9">
                <span class="input-static">
                    #rc.account.getName()#
                </span>
            </div>
        </div>
        <hr>

        <div class="row">
            <label class="col-3 col-form-label">Description:</label>
            <div class="col-9">
                <input type="text" name="Name" value="#rc.transaction.getname()#" class="form-control form-control-sm">
            </div>
        </div>
        
        <div class="row">
            <label class="col-3 col-form-label">Type:</label>
            <div class="col-9">
                <select name="Category" class="form-control form-control-sm">
                    <option value="0"></option>
                    <cfloop array="#rc.categories#" item="local.category">
                        <option value="#local.category.getid()#" #matchSelect(local.category.getid(), rc.transaction.getid())#>
                            #local.category.getName()#
                        </option>
                    </cfloop>
                </select>
            </div>
            
        </div>
        
        <div class="row">
            <label class="col-3 col-form-label">Amount:</label>
            <div class="col-9">
                <input type="text" name="Amount" value="#rc.transaction.getAmount()#" class="form-control form-control-sm">
            </div>
        </div>

        <div class="row">
            <label class="col-3 col-form-label">Date:</label>
            <div class="col-9">

                <div class="input-group">
                    <input type="text" name="Date" value="#rc.transaction.getTransactionDate()#" class="form-control form-control-sm" data-datepicker>
                    <div class="input-group-append">
                        <span class="input-group-text"><i class="fa fa-calendar"></i></span>
                    </div>
                </div>

            </div>
        </div>

        <div class="row">
            <label class="col-3 col-form-label">Note:</label>
            <div class="col-9">
                <input type="text" name="Note" value="#rc.transaction.getNote()#" class="form-control form-control-sm">
            </div>
        </div>

        <div class="row">
            <div class="col-9 offset-3">
                <button type="submit" name="submitTransaction" class="btn btn-primary btn-sm">Submit Entry</button>
            </div>
        </div>

    </form>
</cfoutput>