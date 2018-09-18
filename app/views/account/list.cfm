<cfoutput>
<div class="alert alert-success">
	<span class="badge badge-light summary">
		$<?=$AccountSummary?>
	</span>
	<span>- Accounts Summary</span>
	
</div>

<div class="container-fluid d-none d-md-block">
    <div class="row list-group-header">
        <div class="col">
            Account          
        </div>
        <div class="col text-right ">
            Total
        </div>
        <div class="col text-right">
            Verified
        </div>
        <div class="col"></div>
    </div>
</div>

<ul class="list-group">

    <cfloop array="#rc.accounts#" item="thisAccount" index="i">
        
        <!--- Style accounts that are included in the summary --->
        <cfset local.badgeClass = "info">
        <cfif thisAccount.inSummary()>
            <cfset local.badgeClass = "success">
        </cfif>

        <li class="list-group-item">

            <!--- Display for small devices --->
            <div class="d-block d-md-none">
                <span class="btn btn-link"  data-accountid="#thisAccount.getId()#">
                    #thisAccount.getName()#
                </span>
                <div class="pull-right text-right">
                    <span class="badge badge-#local.badgeClass#">
                        $#thisAccount.getBalance()#
                    </span>
                    <br>
                    <span class="badge badge-light text-muted">
                        $#thisAccount.getVerifiedBalance()#
                    </span>
                </div>
            </div>

            <!--- Display for large devices --->
            <div class="container-fluid d-none d-md-block">
                <div class="row">
                    <div class="col">
                        <span class="btn btn-link"  data-accountid="#thisAccount.getId()#">
                            #thisAccount.getname()#
                        </span>
                    </div>
                    <div class="col text-right ">
                        <span class="badge badge-#local.badgeClass#">
                            $#thisAccount.getBalance()#
                        </span>
                    </div>
                    <div class="col text-right">
                        $#thisAccount.getVerifiedBalance()#
                    </div>
                    <div class="col text-right">
                        <button class="btn btn-link btn-sm" data-edit-trn="#thisAccount.getId()#" >
                            <i class="fa fa-pencil"></i> edit
                        </button>
                    </div>
                </div>
            </div>
            
        </li>
    </cfloop> 
</ul>

<br>

<a href="account/createEdit" class="btn btn-primary btn-sm pull-right d-none d-md-inline" ><i class="fa fa-plus"></i> Create New Account</a>

<div class="clearfix"></div>

    <div class="container-fluid ">
    <div class="row list-group-header">
        <div class="col">
            Account Groups          
        </div>
        <div class="col text-right d-none d-md-block">
            Total
        </div>
        <div class="col text-right d-none d-md-block">
            Verified
        </div>
        <div class="col"></div>
    </div>
</div>

<ul class="list-group">
      <?php
            $GrandTotal = 0.00;
            foreach($AccountGroups as $row) {
                $AccountDescription = $row["AccountDescription"];
                $AccountTotal = number_format($row['AccountTotal'],2); 
                $AccountVerified = number_format($row['VerifiedTotal'],2); 
                $GrandTotal = $GrandTotal + $row['AccountTotal']; 
                $icon = getAccountIcon($row['AccountTypeDescription']); ?>
                <li class="list-group-item">
                    <div class="d-block d-md-none">
                        <?= $icon." ".$AccountDescription ?>
                        <div class="pull-right text-right">
                            <span class="badge badge-secondary">
                                $<?= $AccountTotal ?>
                            </span>
                            <br>
                            <span class="badge badge-light text-muted">
                                $<?= $AccountVerified ?>
                            </span>
                        </div>
                    </div>
                    <div class="container-fluid d-none d-md-block">
                        <div class="row">
                            <div class="col">
                                <?= $icon." ".$AccountDescription ?>
                            </div>
                            <div class="col text-right ">
                                $<?= $AccountTotal ?>
                            </div>
                            <div class="col text-right">
                                $<?= $AccountVerified ?>
                            </div>
                            <div class="col"></div>
                        </div>
                    </div>
                    

                </li>
        <?php } ?>  
</ul>
    
</cfoutput>