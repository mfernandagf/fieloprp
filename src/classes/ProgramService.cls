/**
 * @brief      API para la seccion de datos de transactions
 * @details    La API contiene metodos estaticos para realizar pedidos de datos sobre transactions
 */
public with sharing class ProgramService {

    private static Map<Id, Program__c> programMap;
    private static Boolean isSingleProgram;
    public static Id singleProgramId;

    public static void createFromModel( Program__c record, Id modelId ){
        if ( !String.isBlank(modelId ) ) {
            SavePoint sp;
            try {
                Model__c selectModel = [SELECT Id, Icon__c, Name, Description__c, JSON__c, Type__c, Category__c FROM Model__c WHERE Type__c = 'Program' AND ID = :modelId ];
                List<ExportService.MultiSegmentRelation> multiSegmentRelations = new List<ExportService.MultiSegmentRelation>();
                SObjectUnitOfWork uow = ExportService.importData( selectModel.JSON__c, multiSegmentRelations);

            // Si no vienen programs da un error, sino le setea el name a la primera
                if ( uow.m_newListByType.containsKey('FieloPLT__Program__c') ) {
                    List<Program__c> programs = (List<Program__c>) uow.m_newListByType.get('FieloPLT__Program__c');
                    if ( programs.size() > 0 ) {
                        programs.get(0).Name = record.Name ;

                        ExportService.saveData(uow, multiSegmentRelations);
                    } else {
                        throw new FieloException ('The model is empty' );
                    }
                } else {
                    throw new FieloException ('The model is empty' );
                }

            } catch (Exception e ) {
                if(sp != null) {
                    Database.rollback(sp);
                }
                throw new FieloException (e.getMessage() );
            }
        } else {
            throw new FieloException ('At least you need to select one model');
        }
    }
    /**
     * @brief       habilita para poder borrar un programa
     * @details     Luego de llamar el metodo al invocar el dml de delete de un program permite borrarlo
     * @version     10.0
     * @param       value           Valor para habilitar y desahibilitar el delete
     * @returns     Void
     * @test
     * @code
     *          FieloEE.SObjectService.deleteProgram(true);
     *          delete [SELECT Id FROM FieloEE__Program__c];
     * @endcode
     */
    public static void deleteProgram(Boolean value){
        Programs.allowProgramDelete = value;
    }

    public static void selectProgram(Id programId){
        Settings__c settings = Settings__c.getInstance(UserInfo.getUserId());
        settings.CurrentProgramId__c = programId;
        upsert settings;
    }

    public static Program__c getActiveProgram(){
        // Busca el id del Program Activo
        Settings__c settings = Settings__c.getInstance(UserInfo.getUserId());
        if(!String.isEmpty(settings.CurrentProgramId__c)){
            try{
                Program__c program = getProgram(settings.CurrentProgramId__c);
                if(program != null){
                    return program;
                }
            }catch(Exception e){
                // Si falla por que el Id esta mal guardado continua

            }
        }
        // Si el usuario no tiene ninguno activo entonces activa el primero
        Program__c program = getPrograms().values().get(0);
        settings.CurrentProgramId__c = program.Id;
        return program;
    }

    public static Program__c getProgram(Id programId){
        if(programId != null && getPrograms().containsKey(programId)){
            return getPrograms().get(programId);
        }
        return null;
    }

    public static Map<Id,Program__c> getPrograms(){
        if(programMap == null){
            List<Program__c> programs = [SELECT Id, Name FROM Program__c];
            // Si esta vacio => crea uno default
            if(programs.size() == 0){
                Program__c program = new Program__c(Name = 'Default');
                insert program;
                programMap = new Map<Id,Program__c> {program.Id => program};
            }else{
                programMap = new Map<Id,Program__c>(programs);
            }
        }
        return programMap;
    }

    public static void updateCriteriaField( Set<Id> programIds ){

        if(!programIds.isEmpty()){
            List<Segment__c> segments = new SegmentsSelector().selectByProgramAndActive(programIds, null, new Set<Id>());
            List<Level__c> levels = new LevelsSelector().selectActiveLevelsByPrograms(programIds);
            Map<Id,Program__c> programs = new Map<Id,Program__c>(new ProgramsSelector(new Set<String>{'FieloPLT__CriteriaFields__c'}).selectById(programIds));

            Map<Id,Map<String,SObjectService.CriteriaWrapper>> criteriasMapByProgram = new Map<Id,Map<String,SObjectService.CriteriaWrapper>>();

            for(Program__c p : programs.values()){
                Map<String,SObjectService.CriteriaWrapper> criteriasMapByObject = new Map<String,SObjectService.CriteriaWrapper>();
                criteriasMapByObject.put('levels', new SObjectService.CriteriaWrapper());
                criteriasMapByObject.put('segments', new SObjectService.CriteriaWrapper());
                criteriasMapByProgram.put(p.Id, criteriasMapByObject);
            }

            // Recorre las rules y sus criterios para armar los mapas
            for(Segment__c segment : segments){
                //agrega los campos correspondientes a cada objeto del mapa
                for(Criterion__c criterion : segment.SegmentCriteria__r){
                    String objectName = criterion.CriterionGroup__c == null ? 'FieloPLT__Member__c' : criterion.CriterionGroup__r.RelatedList__c;
                    if(String.isNotBlank(criterion.FieldName__c)){
                        //si el segment tiene program aplica solo a ese
                        if(segment.Program__c != null){
                            if(criteriasMapByProgram.get(segment.Program__c).get('segments').fieldsByObject.containsKey(objectName)){
                                criteriasMapByProgram.get(segment.Program__c).get('segments').fieldsByObject.get(objectName).add(criterion.FieldName__c);
                            }else{
                                criteriasMapByProgram.get(segment.Program__c).get('segments').fieldsByObject.put(objectName, new Set<String>{criterion.FieldName__c});
                            }

                            //si el trae un campo por relacion marco la action como Crossed Field
                            if(criterion.FieldName__c.contains('__r')){
                                criteriasMapByProgram.get(segment.Program__c).get('segments').isCrossField = true;
                            }
                        //si no tiene program aplica a todos
                        }else{
                            for(Id progId: criteriasMapByProgram.keySet()){
                                if(criteriasMapByProgram.get(progId).get('segments').fieldsByObject.containsKey(objectName)){
                                    criteriasMapByProgram.get(progId).get('segments').fieldsByObject.get(objectName).add(criterion.FieldName__c);
                                }else{
                                    criteriasMapByProgram.get(progId).get('segments').fieldsByObject.put(objectName, new Set<String>{criterion.FieldName__c});
                                }

                                //si el trae un campo por relacion marco la action como Crossed Field
                                if(criterion.FieldName__c.contains('__r')){
                                    criteriasMapByProgram.get(progId).get('segments').isCrossField = true;
                                }
                            }
                        }
                    }
                    if(criterion.IsField__c && String.isNotBlank(criterion.Values__c)){
                        //si el segment tiene program aplica solo a ese
                        if(segment.Program__c != null){
                            if(criteriasMapByProgram.get(segment.Program__c).get('segments').fieldsByObject.containsKey(objectName)){
                                criteriasMapByProgram.get(segment.Program__c).get('segments').fieldsByObject.get(objectName).add(criterion.Values__c);
                            }else{
                                criteriasMapByProgram.get(segment.Program__c).get('segments').fieldsByObject.put(objectName, new Set<String>{criterion.Values__c});
                            }

                            //si el trae un campo por relacion marco la action como Crossed Field
                            if(criterion.Values__c.contains('__r')){
                                criteriasMapByProgram.get(segment.Program__c).get('segments').isCrossField = true;
                            }
                        //si no tiene program aplica a todos
                        }else{
                            for(Id progId: criteriasMapByProgram.keySet()){
                                if(criteriasMapByProgram.get(progId).get('segments').fieldsByObject.containsKey(objectName)){
                                    criteriasMapByProgram.get(progId).get('segments').fieldsByObject.get(objectName).add(criterion.Values__c);
                                }else{
                                    criteriasMapByProgram.get(progId).get('segments').fieldsByObject.put(objectName, new Set<String>{criterion.Values__c});
                                }

                                //si el trae un campo por relacion marco la action como Crossed Field
                                if(criterion.Values__c.contains('__r')){
                                    criteriasMapByProgram.get(progId).get('segments').isCrossField = true;
                                }
                            }
                        }
                    }

                    if(criterion.CriterionGroup__c != null){
                        //si el segment tiene program aplica solo a ese
                        if(segment.Program__c != null){
                            criteriasMapByProgram.get(segment.Program__c).get('segments').isUsingCriterionGroup = true;
                        //si no tiene program aplica a todos
                        }else{
                            for(Id progId: criteriasMapByProgram.keySet()){
                                criteriasMapByProgram.get(progId).get('segments').isUsingCriterionGroup = true;
                            }
                        }
                    }
                }
            }

            // Recorre las rules y sus criterios para armar los mapas
            for(Level__c level : levels){
                //agrega los campos correspondientes a cada objeto del mapa
                for(Criterion__c criterion : level.LevelCriteria__r){
                    String objectName = criterion.CriterionGroup__c == null ? 'FieloPLT__Member__c' : criterion.CriterionGroup__r.RelatedList__c;
                    if(String.isNotBlank(criterion.FieldName__c)){
                        if(criteriasMapByProgram.get(level.Program__c).get('levels').fieldsByObject.containsKey(objectName)){
                            criteriasMapByProgram.get(level.Program__c).get('levels').fieldsByObject.get(objectName).add(criterion.FieldName__c);
                        }else{
                            criteriasMapByProgram.get(level.Program__c).get('levels').fieldsByObject.put(objectName, new Set<String>{criterion.FieldName__c});
                        }

                        //si el trae un campo por relacion marco la action como Crossed Field
                        if(criterion.FieldName__c.contains('__r')){
                            criteriasMapByProgram.get(level.Program__c).get('levels').isCrossField = true;
                        }
                    }
                    if(criterion.IsField__c && String.isNotBlank(criterion.Values__c)){
                        if(criteriasMapByProgram.get(level.Program__c).get('levels').fieldsByObject.containsKey(objectName)){
                            criteriasMapByProgram.get(level.Program__c).get('levels').fieldsByObject.get(objectName).add(criterion.Values__c);
                        }else{
                            criteriasMapByProgram.get(level.Program__c).get('levels').fieldsByObject.put(objectName, new Set<String>{criterion.Values__c});
                        }

                        //si el trae un campo por relacion marco la action como Crossed Field
                        if(criterion.Values__c.contains('__r')){
                            criteriasMapByProgram.get(level.Program__c).get('levels').isCrossField = true;
                        }
                    }

                    if(criterion.CriterionGroup__c != null){
                        criteriasMapByProgram.get(level.Program__c).get('levels').isUsingCriterionGroup = true;
                    }
                }
            }

            // Setea los valores en los campos desnormalizados de actions segun los mapas
            for(Program__c program : programs.values()){
                program.CriteriaFields__c = JSON.serialize(criteriasMapByProgram.get(program.Id), false);
            }

            // Actualiza los programs
            update programs.values();
        }
    }

    public static List<SelectOption> getProgramsSelectOptions(){
        List<SelectOption> options = new List<SelectOption>();
        for(Program__c p : new ProgramsSelector(new Set<String>{'Name'}).selectAll()){
            options.add(new SelectOption(p.Id, p.Name));
        }
        sortSelectOptions(options);
        return options;
    }

    public static void sortSelectOptions(List<SelectOption> records){
        Map<String, Selectoption> mapping = new Map<String, Selectoption>();

        // Suffix to avoid duplicate values like same labels or values are in inbound list
        Integer suffix = 1;

        for (Selectoption opt : records) {
            mapping.put((opt.getLabel() + suffix++), opt);
        }

        List<String> sortKeys = new List<String>();
        sortKeys.addAll(mapping.keySet());

        sortKeys.sort();

        // clear the original collection to rebuilt it
        records.clear();

        for (String key : sortKeys) {
            records.add(mapping.get(key));
        }
    }

    public static List<SelectOption> getProgramsLandingSelectOptions(){
        Map<Id, Program__c> programsMap = getPrograms();
        //Program__c programActive = getActiveProgram();

        List<SelectOption> options = new List<SelectOption>();
        for(Program__c program: programsMap.values()){
            //if (program.Id != programActive.Id ){
                options.add(new SelectOption(program.Id, program.Name));
            //}
        }
        sortSelectOptions(options);
        return options;
    }

    public static Id getSingleProgramId(){
        if(isSingleProgram == null){
            List<Program__c > programs = [SELECT Id FROM Program__c LIMIT 2];
            if(programs.size() == 1){
                singleProgramId = programs[0].Id;
            }else{
                singleProgramId = null;
            }
            isSingleProgram = singleProgramId != null;
        }
        return singleProgramId;
    }


}