public class InvoicesSelector extends SObjectSelector{

    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                Invoice__c.Id,
                Invoice__c.Name,
                Invoice__c.Amount__c,
                Invoice__c.Status__c,
                Invoice__c.HasDetails__c,
                Invoice__c.InvoiceNumber__c,
                Invoice__c.Distributor__c
            };
    }

    public InvoicesSelector(Set<String> fields){
        super(fields);
    }

    public InvoicesSelector(){
        super();
    }

    public Schema.SObjectType getSObjectType(){
        return Invoice__c.sObjectType;
    }

    public List<Invoice__c> selectById(Set<Id> invoiceIds){
        return (List<Invoice__c>) selectSObjectsById(invoiceIds);
    }

    public List<Invoice__c> selectByItemIdWithItemInfo(Set<Id> invoiceItemIds){
        return (List<Invoice__c>) Database.query(String.format(
                'select {0}, (Select Id, TotalPrice__c From InvoiceItems__r) ' +
                  'from {1} ' +
                  'where Id In (Select FieloPRP__Invoice__c From FieloPRP__InvoiceItem__c Where Id in: invoiceItemIds) ' +
                  'order by {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }

    public List<Invoice__c> selectByItemIdWithDetailedInvoiceDisabled(Set<Id> invoiceIds){
        return (List<Invoice__c>) Database.query(String.format(
                'select {0} ' +
                  'from {1} ' +
                  'where Id In: invoiceIds ' +
                  'and FieloPRP__Member__r.FieloPLT__Program__r.RequestInvoiceProducts__c = false ' + 
                  'order by {2}',
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy() } ));
    }

    public List<Invoice__c> selectByProgramAndStatus(Set<String> status, Id programId) {
        String query = 'SELECT {0} ' + ' FROM {1} ';

        List<String> whereConditions = new List<String>();
        if (programId != null) {
            whereConditions.add(' Member__r.FieloPLT__Program__c =: programId ');
        }
        if (status != null) {
            whereConditions.add(' Status__c IN : status ');
        }
        if(!whereConditions.isEmpty()){
            query += 'WHERE ' + String.join(whereConditions, 'AND');
        }
        
        query += 'order by {2} {3} {4}';        
        return (List<Invoice__c>) Database.query(String.format(query,
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy(),
                    getLimitCondition(),
                    getOffsetCondition() } ));
    }

    public List<Invoice__c> selectByInvoiceNumberDistributorAndStatus(Set<String> invoiceNumbers, Set<String> distributors, String status) {
        String query = 'SELECT {0} ' + ' FROM {1} ';

        List<String> whereConditions = new List<String>();
        if (invoiceNumbers != null) {
            whereConditions.add(' InvoiceNumber__c IN :invoiceNumbers ');
        }
        if (distributors != null) {
            whereConditions.add(' Distributor__c IN :distributors ');
        }
        whereConditions.add(' Status__c = :status ');
        if(!whereConditions.isEmpty()){
            query += 'WHERE ' + String.join(whereConditions, 'AND');
        }
        
        query += 'order by {2} {3} {4}';        
        return (List<Invoice__c>) Database.query(String.format(query,
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy(),
                    getLimitCondition(),
                    getOffsetCondition() } ));
    }

    public List<Invoice__c> selectByMemberIdAndInvoiceIdBetweenDates(Set<Id> invoiceIds, Id memberId, Date fromdate, Date todate){
        assertIsAccessible();
        String query = 'SELECT {0} ' + ' FROM {1} ';

        List<String> whereConditions = new List<String>();
        if (memberId != null) {
            whereConditions.add(' Member__c =: memberId ');
        }
        if( !invoiceIds.isEmpty() ) {
            whereConditions.add(' Id IN : invoiceIds ');
        }
        if(fromdate!=null){
            whereConditions.add(
                'FieloPRP__Date__c >= ' + String.format(
                    '{0}-{1}-{2}'
                    ,new List<String>{
                            String.valueOf(fromdate.year()),
                            ('0'+String.valueOf(fromdate.month())).right(2),
                            ('0'+String.valueOf(fromdate.day())).right(2)
                        }
                    )
            );
        }
        if(todate!=null){
            whereConditions.add(
                'FieloPRP__Date__c <= ' + String.format(
                    '{0}-{1}-{2}'
                    ,new List<String>{
                            String.valueOf(todate.year()),
                            ('0'+String.valueOf(todate.month())).right(2),
                            ('0'+String.valueOf(todate.day())).right(2)
                        }
                    )
            );
        }
        if(!whereConditions.isEmpty()){
            query += 'WHERE ' + String.join(whereConditions, ' AND ');
        }
        
        query += ' order by {2} {3} {4}';

        query = String.format(query,
                new List<String> {
                    getFieldListString(),
                    getSObjectName(),
                    getOrderBy(),
                    getLimitCondition(),
                    getOffsetCondition() } );

        System.debug('query'+ query);
        
        return (List<Invoice__c>) Database.query(query);
    }

    public static List<ProcessInstance> selectInvoiceApprovalProcessInstance(Set<Id> invoiceIds){
        String query = 'SELECT Id, '
                + ' (SELECT Id, StepStatus,Actor.Name, Comments FROM StepsAndWorkitems where StepStatus = \'Pending\')'
                + ' FROM ProcessInstance WHERE TargetObjectId in :invoiceIds';
        return (List<ProcessInstance>) Database.query(query);
    }
}