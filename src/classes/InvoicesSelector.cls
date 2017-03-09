public class InvoicesSelector extends SObjectSelector{

    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                Invoice__c.Id,
                Invoice__c.Name,
                Invoice__c.Amount__c,
                Invoice__c.HasDetails__c
            };
    }

    public InvoicesSelector(Set<String> fields){
        super(fields);
    }

    public InvoicesSelector(){
        super();
    }

    public Schema.SObjectType getSObjectType(){
        return Invoice__c.sObjectType;
    }

    public List<Invoice__c> selectById(Set<Id> invoiceIds){
        return (List<Invoice__c>) selectSObjectsById(invoiceIds);
    }

    public List<Invoice__c> selectByIdWithItemInfo(Set<Id> invoiceIds){
        return (List<Invoice__c>) Database.query(String.format(
                'select {0}, (Select Id, TotalPrice__c From InvoiceItems__r) ' +
                  'from {1} ' +
                  'where Id In: invoiceIds ' +
                  'order by {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }

    public List<Invoice__c> selectByItemIdWithItemInfo(Set<Id> invoiceItemIds){
        return (List<Invoice__c>) Database.query(String.format(
                'select {0}, (Select Id, TotalPrice__c From InvoiceItems__r) ' +
                  'from {1} ' +
                  'where Id In (Select FieloPRP__Invoice__c From FieloPRP__InvoiceItem__c Where Id in: invoiceItemIds) ' +
                  'order by {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }

    public List<Invoice__c> selectByItemId(Set<Id> invoiceItemIds){
        return (List<Invoice__c>) Database.query(String.format(
                'select {0} ' +
                  'from {1} ' +
                  'where Id In (Select FieloPRP__Invoice__c From FieloPRP__InvoiceItem__c Where Id in: invoiceItemIds) ' +
                  'order by {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }

    public List<Invoice__c> selectByItemIdWithDetailedInvoiceDisabled(Set<Id> invoiceIds){
        return (List<Invoice__c>) Database.query(String.format(
                'select {0} ' +
                  'from {1} ' +
                  'where Id In: invoiceIds ' +
                  'and FieloPRP__Member__r.FieloPLT__Program__r.DetailedInvoice__c = false ' + 
                  'order by {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }

    public List<Invoice__c> selectByProgramAndStatus(Set<String> status, Id programId) {
        String query = 'SELECT {0} ' + ' FROM {1} ';

        List<String> whereConditions = new List<String>();
        if (programId != null) {
            whereConditions.add(' Member__r.FieloPLT__Program__c =: programId ');
        }
        if (status != null) {
            whereConditions.add(' Status__c IN : status ');
        }
        if(!whereConditions.isEmpty()){
            query += 'WHERE ' + String.join(whereConditions, 'AND');
        }
        
        query += 'order by {2} {3} {4}';        
        return (List<Invoice__c>) Database.query(String.format(query,
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy(),
                    getLimitCondition(),
                    getOffsetCondition() } ));
    } 
}