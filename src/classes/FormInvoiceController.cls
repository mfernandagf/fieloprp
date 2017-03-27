public with sharing class FormInvoiceController {

    public Id cProgramId {get;set;}

    public FormInvoiceController(FormController controller) {

    }

  	private Map<String, Schema.SObjectField> fieldMap { get {
    	if ( fieldMap == null ) {
      		Schema.DescribeSObjectResult[] describes = Schema.describeSObjects(new String[]{ 'FieloPLT__Invoice__c' });
      		fieldMap = describes.get(0).fields.getMap();
    	}
    	return fieldMap;
  	} set; }

	/*****  Metodos Remote para Save y Retrieve *****/
    @RemoteAction
    public static RemoteActionResult save( Invoice__c record, List<InvoiceItem__c> items, List<String> nullFields){
	    Savepoint sp;
	    RemoteActionResult result = new RemoteActionResult();
	    try{
	        sp = Database.setSavepoint();

	        Boolean isUpdate = record.Id != null;
	        


	        SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{Invoice__c.SObjectType, InvoiceItem__c.SObjectType});
	        // Actualiza los criterios
	        // List<Id> idItems = new List<Id>();
	        if(isUpdate){
	        	uow.registerDirty(record);
	        	
	        	List<InvoiceItem__c> oldItems = [SELECT Id FROM InvoiceItem__c WHERE Invoice__c = :record.Id];
	        	if(!oldItems.isEmpty()){
	        		uow.registerDeleted(oldItems);
	        	}
	        }else{
	        	uow.registerDirty(record);
	        }

	        if(!items.isEmpty()){
        		for(InvoiceItem__c ii : items){
        			uow.registerNew(ii, InvoiceItem__c.Invoice__c, record);	        			
        		}
        	}

        	uow.commitWork();
	        result.addMessage(new RemoteActionResult.RemoteActionMessage( ApexPages.Severity.Confirm, 'Data was saved successfully') );
	    }catch(DmlException e){
	        //System.debug(LoggingLevel.ERROR, e);
		    // Agrega las Validation Rules asociadas al Campo
	        Database.rollback(sp);
	        if(ApexPages.hasMessages()){
	            result.redirectURL = '';
	            for(ApexPages.Message m : ApexPages.getMessages()){
	                result.addMessage(new RemoteActionResult.RemoteActionMessage(m, 'FieloPRP__Invoice__c'));
	            }
	        } else {
	          	result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
	        }
	    }catch(Exception e){
	        System.debug(LoggingLevel.ERROR, e);
	        System.debug(LoggingLevel.ERROR,e.getStackTraceString());
	        if(sp != null){
	            Database.rollback(sp);
	        }
	        result.addMessage(new RemoteActionResult.RemoteActionMessage(e));
	    }

	    return result;
  	}

	@RemoteAction
	public static Invoice__c retrieve( String recordId, String fields ){
	    String query = 'SELECT (SELECT Id, Product__r.Name, Quantity__c, TotalPrice__c FROM InvoiceItems__r), ' + fields;
	    query += ' FROM Invoice__c';
	    query += ' WHERE ID =: recordId' ;
	    query += ' LIMIT 1';
	    List<Invoice__c> result = Database.query(query);
	    return result.get(0);
  	}
}