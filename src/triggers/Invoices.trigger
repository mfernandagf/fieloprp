trigger Invoices on FieloPRP__Invoice__c (before insert, after insert, before update, after update, before delete) {
   SObjectDomain.triggerHandler(Invoices.class);
}