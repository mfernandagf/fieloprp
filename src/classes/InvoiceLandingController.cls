/**
* @description Class to Controller the Incentives Landing Page.
*/
public with sharing class InvoiceLandingController {

    public String currentView {get;set;}

    public FieloPLT__Program__c currentProgram { get {
        if ( currentProgram == null) {
            currentProgram = [SELECT Id FROM FieloPLT__Program__c LIMIT 1];//ProgramService.getActiveProgram();
        }
        return currentProgram;
    }set;}

    public InvoiceLandingController(ApexPages.StandardSetController stController) {
        if ( Apexpages.currentPage().getParameters().containsKey('view') ) {
            currentView = Apexpages.currentPage().getParameters().get('view');
        } else {
            currentView = 'Pending';
        }
    }

    public static List<SelectOption> getStatusViews(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Pending', 'Pending'));
        options.add(new SelectOption('Approved', 'Approved'));
        options.add(new SelectOption('Rejected', 'Rejected'));
        return options;
    }

    private static Set<String> getViewStatus(String currentView) {
        /*Set<String> status;
        if ( currentView  == 'Active' ) {
            status = new Set<String> {'Active', 'Scheduled'};
        } else if ( currentView  == 'Inactive' ) {
            status = new Set<String> {'Inactive', 'Finished'};
        } else {*/
            //status = new Set<String> {'Pending', 'Rejected', 'Approved'};
        //}
        //return status;
        return new Set<String>{currentView};
    }

    @RemoteAction
    public static List<SObject> getInvoices( String objectName, String fields, Integer offset, String orderBy, String filter, Integer recordsPerPage ) {
        Set<String> fieldset = new Set<String> { 'Name', 'Status__c'};
        Map<String,Object> jsonObject = (Map<String, Object>) JSON.deserializeUntyped( filter);
        Id programId = (String)jsonObject.get('program__c');
        String currentView =  (String)jsonObject.get('viewName');
        if ( orderBy == null ) {
            orderBy = 'LastModifiedDate DESC';
        }

        return InvoiceService.getInvoices( fieldset, getViewStatus(currentView), programId, recordsPerPage,  offset, orderBy);
    }


}