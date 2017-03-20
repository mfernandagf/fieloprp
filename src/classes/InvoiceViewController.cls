public class InvoiceViewController{
    public Invoice__c record {get;set;}
    private ApexPages.StandardController controller;
    public List<Attachment> images {get; set;}
    public String buttonString {get;set;}
    public List<Map<String,Object>> buttonList {get;set;}

    /**
    * @brief constructor
    */
    public InvoiceViewController(ApexPages.StandardController controller) {
        this.controller = controller;

        this.controller.addFields(new List<String>{'Name','HasDetails__c','Status__c'});
        record = (Invoice__c)controller.getRecord();

        images = [SELECT Id, Name FROM Attachment WHERE ParentId =: record.Id];

        buttonList = new List<Map<String,Object>>();

        if(record.Status__c == 'Pending'){
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
                'Label' => 'Reject',
                'Type' => 'Remote',
                'Action' => 'FieloPRP.InvoiceViewController.rejectInvoice',
                'Confirm' => true
            });

        }else if(record.Status__c == 'Approved'){
            buttonList.add(new Map<String,Object>{
                'Label' => 'Review',
                'Type' => 'Remote',
                'Action' => 'FieloPRP.InvoiceViewController.reviewInvoice',
                'Confirm' => true
            });

            buttonList.add(new Map<String,Object>{
                'Label' => 'Revert',
                'Type' => 'Remote',
                'Action' => 'FieloPRP.InvoiceViewController.revertInvoice',
                'Confirm' => true
            });

        }else if(record.Status__c == 'Rejected'){
            buttonList.add(new Map<String,Object>{
                'Label' => 'Review',
                'Type' => 'Remote',
                'Action' => 'FieloPRP.InvoiceViewController.reviewInvoice',
                'Confirm' => true
            });

        }else if(record.Status__c == 'Reverted'){
            buttonList.add(new Map<String,Object>{
                'Label' => 'Review',
                'Type' => 'Remote',
                'Action' => 'FieloPRP.InvoiceViewController.reviewInvoice',
                'Confirm' => true
            });
        }

        if(!buttonList.isEmpty()){
            buttonString = JSON.serialize(buttonList);
            buttonString = buttonString.substring(1,buttonString.length()-1);    
        }
    }

    /**
    * @brief Update invoice status to Approved
    */
    @RemoteAction
    public static RemoteActionResult approveInvoice(Id recordId){
        RemoteActionResult result = new RemoteActionResult();

        try{
            String status = 'Approved';
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
    * @brief Update invoice status to Rejected
    */
    @RemoteAction
    public static RemoteActionResult rejectInvoice(Id recordId){
        RemoteActionResult result = new RemoteActionResult();

        try{
            String status = 'Rejected';
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
    public static RemoteActionResult reviewInvoice(Id recordId){
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
    * @brief Update invoice status to Reverted
    */
    @RemoteAction
    public static RemoteActionResult revertInvoice(Id recordId){
        RemoteActionResult result = new RemoteActionResult();

        try{
            String status = 'Reverted';
            InvoiceService.updateInvoiceStatus(new Set<Id>{recordId}, status);
            result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.CONFIRM, 'Record '+status) );
            result.redirectURL = '/'+recordId;
        }
        catch(Exception e){
            result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
        }
        
        return result;
    }    
}