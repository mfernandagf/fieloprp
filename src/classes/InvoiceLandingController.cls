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
}