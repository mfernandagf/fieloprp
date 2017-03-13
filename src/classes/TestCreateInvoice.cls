@isTest
private class TestCreateInvoice {
	
    private static List<FieloPLT__Program__c> programs;
    private static List<FieloPLT__Member__c> members;
    private static List<FieloPRP__Invoice__c> invoices;

    private static void createPrograms() {
        programs = RTMockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__DetailedInvoice__c = true;
        insert programs;
    }

    private static void createMembers(){
        members = RTMockUpFactory.createMembers(programs[0].Id,2);
        insert members;
    }

    private static void createInvoice(){
        invoices = RTMockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;
    }
	
	/*	TEST-1578
		Create an Invoice
		– The option to Consider Invoice Detail is true
	*/
	@isTest static void PRP_0002_FB(){
		//Given
        programs = RTMockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__DetailedInvoice__c = true;
        insert programs;

        members = RTMockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = RTMockUpFactory.createInvoices(members[0].Id,1);
        //When
        invoices[0].Amount__c = 10;

        //Then
        try{
        	insert invoices;
        }
        catch(Exception e){
        	System.assertEquals(0, [Select Id,Amount__c From Invoice__c].size());
        }

        invoices[0].Amount__c = null;

        insert invoices;

        invoices[0].Amount__c = 10;

        //Then
        try{
        	update invoices;
        }
        catch(Exception e){
        	System.assertEquals(null, ((Invoice__c)[Select Id,Amount__c From Invoice__c]).Amount__c);
        }

        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            UnitPrice__c = 50.0
        );

        insert item;

        invoices[0].Amount__c = 10.0;

        try{
        	update invoices;
        }
        catch(Exception e){
        	System.assertEquals(500.0, ((Invoice__c)[Select Id,Amount__c From Invoice__c]).Amount__c);
        }
	}
}