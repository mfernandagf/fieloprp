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
}