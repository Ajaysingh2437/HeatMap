({
	init : function(component, event, helper) {
		helper.init(component);
	},
    onChange : function(component, event, helper) {
        var allValid = component.find('field').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        if (allValid) {
            helper.generateHeatMap(component);
        } else {
            helper.showToast("", "Review the error on this page.", "error");
        }
	},
    generateHeatMap : function(component, event, helper) {
		helper.generateHeatMap(component);
	},
})