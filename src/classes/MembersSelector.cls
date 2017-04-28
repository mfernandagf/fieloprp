public class MembersSelector extends SObjectSelector{

    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                FieloPLT__Member__c.Id,
                FieloPLT__Member__c.Name
            };
    }

    public MembersSelector(Set<String> fields){
        super(fields);
    }

    public MembersSelector(){
        super();
    }

    public Schema.SObjectType getSObjectType(){
        return FieloPLT__Member__c.sObjectType;
    }

    public List<FieloPLT__Member__c> selectById(Set<Id> memberIds){
        return (List<FieloPLT__Member__c>) selectSObjectsById(memberIds);
    }

    public List<FieloPLT__Member__c> selectByIdAndProgramWithDetailedInvoiceFalse(Set<Id> memberIds){

        String soqlString = String.format(
            'select {0} ' +
            'from {1} ' +
            'where Id In: memberIds ' +
            'and FieloPLT__Program__r.RequestInvoiceProducts__c = false ' + 
            'order by {2}',
            new List<String> {
            getFieldListString(),
            getSObjectName(),
            getOrderBy() } );
        
        return (List<FieloPLT__Member__c>) Database.query( soqlString );
    }
}