({	
    loadChart : function(cmp, event, helper) {
        var options = {};
        var params = event.getParam('arguments');
        if (params) {
            var data = JSON.parse(JSON.stringify(params.chartData));
            var newData = {};
            newData.labels = data.labels;
            newData.datasets = data.datasets;
            var ctx = cmp.find("heatmap").getElement().getContext('2d');
            var newChart = new Chart(ctx).HeatMap(data, options);
        }        
    }
})