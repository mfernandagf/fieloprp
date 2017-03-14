@isTest
private class TestCreateInvoice {
	
    private static List<FieloPLT__Program__c> programs;
    private static List<FieloPLT__Member__c> members;
    private static List<FieloPRP__Invoice__c> invoices;

    private static void createPrograms() {
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__DetailedInvoice__c = true;
        insert programs;
    }

    private static void createMembers(){
        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;
    }

    private static void createInvoice(){
        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;
    }
	
	/*	TEST-1578
		Create an Invoice
		– The option to Consider Invoice Detail is true
	*/
	@isTest static void PRP_0002_FB(){
		//Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__DetailedInvoice__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        
        invoices[0].Amount__c = 10;

        //Then
        try{
        	insert invoices;
        }
        catch(Exception e){
        	System.assertEquals(0, [SELECT Id,Amount__c FROM Invoice__c].size());
        }

        invoices[0].Amount__c = null;

        insert invoices;

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
        	System.assertEquals(500.0, ((Invoice__c)[SELECT Id,Amount__c FROM Invoice__c]).Amount__c);
        }
	}

	/*	TEST-1579
		Create an Invoice
		– The option to Consider Invoice Detail is false
	*/
	@isTest static void PRP_0002_FA1_1(){
		//Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__DetailedInvoice__c = false;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        //When
        invoices[0].Amount__c = 10;

        //Then
        insert invoices;
        
        invoices[0].Amount__c = null;

        update invoices;

        invoices[0].Amount__c = 10;

        //Then
        try{
        	update invoices;
        }
        catch(Exception e){
        	System.assertEquals(10.0, ((Invoice__c)[SELECT Id, Amount__c FROM Invoice__c]).Amount__c.setScale(1) );
        }
	}

	/*	TEST-1580
		Create an Invoice
		– Validations
		– Try to create an invoice item when the option to Consider Invoice Detail is false
	*/
	@isTest static void PRP_0002_FA1_2(){
		//Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__DetailedInvoice__c = false;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        //When
        invoices[0].Amount__c = 10;

        //Then
        insert invoices;
        
        invoices[0].Amount__c = null;

        update invoices;

        invoices[0].Amount__c = 10;

        //Then
        update invoices;

        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            UnitPrice__c = 50.0
        );

        try{
        	insert item;
        }
        catch(Exception e){
        	System.assertEquals(0, [SELECT Id FROM InvoiceItem__c].size());
        }
	}

	/*	TEST-1581
		Create an Invoice
		– Delete Invoice
		- The option to Consider Invoice Detail is true
	*/
	@isTest static void PRP_0002_FA2(){
		//Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__DetailedInvoice__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;
        
        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            UnitPrice__c = 50.0
        );

        insert item;


        try{
        	//When
        	delete invoices;
        }
        catch(Exception e){
        	//Then
        	System.assertEquals(0, [SELECT Id FROM Invoice__c].size());
        	System.assertEquals(0, [SELECT Id FROM InvoiceItem__c].size());
        }
	}

	/*	TEST-1582
		Create an Invoice
		– Validations
		– Edit Amount field when the option Consider Invoice Detail is true
	*/
	@isTest static void PRP_0002_FA3(){
		//Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__DetailedInvoice__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        invoices[0].Amount__c = 10;

        //Then
        try{
        	update invoices;
        }
        catch(Exception e){
        	System.assertEquals(null, ((Invoice__c)[SELECT Id,Amount__c FROM Invoice__c]).Amount__c);
        }
	}

	/*	TEST-1583
		Create an Invoice
		– Validations
		– Create Invoice with no Member
	*/
	@isTest static void PRP_0002_FA4(){
		//Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__DetailedInvoice__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);

        //when
        invoices[0].Member__c = null;
        try{
        	insert invoices;
        }
        catch(Exception e){
        	//then
        	System.assertEquals(0, [SELECT Id FROM Invoice__c].size());
        }
	}

	/*	TEST-1584
		Create an Invoice
		– Validations
		– Edit the Member lookup
	*/
	@isTest static void PRP_0002_FA5(){
		//Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__DetailedInvoice__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);

        //when
        invoices[0].Member__c = members[1].Id;
        try{
        	insert invoices;
        }
        catch(Exception e){
        	//then
        	System.assertEquals( members[0].Id, ((Invoice__c)[SELECT Id,Member__c FROM Invoice__c]).Member__c );
        }
	}

	/*	TEST-1585
		Create an Invoice
		– Validations
		– Edit Invoice when its status is Approved
	*/
	@isTest static void PRP_0002_FA6_1(){
		//Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__DetailedInvoice__c = false;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        invoices[0].Status__c='Approved';
        insert invoices;
        
        String oldInvoiceNumber = invoices[0].InvoiceNumber__c;

        invoices[0].InvoiceNumber__c = 'Teste';

        //when
        try{
        	update invoices;
        }
        catch(Exception e){
        	//then
        	System.assertEquals( oldInvoiceNumber, ((Invoice__c)[SELECT Id,InvoiceNumber__c FROM Invoice__c]).InvoiceNumber__c );
        }
	}

	/*	TEST-1586
		Create an Invoice
		– Validations
		– Edit Invoice when its status is Rejected
	*/
	@isTest static void PRP_0002_FA6_2(){
		//Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__DetailedInvoice__c = false;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        invoices[0].Status__c='Rejected';
        insert invoices;
        
        String oldInvoiceNumber = invoices[0].InvoiceNumber__c;

        invoices[0].InvoiceNumber__c = 'Teste';

        //when
        try{
        	update invoices;
        }
        catch(Exception e){
        	//then
        	System.assertEquals( oldInvoiceNumber, ((Invoice__c)[SELECT Id,InvoiceNumber__c FROM Invoice__c]).InvoiceNumber__c );
        }
	}

	@isTest static void validateHasDetailsAccess(){
		//Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__DetailedInvoice__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        
        insert invoices;

        //When
        invoices[0].HasDetails__c=false;

        try{
        	update invoices;
        }
        catch(Exception e){
        	//then
        	System.assertEquals( true, ((Invoice__c)[SELECT Id,HasDetails__c From Invoice__c]).HasDetails__c );
        }
        
	}
}