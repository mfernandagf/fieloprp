// TODO: Ver que pasa cuando hay registros para un program y registros sin program
public with sharing abstract class PageSettingsController {
	private String objectName { get; set; }
	private Map<ID, Schema.RecordTypeInfo> mapRecordTypes { get; set; }	

/* Para los page settings de un view */
	private SObject record { get; set; }
	private List<FieloPLT__PageSettings__c> relatedPS {get;set;}
	private List<FieloPLT__PageSettings__c> relatedFormsPS {get;set;}
	private FieloPLT__PageSettings__c editPS {get;set;}
	private FieloPLT__PageSettings__c viewPS {get;set;}
	private FieloPLT__PageSettings__c detailPS {get;set;}


	public Boolean getHasEditForm () {
		return editPS != null && editPS.FieloPLT__Fieldset__c != '';
	}

/* 
	Constructor para los Views
*/
	public void setRecord( SObject r ) { 
		this.record = r;		
	}

	public Set<String> fieldList { get {
		if ( fieldList == null ) {
			fieldList = new Set<String>();
			if ( !String.isBlank(viewPS.FieloPLT__Fieldset__c) ) {
				for ( BackendHeaderRecordController.HeaderColumn c:  (List<BackendHeaderRecordController.HeaderColumn>)JSON.deserialize( '[' + viewPS.FieloPLT__Fieldset__c + ']', List<BackendHeaderRecordController.HeaderColumn>.class ) ) {
					fieldList.add(c.Name );
				}
			}
			if ( !String.isBlank(detailPS.FieloPLT__Fieldset__c) ) {
				for ( FormController.Section s:  (List<FormController.Section>) JSON.deserialize( '[' + detailPS.FieloPLT__Fieldset__c + ']', List<FormController.Section>.class ) ) {
		          for ( List<FormController.FormField> r :s.rows ) {
		            for ( FormController.FormField f :r ) {
		              if ( !String.isBlank(f.Name) ) {
		              	fieldList.add(f.Name );
		              }
		            }
		          }
				}
			}
		}
		return fieldList;
	} set ;}

	public List<FieloPLT__PageSettings__c> related { get {
		if ( related == null ) {
			related = relatedPS;
		}
		return relatedPS;
	} set; }
	public List<FieloPLT__PageSettings__c> relatedForms { get {
		if ( relatedForms == null ) {
			relatedForms = relatedFormsPS;
		}
		return relatedFormsPS;

	} set; }
	public FieloPLT__PageSettings__c edit { get {
		if ( edit == null ) {
			// Quita la primer , que concatena los settings
			if ( !String.isBlank(editPS.FieloPLT__Fieldset__c) ) {
				editPS.FieloPLT__Fieldset__c = '[' + PageSettingsController.replaceFormula( editPS.FieloPLT__Fieldset__c, record ) + ']';
			}
			
			edit = editPS;
		}
		return editPS;

	} set; }
	public FieloPLT__PageSettings__c view { get {
		if ( view == null ) {
			if ( !String.isBlank(viewPS.FieloPLT__Fieldset__c) ) {
				viewPS.FieloPLT__Fieldset__c = '[' + PageSettingsController.replaceFormula( viewPS.FieloPLT__Fieldset__c, record ) + ']';
			}
			if ( !String.isBlank(viewPS.FieloPLT__Buttons__c) ) {
				viewPS.FieloPLT__Buttons__c =  '[' + PageSettingsController.replaceFormula(  viewPS.FieloPLT__Buttons__c, record) + ']';
			}
			if ( !String.isBlank(viewPS.FieloPLT__Tools__c) ) {
				viewPS.FieloPLT__Tools__c =  '[' + PageSettingsController.replaceFormula( viewPS.FieloPLT__Tools__c, record) + ']';
			}
			view = viewPS;
		}
		return viewPS;

	} set; }
	public FieloPLT__PageSettings__c detail{ get {
		if ( detail == null ) {
			if ( !String.isBlank(detailPS.FieloPLT__Fieldset__c) ) {
				detailPS.FieloPLT__Fieldset__c = '[' + PageSettingsController.replaceFormula( detailPS.FieloPLT__Fieldset__c/*.substring(1)*/, record ) + ']';
			}
			detail = detailPS;
		}
		return detailPS;

	} set; }

	public void initPageSettings( String objectName, SObject record, String standardButtons, String standardTools  ) {
		this.objectName = objectName;
		this.mapRecordTypes = SObjectDescribe.getMapRecordTypes(objectName);
		this.record = record;
		// 
		List<String> recordTypeNames = new List<String>();
		Id recordTypeId;
		try {
			recordTypeId = (Id)record.get('recordTypeId');			
		} catch ( Exception e) {}
		if ( recordTypeId != null ) {
  			recordTypeNames.add( mapRecordTypes.get(recordTypeId).getName() );
		}			
		List<FieloPLT__PageSettings__c> settings =  PageSettingsController.getPageSettings( new List<String>{ 'Edit', 'Related', 'View', 'Detail' }, recordTypeNames, objectName );

		if(standardButtons == null){
			standardButtons = '';
		}
		if(standardTools == null){
			standardTools = '';
		}
		Boolean noEdit = true;
		relatedPS = new List<FieloPLT__PageSettings__c>();
		editPS = new FieloPLT__PageSettings__c( FieloPLT__Fieldset__c = '', FieloPLT__Buttons__c = '', FieloPLT__Tools__c = '');
		detailPS = new FieloPLT__PageSettings__c( FieloPLT__Fieldset__c = '', FieloPLT__Buttons__c = '', FieloPLT__Tools__c = '');
		viewPS = new FieloPLT__PageSettings__c( FieloPLT__Fieldset__c = '', FieloPLT__Buttons__c = standardButtons, FieloPLT__Tools__c = standardTools);

		Set<String> relatedObjects = new Set<String>();
		String viewActions = '';
		// Por Performance dividimos la logica entre los que tienen Recordtype y los que no
		if ( recordTypeId != null ) {
			Map<String, Boolean> skipDefault = new Map<String, Boolean>();

			for ( FieloPLT__PageSettings__c p : settings ) {
				if ( !skipDefault.containsKey( p.FieloPLT__Type__c) ) {
					skipDefault.put(p.FieloPLT__Type__c, !String.isBlank(p.FieloPLT__RecordType__c) );
				}
			    if ( !String.isBlank(p.FieloPLT__RecordType__c) || !skipDefault.get(p.FieloPLT__Type__c) ) {
					if ( p.FieloPLT__Type__c == 'Related' ) {
						if ( ! String.isBlank( p.FieloPLT__StandardActions__c )  ) {
							relatedObjects.add(p.FieloPLT__TargetObject__c);
						}
			        	relatedPS.add(p);
					} else if ( p.FieloPLT__Type__c == 'Edit'  ) {
						noEdit = false; 
						if ( p.FieloPLT__Fieldset__c != null ) {
							editPS.FieloPLT__Fieldset__c += (editPS.FieloPLT__Fieldset__c == '') ? p.FieloPLT__Fieldset__c : ',' + p.FieloPLT__Fieldset__c;
						}				
					} else if ( p.FieloPLT__Type__c == 'Detail'  ) {			
						if ( ! String.isBlank(p.FieloPLT__Fieldset__c )  ) {
							detailPS.FieloPLT__Fieldset__c += (detailPS.FieloPLT__Fieldset__c == '') ? p.FieloPLT__Fieldset__c : ',' + p.FieloPLT__Fieldset__c;
						}			
					} else {
						if ( ! String.isBlank( p.FieloPLT__StandardActions__c )  ) {
							viewActions = p.FieloPLT__StandardActions__c;
						}												
						if ( ! String.isBlank(p.FieloPLT__Fieldset__c ) ) {
							viewPS.FieloPLT__Fieldset__c += (viewPS.FieloPLT__Fieldset__c == '') ? p.FieloPLT__Fieldset__c : ',' + p.FieloPLT__Fieldset__c;
						}
						if ( ! String.isBlank(p.FieloPLT__Buttons__c) ) {
							viewPS.FieloPLT__Buttons__c += (viewPS.FieloPLT__Buttons__c == '' ) ? p.FieloPLT__Buttons__c : ',' + p.FieloPLT__Buttons__c;
						}
						if ( ! String.isBlank(p.FieloPLT__Tools__c)  ) {
							viewPS.FieloPLT__Tools__c += (viewPS.FieloPLT__Tools__c == '') ? p.FieloPLT__Tools__c : ',' + p.FieloPLT__Tools__c;
						}
					}
			    }
			}

		} else {
			for ( FieloPLT__PageSettings__c p : settings ) {
				if ( p.FieloPLT__Type__c == 'Related' ) {
					if ( ! String.isBlank( p.FieloPLT__StandardActions__c )  ) {
						relatedObjects.add(p.FieloPLT__TargetObject__c);
					}

		        	relatedPS.add(p);
				} else if ( p.FieloPLT__Type__c == 'Edit'  ) {
					if ( ! String.isBlank(p.FieloPLT__Fieldset__c) ) {
						noEdit = false;						
						editPS.FieloPLT__Fieldset__c += (editPS.FieloPLT__Fieldset__c == '') ? p.FieloPLT__Fieldset__c : ',' + p.FieloPLT__Fieldset__c;
					}			
				} else if ( p.FieloPLT__Type__c == 'Detail'  ) {
					if ( ! String.isBlank(p.FieloPLT__Fieldset__c) ) {
						detailPS.FieloPLT__Fieldset__c += (detailPS.FieloPLT__Fieldset__c == '') ? p.FieloPLT__Fieldset__c : ',' + p.FieloPLT__Fieldset__c; 
					}				
				} else {
					if ( ! String.isBlank( p.FieloPLT__StandardActions__c )  ) {
						viewActions = p.FieloPLT__StandardActions__c;
					}
					if ( ! String.isBlank(p.FieloPLT__Fieldset__c) ) {
						viewPS.FieloPLT__Fieldset__c += (viewPS.FieloPLT__Fieldset__c == '') ? p.FieloPLT__Fieldset__c : ',' + p.FieloPLT__Fieldset__c;
					}
					if ( ! String.isBlank(p.FieloPLT__Buttons__c)  ) {
						viewPS.FieloPLT__Buttons__c += (viewPS.FieloPLT__Buttons__c == '') ? p.FieloPLT__Buttons__c : ',' + p.FieloPLT__Buttons__c;
					}
					if ( ! String.isBlank(p.FieloPLT__Tools__c) ) {
						viewPS.FieloPLT__Tools__c += (viewPS.FieloPLT__Tools__c == '') ? p.FieloPLT__Tools__c : ',' + p.FieloPLT__Tools__c;
					}
				}
			}
		}
		// Reemplaza las formulas y agrega las standard actions en las related
		if ( relatedPS.size() > 0 ) {			
			// Busca si Hay PageSettings Edit de los objetos en caso positivo mete el form
			Map<String, FieloPLT__PageSettings__c> mapForms = new Map<String, FieloPLT__PageSettings__c>();

			if ( relatedObjects.size() > 0 ) {
				List<FieloPLT__PageSettings__c> forms = getRelatedForms( relatedObjects );
				if ( forms.size() > 0 ) {
					for ( FieloPLT__PageSettings__c p : forms ) {
						if ( mapForms.containsKey(p.FieloPLT__Object__c) ) {
							FieloPLT__PageSettings__c m = mapForms.get(p.FieloPLT__Object__c);
							m.FieloPLT__Fieldset__c += ',' + p.FieloPLT__Fieldset__c;
						} else {
							mapForms.put(p.FieloPLT__Object__c, p );
						}
					}
					this.relatedFormsPS = mapForms.values();					
				}
			}
			// Buscar si hay formularios de los relatedObjects
			for ( FieloPLT__PageSettings__c r : relatedPS ) {
				if ( !String.isBlank(r.FieloPLT__Buttons__c) ) {
					r.FieloPLT__Buttons__c = PageSettingsController.replaceFormula( r.FieloPLT__Buttons__c , record); 
				}
				if ( !String.isBlank(r.FieloPLT__Tools__c) ) {
					r.FieloPLT__Tools__c =  PageSettingsController.replaceFormula( r.FieloPLT__Tools__c , record); 
				}
				if ( !String.isBlank(r.FieloPLT__Actions__c) ) {
					r.FieloPLT__Actions__c =  PageSettingsController.replaceFormula( r.FieloPLT__Actions__c , record); 
				}
				if ( !String.isBlank(r.FieloPLT__StandardActions__c) ) {
					Set<String> opciones = new Set<String>();
					opciones.addAll( r.FieloPLT__StandardActions__c.split(';') );

					if ( opciones.contains('New') ){
						if ( mapForms.containsKey(r.FieloPLT__TargetObject__c) ) {
							r.FieloPLT__Buttons__c = '{"Label": "' + Label.New + '", "Type": "Modal", "Action": "' + r.FieloPLT__TargetObject__c + 'Form" }' + (String.isBlank(r.FieloPLT__Buttons__c)?'':','+ r.FieloPLT__Buttons__c);
						} else {							
							r.FieloPLT__Buttons__c = '{"Label": "' + Label.New + '", "Type": "Action", "Action": "New", "ObjectName" : "' + r.FieloPLT__TargetObject__c + '" }' + (String.isBlank(r.FieloPLT__Buttons__c)?'':',' + r.FieloPLT__Buttons__c) ;
						}
					}
					if ( opciones.contains('Edit') ){
						if ( mapForms.containsKey(r.FieloPLT__TargetObject__c) ) {
							r.FieloPLT__Actions__c = '{"Label": "' + Label.Edit + '", "Type": "Modal", "Action": "' + r.FieloPLT__TargetObject__c + 'Form" }' + (String.isBlank(r.FieloPLT__Actions__c)?'':',' + r.FieloPLT__Actions__c) ;
						} else {
							r.FieloPLT__Actions__c = '{"Label": "' + Label.Edit + '", "Type": "Action", "Action": "Edit", "ObjectName" : "' + r.FieloPLT__TargetObject__c + '" }' + (String.isBlank(r.FieloPLT__Actions__c)?'':',' + r.FieloPLT__Actions__c);
						}
					}
					if ( opciones.contains('Delete') ){
						r.FieloPLT__Actions__c = '{"Label": "' + Label.Delete + '", "Type": "Remote", "Action": "FieloPLT.RelatedListController.deleteRecord", "Confirm":true }' + (String.isBlank(r.FieloPLT__Actions__c)?'':',' + r.FieloPLT__Actions__c) ;
						//r.FieloPLT__Actions__c = '{"Label": "' + Label.Delete + '", "Type": "Action", "Action": "Delete", "ObjectName" : "' + r.FieloPLT__TargetObject__c + '" }' + (String.isBlank(r.FieloPLT__Actions__c)?'':',') + r.FieloPLT__Actions__c;
					}									
				}
				// TODO: Ver si los fieldset de related necesitan
				//if ( !String.isBlank(settings.FieloPLT__Fieldset__c) ) {
				//	settings.FieloPLT__Fieldset__c = PageSettingsController.replaceFormula( settings.FieloPLT__Fieldset__c, record );
				//}
			}			
		}

		if ( !String.isBlank(viewActions) ) {
			Set<String> opciones = new Set<String>();
			opciones.addAll( viewActions.split(';') );

			if ( opciones.contains('Edit') ){
				if ( opciones.contains('Edit') ){
					if ( noEdit ) {
						viewPS.FieloPLT__Buttons__c = '{"Label": "' + Label.Edit + '", "Type": "Action", "Action": "Edit", "ObjectName" : "' + objectName + '" }' + (String.isBlank(viewPS.FieloPLT__Buttons__c)?'':',') + viewPS.FieloPLT__Buttons__c;
					} else {
						viewPS.FieloPLT__Buttons__c = '{"Label": "' + Label.Edit + '", "Type": "Modal", "Action": "' + objectName + 'Form" }' + (String.isBlank(viewPS.FieloPLT__Buttons__c)?'':',') + viewPS.FieloPLT__Buttons__c;
					}				
				}
			}
			if ( opciones.contains('Delete') ){
				//viewPS.FieloPLT__Tools__c = '{"Label": "' + Label.Delete + '", "CssClass": "slds-button--destructive fielosf-button__delete", "Confirm": true, "Type": "Remote", "Action": "FieloPLT.BackendHeaderRecordController.deleteRecord", "Parameters":"{ \'RetUrl\':\'/\' }" }' + (String.isBlank(viewPS.FieloPLT__Tools__c)?'':',') + viewPS.FieloPLT__Tools__c;
				viewPS.FieloPLT__Tools__c = '{"Label": "' + Label.Delete + '", "CssClass": "slds-button--destructive fielosf-button__delete", "Confirm": true, "Type": "Action", "Action": "Delete", "ObjectName" : "' + objectName + '" }' + (String.isBlank(viewPS.FieloPLT__Tools__c)?'':',') + viewPS.FieloPLT__Tools__c;
			}								
		}
	}


/***** METODOS DE SOPORTE *****/
	private List<FieloPLT__PageSettings__c> getRelatedForms( Set<String> objects ) {
        Id programId = ProgramService.getActiveProgram().Id;
        
        String query = 'SELECT FieloPLT__StandardActions__c, FieloPLT__Object__c, FieloPLT__Fieldset__c FROM FieloPLT__PageSettings__c ';
        // WHERE CONDITION 
        query += ' WHERE FieloPLT__isActive__c = true AND FieloPLT__Type__c = \'Edit\' AND FieloPLT__Object__c IN :objects AND ( FieloPLT__Program__c =: programId OR FieloPLT__Program__c = null )  ';

        // ORDER BY & LIMIT 
        query += ' AND FieloPLT__RecordType__c = null ORDER BY FieloPLT__Object__c, FieloPLT__Order__c LIMIT 100 ';         	
        return Database.query(query);        
    }   

/***** METODOS STATICOS DE SOPORTE *****/
	private static Map<String, String> mapLabels { get; set; }

    private static String translateLabel(String labelName ){ 
    	String labelValue;

    	if ( PageSettingsController.mapLabels == null ) {
    		PageSettingsController.mapLabels = new Map<String, String> { 'Edit' => Label.Edit, 'Delete' => Label.Delete, 'New' => Label.New };    		
    	}

    	if ( PageSettingsController.mapLabels.containsKey(labelName) ) {
    		labelValue =  PageSettingsController.mapLabels.get(labelName);
    	} else {
    		try {
				Component.Apex.OutputText output;
				output = new Component.Apex.OutputText();
				output.expressions.value = '{!$Label.' + labelName + '}';
				labelValue = string.valueOf(output.value);
    		} catch (Exception e) {}
			PageSettingsController.mapLabels.put( labelName, labelValue );    			
    	}
    	return labelValue;
    }
    
    public static String replaceFormula(String json , SObject record) { 
    	Pattern formulaRegEx = Pattern.compile('\\{\\!record.([a-z|A-Z|0-9].*?)\\}');
    	Pattern labelRegEx = Pattern.compile('\\{\\!\\$[Ll]abel.([a-z|A-Z|0-9].*?)\\}');
        if (  !String.isBlank(json) ) {
        	if ( record != null ) {
				Matcher m = formulaRegEx.matcher(json);

				// Usa un set en caso que se repita
				Set<String> apiNames = new Set<String>();
				while (m.find()) {
				    String formula = m.group();
				    String apiName = formula.substring(9,formula.length()-1);
				    if ( !apiNames.contains(apiName) ) {
		                if(record.get(apiName) != null){
		                    json = json.replace(formula, String.valueOf(record.get(apiName)));
		                } else {
		                    json = json.replace(formula, '');
		                }
				    	apiNames.add(apiName);
				    }
				}
			}
			Matcher ml = labelRegEx.matcher(json);
			// Usa un set en caso que se repita
			Set<String> labelNames = new Set<String>();
			while (ml.find()) {
			    String formula = ml.group();
			    String labelName = formula.substring(9,formula.length()-1);
			    if ( !labelNames.contains(labelName) ) {
                    json = json.replace(formula, translateLabel( labelName ) );
			    	labelNames.add(labelName);
			    }
			}

        }
        return json;
    }


	public static List<FieloPLT__PageSettings__c> getPageSettings( List<String> settingType, List<String> recordTypes, String objectName ) {
        Id programId = ProgramService.getActiveProgram().Id;
        
        String query = 'SELECT FieloPLT__StandardActions__c, FieloPLT__Type__c, FieloPLT__RecordType__c, FieloPLT__Fieldset__c, FieloPLT__TargetObject__c, FieloPLT__TargetField__c, FieloPLT__Tools__c, FieloPLT__Buttons__c, FieloPLT__Actions__c FROM FieloPLT__PageSettings__c ';
        // WHERE CONDITION 
        query += ' WHERE FieloPLT__isActive__c = true AND FieloPLT__Type__c IN :settingType  AND FieloPLT__Object__c = :objectName AND ( FieloPLT__Program__c =: programId OR FieloPLT__Program__c = null )  ';

        if ( recordTypes.isEmpty() ) {
	        // ORDER BY & LIMIT 
	        query += ' AND FieloPLT__RecordType__c = null ORDER BY FieloPLT__Type__c, FieloPLT__Order__c LIMIT 100 ';         	
        } else {
            query += 'AND ( FieloPLT__RecordType__c IN :recordTypes  OR FieloPLT__RecordType__c = null )';
	        // ORDER BY & LIMIT 
	        query += ' ORDER BY FieloPLT__Type__c, FieloPLT__RecordType__c, FieloPLT__Order__c LIMIT 100 ';         	
        }
        return Database.query(query);        
    }

}