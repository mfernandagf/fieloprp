@isTest
public class TestInvoiceLandingController {
	private static List<FieloPLT__Program__c> programs;
    private static List<FieloPLT__Member__c> members;
    private static List<FieloPRP__Invoice__c> invoices;

    private static void createPrograms() {
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
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

	@isTest static void unitTest(){
		//Given
		programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        ApexPages.Standardsetcontroller standardController = new ApexPages.Standardsetcontroller(invoices);
        /*InvoiceLandingController controller = new InvoiceLandingController(standardController);
        
        // List<SelectOption> statusList = InvoiceLandingController.getStatusViews();

        String jsonFilter = '{"member__r.fieloplt__program__c":"'+programs[0].Id+'", "viewName":"Pending"}';

        List<SObject> records = InvoiceLandingController.getInvoices('FieloPRP__Invoice__c','Name',1,null,jsonFilter,10);

        FieloPLT__Program__c currentProgram = controller.currentProgram;*/
	}

	@isTest static void unitTest2(){
		//Given
		programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        Test.setCurrentPageReference(new PageReference('Page.InvoiceLanding')); 
		System.currentPageReference().getParameters().put('view', 'Pending for Approval');
        ApexPages.Standardsetcontroller standardController = new ApexPages.Standardsetcontroller(invoices);
        // InvoiceLandingController controller = new InvoiceLandingController(standardController);
	}
}