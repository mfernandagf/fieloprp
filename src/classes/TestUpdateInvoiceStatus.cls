@isTest
public class TestUpdateInvoiceStatus {
    private static List<FieloPLT__Program__c> programs;
    private static List<FieloPLT__Member__c> members;
    private static List<FieloPRP__Invoice__c> invoices;
    private static List<FieloPRP__InvoiceItem__c> items;

    @isTest
    static void itShouldUpdateInvoiceStatus(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__RequestInvoiceProducts__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,2);
        invoices[0].FieloPRP__Date__c = Date.newinstance(2017, 1, 2);
        invoices[1].FieloPRP__Date__c = Date.newinstance(2017, 1, 2);
        insert invoices;

        items = new List<InvoiceItem__c>{
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 15.0,
                UnitPrice__c = 50.0
            ),
            new InvoiceItem__c(
                Invoice__c = invoices[0].Id,
                Quantity__c = 10.0,
                UnitPrice__c = 50.0
            )
        };

        insert items;

        // When
        Test.startTest();
            InvoiceService.updateInvoiceStatus(new Set<Id>{invoices[0].Id}, 'Approved');
        Test.stopTest();

        //Then
        System.assertEquals('Approved', ((Invoice__c)[SELECT Id, FieloPRP__Status__c FROM FieloPRP__Invoice__c Where Id =:invoices[0].Id]).FieloPRP__Status__c );
    }
}