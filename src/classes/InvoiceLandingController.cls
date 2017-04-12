/**
* @description Class to Controller the Incentives Landing Page.
*/
public with sharing class InvoiceLandingController extends PageSettingsSetController{
    private ApexPages.StandardSetController controller {get;set;}
    public String currentView {get;set;}

    public FieloPLT__Program__c currentProgram { get {
        if ( currentProgram == null) {
            currentProgram = ProgramService.getActiveProgram();
        }
        return currentProgram;
    }set;}

    public InvoiceLandingController(ApexPages.StandardSetController stController) {
        this.controller = stController;

        initPageSettings('FieloPRP__Invoice__c',null,null);

        System.debug('newSettings: ' + this.newSettings);
        System.debug('landingSettings: ' + this.landingSettings);
    }

    public List<SelectOption> getListViews() {
        return controller.getListViewOptions();
    }

    @RemoteAction
    public static List<SObject> getInvoices( String objectName, String fields, Integer offset, String orderBy, String filter, Integer recordsPerPage ) {
        
        Set<String> fieldset = new Set<String>(fields.split(','));

        Map<String,Object> jsonObject = (Map<String, Object>) JSON.deserializeUntyped( filter);

        Id programId = (String)jsonObject.get('FieloPRP__Member__r.FieloPLT__Program__c');

        if ( orderBy == null ) {
            orderBy = 'LastModifiedDate DESC';
        }

        return InvoiceService.getInvoices( fieldset, null, programId, recordsPerPage,  offset, orderBy);
    }

    @RemoteAction
    public static RemoteActionResult save( Invoice__c record, List<InvoiceItem__c> items ){
        Savepoint sp;
        RemoteActionResult result = new RemoteActionResult();

        try{
            sp = Database.setSavepoint();

            Map<Id, Integer> quantityPerReward = new Map<Id, Integer>();
            for ( InvoiceItem__c i :items ) {
                Integer q = i.Quantity__c.intValue();
                if ( q >= 1 ) {
                    quantityPerReward.put( i.Product__c, q );
                }
            }
            // Setea Type BackEnd
            record.Origin__c = 'BackEnd';

            // Verifica que la redemption tenga items
            if ( quantityPerReward.isEmpty() ) {
                result.addMessage( new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.ERROR,Label.ErrorRedemptionItemsRequired));
            } else {
                List<Redemption__c> rr = RedemptionService.createRedemptions( quantityPerReward, record.member__c);
                if ( rr.size() == 1  ) {
                    result.addMessage( new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, 'The redemption was created successfully') );
                    result.redirectURL = '/'+rr[0].Id;
                } else {
                    result.addMessage( new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, 'Multiple redemptions were created') );
                }
            }

        }catch(DMLException e){
            if(sp != null){
                Database.rollback(sp);
            }
            result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
        }catch(Exception e){
            if(sp != null){
                Database.rollback(sp);
            }
            result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
        }
        return result;
    }
}