public with sharing class RecentRecordsController {
    
  /***** Header fields  ******/  
    public String cFieldset{get;set;}
    public String cNameField{get;set;}
    
    public class HeaderColumn {
      public String Type{get;set;}
      public String Name{get;set;}
      public String Label{get;set;}
    }

  private Map<String, Schema.SObjectField> objectFieldMap { get {
    if ( objectFieldMap == null && !String.isBlank(csObjectName) ) {
      Schema.DescribeSObjectResult[] describeObjects = Schema.describeSObjects(  new List<String>{csObjectName} );
      if ( describeObjects.size() > 0 ) {
        objectFieldMap = describeObjects.get(0).fields.getMap();
      }
    }
    return objectFieldMap;
  } set;}

    public List<HeaderColumn> fields { get {
        if ( fields == null ) {
          if ( !String.isBlank(cFieldset)  ) {
            // Si empieza con [ es un valor seteado en una visual force => lo tiene que modificar para que sea json
            if ( !cFieldset.startsWith('[') ) {
              cFieldset = '[' + cFieldset.replace('\'', '"') + ']';
            }
			
            System.debug('cFieldset: ' + cFieldset);
              
            fields = (List<HeaderColumn>) JSON.deserialize( cFieldset, List<HeaderColumn>.class );

            // Rellenar los Labels y Types Nulos
            if ( objectFieldMap != null ) {
              for ( HeaderColumn c: fields ) {
                String apiName = c.Name.indexOf('__r') > 0 ? c.Name.substring(0, c.Name.indexOf('__r') ) + '__c' : c.Name;
                if ( objectFieldMap.containsKey(apiName) && ( c.Label == null || c.Type == null) ) {
                  Schema.DescribeFieldResult fieldDescribe = objectFieldMap.get(apiName).getDescribe();              
                  if ( c.Label == null ) {
                    c.Label = fieldDescribe.getLabel();
                  }
                  if ( c.Type == null ) {
                    c.Type = fieldDescribe.getType().name();
                  }              
                }
              }
            }


          } else {
            fields = new List<HeaderColumn>();
          }
        }
        return fields;
      } set;
    } 

    public String fieldsetString { get {
        if ( fieldsetString == null) {
          fieldsetString = cNameField;
          for ( HeaderColumn c :fields ){
            if ( c.Name != cNameField ) {
              fieldsetString += ','  + c.Name;
            }
          }
        }
        return fieldsetString;
      } set;
    }
    
  /***** Query Datos  ******/  
    public String csObjectName {get; set;}
    public Integer cRecordsPerPage {get; set;}
    public String orderBy {get; set;}  
    public String cDataFilters {get; set;}  
    
    private static String getWhereCondition( String filterJson ) {
      String whereCondition = '';
      if(filterJson != null && filterJson != '{}'){        
        Map<String,Object> filter = (Map<String, Object>) JSON.deserializeUntyped( filterJson);
        for ( String k :filter.keySet() ) {
          String value = (String) filter.get(k);
          if ( value.startsWith('!') ) {
            whereCondition += ' AND ' + k + ' <> \'' +  value.substring(1) + '\'';            
          } else {
            whereCondition += ' AND ' + k + ' = \'' +  value + '\'';
          }
        }
        whereCondition = ' WHERE ' + whereCondition.substring(4);
      }
      return whereCondition;
    }

    @RemoteAction
    public static List<SObject> getRecords( String objectName, String fields, Integer offset, String orderBy, String dataFilters, Integer recordsPerPage ) {

        String query = 'SELECT Id, ' + fields;
        query += ' FROM ' + objectName;
        query += getWhereCondition( dataFilters ); 
        // ORDER BY       
        if ( orderBy == null ) {
            orderBy = 'LastModifiedDate DESC';
        }
        query += ' ORDER BY '+ orderBy; //DESC
        // LIMIT & OFFSET
        if ( recordsPerPage == null ) {
            recordsPerPage = 10;
        }
        query += ' LIMIT '+ String.valueOf(recordsPerPage);
        if ( offset != null ){
          query += ' OFFSET '+ String.valueOf(offset);
        }
        system.debug('query: '+query);

        return Database.query(query);
    }

    public List<sObject> recentRecords { get {
      if ( recentRecords == null ) {
        if ( !String.isBlank(cDataFilters) ) {
          cDataFilters = cDataFilters.replace('\'', '"'); 
        }

        recentRecords = getRecords(  csObjectName,  fieldsetString, 0,  orderBy,  cDataFilters,  cRecordsPerPage );
      }
      return recentRecords;
    } set; }    
}