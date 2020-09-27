public with sharing class HeatMapService extends VisualEditor.DynamicPicklist{
    
    VisualEditor.DesignTimePageContext context;
	public HeatMapService(VisualEditor.DesignTimePageContext context) {
       this.context = context;
    }
    
    public override VisualEditor.DataRow getDefaultValue(){
        return null;
    }
    
    //This method will help in getting all the accessible objects of an org
    public override VisualEditor.DynamicPickListRows getValues(){   
        VisualEditor.DynamicPickListRows  allAccessibleObjects = new VisualEditor.DynamicPickListRows();
        for(Schema.SObjectType thisObj : Schema.getGlobalDescribe().values()){
            Schema.DescribeSObjectResult descObjResult = thisObj.getDescribe();
            if(descObjResult.isAccessible()){
                allAccessibleObjects.addRow(new VisualEditor.DataRow(descObjResult.getLabel(), descObjResult.getName()));
            }
        }
        return allAccessibleObjects;
    }
    
    //This method will help in getting all the accessible picklit fields of an objects
    public static List<PicklistWrapper> getPicklistFields(String objName){   
        List<PicklistWrapper> plWrapper = new List<PicklistWrapper>();
        for(Schema.SObjectField thisObj : Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().values()){
            Schema.DescribeFieldResult descObjResult = thisObj.getDescribe();
            if(descObjResult.isAccessible() && String.valueOf(descObjResult.Type).equals('PICKLIST')){
                plWrapper.add(new PicklistWrapper(descObjResult.getName(), descObjResult.getLabel()));
            }
        }
        return plWrapper;
    }
    
    //This method will help in getting the picklist field metadata of an object
    public static List<String> getPicklistValues(String objName, String fieldName){
        List<String> plValues = new List<String>();
        for( Schema.PicklistEntry pickListVal : Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(fieldName).getDescribe().getPicklistValues()){
            plValues.add(pickListVal.getValue());
        }
        return plValues;
    }
	
    public class PicklistWrapper{
        @AuraEnabled
        public String value {get;set;}
        @AuraEnabled
        public String label {get;set;}
        public PicklistWrapper(String value, String label){
            this.value = value;
            this.label = label;
        }
    }

}