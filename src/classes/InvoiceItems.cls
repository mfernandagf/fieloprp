public class InvoiceItems extends SObjectDomain {
    public static Boolean totalPriceChanged = false;
    public static Boolean totalPriceZero = false;
    public static Boolean unitPriceChanged = false;
    public static Boolean unitPriceZero = false;
    public static Boolean quantityChanged = false;
    public static Boolean quantityZero = false;

    public static Boolean validateAdminFields = true;

    public static Set<Id> processedIds = new Set<Id>();

    public InvoiceItems(List<InvoiceItem__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<SObject> sObjectList) {
            return new InvoiceItems(sObjectList);
        }
    }

    public override void onValidate( Map<Id,SObject> existingRecords ){
        
        for(InvoiceItem__c item: (List<InvoiceItem__c>)records){
            processedIds.add(item.Id);

            totalPriceZero = item.TotalPrice__c == 0.0;
            quantityZero = item.Quantity__c == 0.0;
            unitPriceZero = item.UnitPrice__c == 0.0;

            //All zero
            if( totalPriceZero && quantityZero && unitPriceZero ){
                item.addError( Label.AllPriceFieldsZero );
            }

            //Only Unit Price is set
            else if( totalPriceZero && quantityZero && !unitPriceZero ){
                item.addError( Label.TotalPriceAndQuantityZero );
            }

            //Quantity is zero
            else if( quantityZero ){
                item.addError( Label.QuantityZero );  
            }
        }

        Map<Id, InvoiceItem__c> itemsWithDraftInvoice = new Map<Id,InvoiceItem__c>(new InvoiceItemsSelector().selectByIdWithInvoiceStatusPending(processedIds));

        for(InvoiceItem__c item: (List<InvoiceItem__c>)records){
            if( !itemsWithDraftInvoice.containsKey(item.Id) ){
                item.addError( Label.DraftNotEditable );
            }
        }
    }

    public override void onAfterInsert() {
        Set<Id> invoiceIds = new Set<Id>();

        for(InvoiceItem__c item: (List<InvoiceItem__c>)records){
            //Add all new items, no check needed
            invoiceIds.add(item.Invoice__c);

        }

        if(!invoiceIds.isEmpty()){
            List<Invoice__c> invoicesList = new InvoicesSelector().selectById(invoiceIds);
            Map<Id,Invoice__c> mapInvoices = new Map<Id, Invoice__c>(invoicesList);

            for( InvoiceItem__c item: (List<InvoiceItem__c>)records ){
                if(mapInvoices.containsKey(item.Invoice__c))
                    mapInvoices.get(item.Invoice__c).Amount__c = mapInvoices.get(item.Invoice__c).Amount__c != null
                        ? mapInvoices.get(item.Invoice__c).Amount__c + item.TotalPrice__c
                        : item.TotalPrice__c;
            }

            if(invoicesList.size()>0){
                try{
                    Invoices.validateAdminFields=false;

                    SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{Invoice__c.SObjectType});
                    uow.registerDirty(invoicesList);
                    uow.commitWork();

                    Invoices.validateAdminFields=true;
                }catch(Exception e){
                    Invoices.validateAdminFields=true;
                    throw e;
                }
                
            }
        }
    }

    public override void onBeforeInsert(){
        for(InvoiceItem__c item: (List<InvoiceItem__c>)records){
            totalPriceZero = item.TotalPrice__c == 0 ? true: false;
            quantityZero = item.Quantity__c == 0 ? true: false;
            unitPriceZero = item.UnitPrice__c == 0 ? true: false;

            if( !(!totalPriceZero && quantityZero && unitPriceZero) ){

                //UnitPrice and Quantity set
                if( !quantityZero && !unitPriceZero ){
                    item.TotalPrice__c = item.Quantity__c * item.UnitPrice__c;
                }
                
                //Total Price and Unit Price set
                else if( !totalPriceZero && quantityZero && !unitPriceZero ){
                    item.Quantity__c = item.TotalPrice__c / item.UnitPrice__c;
                }
                
                //Quantity and Total Price set
                else if( !totalPriceZero && !quantityZero && unitPriceZero ){
                    item.UnitPrice__c = item.TotalPrice__c / item.Quantity__c;
                }
                
            }
        }
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords){
        for(InvoiceItem__c item: (List<InvoiceItem__c>)records){
            totalPriceChanged = item.TotalPrice__c != ((InvoiceItem__c)existingRecords.get(item.Id)).TotalPrice__c;
            unitPriceChanged = item.Quantity__c != ((InvoiceItem__c)existingRecords.get(item.Id)).Quantity__c;
            quantityChanged = item.UnitPrice__c != ((InvoiceItem__c)existingRecords.get(item.Id)).UnitPrice__c;
            totalPriceZero = item.TotalPrice__c == 0.0;
            quantityZero = item.Quantity__c == 0.0;
            unitPriceZero = item.UnitPrice__c == 0.0;

            if( totalPriceChanged || unitPriceChanged || quantityChanged ){

                //Only Quantity is changed
                if( !totalPriceChanged && !unitPriceChanged && quantityChanged ){
                    item.TotalPrice__c = item.Quantity__c * item.UnitPrice__c;
                }

                //Quantity and Total Price are changed
                else if( totalPriceChanged && !unitPriceChanged && quantityChanged ){
                    if( !quantityZero )
                        item.UnitPrice__c = item.TotalPrice__c / item.Quantity__c;
                    else
                        item.Quantity__c.addError( Label.QuantityZero );
                }

                //Only Unit Price is changed
                else if( !totalPriceChanged && unitPriceChanged ){
                    item.TotalPrice__c = item.Quantity__c * item.UnitPrice__c;
                }

                //Total Price and Unit Price are changed
                else if( totalPriceChanged && unitPriceChanged && !quantityChanged ){
                    if( !unitPriceZero )
                        item.Quantity__c = item.TotalPrice__c / item.UnitPrice__c;
                    else
                        item.UnitPrice__c.addError( Label.UnitPriceZero );
                }

                //Everything changed
                else if( totalPriceChanged && unitPriceChanged && quantityChanged ){
                    item.TotalPrice__c = item.Quantity__c * item.UnitPrice__c;
                }
            }
        }
    }    

    public override void onAfterUpdate(Map<Id,SObject> existingRecords) {
        Set<Id> itemIds = new Set<Id>();

        //Check for updates that may affect TotalPrice
        for(InvoiceItem__c item: (List<InvoiceItem__c>)records){
            //Add only updated items.
            if( item.TotalPrice__c != ((InvoiceItem__c)existingRecords.get(item.Id)).TotalPrice__c
                || item.Quantity__c != ((InvoiceItem__c)existingRecords.get(item.Id)).Quantity__c 
                || item.UnitPrice__c != ((InvoiceItem__c)existingRecords.get(item.Id)).UnitPrice__c ){

                itemIds.add(item.Id);
            }
            
        }

        if(!itemIds.isEmpty()){
            //Method that returns the invoices with its related data
            List<Invoice__c> invoices = new InvoicesSelector().selectByItemIdWithItemInfo(itemIds);

            //Method to update the amount of a given Invoice List.
            //this method is used in afterInsert, afterUpdate and afterDelete methods
            updateInvoiceAmount(invoices);
        }
    }

    public override void onAfterDelete() {
        Set<Id> invoiceIds = new Set<Id>();

        for(InvoiceItem__c item: (List<InvoiceItem__c>)records){
            //Add all new items, no check needed
            invoiceIds.add(item.Invoice__c);

        }

        if(!invoiceIds.isEmpty()){
            List<Invoice__c> invoicesList = new InvoicesSelector().selectById(invoiceIds);
            Map<Id,Invoice__c> mapInvoices = new Map<Id, Invoice__c>(invoicesList);

            for( InvoiceItem__c item: (List<InvoiceItem__c>)records ){
                mapInvoices.get(item.Invoice__c).Amount__c -= item.TotalPrice__c;
            }

            if(invoicesList.size()>0){
                try{
                    Invoices.validateAdminFields=false;

                    SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{Invoice__c.SObjectType});
                    uow.registerDirty(invoicesList);
                    uow.commitWork();

                    Invoices.validateAdminFields=true;
                }catch(Exception e){
                    Invoices.validateAdminFields=true;

                    throw e;
                }
            }
        }
    }

    /* This method receive a List of Infoice and it's related data and recalculates
        the Amount field.
    */
    public static void updateInvoiceAmount( List<Invoice__c> invoicesList ){
        List<InvoiceItem__c> items = new List<InvoiceItem__c>();
        for(Invoice__c invoice: invoicesList){
            invoice.Amount__c=0;
            for(InvoiceItem__c invoiceItem: invoice.InvoiceItems__r){
                invoice.Amount__c += invoiceItem.TotalPrice__c;
            }
        }

        if(invoicesList.size()>0){
            try{
                Invoices.validateAdminFields=false;

                SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{Invoice__c.SObjectType});
                uow.registerDirty(invoicesList);
                uow.commitWork();

                Invoices.validateAdminFields=true;

            }catch(Exception e){
                Invoices.validateAdminFields=true;

                throw e;
            }
            
        }
    }
}