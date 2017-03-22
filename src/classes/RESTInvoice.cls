/**
 * @ingroup Invoice
 * \~English
 * @details    This REST Service interacts with the Fielo Invoice Module Services.
 */
@RestResource(urlMapping='/v1/members/*/invoices/*')
global with sharing class RESTInvoice {

    @HttpGet
    /**
     * @details     This method retuns invoice information related to a given Id
     * @param       invoiceId        	Optional parameter, if it is present the method will return a specific record
     * @param       fieldset            Fields to retrieve
     * @param       fromDate            Initial date to filter the returned records
     * @param       toDate              Last date to filter the returned records
     * @param       quantity            Number of records to return
     * @param       offset              Query offset (rows to skip when paginating the query results.)
     * @param       orderBy             Sort order of the returned data
     * @returns     List of Invoices returned by the criteria sent to the method
     * @retval  Success @verbinclude rewards.xml
     * @retval  Failure @verbinclude failure.xml
     *
     * @code{.sh}
     *          curl -X GET -H "Content-Type:application/json" -k -H 'Authorization: Bearer sessionId' 'https://{instance}.salesforce.com/services/apexrest/FieloEE/RestRedemption'
     * @endcode
     */
    global static void getInvoices(){
        
        if( RestContext.request.requestUri.contains('/invoices/') && RestContext.request.requestUri.contains('/invoiceItems') ){
            //Get Related List
            getRelatedList();
        } else if( RestContext.request.requestUri.contains('/invoices/') && !RestContext.request.requestUri.contains('/invoiceItems') ){
            //Get Detail
            getSingleRecord();
        } else {
            //Get List
            getList();
        }
    }

    @HttpPost
    global static void createInvoice(){
        //MemberId
        String requestUri = RestContext.request.requestUri;
        String memberId = requestUri.substring( requestUri.indexOf('/members/')  , requestUri.length() );
        memberId = memberId.replace('/members/', '');
        memberId = memberId.replace('/invoices', '');

        List<Map<String,Object>> response;
        RestRequest req = RestContext.request;//.requestBody;
        RestResponse resp = RestContext.response;
        resp.addHeader('Accept', 'application/json');
        resp.addHeader('Content-Type', 'application/json');

        try{
            if( MemberService.isMemberBlocked(memberId) == true ){
                response = new List<Map<String,Object>>{
                    new Map<String,Object>{
                        'statusCode' => 404,
                        'response' => new Map<String,String>{
                            'errorcode' => 'FIELO_ACCOUNT_BLOCKED',
                            'message' => Label.ErrorFieloAccountBlocked
                        }
                    }
                };
                RestContext.response.responseBody = Blob.valueOf( JSON.serialize( response ) );
            } else {
                List<Invoice__c> invoices = (List<Invoice__c>) System.JSON.deserialize( req.requestBody.toString(), List<Invoice__c>.class);

                for(Invoice__c invoice:invoices){
                    invoice.Member__c = memberId;
                }

                InvoiceService.createInvoice(invoices);

                resp.statusCode = 201;
                resp.responseBody = Blob.valueOf( JSON.serialize(invoices) );
            }
        }
        catch(Exception e){
            response = new List<Map<String,Object>>{
                    new Map<String,Object>{
                        'statusCode' => 404,
                        'response' => new Map<String,String>{
                            'errorcode' => 'EXCEPTION',
                            'message' => e.getMessage()
                        }
                    }
                };
            RestContext.response.responseBody = Blob.valueOf( JSON.serialize( response ) );
        }
    }

    private static void getSingleRecord() {
        //MemberId
        String requestUri = RestContext.request.requestUri;
        String memberId = requestUri.substring( requestUri.indexOf('/members/')  , requestUri.length() );
        memberId = memberId.replace('/members/', '');
        memberId = memberId.substring( 0, memberId.indexOf('/invoices/') );

        requestUri = RestContext.request.requestUri;
        String invoiceId = requestUri.substring( requestUri.indexOf('/invoices/')  , requestUri.length() );
        invoiceId = invoiceId.replace('/invoices/', '');

        String fieldset = RestContext.request.params.get('fields');
        Set<String> fields = new Set<String>();
        for(String s : fieldset != null ? fieldset.split(',') : new List<String>{'Id', 'Name'} ){
            fields.add((s));
        }

        List<Map<String,Object>> response;
        RestResponse resp = RestContext.response;
        resp.addHeader('Accept', 'application/json');
        resp.addHeader('Content-Type', 'application/json');

        if( MemberService.isMemberBlocked(memberId) == true ){
            response = new List<Map<String,Object>>{
                    new Map<String,Object>{
                        'statusCode' => 404,
                        'response' => new Map<String,String>{
                            'errorcode' => 'FIELO_ACCOUNT_BLOCKED',
                            'message' => Label.ErrorFieloAccountBlocked
                        }
                    }
                };
            RestContext.response.responseBody = Blob.valueOf( JSON.serialize( response ) );
        } else {
            InvoicesSelector selector = new InvoicesSelector(fields);

            List<Invoice__c> invoices = selector.selectByMemberIdAndInvoiceIdBetweenDates(
                new Set<Id>{invoiceId},
                memberId,
                null,
                null
            );

            if( !invoices.isEmpty() ){
                RestContext.response.responseBody = Blob.valueOf( JSON.serialize( invoices ) );
            } else {
                response = new List<Map<String,Object>>{
                    new Map<String,Object>{
                        'statusCode' => 200,
                        'response' => new Map<String,String>{
                            'errorcode' => 'RECORD_NOT_FOUND',
                            'message' => 'Record not found'
                        }
                    }
                };
                RestContext.response.responseBody = Blob.valueOf( JSON.serialize( response ) );
            }
        }
    }

    private static void getList() {
        //MemberId
        String requestUri = RestContext.request.requestUri;
        String memberId = requestUri.substring( requestUri.indexOf('/members/')  , requestUri.length() );
        memberId = memberId.replace('/members/', '');
        memberId = memberId.substring( 0, memberId.indexOf('/invoices') );

        requestUri = RestContext.request.requestUri;

        String fieldset = RestContext.request.params.get('fields');
        Set<String> fields = new Set<String>();
        for(String s : fieldset != null ? fieldset.split(',') : new List<String>{'Id', 'Name'} ){
            fields.add((s));
        }

        String offSet = RestContext.request.params.get('offset');
        String queryLimit = RestContext.request.params.get('limit');
        String orderby = RestContext.request.params.get('orderby');
        String fromdate = RestContext.request.params.get('fromdate');
        String todate = RestContext.request.params.get('todate');

        List<Map<String,Object>> response;
        RestResponse resp = RestContext.response;
        resp.addHeader('Accept', 'application/json');
        resp.addHeader('Content-Type', 'application/json');

        if( MemberService.isMemberBlocked(memberId) == true ){
            response = new List<Map<String,Object>>{
                    new Map<String,Object>{
                        'statusCode' => 404,
                        'response' => new Map<String,String>{
                            'errorcode' => 'FIELO_ACCOUNT_BLOCKED',
                            'message' => Label.ErrorFieloAccountBlocked
                        }
                    }
                };
            RestContext.response.responseBody = Blob.valueOf( JSON.serialize( response ) );
        } else {
            InvoicesSelector selector = new InvoicesSelector(fields);
            
            if(offset!=null){
                selector.setOffset(Integer.valueOf(offset));
            }
            if(queryLimit!=null){
                selector.setLimit(Integer.valueOf(queryLimit));
            }
            if(orderby!=null){
                selector.setOrderBy(orderby);
            }

            List<Invoice__c> invoices = selector.selectByMemberIdAndInvoiceIdBetweenDates(
                new Set<Id>(),
                memberId,
                fromdate!=null ? getdateFromString(fromdate) : null,
                todate!=null ? getdateFromString(todate) : null
            );

            if( !invoices.isEmpty() ){
                RestContext.response.responseBody = Blob.valueOf( JSON.serialize( invoices ) );
            } else {
                response = new List<Map<String,Object>>{
                    new Map<String,Object>{
                        'statusCode' => 200,
                        'response' => new Map<String,String>{
                            'errorcode' => 'RECORD_NOT_FOUND',
                            'message' => 'No invoice found'
                        }
                    }
                };
                RestContext.response.responseBody = Blob.valueOf( JSON.serialize( response ) );
            }
        }
    }

    private static void getRelatedList() {
        //MemberId
        String requestUri = RestContext.request.requestUri;
        String memberId = requestUri.substring( requestUri.indexOf('/members/')  , requestUri.length() );
        memberId = memberId.replace('/members/', '');
        memberId = memberId.substring( 0, memberId.indexOf('/invoices') );

        requestUri = RestContext.request.requestUri;
        String invoiceId = requestUri.substring( requestUri.indexOf('/invoices/')  , requestUri.length() );
        invoiceId = invoiceId.replace('/invoices/', '');
        invoiceId = invoiceId.replace('/invoiceItems', '');

        String fieldset = RestContext.request.params.get('fields');
        Set<String> fields = new Set<String>();
        for(String s : fieldset != null ? fieldset.split(',') : new List<String>{'Id', 'Name', 'Invoice__r.Id', 'Invoice__r.Name'} ){
            fields.add((s));
        }

        String offSet = RestContext.request.params.get('offset');
        String queryLimit = RestContext.request.params.get('limit');
        String orderby = RestContext.request.params.get('orderby');

        List<Map<String,Object>> response;
        RestResponse resp = RestContext.response;
        resp.addHeader('Accept', 'application/json');
        resp.addHeader('Content-Type', 'application/json');

        if( MemberService.isMemberBlocked(memberId) == true ){
            response = new List<Map<String,Object>>{
                    new Map<String,Object>{
                        'statusCode' => 404,
                        'response' => new Map<String,String>{
                            'errorcode' => 'FIELO_ACCOUNT_BLOCKED',
                            'message' => Label.ErrorFieloAccountBlocked
                        }
                    }
                };
            RestContext.response.responseBody = Blob.valueOf( JSON.serialize( response ) );
        } else {
            InvoiceItemsSelector selector = new InvoiceItemsSelector(fields);
            
            if(offset!=null){
                selector.setOffset(Integer.valueOf(offset));
            }
            if(queryLimit!=null){
                selector.setLimit(Integer.valueOf(queryLimit));
            }
            if(orderby!=null){
                selector.setOrderBy(orderby);
            }

            List<InvoiceItem__c> items = selector.selectByMemberIdAndInvoiceId(
                new Set<Id>{invoiceId},
                memberId
            );

            if( !items.isEmpty() ){
                RestContext.response.responseBody = Blob.valueOf( JSON.serialize( items ) );
            } else {
                response = new List<Map<String,Object>>{
                    new Map<String,Object>{
                        'statusCode' => 200,
                        'response' => new Map<String,String>{
                            'errorcode' => 'RECORD_NOT_FOUND',
                            'message' => 'No invoice items found'
                        }
                    }
                };
                RestContext.response.responseBody = Blob.valueOf( JSON.serialize( response ) );
            }
        }
    }

    public static Date getdateFromString(String dateString){
        //YYYY-MM-DD format
        if( ((Pattern.compile('\\d{4}\\-(\\d{2}|\\d)\\-(\\d{2}|\\d)')).matcher(dateString)).matches() ){
            List<String> dateList = dateString.split('-');
            return Date.newinstance( Integer.valueOf(dateList[0]), Integer.valueOf(dateList[1]), Integer.valueOf(dateList[2]) );
        }
        //MM/DD/YYYY format
        if( ((Pattern.compile('(\\d{2}|\\d)\\/(\\d{2}|\\d)\\/\\d{4}')).matcher(dateString)).matches() ){
            List<String> dateList = dateString.split('/');
            return Date.newinstance( Integer.valueOf(dateList[2]), Integer.valueOf(dateList[0]), Integer.valueOf(dateList[1]) );
        }
        return null;
    }
}