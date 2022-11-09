<!-- VISUALISATION LAYER PORTLET INSTANCE  -->
<%@
taglib uri="http://liferay.com/tld/portlet"
	prefix="liferay-portlet"%>

<liferay-portlet:runtime defaultPreferences="${preferences}"
	portletName="Visualisation_Layer_INSTANCE_${instanceID}"
	queryString="&granuleName=${granule.name}&collectionName=${granule.collection.shortName}&privacyType=${granule.privacy}" />




