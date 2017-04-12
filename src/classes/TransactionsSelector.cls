public class TransactionsSelector extends SObjectSelector{

	public List<Schema.SObjectField> getSObjectFieldList(){
		return new List<Schema.SObjectField> {
				FieloPLT__Transaction__c.Id,
				FieloPLT__Transaction__c.FieloPLT__Date__c,
				FieloPLT__Transaction__c.FieloPLT__Action__c,
                FieloPLT__Transaction__c.FieloPLT__IsReverted__c
			};
	}

	public TransactionsSelector(Set<String> fields){
		super(fields);
	}

	public TransactionsSelector(){
		super();
	}

	public Schema.SObjectType getSObjectType(){
		return FieloPLT__Transaction__c.sObjectType;
	}

	public List<FieloPLT__Transaction__c> selectById(Set<ID> idSet){
		return (List<FieloPLT__Transaction__c>) selectSObjectsById(idSet);
	}

    public List<FieloPLT__Transaction__c> selectByInvoiceIdAndNotReverted(Set<Id> invoiceIds ){
        return (List<FieloPLT__Transaction__c>) Database.query(
                String.format(
                'SELECT {0} ' +
                  'FROM {1} ' +
                  'WHERE FieloPRP__Invoice__c In : invoiceIds AND FieloPLT__IsReverted__c=false',
                new List<String> {
                    getFieldListString(),
                    getSObjectName()}));
    }
}