public class InvoiceViewController{
    public Invoice__c record {get;set;}
    private ApexPages.StandardController controller;

    /**
    * @brief constructor
    */
    public InvoiceViewController(ApexPages.StandardController controller) {
        this.controller = controller;

        this.controller.addFields(new List<String>{'Name'});
        record = (Invoice__c)controller.getRecord();
    }

}