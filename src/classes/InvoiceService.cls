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

    public class InvoiceWrapper{
        public Invoice__c invoice;
        public List<InvoiceItem__c> invoiceItems;
    }

    public static List<Invoice__c> createInvoice(List<InvoiceWrapper> invoices){
        SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SobjectType>{Invoice__c.SObjectType, InvoiceItem__c.SObjectType});
        
        for(InvoiceWrapper InvoiceWrapper: invoices){
            uow.registerNew(InvoiceWrapper.invoice);
            if(InvoiceWrapper.invoiceItems!=null){
                for(InvoiceItem__c item: InvoiceWrapper.invoiceItems){
                    uow.registerNew(item, InvoiceItem__c.Invoice__c, InvoiceWrapper.invoice);
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

    public static void reprocessInvoice(Set<Id> invoiceIds){
        List<Invoice__c> invoices = new InvoicesSelector( Schema.getGlobalDescribe().get('FieloPRP__Invoice__c').getDescribe().fields.getMap().keySet() ).selectById(invoiceIds);
        if(!invoices.isEmpty()){
            FieloPLT.SObjectService.processRecords(invoices, null );
        }
    }

    public static Boolean isLockedByApprovalProcess(Set<Id> invoiceIds){
        List<ProcessInstance> approvalProcessInstanceList = InvoicesSelector.selectInvoiceApprovalProcessInstance(invoiceIds);

        for(ProcessInstance pi: approvalProcessInstanceList){
            if(pi.StepsAndWorkitems!=null){
                if(!pi.StepsAndWorkitems.isEmpty()){
                    return true;
                }
            }
        }

        return false;
    }

    public static void submitForApproval(Set<Id> recordIds){
        try{
            SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{Invoice__c.SObjectType});

            for(Id recordId : recordIds){
                uow.registerForApproval(recordId, null);
            }

            uow.commitWork();
        }
        catch(Exception e){ System.debug('Approval MSG: ' + e); }
    }

    public static void unlockRecord(Set<Id> recordIds, Boolean allOrNothing){
        try{
            List<Approval.UnlockResult> result = System.Approval.unlock(new List<Id>(recordIds));
        }
        catch(Exception e){System.debug('Approval msg: '+e);}
    }

    public static void processAprovalAction(Set<Id> recordIds, String approvalAction){
        List<ProcessInstance> approvalProcessInstanceList = InvoicesSelector.selectInvoiceApprovalProcessInstance(recordIds);

        for(ProcessInstance pi: approvalProcessInstanceList){
            if(pi.StepsAndWorkitems!=null){
                if(!pi.StepsAndWorkitems.isEmpty()){
                    for(ProcessInstanceHistory piwi: pi.StepsAndWorkitems){
                        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                        req.setAction( approvalAction );
                        req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                        req.setWorkitemId(piwi.Id);
                        Approval.ProcessResult result =  Approval.process(req);
                    }
                }
            }
        }       
    }
}