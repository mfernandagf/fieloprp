public class InvoiceViewController{
    public Invoice__c record {get;set;}
    private ApexPages.StandardController controller;
    public List<Attachment> images {get; set;}

    /**
    * @brief constructor
    */
    public InvoiceViewController(ApexPages.StandardController controller) {
        this.controller = controller;

        this.controller.addFields(new List<String>{'Name','HasDetails__c'});
        record = (Invoice__c)controller.getRecord();

        images = [SELECT Id, Name FROM Attachment WHERE ParentId =: record.Id];
    }

}