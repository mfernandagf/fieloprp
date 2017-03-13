public with sharing class Invoices extends SObjectDomain {
	
	public static Set<Id> processedIds = new Set<Id>();
    public static Boolean validateAdminFields = true;
    public static Decimal newAmount;
    public static Decimal oldAmount;

    public Invoices(List<Invoice__c> records) {
        super(records);
    }

    public override void onAfterInsert() {
        FieloPLT.SObjectService.processRecords((List<Invoice__c>) Records, null);
    }

    public override void onValidate(){
        if(validateAdminFields){
            Set<Id> memberIds = new Set<Id>();
            for(Invoice__c invoice: (List<Invoice__c>)records){
                if(invoice.Member__c!=null)
                    memberIds.add(invoice.Member__c);
            }

            Map<Id,FieloPLT__Member__c> disabledUpdateMembers = new Map<Id, FieloPLT__Member__c>( new MembersSelector().selectByIdAndProgramWithDetailedInvoiceFalse(memberIds));

            for(Invoice__c invoice: (List<Invoice__c>)records){
                if( invoice.Amount__c != null && invoice.Amount__c != 0.0 )
                    if(invoice.Member__c!=null)
                        if( !disabledUpdateMembers.containsKey( invoice.Member__c ) )
                            invoice.addError( Label.AmountUpdateDisabled );

            }
        }
    }

    public override void onValidate( Map<Id,SObject> existingRecords ){
        if(validateAdminFields){
            Map<Id,Invoice__c> disabledUpdateinvoices = new Map<Id, Invoice__c>( new InvoicesSelector().selectByItemIdWithDetailedInvoiceDisabled(new Map<Id,Invoice__c>((List<Invoice__c>)records).keyset()));

            for(Invoice__c invoice: (List<Invoice__c>)records){
                newAmount = invoice.Amount__c==null
                    ? 0.0
                    : invoice.Amount__c;
                oldAmount = ((Invoice__c)existingRecords.get(invoice.Id)).Amount__c==null
                    ? 0.0
                    : ((Invoice__c)existingRecords.get(invoice.Id)).Amount__c;

                if( newAmount.setScale(2) != oldAmount.setScale(2) )
                    if( !disabledUpdateinvoices.containsKey( invoice.Id ) )
                        invoice.addError( Label.AmountUpdateDisabled );

                if( invoice.HasDetails__c != ((Invoice__c)existingRecords.get(invoice.Id)).HasDetails__c )
                    invoice.addError( Label.HasDetailsNotEditable );

                if( ((Invoice__c)existingRecords.get(invoice.Id)).Status__c != 'Pending' ){
                    invoice.addError( Label.DraftNotEditable );
                }
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
        Set<Id> memberIds = new Set<Id>();
        for(Invoice__c invoice: (List<Invoice__c>)records){
            memberIds.add(invoice.Member__c);
        }

        Map<Id,FieloPLT__Member__c> detailessInvoiceMembers = new Map<Id, FieloPLT__Member__c>( new MembersSelector().selectByIdAndProgramWithDetailedInvoiceFalse(memberIds));

        for(Invoice__c record : (List<Invoice__c>)records){
            if(record.Status__c == null){
                record.Status__c = 'Pending';
            }

            record.HasDetails__c = !detailessInvoiceMembers.containsKey( record.Member__c );
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
        try{
            delete [SELECT Id FROM InvoiceItem__c WHERE Invoice__c IN : invoices];
        }
        catch(Exception e){
            for(Invoice__c invoice: invoices){
                invoice.addError(e.getMessage());
            }
        }
    }
}