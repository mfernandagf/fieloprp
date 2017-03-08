public with sharing class Invoices extends SObjectDomain {
	
	public static Set<Id> processedIds = new Set<Id>();
    public static Boolean validateAdminFields = true;

    public Invoices(List<Invoice__c> records) {
        super(records);
    }

    public override void onAfterInsert() {
        FieloPLT.SObjectService.processRecords((List<Invoice__c>) Records, null);
    }

    public override void onValidate(){
        if(validateAdminFields){
            for(Invoice__c invoice: (List<Invoice__c>)records){
                processedIds.add(invoice.Id);
            }

            Map<Id,Invoice__c> disabledUpdateinvoices = new Map<Id, Invoice__c>( new InvoicesSelector().selectByItemIdWithDetailedInvoiceDisabled(processedIds));

            for(Invoice__c invoice: (List<Invoice__c>)records){
                if( invoice.Amount__c != null && invoice.Amount__c != null )
                    if( !disabledUpdateinvoices.containsKey( invoice.Id ) )
                        invoice.addError( Label.AmountUpdateDisabled );

            }
        }
    }

    public override void onValidate( Map<Id,SObject> existingRecords ){
        if(validateAdminFields){
            for(Invoice__c invoice: (List<Invoice__c>)records){
                processedIds.add(invoice.Id);
            }

            Map<Id,Invoice__c> disabledUpdateinvoices = new Map<Id, Invoice__c>( new InvoicesSelector().selectByItemIdWithDetailedInvoiceDisabled(processedIds));

            for(Invoice__c invoice: (List<Invoice__c>)records){
                if( invoice.Amount__c != ((Invoice__c)existingRecords.get(invoice.Id)).Amount__c )
                    if( !disabledUpdateinvoices.containsKey( invoice.Id ) )
                        invoice.addError( Label.AmountUpdateDisabled );
            }
        }
    }

    public override void onAfterUpdate(Map<Id,SObject> existingRecords) {
        List<Invoice__c> recordsToProcess = new List<Invoice__c>();
        Map<Id,Invoice__c> mapExistingRecordsToProcess = new Map<Id,Invoice__c>();
        for(Invoice__c record : (List<Invoice__c>)records){
            if(!processedIds.contains(record.Id)){
                recordsToProcess.add(record);
                mapExistingRecordsToProcess.put(record.Id,(Invoice__c)existingRecords.get(record.Id));
                processedIds.add(record.Id);
            }
        }
        if(!recordsToProcess.isEmpty()){
            FieloPLT.SObjectService.processRecords(recordsToProcess, mapExistingRecordsToProcess);
        }
    }

    public override void onApplyDefaults() {
        for(Invoice__c record : (List<Invoice__c>)records){
            if(record.Status__c == null){
                record.Status__c = 'Pending';
            }
        }
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<SObject> sObjectList) {            
            return new Invoices(sObjectList);
        }
    }

    public override void onBeforeDelete(){
        deleteCriteria((List<Invoice__c>) Records);
    }

    public static void deleteCriteria(List<Invoice__c> invoices){

        if(SecurityUtils.checkSObjectIsDeletable(InvoiceItem__c.sObjectType)){
            delete [SELECT Id FROM InvoiceItem__c WHERE Invoice__c IN : invoices];
        }else{
            throw new FieloPLT.FieloException('You can not delete these records');
        }
    }
}