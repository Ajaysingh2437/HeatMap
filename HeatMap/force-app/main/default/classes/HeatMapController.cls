//This class serve as a apex controller for HeatMap aura component
public class HeatMapController{
    @AuraEnabled
    public static List<HeatMapService.PicklistWrapper> getPicklistFields(String objName){
        try{
            return HeatMapService.getPicklistFields(objName);
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        } 
    }
    
    @AuraEnabled
    public static Map<String, String> getHeatMap(String objName, String selPrimaryField, String selSecondaryField, String parentFieldName, Id recordId){
        try{
           Map<String, String> responseMap = new Map<String, String>();
            
            responseMap.put('primaryValues',JSON.serialize(HeatMapService.getPicklistValues(objName, selPrimaryField)));
            responseMap.put('secondaryValues',JSON.serialize(HeatMapService.getPicklistValues(objName, selSecondaryField)));
            
            String query = 'SELECT '+ selPrimaryField + ', ' + selSecondaryField +', COUNT(Id) RecCount FROM '+ objName;
            query +=' GROUP BY '+ selPrimaryField + ', ' + selSecondaryField+ ', ' + parentFieldName;
            query +=' HAVING '+ selPrimaryField + '<>null AND '+ selSecondaryField+ '<>null ';
            query +=' AND '+ parentFieldName + '=:recordId';
            System.debug('query'+query);
            responseMap.put('data',JSON.serialize(Database.query(query)));
            return responseMap;
            
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        } 
    }
}