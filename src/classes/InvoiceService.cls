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
}