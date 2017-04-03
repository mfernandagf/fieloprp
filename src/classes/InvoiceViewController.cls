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
            this.controller.addFields(new List<String>{'Name','HasDetails__c','Status__c'});
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
            if(record.Status__c == 'Draft'){
                buttonList.add(new Map<String,Object>{
                    'Label' => 'Edit',
                    'Type' => 'Modal',
                    'Action' => 'invoiceForm'
                });
                buttonList.add(new Map<String,Object>{
                    'Label' => 'Approve',
                    'Type' => 'Remote',
                    'Action' => 'FieloPRP.InvoiceViewController.approveInvoice',
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
                buttonList.add(new Map<String,Object>{
                    'Label' => 'Reopen',
                    'Type' => 'Remote',
                    'Action' => 'FieloPRP.InvoiceViewController.reopenInvoice',
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
                    'Action' => 'FieloPRP.InvoiceViewController.approveAndReprocessInvoice',
                    'Confirm' => true
                });
            }
        }
        else if(record.Status__c == 'Pending'){
            buttonList.add(new Map<String,Object>{
                'Label' => 'Reopen',
                'Type' => 'Remote',
                'Action' => 'FieloPRP.InvoiceViewController.reopenInvoice',
                'Confirm' => true
            });
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
    public static RemoteActionResult approveInvoice(Id recordId){
        RemoteActionResult result = new RemoteActionResult();

        try{
            String status = 'Approved';
            InvoiceService.processAprovalAction(new Set<Id>{recordId},'Approve');
            
            InvoiceService.updateInvoiceStatus(new Set<Id>{recordId}, status);
            
            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, 'Record '+status) );
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
    public static RemoteActionResult approveAndReprocessInvoice(Id recordId){
        RemoteActionResult result = new RemoteActionResult();

        try{
            String status = 'Approved';
            InvoiceService.updateInvoiceStatus(new Set<Id>{recordId}, status);
            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, 'Record reprocessed') );
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
            String status = 'Rejected';

            InvoiceService.processAprovalAction(new Set<Id>{recordId},'Reject');

            InvoiceService.updateInvoiceStatus(new Set<Id>{recordId}, status);
            
            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, 'Record '+status) );
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
            String status = 'Draft';

            InvoiceService.processAprovalAction(new Set<Id>{recordId},'Reject');

            InvoiceService.updateInvoiceStatus(new Set<Id>{recordId}, status);

            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, 'Record updated.') );
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
    public static RemoteActionResult setPendingStatus(Id recordId){
        RemoteActionResult result = new RemoteActionResult();

        try{
            String status = 'Pending';
            InvoiceService.updateInvoiceStatus(new Set<Id>{recordId}, status);
            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, 'Record updated.') );
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
            String status = 'Canceled';
            InvoiceService.updateInvoiceStatus(new Set<Id>{recordId}, status);
            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, 'Record '+status) );
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
            String status = 'Pending';

            InvoiceService.updateInvoiceStatus(new Set<Id>{recordId}, status);

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