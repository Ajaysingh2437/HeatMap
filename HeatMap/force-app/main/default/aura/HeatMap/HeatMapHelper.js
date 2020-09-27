({
    init : function(component) {
        var action = component.get("c.getPicklistFields");
        action.setParams({
            "objName":component.get("v.objName")
        });
        this.showSpinner(component);
        action.setCallback(this, function(response) {
            this.hideSpinner(component);
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.fields", response.getReturnValue());
            }else{
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        this.showToast("Error: ", errors[0].message, "error");
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    generateHeatMap: function (component) {
        var objName 			= component.get("v.objName"),
            selPrimaryField 	= component.get("v.selPrimaryField"),
            selSecondaryField	= component.get("v.selSecondaryField"),
            parentFieldName		= component.get("v.parentFieldName"),
            recordId			= component.get("v.recordId"),
            action 				= component.get("c.getHeatMap");
        
        action.setParams({
            "objName"			:objName,
            "selPrimaryField"	:selPrimaryField,
            "selSecondaryField"	:selSecondaryField,
            "parentFieldName"	:parentFieldName,
            "recordId"			:recordId,

        });
        
        this.showSpinner(component);
        
        action.setCallback(this, function(response) {
            this.hideSpinner(component);
            var state = response.getState();
            
            if(state === "SUCCESS"){
                var responseMap 	= response.getReturnValue(),
                    data			= JSON.parse(responseMap.data),
                    primaryValues 	= JSON.parse(responseMap.primaryValues),
                    secondaryValues = JSON.parse(responseMap.secondaryValues);
                                var column = [], tableData = {};
                tableData.labels = secondaryValues;
                tableData.datasets = [];
                for(var i=0; i<primaryValues.length; i++){
                    column = [];
                    for(var j=0; j<secondaryValues.length; j++){
                            column.push(0);
                    }
                    tableData['datasets'].push({label:primaryValues[i],data:column});
                }
                for (var i in data){
                    var rowIndex = primaryValues.indexOf(data[i][selPrimaryField]);
                    var colIndex = secondaryValues.indexOf(data[i][selSecondaryField]);
                    tableData.datasets[rowIndex].data[colIndex] = data[i].RecCount;
                }
                component.find("chartComp").loadChart(tableData);
                
            }else{
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        this.showToast("Error: ", errors[0].message, "error");
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    showSpinner: function (component) {
        var spinner = component.find("spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    
    hideSpinner: function (component) {
        var spinner = component.find("spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    showToast: function (title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message
        });
        toastEvent.fire();
    }
})