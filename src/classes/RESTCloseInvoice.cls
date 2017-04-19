@RestResource(urlMapping='/v1/members/*/closeinvoices/*')
global with sharing class RESTCloseInvoice {
	
	@HttpPatch
    global static void closeInvoices(List<Id> invoiceIds){
        RestRequest req = RestContext.request;
        RestResponse resp = RestContext.response;
        RestAPIResponse response = new RestAPIResponse();
        try{
            RestInvoice.checkPermissions();
            try{
                //MemberId
                String requestUri = RestContext.request.requestUri;
                String memberId = requestUri.substring( requestUri.indexOf('/members/')  , requestUri.length() );
                memberId = memberId.replace('/members/', '');
                memberId = memberId.replace('/invoices', '');

                resp.addHeader('Accept', 'application/json');
                resp.addHeader('Content-Type', 'application/json');

            
                if( MemberService.isMemberBlocked(memberId) == true ){
                    response.message = Label.ErrorFieloAccountBlocked;
                    response.errorcode = 'FIELO_ACCOUNT_BLOCKED';
                    resp.statusCode = 404;
                    resp.responseBody = Blob.valueOf( JSON.serialize(response) );
                    RestContext.response.responseBody = Blob.valueOf( JSON.serialize( response ) );
                } else {
                    List<Invoice__c> closedInvoices = InvoiceService.closeInvoices(new Set<Id>(invoiceIds));

                    resp.statusCode = 201;
                    resp.responseBody = Blob.valueOf( JSON.serialize(closedInvoices) );
                }
            }
            catch(Exception e){
                response.message = e.getMessage();
                response.errorcode = 'EXCEPTION';
                resp.statusCode = 404;
                resp.responseBody = Blob.valueOf( JSON.serialize( response ) );
            }
        }
        catch(Exception e){
            response.message = e.getMessage();
            response.errorcode = 'FORBIDDEN';
            resp.statusCode = 403;
            resp.responseBody = Blob.valueOf( JSON.serialize( response ) );
        }
    }

}