<%@ include file="/init.jsp" %>

<p>
	I'm alive
	<b><liferay-ui:message key="Test.caption"/></b>
</p>



<%-- render() | Mode Scriplet  --%>
<p>
    Salut, je m'appelle <%= request.getAttribute("name") %>, j'ai <%= request.getAttribute("age") %> ans. (Mode Scriplet)
</p>

<%-- render() | Mode EL --%>
<p>
    Salut, je m'appelle ${name}, j'ai ${age} ans. (Mode EL)
</p>

<%-- render() | Boucle JSTL --%>
<p>
    <ul>
        J'affiche mes langages informatiques favoris avec une boucle JSTL :
        <c:forEach items="${favoriteLanguages}" var="favLang">
            <li>${favLang}</li>
        </c:forEach>
    </ul>
</p>

<hr />
<hr />

<%-- Formulaires --%>
<p>
    Deux formulaires basiques :
</p>

<portlet:actionURL name="processAction" var="processAction" />
<portlet:actionURL name="formSentWithAlloy" var="formSentWithAlloy" />
<portlet:actionURL name="generate_portlets" var="generatePortlets"/>


<%-- processAction() | Formulaire HTML --%>
<form method="post" action="<%= processAction %>">
    <label for="field1">Texte du formulaire : </label>
    <input id="field1" name="<portlet:namespace/>field1" type="text" />
    <input type="submit" value="Envoyer formulaire vers `processAction()`" />
</form>
<p> My message is ${field1}</p>
<hr />

<%-- processAction() | Formulaire Alloy UI --%>
<aui:form method="post" action="<%= formSentWithAlloy %>">
    <aui:input name="field2" label="Texte du formulaire Alloy : " />
    <aui:button type="submit" value="Envoyer formulaire vers `formSentWithAlloy()`" />
</aui:form>
<p> My message is ${field2}</p>




<aui:form action="<%= generatePortlets %>" cssClass="container-fluid-1280" method="post" name="fm">
    <aui:input name="count" label="Portlet number" type="text" value="2"></aui:input>
    <aui:button type="submit" value="Add random portlets"></aui:button>
</aui:form>





<script src="https://cdnjs.cloudflare.com/ajax/libs/ol3/4.6.5/ol.js"
	type="text/javascript"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/ol3/4.6.5/ol.css"
	type="text/css">
<script type="text/javascript"
	src="https://cdn.polyfill.io/v2/polyfill.min.js?features=requestAnimationFrame,Element.prototype.classList,URL"></script>

<script type="text/javascript"
	src="https://rawgit.com/SFPink/ol3-layerswitcher/master/src/ol3-layerswitcher.js?id=1"></script>
<link rel="stylesheet" type="text/css"
	href="https://rawgit.com/SFPink/ol3-layerswitcher/master/src/ol3-layerswitcher.css?id=1">
<link rel="stylesheet" type="text/css"
	href="https://rawgit.com/SFPink/ol3-layerswitcher/master/src/ol3-layerswitcher.css">

<style id="compiled-css" type="text/css">
#map {
	width: 50%;
	height: 50%;
}

.layer-switcher {
	position: absolute;
	right: unset;
	text-align: left;
	bottom: 3em;
}
</style>


<!-- TODO: Missing CoffeeScript 2 -->

<script type="text/javascript">
	var watercolorlabels = new ol.layer.Group({
		type : 'base',
		combine : true,
		visible : false,
		layers : [ new ol.layer.Tile({
			source : new ol.source.Stamen({
				layer : 'watercolor'
			})
		}), new ol.layer.Tile({
			source : new ol.source.Stamen({
				layer : 'terrain-labels'
			})
		}) ]
	});

	var watercolor = new ol.layer.Tile({
		type : 'base',
		visible : false,
		source : new ol.source.Stamen({
			layer : 'watercolor'
		})
	});

	var OSM = new ol.layer.Tile({
		type : 'base',
		visible : true,
		opacity : 0.6,
		source : new ol.source.OSM()
	});

	var countries = new ol.layer.Image(
			{
				source : new ol.source.ImageArcGISRest(
						{
							ratio : 1,
							params : {
								'LAYERS' : 'show:0'
							},
							url : "https://ons-inspire.esriuk.com/arcgis/rest/services/Administrative_Boundaries/Countries_December_2016_Boundaries/MapServer"
						})
			});

	var map = new ol.Map({
		target : 'map',
		layers : [ new ol.layer.Group({
			'title' : 'Base maps',
			layers : [ watercolor, watercolorlabels, OSM ]
		}), new ol.layer.Group({
			title : 'Overlays',
			layers : [ countries ]
		}) ],
		view : new ol.View({
			center : ol.proj.transform([ -0.92, 52.96 ], 'EPSG:4326',
					'EPSG:3857'),
			zoom : 6
		})
	});

	var layerSwitcher = new ol.control.LayerSwitcher({
		onLayerToggle : function(visible, layer) {

		},
		onOpacityChange : function(opacity, layer) {

		},
		layers : [ {
			title : "Base",
			layers : [ {
				title : "OSM",
				layer : OSM,
				enableOpacitySliders : true,
				legend : "<strong>OSM is cool</strong>"
			}, {
				title : "Nested Layers",
				layers : [ {
					title : "Water Color",
					layer : watercolor,
					enableOpacitySliders : false
				}, {
					title : "Water Color With Labels",
					layer : watercolorlabels,
					enableOpacitySliders : true
				} ]
			} ]
		}, {
			title : "Overlays",
			layers : [ {
				title : "Countries",
				layer : countries,
				enableOpacitySliders : true,
				legend : "Some countries"
			} ]
		} ]
	});

	map.addControl(layerSwitcher);
</script>


<div id="map"></div>



