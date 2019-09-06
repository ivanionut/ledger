<cfoutput>

    <cfsavecontent variable="toHead">
        <link rel="stylesheet" type="text/css" href="./assets/css/account.css?v=#application.version#" />
    </cfsavecontent>
    <cfhtmlhead text = "#toHead#">

    <cfset local.viewID = "view" & randrange(1,10000000)>

    <div id="#local.viewId#" class="account-summary">
        <div class="bg-dark">
            <div class="center-content">
                <div>
                    <button class="navbar-toggler collapsed float-left" type="button" data-toggle="collapse" data-target="##navbar">
                        <i class="fa fa-bars"></i>
                    </button>
                </div>
                <h6 class="text-center">#rc.account.getLongName()#</h6>
            </div>
        </div>
        <div class="balance-wrap center-content">
            <div class="balance">
                <div class="amount" data-js-hook="accountBalance">
                    #moneyFormat(rc.account.getBalance())#
                </div>
                Account Balance
            </div>
            <div class="balance">
                <div class="amount" data-js-hook="linkedBalanceVerified">
                    #dollarFormat(rc.account.getVerifiedLinkedBalance())#
                </div>
                Verified Balance
            </div>
            <div class="balance">
                <div class="amount" data-js-hook="summaryBalance">
                    #moneyFormat(rc.user.getSummaryBalance())#
                </div>
                Checkbook Summary
            </div>
        </div>
    </div>

    <script>
        viewScripts.add( function(){
            var viewId = '#local.viewId#',
                $view = $("##" + viewId),
                $accountBtn = $view.find("[data-change-account]");
            
                $accountBtn.click( function() {
                    var $btn = $(this),
                        accountid = $btn.data('changeAccount');
                    
                    post('#buildurl(rc.returnTo)#', {
                        accountid:accountid
                    });
                });
        });
    </script>
</cfoutput>