@isTest
public class TestChangeInvoiceStatus {
    private static List<FieloPLT__Program__c> programs;
    private static List<FieloPLT__Member__c> members;
    private static List<FieloPRP__Invoice__c> invoices;
    private static FieloPLT__PointType__c pointType;
    private static FieloPLT__ProgramPointType__c programPointType;

    /*  TEST-1594
        Change Invoice Status
        – Approve a Pending Invoice (OK)
    */
    @testSetup static void createData(){
        //Given
        pointType = new FieloPLT__PointType__c(
            Name = 'Point', 
            FieloPLT__MemberBalanceField__c = 'FieloPLT__Points__c', 
            FieloPLT__TransactionBalanceField__c = 'FieloPLT__Points__c', 
            FieloPLT__RewardBalanceField__c = 'FieloPLT__Points__c', 
            FieloPLT__RedemptionBalanceField__c = 'FieloPLT__Points__c', 
            FieloPLT__RedemptionItemBalanceField__c = 'FieloPLT__Points__c'
        );
        insert pointType;

        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__DetailedInvoice__c = true;
        insert programs;

        programPointType = new FieloPLT__ProgramPointType__c(
            FieloPLT__AuditPoints__c=false,
            FieloPLT__ExpirationMode__c='Total',
            FieloPLT__PointType__c=pointType.Id,
            FieloPLT__Program__c=programs[0].Id,
            FieloPLT__RequestPointApproval__c=false
        );
        insert programPointType;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        //cannot insert member with points, member applydefaults ignores the points value upon insert
        members[0].FieloPLT__Points__c = 100;
        members[1].FieloPLT__Points__c = 100;
        update members;

        invoices = MockUpFactory.createInvoices(members[0].Id,1);
        insert invoices;

        InvoiceItem__c item = new InvoiceItem__c(
            Invoice__c = invoices[0].Id,
            Quantity__c = 10.0,
            TotalPrice__c = 70.0
        );
        
        insert item;

        FieloPLT__Transaction__c transaccion = new FieloPLT__Transaction__c(
            FieloPLT__Member__c = members.get(0).Id
            , FieloPRP__Invoice__c = invoices[0].Id
            , FieloPLT__Points__c = 100
            , FieloPLT__IsOffline__c = false
            , FieloPLT__IsProcessed__c = true
            , FieloPLT__SkipEngine__c = true
        );

        insert transaccion;
    }

    @isTest static void PRP_0004_FB(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        Test.startTest();

        invoices[0].Status__c = 'Approved';

        update invoices;

        system.assertEquals('Approved', ((Invoice__c)[SELECT Id, Status__c FROM Invoice__c]).Status__c);

        Test.stopTest();
    }

    /*  TEST-1595
        Change Invoice Status
        – Reject a Pending Invoice (OK)
    */
    @isTest static void PRP_0004_FA1_1(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        Test.startTest();

        invoices[0].Status__c = 'Rejected';

        update invoices;

        system.assertEquals('Rejected', ((Invoice__c)[SELECT Id, Status__c FROM Invoice__c]).Status__c);

        Test.stopTest();
    }

    /*  TEST-1596
        Change Invoice Status
        – Validations
        - Revert a Pending Invoice (NOK)
    */
    @isTest static void PRP_0004_FA1_2(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        Test.startTest();

        invoices[0].Status__c = 'Reverted';

        try{
            update invoices;
        }
        catch(Exception e){
            //do nothing, expected validation
        }   

        system.assertEquals('Pending', ((Invoice__c)[SELECT Id, Status__c FROM Invoice__c]).Status__c);

        Test.stopTest();
    }

    /*  TEST-1597
        Change Invoice Status
        - Revert an Approved Invoice (OK)
    */
    @isTest static void PRP_0004_FA2(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        Test.startTest();

        invoices[0].Status__c = 'Approved';

        update invoices;

        invoices[0].Status__c = 'Reverted';

        update invoices;

        system.assertEquals(true,[Select Id, Name, FieloPLT__IsReverted__c From FieloPLT__Transaction__c WHERE Invoice__c =: invoices[0].Id ].FieloPLT__IsReverted__c);
        system.assertEquals('Reverted',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }

    /*  TEST-1598
        Change Invoice Status
        - Review an Approved Invoice (OK)
    */
    @isTest static void PRP_0004_FA3_1(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        Test.startTest();

        invoices[0].Status__c = 'Approved';

        update invoices;

        invoices[0].Status__c = 'Pending';

        update invoices;

        system.assertEquals(true,[Select Id, Name, FieloPLT__IsReverted__c From FieloPLT__Transaction__c WHERE Invoice__c =: invoices[0].Id ].FieloPLT__IsReverted__c);
        system.assertEquals('Pending',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }

    /*  TEST-1599
        Change Invoice Status
        – Validations
        - Reject an Approved Invoice (NOK)
    */
    @isTest static void PRP_0004_FA3_2(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        Test.startTest();

        invoices[0].Status__c = 'Approved';

        update invoices;

        invoices[0].Status__c = 'Rejected';

        try{
            update invoices;
        }
        catch(Exception e){}

        system.assertEquals(false,[Select Id, Name, FieloPLT__IsReverted__c From FieloPLT__Transaction__c WHERE Invoice__c =: invoices[0].Id ].FieloPLT__IsReverted__c);
        system.assertEquals('Approved',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }

    /*  TEST-1600
        Change Invoice Status
        - Review a Rejected Invoice (OK)
    */
    @isTest static void PRP_0004_FA4_1(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        Test.startTest();

        invoices[0].Status__c = 'Rejected';

        update invoices;

        invoices[0].Status__c = 'Pending';

        update invoices;
        
        system.assertEquals('Pending',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }

    /*  TEST-1601
        Change Invoice Status
        – Validations
        - Approve a Rejected Invoice (NOK)
    */
    @isTest static void PRP_0004_FA4_2(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        Test.startTest();

        invoices[0].Status__c = 'Rejected';

        update invoices;

        invoices[0].Status__c = 'Approved';

        try{
            update invoices;
        }
        catch(Exception e){}
        
        system.assertEquals('Rejected',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }

    /*  TEST-1602
        Change Invoice Status
        – Validations
        - Revert a Rejected Invoice (NOK)
    */
    @isTest static void PRP_0004_FA4_3(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        Test.startTest();

        invoices[0].Status__c = 'Rejected';

        update invoices;

        invoices[0].Status__c = 'Reverted';

        try{
            update invoices;
        }
        catch(Exception e){}
        
        system.assertEquals('Rejected',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }

    /*  TEST-1603
        Change Invoice Status
        - Review a Reverted Invoice (OK)
    */
    @isTest static void PRP_0004_FA5_1(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        invoices[0].Status__c = 'Approved';

        update invoices;

        Test.startTest();

        invoices[0].Status__c = 'Reverted';

        update invoices;

        invoices[0].Status__c = 'Pending';

        update invoices;
                
        system.assertEquals('Pending',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }

    /*  TEST-1604
        Change Invoice Status
        – Validations
        - Reject a Reverted Invoice (NOK)
    */
    @isTest static void PRP_0004_FA5_2(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        invoices[0].Status__c = 'Approved';

        update invoices;

        Test.startTest();

        invoices[0].Status__c = 'Reverted';

        update invoices;

        invoices[0].Status__c = 'Rejected';

        try{
            update invoices;
        }
        catch(Exception e){}
                
        system.assertEquals('Reverted',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }

    /*  TEST-1605
        Change Invoice Status
        – Validations
        - Approve a Reverted Invoice (NOK)
    */
    @isTest static void PRP_0004_FA5_3(){
        invoices = [SELECT Id, Name, Status__c FROM Invoice__c];

        invoices[0].Status__c = 'Approved';

        update invoices;

        Test.startTest();

        invoices[0].Status__c = 'Reverted';

        update invoices;

        invoices[0].Status__c = 'Approved';

        try{
            update invoices;
        }
        catch(Exception e){}
                
        system.assertEquals('Reverted',[SELECT Id, Status__c FROM Invoice__c LIMIT 1].Status__c);

        Test.stopTest();
    }
}