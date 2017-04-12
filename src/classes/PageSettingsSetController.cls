// TODO: Ver que pasa cuando hay registros para un program y registros sin program
public with sharing abstract class PageSettingsSetController {
    private String objectName { get; set; }
    private Map<ID, Schema.RecordTypeInfo> mapRecordTypes { get; set; } 

/* Para los page settings de una landing */
    private FieloPLT__PageSettings__c newPS {get;set;}
    private FieloPLT__PageSettings__c landingPS {get;set;}

    public Boolean getHasNewForm () {
        return newPS != null && newPS.FieloPLT__Fieldset__c != '';
    }
    public void addNewFieldSet( String fieldset ) {
        if ( !String.isBlank( newPS.FieloPLT__Fieldset__c)  ) {
            newPS.FieloPLT__Fieldset__c += ',';
        }
        newPS.FieloPLT__Fieldset__c += fieldset;      
    }
    public FieloPLT__PageSettings__c newSettings { get {
        if ( newSettings == null ) {
            if ( !String.isBlank(newPS.FieloPLT__Fieldset__c) ) {         
                newPS.FieloPLT__Fieldset__c = '[' + PageSettingsController.replaceFormula( newPS.FieloPLT__Fieldset__c, null ) + ']';
            }
            newSettings = newPS;
        }
        return newSettings;
    } set; }

    public FieloPLT__PageSettings__c landingSettings { get {
        if ( landingSettings == null ) {
            if ( !String.isBlank(landingPS.FieloPLT__Fieldset__c) ) {
                landingPS.FieloPLT__Fieldset__c = '[' + landingPS.FieloPLT__Fieldset__c + ']';
                // TODO: Ver si los fieldset de landing necesitan   
            }
            if ( !String.isBlank(landingPS.FieloPLT__Buttons__c) ) {
                landingPS.FieloPLT__Buttons__c =   '[' +  PageSettingsController.replaceFormula(  landingPS.FieloPLT__Buttons__c , null) + ']'; 
            }
            if ( !String.isBlank(landingPS.FieloPLT__Tools__c) ) {
                landingPS.FieloPLT__Tools__c =   '[' + PageSettingsController.replaceFormula( landingPS.FieloPLT__Tools__c , null) + ']'; 
            }
            
            landingSettings = landingPS;
        }
        return landingSettings;
    } set; }

/* 
    Constructor para las Landings
*/
    public void initPageSettings( String objectName, String standardButtons, String standardTools   ) {
        this.objectName = objectName;
        //this.mapRecordTypes = PageSettingsController.getMapRecordTypes(objectName);

        List<String> recordTypeNames = new List<String>();
        //for ( Schema.RecordTypeInfo r : mapRecordTypes.values() ) {
        //  if ( !r.isMaster() && r.isAvailable() ) {
        //      recordTypeNames.add(r.getName());
        //  }
        //}

        List<FieloPLT__PageSettings__c> settings =  PageSettingsController.getPageSettings( new List<String>{ 'Edit', 'New', 'Landing' }, recordTypeNames, objectName );

        newPS = new FieloPLT__PageSettings__c( FieloPLT__Fieldset__c = '', FieloPLT__Object__c = objectName );
        FieloPLT__PageSettings__c editPS = new FieloPLT__PageSettings__c( FieloPLT__Fieldset__c = '', FieloPLT__Object__c = objectName );

        if(standardButtons == null){
            standardButtons = '';
        }
        if(standardTools == null){
            standardTools = '';
        }
        landingPS = new FieloPLT__PageSettings__c( FieloPLT__Fieldset__c = '', FieloPLT__Buttons__c = standardButtons, FieloPLT__Tools__c = standardTools, FieloPLT__StandardActions__c = 'New');
        Boolean noEdit = true;
        Boolean noNew = true;
        for ( FieloPLT__PageSettings__c p : settings ) {
            if ( p.FieloPLT__Type__c == 'New' ) {
                noNew = false;
                noEdit = false;
                if ( ! String.isBlank(p.FieloPLT__Fieldset__c) ) {
                    newPS.FieloPLT__Fieldset__c += (newPS.FieloPLT__Fieldset__c == '' ) ? p.FieloPLT__Fieldset__c : ',' + p.FieloPLT__Fieldset__c;
                }
            } else if ( p.FieloPLT__Type__c == 'Edit' ) {
                noEdit = false;
                if ( ! String.isBlank(p.FieloPLT__Fieldset__c) ) {
                    editPS.FieloPLT__Fieldset__c += (editPS.FieloPLT__Fieldset__c == '' ) ? p.FieloPLT__Fieldset__c : ',' + p.FieloPLT__Fieldset__c;
                }
            } else {                
                if ( ! String.isBlank(p.FieloPLT__Fieldset__c) ) {
                    landingPS.FieloPLT__Fieldset__c += (landingPS.FieloPLT__Fieldset__c == '' ) ? p.FieloPLT__Fieldset__c : ',' + p.FieloPLT__Fieldset__c;
                }
                if ( ! String.isBlank(p.FieloPLT__Buttons__c) ) {
                    landingPS.FieloPLT__Buttons__c += (landingPS.FieloPLT__Buttons__c == '' ) ? p.FieloPLT__Buttons__c : ',' + p.FieloPLT__Buttons__c;
                }
                if ( ! String.isBlank(p.FieloPLT__Tools__c ) ) {
                    landingPS.FieloPLT__Tools__c += (landingPS.FieloPLT__Tools__c == '' ) ? p.FieloPLT__Tools__c : ',' + p.FieloPLT__Tools__c;
                }
                landingPS.FieloPLT__StandardActions__c = p.FieloPLT__StandardActions__c;
            }
        }
        if ( noNew ) {
            newPS = editPS;
        }
        if ( ! String.isBlank( landingPS.FieloPLT__StandardActions__c )  ) {
            Set<String> opciones = new Set<String>();
            opciones.addAll( landingPS.FieloPLT__StandardActions__c.split(';') );

            if ( opciones.contains('New') ){
                if ( noEdit ) {
                    landingPS.FieloPLT__Buttons__c = '{"Label": "' + Label.New + '", "Type": "Action", "Action": "New", "ObjectName" : "' + objectName + '" }' + (String.isBlank(landingPS.FieloPLT__Buttons__c)?'':',') + landingPS.FieloPLT__Buttons__c;
                } else {
                    landingPS.FieloPLT__Buttons__c = '{"Label": "' + Label.New + '", "Type": "Modal", "Action": "' + objectName + 'Form" }' + (String.isBlank(landingPS.FieloPLT__Buttons__c)?'':',') + landingPS.FieloPLT__Buttons__c;
                }               
            }
        }    
    }
}