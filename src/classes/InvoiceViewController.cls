public class InvoiceViewController extends PageSettingsController {
    public Invoice__c record {get;set;}
    private ApexPages.StandardController controller;
    public List<Attachment> images {get; set;}
    public String buttonString {get;set;}
    public String hiddenClass {get;set;}
    public Boolean lockedRecord {get;set;}
    public List<Map<String,Object>> buttonList {get;set;}

    /**
    * @brief constructor
    */
    public InvoiceViewController(ApexPages.StandardController controller) {
        this.controller = controller;

        if(!Test.isRunningTest()){
            this.controller.addFields(new List<String>{
                'Name',
                'FieloPRP__HasDetails__c',
                'FieloPRP__Member__c',
                'FieloPRP__InvoiceNumber__c',
                'FieloPRP__Status__c',
                'FieloPRP__Amount__c',
                'FieloPRP__Date__c',
                'FieloPRP__Description__c'
                });
        }

        record = (Invoice__c)controller.getRecord();

        try{
            lockedRecord = InvoiceService.isLockedByApprovalProcess( new Set<Id>{record.Id} );
        }
        catch(Exception e){
            lockedRecord = false;
        }
        
        hiddenClass = lockedRecord ? '' : 'slds-hide';

        images = [SELECT Id, Name FROM Attachment WHERE ParentId =: record.Id];

        buttonList = new List<Map<String,Object>>();

        if(!lockedRecord){
            if(record.Status__c == 'Draft' || record.Status__c == 'New'){
                buttonList.add(new Map<String,Object>{
                    'Label' => 'Edit',
                    'Type' => 'Modal',
                    'Action' => 'invoiceForm'
                });
                buttonList.add(new Map<String,Object>{
                    'Label' => 'Close',
                    'Type' => 'Remote',
                    'Action' => 'FieloPRP.InvoiceViewController.closeInvoice',
                    'Confirm' => true
                });
                buttonList.add(new Map<String,Object>{
                    'Label' => 'Submit for approval',
                    'Type' => 'Remote',
                    'Action' => 'FieloPRP.InvoiceViewController.submitForApproval',
                    'Confirm' => true
                });
            }else if(record.Status__c == 'Pending'){
                buttonList.add(new Map<String,Object>{
                    'Label' => 'Approve',
                    'Type' => 'Remote',
                    'Action' => 'FieloPRP.InvoiceViewController.approveInvoice',
                    'Confirm' => true
                });
                buttonList.add(new Map<String,Object>{
                    'Label' => 'Reject',
                    'Type' => 'Remote',
                    'Action' => 'FieloPRP.InvoiceViewController.rejectInvoice',
                    'Confirm' => true
                });
            }else if(record.Status__c == 'Approved'){
                buttonList.add(new Map<String,Object>{
                    'Label' => 'Cancel',
                    'Type' => 'Remote',
                    'Action' => 'FieloPRP.InvoiceViewController.cancelInvoice',
                    'Confirm' => true
                });
                buttonList.add(new Map<String,Object>{
                    'Label' => 'Reprocess',
                    'Type' => 'Remote',
                    'Action' => 'FieloPRP.InvoiceViewController.reprocessInvoice',
                    'Confirm' => true
                });
            }else if(record.Status__c == 'Rejected'){
                buttonList.add(new Map<String,Object>{
                    'Label' => 'Reopen',
                    'Type' => 'Remote',
                    'Action' => 'FieloPRP.InvoiceViewController.reopenInvoice',
                    'Confirm' => true
                });
            }else if(record.Status__c == 'Canceled'){
                buttonList.add(new Map<String,Object>{
                    'Label' => 'Reopen',
                    'Type' => 'Remote',
                    'Action' => 'FieloPRP.InvoiceViewController.reopenInvoice',
                    'Confirm' => true
                });
                buttonList.add(new Map<String,Object>{
                    'Label' => 'Reprocess',
                    'Type' => 'Remote',
                    'Action' => 'FieloPRP.InvoiceViewController.approveInvoice',
                    'Confirm' => true
                });
            }
        }

        if(!buttonList.isEmpty()){
            buttonString = JSON.serialize(buttonList);
            buttonString = buttonString.substring(1,buttonString.length()-1);    
        }

        initPageSettings( 'FieloPRP__Invoice__c', (SObject) record, buttonString, '' );
    }

    /**
    * @brief Update invoice status to Approved
    */
    @RemoteAction
    public static RemoteActionResult closeInvoice(Id recordId){
        RemoteActionResult result = new RemoteActionResult();

        try{
            Invoice__c invoice = InvoiceService.closeInvoices(new Set<Id>{recordId})[0];
            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, 'Record ' + invoice.Status__c) );
            result.redirectURL = '/'+recordId;
        }
        catch(Exception e){
            result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
        }

        return result;
    }

    /**
    * @brief Update invoice status to Approved
    */
    @RemoteAction
    public static RemoteActionResult approveInvoice(Id recordId){
        RemoteActionResult result = new RemoteActionResult();

        try{
            InvoiceService.updateInvoiceStatus(new Set<Id>{recordId}, 'Approved');
            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, 'Record Approved.') );
            result.redirectURL = '/'+recordId;
        }
        catch(Exception e){
            result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
        }

        return result;
    }

    /**
    * @brief Update invoice status to Rejected
    */
    @RemoteAction
    public static RemoteActionResult rejectInvoice(Id recordId){
        RemoteActionResult result = new RemoteActionResult();

        try{
            InvoiceService.updateInvoiceStatus(new Set<Id>{recordId}, 'Rejected');
            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, 'Record Rejected.') );
            result.redirectURL = '/'+recordId;
        }
        catch(Exception e){
            result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
        }
        
        return result;
    }

    /**
    * @brief Update invoice status to Pending
    */
    @RemoteAction
    public static RemoteActionResult reopenInvoice(Id recordId){
        RemoteActionResult result = new RemoteActionResult();

        try{
            InvoiceService.updateInvoiceStatus(new Set<Id>{recordId}, 'Draft');
            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, 'Record Draft.') );
            result.redirectURL = '/'+recordId;
        }
        catch(Exception e){
            result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
        }
        
        return result;
    }

    /**
    * @brief Update invoice status to Canceled
    */
    @RemoteAction
    public static RemoteActionResult cancelInvoice(Id recordId){
        RemoteActionResult result = new RemoteActionResult();

        try{
            InvoiceService.updateInvoiceStatus(new Set<Id>{recordId}, 'Canceled');
            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, 'Record Canceled') );
            result.redirectURL = '/'+recordId;
        }
        catch(Exception e){
            result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
        }
        
        return result;
    }

    /**
    * @brief Reprocess an invoice
    */
    @RemoteAction
    public static RemoteActionResult reprocessInvoice(Id recordId){
        RemoteActionResult result = new RemoteActionResult();

        try{
            InvoiceService.reprocessInvoice(new Set<Id>{recordId});

            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, 'Record reprocessed') );
            result.redirectURL = '/'+recordId;
        }
        catch(Exception e){
            result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
        }
        
        return result;
    }

    /**
    * @brief Reprocess an invoice
    */
    @RemoteAction
    public static RemoteActionResult submitForApproval(Id recordId){
        RemoteActionResult result = new RemoteActionResult();

        try{
            InvoiceService.updateInvoiceStatus(new Set<Id>{recordId}, 'Pending');
            InvoiceService.submitForApproval(new Set<Id>{recordId});

            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, 'Record updated') );
            result.redirectURL = '/'+recordId;
        }
        catch(Exception e){
            result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
        }
        
        return result;
    }
}