
{
  "Libraries" : [ {
    "Name" : "FieloPRP",
    "ruletriggers" : [ {
      "Name" : "Invoice",
      "FieloPLT__ConditionField__c" : "FieloPRP__Status__c",
      "FieloPLT__ConditionType__c" : "Text",
      "FieloPLT__ConditionValue__c" : "Approved",
      "FieloPLT__Date__c" : "CreatedDate",
      "FieloPLT__LookupFromTransaction__c" : "FieloPRP__Invoice__c",
      "FieloPLT__LookupfromTracker__c" : "FieloPRP__Invoice__c",
      "FieloPLT__Object__c" : "FieloPRP__Invoice__c",
      "actions" : [ {
        "Name" : "Invoice > FieloPRP__Member__c",
        "FieloPLT__TargetMember__c" : "FieloPRP__Member__c"
      } ]
    } ],
    "models" : [ {
      "Name" : "(Monthly) $1 -> 2P + Points by Product Family",
      "FieloPLT__Category__c" : "Miscelaneas",
      "FieloPLT__Icon__c" : "fielosf-icon-content",
      "FieloPLT__JSON__c" : "{  &quot;promotions&quot; : [ {    &quot;Name&quot; : &quot;Promotion to April&quot;,    &quot;rules&quot; : [ {      &quot;actionName&quot; : &quot;FieloPRP__Invoice__c.FieloPRP__Status__c[Approved]&gt;FieloPRP__Member__c&quot;,      &quot;pointTypeName&quot; : &quot;Point&quot;,      &quot;Name&quot; : &quot;Amount x 2&quot;,      &quot;FieloPLT__ConversionValue__c&quot; : 2.00,      &quot;FieloPLT__LogicalExpression__c&quot; : &quot;ALL&quot;,      &quot;FieloPLT__PointConversionMode__c&quot; : &quot;Multiplier&quot;,      &quot;FieloPLT__RecordFieldName__c&quot; : &quot;FieloPRP__Amount__c&quot;,      &quot;FieloPLT__RelatedList__c&quot; : &quot;FieloPRP__Invoice__c&quot;,      &quot;FieloPLT__StockControl__c&quot; : false,      &quot;FieloPLT__Type__c&quot; : &quot;No Competition&quot;    }, {      &quot;actionName&quot; : &quot;FieloPRP__Invoice__c.FieloPRP__Status__c[Approved]&gt;FieloPRP__Member__c&quot;,      &quot;pointTypeName&quot; : &quot;Point&quot;,      &quot;Name&quot; : &quot;Product Family - Qty x 10&quot;,      &quot;FieloPLT__ConversionValue__c&quot; : 10.00,      &quot;FieloPLT__LogicalExpression__c&quot; : &quot;ALL&quot;,      &quot;FieloPLT__PointConversionMode__c&quot; : &quot;Multiplier&quot;,      &quot;FieloPLT__RecordFieldName__c&quot; : &quot;FieloPRP__Quantity__c&quot;,      &quot;FieloPLT__RelatedList__c&quot; : &quot;FieloPRP__InvoiceItems__r&quot;,      &quot;FieloPLT__StockControl__c&quot; : false,      &quot;FieloPLT__Type__c&quot; : &quot;No Competition&quot;,      &quot;criteria&quot; : [ {        &quot;FieloPLT__BooleanValue__c&quot; : false,        &quot;FieloPLT__FieldName__c&quot; : &quot;FieloPRP__Product__r.Family&quot;,        &quot;FieloPLT__FieldType__c&quot; : &quot;List&quot;,        &quot;FieloPLT__IsField__c&quot; : false,        &quot;FieloPLT__Operator__c&quot; : &quot;equals&quot;,        &quot;FieloPLT__Order__c&quot; : 1,        &quot;FieloPLT__Values__c&quot; : &quot;Electricity&quot;,        &quot;FieloPLT__Description__c&quot; : &quot;FieloPRP__Product__r.Family = Electricity&quot;      } ]    } ]  } ]}",
      "FieloPLT__Type__c" : "Promotion"
    }, {
      "Name" : "$1 -> 2P (Always)",
      "FieloPLT__Category__c" : "Miscelaneas",
      "FieloPLT__Icon__c" : "fielosf-icon-content",
      "FieloPLT__JSON__c" : "{  &quot;promotions&quot; : [ {    &quot;Name&quot; : &quot;Default Promotion&quot;,    &quot;rules&quot; : [ {      &quot;actionName&quot; : &quot;FieloPRP__Invoice__c.FieloPRP__Status__c[Approved]&gt;FieloPRP__Member__c&quot;,      &quot;pointTypeName&quot; : &quot;Point&quot;,      &quot;Name&quot; : &quot;Amount x 2&quot;,      &quot;FieloPLT__ConversionValue__c&quot; : 2.00,      &quot;FieloPLT__PointConversionMode__c&quot; : &quot;Multiplier&quot;,      &quot;FieloPLT__RecordFieldName__c&quot; : &quot;FieloPRP__Amount__c&quot;,      &quot;FieloPLT__RelatedList__c&quot; : &quot;FieloPRP__Invoice__c&quot;,      &quot;FieloPLT__StockControl__c&quot; : false,      &quot;FieloPLT__Type__c&quot; : &quot;No Competition&quot;    } ]  } ]}",
      "FieloPLT__Type__c" : "Promotion"
    } ],
    "pageSettings" : [ {
      "Name" : "Program > Edit",
      "FieloPLT__Object__c" : "FieloPLT__Program__c",
      "FieloPLT__Order__c" : 2,
      "FieloPLT__Type__c" : "Edit",
      "FieloPLT__Sections__c" : "{\"Name\" : \"Invoice Settings\", \r\n\t\"Rows\" :[ \r\n\t\t[\r\n\t\t\t{\"Name\" : \"FieloPRP__RequestInvoiceAuthorization__c\" , \"Type\" : \"checkbox\" }, \r\n\t\t\t{\"Name\" : \"FieloPRP__RequestInvoiceProducts__c\" , \"Type\" : \"checkbox\" }\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\" : \"FieloPRP__ProductInjectQuery__c\" , \"Type\" : \"input\" }\r\n\t\t] \r\n\t] \r\n}"
    }, {
      "Name" : "Program > New",
      "FieloPLT__Object__c" : "FieloPLT__Program__c",
      "FieloPLT__Order__c" : 2,
      "FieloPLT__Type__c" : "New",
      "FieloPLT__Sections__c" : "{\"Name\" : \"Invoice Settings\", \r\n\t\"Rows\" :[ \r\n\t\t[\r\n\t\t\t{\"Name\" : \"FieloPRP__RequestInvoiceAuthorization__c\" , \"Type\" : \"checkbox\" }, \r\n\t\t\t{\"Name\" : \"FieloPRP__RequestInvoiceProducts__c\" , \"Type\" : \"checkbox\" }\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\" : \"FieloPRP__ProductInjectQuery__c\" , \"Type\" : \"input\" }\r\n\t\t] \r\n\t] \r\n}"
    }, {
      "Name" : "Member > Related > Invoice",
      "FieloPLT__Fieldset__c" : "[\r\n\t{ \"Name\" : \"FieloPRP__Status__c\" },\r\n\t{ \"Name\" : \"FieloPRP__Amount__c\" },\r\n        { \"Name\" : \"FieloPRP__Date__c\" }\r\n]",
      "FieloPLT__Object__c" : "FieloPLT__Member__c",
      "FieloPLT__Order__c" : 2,
      "FieloPLT__TargetField__c" : "FieloPRP__Member__c",
      "FieloPLT__TargetObject__c" : "FieloPRP__Invoice__c",
      "FieloPLT__Type__c" : "Related"
    }, {
      "Name" : "Program > Detail",
      "FieloPLT__Object__c" : "FieloPLT__Program__c",
      "FieloPLT__Order__c" : 2,
      "FieloPLT__Type__c" : "Detail",
      "FieloPLT__Sections__c" : "{\"Name\" : \"Invoice Settings\",\r\n\t\"Rows\" :[\r\n\t\t[\r\n\t\t\t{\"Name\" : \"FieloPRP__RequestInvoiceAuthorization__c\" , \"Type\" : \"input\" },\r\n            {\"Name\" : \"FieloPRP__RequestInvoiceProducts__c\" , \"Type\" : \"input\" },\r\n\t\t\t{\"Name\" : \"FieloPRP__ProductInjectQuery__c\" , \"Type\" : \"input\" }\r\n\t\t]\r\n\t]\r\n}"
    }, {
      "Name" : "Invoice > Edit",
      "FieloPLT__Fieldset__c" : "{\"Name\":\"Information\",\"Rows\":[[{\"Name\":\"FieloPRP__Member__c\",\"Type\":\"lookup\"},{\"Name\":\"FieloPRP__HasDetails__c\",\"Type\":\"checkbox\"}],[{\"Name\":\"FieloPRP__InvoiceNumber__c\",\"Type\":\"input\"}],[{\"Name\":\"FieloPRP__Amount__c\",\"Type\":\"input\"},{\"Name\":\"FieloPRP__Date__c\",\"Type\":\"input\"}],[{\"Name\":\"FieloPRP__Description__c\",\"Type\":\"input\"},{\"Name\":\"FieloPRP__Distributor__c\",\"Type\":\"lookup\"}]]}",
      "FieloPLT__Object__c" : "FieloPRP__Invoice__c",
      "FieloPLT__Type__c" : "Edit",
      "FieloPLT__Filters__c" : "[{'Rows':[[{'Name':'Name', 'Type':'input'},{'Name':'Family','Type':'picklist'},{'Name':'ProductCode','Type':'input'}]]}]",
      "FieloPLT__Sections__c" : "{\"Name\":\"Information\",\"Rows\":[[{\"Name\":\"FieloPRP__Member__c\",\"Type\":\"lookup\"},{\"Name\":\"FieloPRP__HasDetails__c\",\"Type\":\"checkbox\"}],[{\"Name\":\"FieloPRP__InvoiceNumber__c\",\"Type\":\"input\"}],[{\"Name\":\"FieloPRP__Amount__c\",\"Type\":\"input\"},{\"Name\":\"FieloPRP__Date__c\",\"Type\":\"input\"}],[{\"Name\":\"FieloPRP__Description__c\",\"Type\":\"input\"},{\"Name\":\"FieloPRP__Distributor__c\",\"Type\":\"lookup\"}]]}",
      "FieloPLT__StandardActions__c" : "Settings"
    }, {
      "Name" : "Invoice > View",
      "FieloPLT__Fieldset__c" : "{\"Name\":\"FieloPRP__Status__c\"},\r\n{\"Name\":\"FieloPRP__InvoiceNumber__c\"},\r\n{\"Name\":\"FieloPRP__Distributor__r.Name\"},\r\n{\"Name\":\"FieloPRP__Member__r.Name\"},\r\n{\"Name\":\"FieloPRP__Amount__c\"},\r\n{\"Name\":\"FieloPRP__Date__c\"},\r\n{\"Name\":\"FieloPRP__Description__c\"}",
      "FieloPLT__Object__c" : "FieloPRP__Invoice__c",
      "FieloPLT__Type__c" : "View",
      "FieloPLT__StandardActions__c" : "View;Settings",
      "FieloPLT__StandardRelated__c" : "ProcessSteps"
    }, {
      "Name" : "Invoice > Landing",
      "FieloPLT__Buttons__c" : "{'Label': 'New', 'Type': 'Modal', 'Action': 'invoiceForm' }",
      "FieloPLT__Fieldset__c" : "{\"Name\":\"FieloPRP__Member__r.Name\"},{\"Name\":\"FieloPRP__Status__c\"},{\"Name\":\"FieloPRP__Amount__c\"}",
      "FieloPLT__Object__c" : "FieloPRP__Invoice__c",
      "FieloPLT__Tools__c" : "{\"Label\": \"Products\", \"Type\": \"Link\", \"Action\": \"/01t\" }",
      "FieloPLT__Type__c" : "Landing",
      "FieloPLT__StandardActions__c" : "Settings"
    }, {
      "Name" : "Invoice > Related > Invoice Item",
      "FieloPLT__Fieldset__c" : "{'Name':'FieloPRP__Product__r.Name'},\r\n{'Name':'FieloPRP__Description__c'},\r\n{'Name':'FieloPRP__Quantity__c'},\r\n{'Name':'FieloPRP__UnitPrice__c'},\r\n{'Name':'FieloPRP__TotalPrice__c'}",
      "FieloPLT__Object__c" : "FieloPRP__Invoice__c",
      "FieloPLT__Order__c" : 0,
      "FieloPLT__TargetField__c" : "FieloPRP__Invoice__c",
      "FieloPLT__TargetObject__c" : "FieloPRP__InvoiceItem__c",
      "FieloPLT__Type__c" : "Related"
    }, {
      "Name" : "Invoice > Related > Transaction",
      "FieloPLT__Fieldset__c" : "{'Name': 'FieloPLT__IsProcessed__c'} ,{'Name': 'FieloPLT__Value__c'} ,{'Name': 'FieloPLT__Points__c'} ,{'Name': 'FieloPLT__IsReverted__c'} ,{'Name': 'CreatedDate'}",
      "FieloPLT__Object__c" : "FieloPRP__Invoice__c",
      "FieloPLT__Order__c" : 1,
      "FieloPLT__TargetField__c" : "FieloPRP__Invoice__c",
      "FieloPLT__TargetObject__c" : "FieloPLT__Transaction__c",
      "FieloPLT__Type__c" : "Related"
    }, {
      "Name" : "Invoice > New",
      "FieloPLT__Fieldset__c" : "{\"Name\":\"Information\",\"Rows\":[[{\"Name\":\"FieloPRP__Member__c\",\"Type\":\"lookup\"},{\"Name\":\"FieloPRP__HasDetails__c\",\"Type\":\"checkbox\"}],[{\"Name\":\"FieloPRP__InvoiceNumber__c\",\"Type\":\"input\"}],[{\"Name\":\"FieloPRP__Amount__c\",\"Type\":\"input\"},{\"Name\":\"FieloPRP__Date__c\",\"Type\":\"input\"}],[{\"Name\":\"FieloPRP__Description__c\",\"Type\":\"input\"},{\"Name\":\"FieloPRP__Distributor__c\",\"Type\":\"lookup\"}]]}",
      "FieloPLT__Object__c" : "FieloPRP__Invoice__c",
      "FieloPLT__Type__c" : "New",
      "FieloPLT__Filters__c" : "[{'Rows':[[{'Name':'Name', 'Type':'input'},{'Name':'Family','Type':'picklist'},{'Name':'ProductCode','Type':'input'}]]}]",
      "FieloPLT__Sections__c" : "{\"Name\":\"Information\",\"Rows\":[[{\"Name\":\"FieloPRP__Member__c\",\"Type\":\"lookup\"},{\"Name\":\"FieloPRP__HasDetails__c\",\"Type\":\"checkbox\"}],[{\"Name\":\"FieloPRP__InvoiceNumber__c\",\"Type\":\"input\"}],[{\"Name\":\"FieloPRP__Amount__c\",\"Type\":\"input\"},{\"Name\":\"FieloPRP__Date__c\",\"Type\":\"input\"}],[{\"Name\":\"FieloPRP__Description__c\",\"Type\":\"input\"},{\"Name\":\"FieloPRP__Distributor__c\",\"Type\":\"lookup\"}]]}",
      "FieloPLT__StandardActions__c" : "Settings"
    } ]
  } ]
}