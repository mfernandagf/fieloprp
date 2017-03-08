public class InvoiceItemsSelector extends SObjectSelector{

    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                InvoiceItem__c.Id,
                InvoiceItem__c.Name,
                InvoiceItem__c.Quantity__c,
                InvoiceItem__c.UnitPrice__c,
                InvoiceItem__c.TotalPrice__c
            };
    }

    public InvoiceItemsSelector(Set<String> fields){
        super(fields);
    }

    public InvoiceItemsSelector(){
        super();
    }

    public Schema.SObjectType getSObjectType(){
        return InvoiceItem__c.sObjectType;
    }

    public List<InvoiceItem__c> selectById(Set<Id> invoiceItemIds){
        return (List<InvoiceItem__c>) selectSObjectsById(invoiceItemIds);
    }

    public List<InvoiceItem__c> selectByIdWithInvoiceStatusPending(Set<Id> invoiceItemIds){
        String draftStatus = 'Pending';
        return (List<InvoiceItem__c>) Database.query(String.format(
                'select {0} ' +
                  'from {1} ' +
                  'where Id In: invoiceItemIds ' +
                  'and FieloPRP__Invoice__r.FieloPRP__Status__c = :draftStatus ' +
                  'order by {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }
}