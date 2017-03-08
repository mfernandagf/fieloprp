trigger InvoiceItems on FieloPRP__InvoiceItem__c (before insert, after insert, before update, after update, before delete, after delete) {
	SObjectDomain.triggerHandler(InvoiceItems.class);
}