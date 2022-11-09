<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet"%>

<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui"%><%@
taglib
	uri="http://liferay.com/tld/portlet" prefix="liferay-portlet"%><%@
taglib
	uri="http://liferay.com/tld/theme" prefix="liferay-theme"%><%@
taglib
	uri="http://liferay.com/tld/ui" prefix="liferay-ui"%>

<liferay-theme:defineObjects />

<portlet:defineObjects />

<!-- <script src="https://cdn.plot.ly/plotly-latest.min.js"></script> -->

<script>
	var data = [];
	var obj = JSON.parse('${jsonHist}');

	for (i = 0; i < obj[0].data.band.length; i++) {
	/* 	 console.log(obj[0].data.band[i]); */
		 var xArray = [];
		var yArray = [];



		for (j = 0; j < obj[0].data.band[i].histogram.length; j++) {
			xArray.push(obj[0].data.band[i].histogram[j].value);
			yArray.push(obj[0].data.band[i].histogram[j].frequency);
		}
		
	/* 	var hue = 'rgb(' + (Math.floor(Math.random() * 256)) + ',' + (Math.floor(Math.random() * 256)) + ',' + (Math.floor(Math.random() * 256)) + ')'; */
		var trace = {
			name : obj[0].data.band[i].bandName,
			x : xArray,
			y : yArray,
			type : 'bar',
			marker : {
				color :  "rgba(100, 200, 102, 1)",
				line : {
					color : "rgba(100, 200, 102, 1)",
					width : 1
				}
			}
		};
		data.push(trace);  
	} 

	
	var layout = {
			  title: {
			    text:'${data.fileName} Histogram',
			    font: {
			      family: 'Courier New, monospace',
			      size: 20
			    },
			    xref: 'paper',
			    x: 0.05,
			  },
			  xaxis: {
			    title: {
			      text: 'bin',
			      font: {
			        family: 'Courier New, monospace',
			        size: 18,
			        color: '#7f7f7f'
			      }
			    },
			  },
			  yaxis: {
			    title: {
			      text: 'frequency',
			      font: {
			        family: 'Courier New, monospace',
			        size: 18,
			        color: '#7f7f7f'
			      }
			    }
			  }
			};
	Plotly.newPlot('histogram<portlet:namespace/>', data, layout, {
		modeBarButtonsToRemove: ['sendDataToCloud','hoverCompareCartesian','select2d','hoverClosestCartesian','lasso2d', 'resetScale2d'],
		responsive : true
	});
</script>