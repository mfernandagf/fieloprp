public with sharing class InvoiceService {
	
	public static List<Invoice__c> getInvoices(Set<String> fields, Set<String> status, Id programId, Integer quantity, Integer offset, String orderBy) {   
        InvoicesSelector selector = new InvoicesSelector(fields);
        selector.setOrderBy(orderBy);
        selector.setLimit(quantity);
        selector.setOffset(offset);
        return selector.selectByProgramAndStatus(status, programId);
    }

    public static void revertInvoices(Set<Id> invoiceIds){
    	List<Id> idsToRevert = new List<Id>(new Map<Id,FieloPLT__Transaction__c>(new TransactionsSelector().selectByInvoiceIdAndNotReverted(invoiceIds)).keySet());
    	if(!idsToRevert.isEmpty())
    		FieloPLT.TransactionService.revertTransactions( idsToRevert );
    }

    public static void updateInvoiceStatus(Set<Id> invoiceIds, String status){
        List<Invoice__c> invoices = new InvoicesSelector().selectById(invoiceIds);
        if(!invoices.isEmpty()){
            for(Invoice__c invoice: invoices){
                invoice.Status__c = status;
            }

            SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{Invoice__c.SObjectType});
            uow.registerDirty(invoices);
            uow.commitWork();
        }
            
    }

    public class InvoiceWrappler{
        public Invoice__c invoice;
        public List<InvoiceItem__c> invoiceItems;
    }

    public static List<Invoice__c> createInvoice(List<InvoiceWrappler> invoices){
        SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SobjectType>{Invoice__c.SObjectType, InvoiceItem__c.SObjectType});
        
        for(InvoiceWrappler invoiceWrappler: invoices){
            uow.registerNew(invoiceWrappler.invoice);
            if(invoiceWrappler.invoiceItems!=null){
                for(InvoiceItem__c item: invoiceWrappler.invoiceItems){
                    uow.registerNew(item, InvoiceItem__c.Invoice__c, invoiceWrappler.invoice);
                }
            }
        }

        try {
           uow.commitWork();

           return (List<Invoice__c>)uow.m_newListByType.get('FieloPRP__Invoice__c');
        }catch(DMLException e){
            throw e;
        }
    }
}