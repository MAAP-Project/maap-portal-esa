package com.esa.maap.datacataloguemainmenu.portlet.constants;

/**
 * @author tkossoko
 */
public class DataCatalogueMainMenuPortletKeys {

	public static final String DATACATALOGUEMAINMENU =
		"com_esa_maap_datacataloguemainmenu_portlet_DataCatalogueMainMenuPortlet";
	
	// input parameter names
		public static final String LOCATION_INPUT_PARAM = "coordinatesInputs";
		public static final String START_DATE_INPUT_PARAM = "startDateAcquisition";
		public static final String END_DATE_INPUT_PARAM = "endDateAcquisition";
		public static final String COLLECTION_NAME_INPUT_PARAM = "groundCampaignName";
		public static final String SUB_REGION_NAME_INPUT_PARAM = "subRegionName";
		public static final String POLARIZATION_TYPE_INPUT_PARAM = "polarizationType";
		public static final String GEOMETRY_TYPE_INPUT_PARAM = "geometryType";
		public static final String PRODUCT_TYPE_INPUT_PARAM = "productType";
		public static final String INSTRUMENT_NAME_INPUT_PARAM = "instrumentName";
		public static final String PROCESSING_LEVEL_INPUT_PARAM = "processingLevel";
		public static final String HEADING_VALUE_INPUT_PARAM = "heading";
		public static final String PRIVACY_INPUT_PARAM = "privacyType";

		// keys
		public static final String MINIMUM_X = "minimumX";
		public static final String MAXIMUM_X = "maximumX";
		public static final String MINIMUM_Y = "minimumY";
		public static final String MAXIMUM_Y = "maximumY";
		public static final String CENTROID_LAT = "cendroidLat";
		public static final String CENTROID_LON = "cendroidLon";
		public static final String WKT = "wkt";
		public static final String LAYER_PREVIEW_URL = "layerPreviewURL";
		public static final String GRANULE_GROUPING = "granuleGrouping";
		public static final String SUBREGION = "subRegion";
		public static final String ID = "id";
		public static final String GRANULE_NAME = "granuleName";
		public static final String ACQUISITION_DATE = "acquisitionDate";
		public static final String COLLECTION = "collection";
		public static final String LAYER_NAME = "layerName";
		public static final String PRIVACY = "privacy";
		public static final String GRANULE_PARAM = "granule";
		public static final String GRANULE_ID_PARAM = "granuleId";
		public static final String FILE_TYPE = "fileType";
		public static final String INSTANCE_ID = "instanceID";
		public static final String DATA_OVERLAY_LIST = "dataOverlayList";
		public static final String JSON_COLLECTION_DATALIST = "collectionDataList";

		// fields

		public static final String NASA_PRODUCTS = "Nasa_products";
		public static final String REGION_OF_INTEREST = "Region_of_Interest";

		// triggers
		public static final String RESEARCH_TRIGGER = "researchTrigger";
		public static final String DOACTION_TRIGGER = "doActionTrigger";
		public static final String SHAREDATA_TRIGGER = "shareDataTrigger";
		public static final String COLLECTIONNAMES_TRIGGER = "getCollectionNamesTrigger";
		// error message & extensions
		public static final String ERROR_MESSAGE_ATTR = "error";

		// other
		public static final String DATE_FORMAT_PATTERN = "yyyy-MM-dd";
		public static final String RANDOM_STRING_PATTERN = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

		public static final String PORTLET_ACTION_NAME = "portletActionName";
		public static final String COLLECTION_NAME = "collectionName";
		public static final String PRIVACY_NAME = "privacy";

		// JSP Pages name
		public static final String LAYERLIST_DATAROW_JSP = "/layerListDataRow";
		public static final String ERROR_JSP = "/error";
		public static final String VISUALISATION_OVERLAY_JSP = "/visualisationOverlay";
		public static final String VISUALISATION_LAYER_JSP = "/portlets/visualisationLayer";
		public static final String VISUALISATION_ANALYSIS_STATS_JSP = "/portlets/visualisationAnalysisStats";
		public static final String VISUALISATION_ANALYSIS_HIST_JSP = "/portlets/visualisationAnalysisHist";
		public static final String VISUALISATION_ROI_ATTRIBUTE_TABLE_JSP = "/portlets/visualisationRoiAttributeTable";

		// wkt
		public static final String WKT_POLYGON = "POLYGON";
		public static final String WKT_POINT = "POINT";
		public static final String WKT_LINESTRING = "LINESTRING";
		
		
		//HTTP codes
		public static final String HTTP_CODE_SUCCESS = "200";
		public static final String HTTP_CODE_ERROR = "400";

}