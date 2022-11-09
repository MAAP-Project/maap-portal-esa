package com.esa.maap.common.consts;

/**
 * Class used to declared constants
 * 
 * @author edupin
 *
 */
public final class Consts {

	// GEOSERVER
	public static final String GEOSERVER_URL_KEY = "BMAP_GEOSERVER_URL";
	public static final String GEOSERVER_WORKSPACE_KEY = "BMAP_GEOSERVER_WORKSPACE";
	public static final String WMS_URL = "/wms";
	

	public static final String PROPERTIES_PARAM = "properties";

	public static final String UNDEFINED = "undefined";
	public static final String NOT_APPLICABLE = "N/A";
//	public static final String NASA_PRODUCTS = "Nasa_products";
//	public static final String REGION_OF_INTEREST = "Region_of_Interest";
	public static final String INSTANCE_ID = "instanceID";

	// METHOD TYPES
	public static final String POST_METHOD_KEY = "POST";
	public static final String GET_METHOD_KEY = "GET";

	// PATTERNS & RANDOM SOURCE STRING
	public static final String DATE_FORMAT_PATTERN = "yyyy-MM-dd";
	public static final String RANDOM_STRING_PATTERN = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

	// EXTENSIONS
	public static final String JSP_EXTENSION = ".jsp";

	public static final String GENERAL_ERROR_MESSAGE_KEY = "back_end_error_global";

	private Consts() {
		// this prevents even the native class from
		// calling this ctor as well :
		throw new AssertionError();
	}

}
