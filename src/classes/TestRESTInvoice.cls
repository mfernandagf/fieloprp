@isTest
public class TestRESTInvoice {
    private static List<FieloPLT__Program__c> programs;
    private static List<FieloPLT__Member__c> members;
    private static List<FieloPRP__Invoice__c> invoices;
    private static List<FieloPRP__InvoiceItem__c> items;
    private static Integer s_num;

    private static String getFakeId(Schema.SObjectType sot){
        String result = String.valueOf(s_num++);
        return sot.getDescribe().getKeyPrefix() + 
        '0'.repeat(12-result.length()) + result;
    }

	@isTest
    static void itShouldGetInvoices(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__DetailedInvoice__c = true;
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

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices';
        
        req.params.put('fields','Id, Name, FieloPRP__InvoiceNumber__c, FieloPRP__Date__c, FieloPRP__Member__c');
        req.params.put('offset','0');
        req.params.put('limit','2');
        req.params.put('orderby','FieloPRP__Date__c');
        req.params.put('fromdate','2017-01-01'); // YYYY-MM-DD - Supported!
        req.params.put('todate','01/05/2017'); // MM/DD/YYYY - Supported!

        req.httpMethod = 'GET';
        // When

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            RESTInvoice.getInvoices();
        Test.stopTest();

        List<Invoice__c> svcInvoices = (List<Invoice__c>) System.JSON.deserialize(RestContext.response.responseBody.toString(), List<Invoice__c>.class);

        System.assertEquals(2,svcInvoices.size());
    }

    @isTest
    static void itShouldGetInvoicesBlockedMember(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__DetailedInvoice__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;
        
        members[0].FieloPLT__Status__c='Blocked';
        update members;

        invoices = MockUpFactory.createInvoices(members[0].Id,2);
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

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices';
        req.httpMethod = 'GET';
        // When

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            RESTInvoice.getInvoices();
        Test.stopTest();

        String statusCode = String.valueOf( ((Map<String,Object>)((List<Object>) JSON.deserializeUntyped( RestContext.response.responseBody.toString() ))[0]).get('statusCode') );

        Map<String,Object> responseMap = (Map<String,Object>)((Map<String,Object>)((List<Object>) JSON.deserializeUntyped( RestContext.response.responseBody.toString() ))[0]).get('response');

        String errorCode = String.valueOf( responseMap.get('errorcode'));
        
        System.assertEquals('404',statusCode);
        System.assertEquals('FIELO_ACCOUNT_BLOCKED',errorCode);
    }

    @isTest
    static void itShouldGetOneInvoice(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__DetailedInvoice__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,2);
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

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices/'+invoices[0].Id;
        req.httpMethod = 'GET';
        // When

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            RESTInvoice.getInvoices();
        Test.stopTest();

        List<Invoice__c> svcInvoices = (List<Invoice__c>) System.JSON.deserialize(RestContext.response.responseBody.toString(), List<Invoice__c>.class);

        System.assertEquals(1,svcInvoices.size());
        System.assertEquals(invoices[0].Id,svcInvoices[0].Id);
    }

    @isTest
    static void itShouldGetOneInvoiceBlockedMember(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__DetailedInvoice__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        members[0].FieloPLT__Status__c='Blocked';
        update members;

        invoices = MockUpFactory.createInvoices(members[0].Id,2);
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

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices/'+invoices[0].Id;
        req.httpMethod = 'GET';
        // When

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            RESTInvoice.getInvoices();
        Test.stopTest();

        String statusCode = String.valueOf( ((Map<String,Object>)((List<Object>) JSON.deserializeUntyped( RestContext.response.responseBody.toString() ))[0]).get('statusCode') );

        Map<String,Object> responseMap = (Map<String,Object>)((Map<String,Object>)((List<Object>) JSON.deserializeUntyped( RestContext.response.responseBody.toString() ))[0]).get('response');

        String errorCode = String.valueOf( responseMap.get('errorcode'));
        
        System.assertEquals('404',statusCode);
        System.assertEquals('FIELO_ACCOUNT_BLOCKED',errorCode);
    }

    @isTest
    static void itShouldGetOneNonExistingInvoice(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__DetailedInvoice__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        invoices = MockUpFactory.createInvoices(members[0].Id,2);
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

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        s_num=0;

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices/'+getFakeId(FieloPRP__Invoice__c.SObjectType);
        req.httpMethod = 'GET';
        // When

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            RESTInvoice.getInvoices();
        Test.stopTest();

        String statusCode = String.valueOf( ((Map<String,Object>)((List<Object>) JSON.deserializeUntyped( RestContext.response.responseBody.toString() ))[0]).get('statusCode') );

        Map<String,Object> responseMap = (Map<String,Object>)((Map<String,Object>)((List<Object>) JSON.deserializeUntyped( RestContext.response.responseBody.toString() ))[0]).get('response');

        String errorCode = String.valueOf( responseMap.get('errorcode'));
        
        System.assertEquals('200',statusCode);
        System.assertEquals('RECORD_NOT_FOUND',errorCode);
    }

    @isTest
    static void itShouldGetNoInvoicesAtAll(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__DetailedInvoice__c = true;
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

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices';
        
        req.params.put('fields','Id, Name, FieloPRP__InvoiceNumber__c, FieloPRP__Date__c, FieloPRP__Member__c');
        req.params.put('offset','0');
        req.params.put('limit','2');
        req.params.put('orderby','FieloPRP__Date__c');
        
        //no record will return: wrong date range to cover all the method code
        req.params.put('fromdate','2017-02-01'); // YYYY-MM-DD - Supported
        req.params.put('todate','01/05/2017'); // MM/DD/YYYY - Supported

        req.httpMethod = 'GET';
        
        // When
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            RESTInvoice.getInvoices();
        Test.stopTest();

        String statusCode = String.valueOf( ((Map<String,Object>)((List<Object>) JSON.deserializeUntyped( RestContext.response.responseBody.toString() ))[0]).get('statusCode') );

        Map<String,Object> responseMap = (Map<String,Object>)((Map<String,Object>)((List<Object>) JSON.deserializeUntyped( RestContext.response.responseBody.toString() ))[0]).get('response');

        String errorCode = String.valueOf( responseMap.get('errorcode'));
        
        System.assertEquals('200',statusCode);
        System.assertEquals('RECORD_NOT_FOUND',errorCode);
    }

    @isTest
    static void itShouldGetInvoiceItems(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__DetailedInvoice__c = true;
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

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices/'+invoices[0].Id+'/invoiceItems';
        
        req.params.put('fields','Id, Name, FieloPRP__Quantity__c, FieloPRP__UnitPrice__c, FieloPRP__Invoice__c');
        req.params.put('offset','0');
        req.params.put('limit','2');
        req.params.put('orderby','CreatedDate');
        req.params.put('fromdate','2017-01-01'); // YYYY-MM-DD - Supported!
        req.params.put('todate','01/05/2017'); // MM/DD/YYYY - Supported!

        req.httpMethod = 'GET';
        // When

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            RESTInvoice.getInvoices();
        Test.stopTest();

        List<InvoiceItem__c> svcItems = (List<InvoiceItem__c>) System.JSON.deserialize(RestContext.response.responseBody.toString(), List<InvoiceItem__c>.class);

        System.assertEquals(2,svcItems.size());
    }

    @isTest
    static void itShouldGetInvoiceItemsBlockedMember(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__DetailedInvoice__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        members[0].FieloPLT__Status__c = 'Blocked';

        update members;

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

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices/'+invoices[0].Id+'/invoiceItems';
        
        req.params.put('fields','Id, Name, FieloPRP__Quantity__c, FieloPRP__UnitPrice__c, FieloPRP__Invoice__c');
        req.params.put('offset','0');
        req.params.put('limit','2');
        req.params.put('orderby','CreatedDate');
        req.params.put('fromdate','2017-01-01'); // YYYY-MM-DD - Supported!
        req.params.put('todate','01/05/2017'); // MM/DD/YYYY - Supported!

        req.httpMethod = 'GET';
        // When

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            RESTInvoice.getInvoices();
        Test.stopTest();

        String statusCode = String.valueOf( ((Map<String,Object>)((List<Object>) JSON.deserializeUntyped( RestContext.response.responseBody.toString() ))[0]).get('statusCode') );

        Map<String,Object> responseMap = (Map<String,Object>)((Map<String,Object>)((List<Object>) JSON.deserializeUntyped( RestContext.response.responseBody.toString() ))[0]).get('response');

        String errorCode = String.valueOf( responseMap.get('errorcode'));
        
        System.assertEquals('404',statusCode);
        System.assertEquals('FIELO_ACCOUNT_BLOCKED',errorCode);
    }

    @isTest
    static void itShouldGetNoInvoiceItemsAtAll(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__DetailedInvoice__c = true;
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

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        //Using the second Invoice Id to make the method returns no invoice item at all
        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices/'+invoices[1].Id+'/invoiceItems';
        
        req.params.put('fields','Id, Name, FieloPRP__Quantity__c, FieloPRP__UnitPrice__c, FieloPRP__Invoice__c');
        req.params.put('offset','0');
        req.params.put('limit','2');
        req.params.put('orderby','CreatedDate');
        req.params.put('fromdate','2017-01-01'); // YYYY-MM-DD - Supported!
        req.params.put('todate','01/05/2017'); // MM/DD/YYYY - Supported!

        req.httpMethod = 'GET';
        // When

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            RESTInvoice.getInvoices();
        Test.stopTest();

        String statusCode = String.valueOf( ((Map<String,Object>)((List<Object>) JSON.deserializeUntyped( RestContext.response.responseBody.toString() ))[0]).get('statusCode') );

        Map<String,Object> responseMap = (Map<String,Object>)((Map<String,Object>)((List<Object>) JSON.deserializeUntyped( RestContext.response.responseBody.toString() ))[0]).get('response');

        String errorCode = String.valueOf( responseMap.get('errorcode'));
        
        System.assertEquals('200',statusCode);
        System.assertEquals('RECORD_NOT_FOUND',errorCode);
    }

    @isTest
    static void itShouldCreateAnInvoice(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__DetailedInvoice__c = true;
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

        List<Invoice__c> newInvoices = [SELECT Id, Name, FieloPRP__Date__c, FieloPRP__Description__c, 
            (SELECT Id, Name, FieloPRP__Quantity__c, FieloPRP__UnitPrice__c FROM InvoiceItems__r ) FROM FieloPRP__Invoice__c LIMIT 2];

        for(Invoice__c invoice: newInvoices){
            invoice.Id = null;
            for(InvoiceItem__c item: invoice.InvoiceItems__r){
                item.Id=null;
            }
        }

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices';
        
        req.httpMethod = 'POST';

        req.requestBody = Blob.valueOf(JSON.serialize(newInvoices));
        // When

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            RESTInvoice.createInvoice();
        Test.stopTest();

        List<Invoice__c> svcInvoices = (List<Invoice__c>) System.JSON.deserialize(RestContext.response.responseBody.toString(), List<Invoice__c>.class);

        System.assert( svcInvoices[0].Id != null );
        System.assert( svcInvoices[1].Id != null );

        System.assert( svcInvoices[0].InvoiceItems__r.size()>0 || svcInvoices[1].InvoiceItems__r.size()>0 );
    }

    @isTest
    static void itShouldNotCreateAnInvoiceBlockedMember(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__DetailedInvoice__c = true;
        insert programs;

        members = MockUpFactory.createMembers(programs[0].Id,2);
        insert members;

        members[0].FieloPLT__Status__c = 'Blocked';

        update members;

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

        List<Invoice__c> newInvoices = [SELECT Id, Name, FieloPRP__Date__c, FieloPRP__Description__c, 
            (SELECT Id, Name, FieloPRP__Quantity__c, FieloPRP__UnitPrice__c FROM InvoiceItems__r ) FROM FieloPRP__Invoice__c LIMIT 2];

        for(Invoice__c invoice: newInvoices){
            invoice.Id = null;
            for(InvoiceItem__c item: invoice.InvoiceItems__r){
                item.Id=null;
            }
        }

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices';
        
        req.httpMethod = 'POST';

        req.requestBody = Blob.valueOf(JSON.serialize(newInvoices));
        // When

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            RESTInvoice.createInvoice();
        Test.stopTest();

        String statusCode = String.valueOf( ((Map<String,Object>)((List<Object>) JSON.deserializeUntyped( RestContext.response.responseBody.toString() ))[0]).get('statusCode') );

        Map<String,Object> responseMap = (Map<String,Object>)((Map<String,Object>)((List<Object>) JSON.deserializeUntyped( RestContext.response.responseBody.toString() ))[0]).get('response');

        String errorCode = String.valueOf( responseMap.get('errorcode'));
        
        System.assertEquals('404',statusCode);
        System.assertEquals('FIELO_ACCOUNT_BLOCKED',errorCode);
    }

    @isTest
    static void itShouldNotCreateAnInvoiceException(){
        //Given
        programs = MockUpFactory.createPrograms('Default', 1);
        programs[0].FieloPRP__DetailedInvoice__c = true;
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

        programs[0].FieloPRP__DetailedInvoice__c = false;
        update programs;

        List<Invoice__c> newInvoices = [SELECT Id, Name, FieloPRP__Date__c, FieloPRP__Description__c, 
            (SELECT Id, Name, FieloPRP__Quantity__c, FieloPRP__UnitPrice__c FROM InvoiceItems__r ) FROM FieloPRP__Invoice__c LIMIT 2];

        for(Invoice__c invoice: newInvoices){
            invoice.Id = null;
            for(InvoiceItem__c item: invoice.InvoiceItems__r){
                item.Id=null;
            }
        }

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/FieloPLT/v1/members/' + members[0].Id + '/invoices';
        
        req.httpMethod = 'POST';

        req.requestBody = Blob.valueOf(JSON.serialize(newInvoices));
        // When

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            RESTInvoice.createInvoice();
        Test.stopTest();

        String statusCode = String.valueOf( ((Map<String,Object>)((List<Object>) JSON.deserializeUntyped( RestContext.response.responseBody.toString() ))[0]).get('statusCode') );

        Map<String,Object> responseMap = (Map<String,Object>)((Map<String,Object>)((List<Object>) JSON.deserializeUntyped( RestContext.response.responseBody.toString() ))[0]).get('response');

        String errorCode = String.valueOf( responseMap.get('errorcode'));
        
        System.assertEquals('404',statusCode);
        System.assertEquals('EXCEPTION',errorCode);
    }
}