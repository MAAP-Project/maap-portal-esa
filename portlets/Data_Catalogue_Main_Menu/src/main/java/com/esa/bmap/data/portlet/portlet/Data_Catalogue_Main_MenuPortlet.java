package com.esa.bmap.data.portlet.portlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.security.SecureRandom;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collection;

import javax.portlet.Portlet;
import javax.portlet.PortletContext;
import javax.portlet.PortletException;
import javax.portlet.PortletRequestDispatcher;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import org.apache.commons.io.FilenameUtils;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.bedatadriven.jackson.datatype.jts.JtsModule;
import com.esa.bmap.common.exceptions.BmapException;
import com.esa.bmap.common.service.Common;
import com.esa.bmap.data.api.DataInterface;
import com.esa.bmap.data.portlet.constants.Data_Catalogue_Main_MenuPortletKeys;
import com.esa.bmap.model.Granule;
import com.esa.bmap.model.GranuleCriteria;
import com.esa.bmap.model.Polarization;
import com.esa.bmap.model.Quadrangle;
import com.esa.bmap.model.QuadrangleType;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.vividsolutions.jts.geom.Coordinate;

/**
 * Main menu of the Data catalogue. Navigation between data categories and
 * retrieval of form input values
 * 
 * @author capgemini
 *
 */
@Component(immediate = true, property = { "com.liferay.portlet.display-category=data_catalogue",
		"com.liferay.portlet.instanceable=false", "javax.portlet.display-name=Data_Catalogue_Main_Menu Portlet",
		"javax.portlet.init-param.template-path=/", "javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.name=" + Data_Catalogue_Main_MenuPortletKeys.Data_Catalogue_Main_Menu,
		"javax.portlet.supported-processing-event=addLayerMarkers", "javax.portlet.resource-bundle=content.Language",
		"javax.portlet.supported-publishing-event=generateResults",
		"javax.portlet.supported-publishing-event=clearSearchResults",
		"javax.portlet.security-role-ref=power-user,user" }, service = Portlet.class)
public class Data_Catalogue_Main_MenuPortlet extends MVCPortlet {

	private static Logger LOG;
	private GranuleCriteria granuleCriteria = new GranuleCriteria();

	private DataInterface dataService;

	private Granule granule;
	private String portletActionName;
	private String dataOverlay;
	private String collectionName;
	private String granuleName;

	private static String GEOSERVER_WORKSPACE;
	private static String GEOSERVER_URL;

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet#init()
	 */
	@Override
	public void init() throws PortletException {
		LOG = LoggerFactory.getLogger(this.getClass().getName());
		LOG.info("Portlet init ");

		super.init();
	}

	/**
	 * Setting a Common Service to use
	 * 
	 * @param commonService
	 */
	@Reference
	public void setCommonService(Common commonService) {

		GEOSERVER_URL = commonService.getValueFromKeyInPropertiesFile("BMAP_GEOSERVER_URL");
		GEOSERVER_WORKSPACE = commonService.getValueFromKeyInPropertiesFile("BMAP_GEOSERVER_WORKSPACE");

	}

	/**
	 * Setting a restClient to use
	 * 
	 * @param restClient
	 */
	@Reference
	public void setDataClientLocalService(DataInterface data) {

		this.dataService = data;
	}

	/**
	 * Sets the Granule Criteria with given parameters from Data Location Form
	 * 
	 * @param request actionRequest
	 * @param response actionResponse
	 * @throws PortletException
	 */
	public void searchDataLocation(ResourceRequest request, ResourceResponse response) {

		// getting coordinates values from form

		if (request.getParameterValues("coordinatesInputs") != null) {
			String[] coordinatesInputs = request.getParameterValues("coordinatesInputs");

			ArrayList<Coordinate> coordinates = new ArrayList<Coordinate>();

			for (int i = 0; i < coordinatesInputs.length; i++) {
				String[] parts = coordinatesInputs[i].split(",");
				// Transform inputs from form to Coordinate object
				Coordinate coord = new Coordinate(Double.parseDouble(parts[0]), Double.parseDouble(parts[1]));
				coordinates.add(coord);

			}

			Coordinate[] coordArray = coordinates.toArray(new Coordinate[coordinates.size()]);

			// setting GranuleCriteria quadrangle with given coordinates
			Quadrangle quadrangle = new Quadrangle(QuadrangleType.LATLONG, coordArray, 0, 0);
			granuleCriteria.setLocation(quadrangle);

			LOG.info("Setting GranuleCriteria quadrangle with values : " + coordinates.toString());
		}
	}

	/**
	 * Sets the Granule Criteria with given parameters from Data Period Form
	 * 
	 * @param request
	 * @param response
	 * @throws PortletException
	 * @throws BmapException
	 */
	public void searchDataPeriod(ResourceRequest request, ResourceResponse response) {

		// getting date criterias from form
		String startDateAcquisition = request.getParameter("startDateAcquisition");
		String endDateAcquisition = request.getParameter("endDateAcquisition");

		// Transform given Dates with adequate dataformatter
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

		if (startDateAcquisition != null && !startDateAcquisition.isEmpty()) {

			LocalDate startDate = LocalDate.parse(startDateAcquisition, formatter);
			LOG.info("Setting GranuleCriteria starDate  with value : " + startDateAcquisition);
			granuleCriteria.setStartDate(startDate);
		}
		if (endDateAcquisition != null && !endDateAcquisition.isEmpty()) {

			LocalDate endDate = LocalDate.parse(endDateAcquisition, formatter);
			LOG.info("Setting GranuleCriteria endDate  with value : " + endDateAcquisition);
			granuleCriteria.setEndDate(endDate);
		}

	}

	/**
	 * Sets the Granule Criteria with given parameters from Ground Data Form
	 * 
	 * @param request actionRequest
	 * @param response actionResponse
	 * @throws BmapException
	 * @throws PortletException
	 */

	public void searchGroundData(ResourceRequest request, ResourceResponse response) {

		// getting GroundData criterias from form
		String groundCampaignNames = request.getParameter("groundCampaignName");
		String subRegionNames = request.getParameter("subRegionName");
		String polarizationTypes = request.getParameter("polarizationType");
		String geometryTypes = request.getParameter("geometryType");
		String productTypes = request.getParameter("productType");
		String instrumentNames = request.getParameter("instrumentName");
		String processingLevels = request.getParameter("processingLevel");
		String heading = request.getParameter("heading");

		// setting granuleCriteria with each parameter values

		// Collections/groundCampaigns names
		if (groundCampaignNames != null && !groundCampaignNames.isEmpty()) {
			ArrayList<String> groundCampaignList = new ArrayList<String>();
			groundCampaignList.add(groundCampaignNames);

			this.granuleCriteria.setCollectionNames(groundCampaignList);

			LOG.info("Setting GranuleCriteria groundCampaignNames  with values : " + groundCampaignNames);
		}

		// SiteNames/subRegions names
		if (subRegionNames != null && !subRegionNames.isEmpty()) {

			ArrayList<String> subRegionsList = new ArrayList<String>();
			subRegionsList.add(subRegionNames);

			try {
				this.granuleCriteria.setSubRegionNames(subRegionsList);
			} catch (BmapException e) {
				request.setAttribute("errorMessage", e.getMessage());
				SessionErrors.add(request, "error");
				LOG.info("Issue while getting setting ground data criterias :" + e);
			}

			LOG.info("Setting GranuleCriteria subRegionNames  with values : " + subRegionsList);
		}

		// Polarization Types
		if (polarizationTypes != null && !polarizationTypes.isEmpty()) {

			ArrayList<Polarization> polarizationTypesList = new ArrayList<Polarization>();

			if (polarizationTypes.equals(Polarization.HH.toString())) {
				polarizationTypesList.add(Polarization.HH);
			} else if (polarizationTypes.equals(Polarization.HV.toString())) {
				polarizationTypesList.add(Polarization.HV);
			} else if (polarizationTypes.equals(Polarization.VV.toString())) {
				polarizationTypesList.add(Polarization.VV);
			} else if (polarizationTypes.equals(Polarization.VH.toString())) {
				polarizationTypesList.add(Polarization.VH);
			}

			this.granuleCriteria.setPolarizations(polarizationTypesList);

			LOG.info("Setting GranuleCriteria Polarizations  with values : " + polarizationTypesList);
		}

		// Geometry Types
		if (geometryTypes != null && !geometryTypes.isEmpty()) {

			ArrayList<String> geometryTypesList = new ArrayList<String>();
			geometryTypesList.add(geometryTypes);

			try {
				this.granuleCriteria.setGeometryTypes(geometryTypesList);
			} catch (BmapException e) {
				request.setAttribute("errorMessage", e.getMessage());
				SessionErrors.add(request, "error");
				LOG.info("Issue while getting setting ground granule criterias :" + e);
			}

			LOG.info("Setting GranuleCriteria GeometryTypeList  with values : " + geometryTypesList);

		}

		// Product Types
		if (productTypes != null && !productTypes.isEmpty()) {

			ArrayList<String> productTypesList = new ArrayList<String>();
			productTypesList.add(productTypes);

			try {
				LOG.info(productTypesList.toString());
				this.granuleCriteria.setProductTypes(productTypesList);

			} catch (BmapException e) {
				request.setAttribute("errorMessage", e.getMessage());
				SessionErrors.add(request, "error");
				LOG.info("Issue while getting setting ground granule criterias :" + e);
			}

			LOG.info("Setting GranuleCriteria productTypeList  with values : " + productTypesList);

		}

		// Instrument Names
		if (instrumentNames != null && !instrumentNames.isEmpty()) {
			ArrayList<String> instrumentNamesList = new ArrayList<String>();
			instrumentNamesList.add(instrumentNames);

			try {
				this.granuleCriteria.setInstrumentNames(instrumentNamesList);
			} catch (BmapException e) {
				request.setAttribute("errorMessage", e.getMessage());
				SessionErrors.add(request, "error");
				LOG.info("Issue while getting setting instrument names granule criterias :" + e);
			}

			LOG.info("Setting GranuleCriteria instrumentList  with values : " + instrumentNamesList);
		}

		// Processing levels
		if (processingLevels != null && !processingLevels.isEmpty()) {

			ArrayList<String> processingLevelsList = new ArrayList<String>();
			processingLevelsList.add(processingLevels);

			try {
				this.granuleCriteria.setProcessingLevels(processingLevelsList);
			} catch (BmapException e) {
				request.setAttribute("errorMessage", e.getMessage());
				SessionErrors.add(request, "error");
				LOG.info("Issue while getting setting ground data criterias :" + e);
			}

			LOG.info("Setting GranuleCriteria processingLevelList  with values : " + processingLevelsList);
		}
		if (heading != null && !heading.isEmpty()) {

			ArrayList<String> headingList = new ArrayList<String>();
			headingList.add(heading);

			this.granuleCriteria.setHeadingValues(headingList);

			LOG.info("Setting GranuleCriteria headingList with values : " + headingList);
		}

	}

	/**
	 * Method catching ajax request. If new search, pass the Granule Criteria to
	 * OSGI Data-api module to get resultlist If other action, then redirect to
	 * adequate portlet or execute requested action
	 */
	@Override
	public void serveResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse)
			throws IOException, PortletException {

		LOG.info("ServeResource for id : " + resourceRequest.getResourceID());

		// Setting Object Mapper with Jts Module used for serialisation and
		// deserialisation of spatial data
		ObjectMapper mapper = new ObjectMapper();
		mapper.registerModule(new JtsModule());

		// If new search ( triggered by search button)
		if (resourceRequest.getResourceID().equals("researchTrigger")) {
			LOG.info("researchTrigger");

			// getting search criterias inputs
			searchGroundData(resourceRequest, resourceResponse);
			searchDataPeriod(resourceRequest, resourceResponse);
			searchDataLocation(resourceRequest, resourceResponse);

			// instanciation of a Collection of granules representing the search results
			Collection<Granule> granuleCollection = null;
			try {
				LOG.info("passing following Granule Criteria to Data-api " + granuleCriteria.toString());
				// getting the populated granuleCollection from service
				granuleCollection = dataService.getGranuleByCriteria(granuleCriteria);

			} catch (BmapException e) {

				resourceRequest.setAttribute("errorMessage", e.getMessage());
				SessionErrors.add(resourceRequest, "error");
				LOG.info("Failed to get result list by Granule Criteria :" + e);
				// reinitializing granule collection --> no data
				granuleCollection = new ArrayList<Granule>();
			}

			// transforming the granuleCollection to json for front to render and render
			// this json
			String granuleResultListJson = transformToJson(granuleCollection);
			PrintWriter printout = resourceResponse.getWriter();
			printout.print(granuleResultListJson);

			// clearing granuleCriteria
			granuleCriteria = new GranuleCriteria();

		} else if (resourceRequest.getResourceID().equals("doActionTrigger")) {
			// for other action
			LOG.info("doActionTrigger");

			// getting granule's collection and granule name, needed for cmr research
			String collectionString = resourceRequest.getParameter("collectionName");
			String granuleNameString = resourceRequest.getParameter("granuleName");
			if (collectionString != null) {
				collectionName = collectionString;
			}
			if (granuleNameString != null) {
				granuleName = granuleNameString;
			}

			// searching granule with given criteria

			if (collectionName != null && granuleName != null) {
				try {
					granule = dataService.getGranuleByName(collectionName + ":@" + granuleName);

				} catch (NumberFormatException | BmapException e) {
					resourceRequest.setAttribute("errorMessage", e.getMessage());
					SessionErrors.add(resourceRequest, "error");
					LOG.error("Failed to get Data by its id :" + e);
				}
			}

			// setting jsp for dispatcher
			String portletAction = resourceRequest.getParameter("portletActionName");
			if (portletAction != null) {
				portletActionName = portletAction;
			}
			LOG.debug("portlet action :" + portletActionName);

			// getting list of data for Overlay
			String dataOverlayList = resourceRequest.getParameter("dataOverlayList");
			if (dataOverlayList != null) {
				dataOverlay = dataOverlayList;
			}

			LOG.debug("dataOverlayList :" + dataOverlay);

			StringBuilder uniqueID = generateUniqueID();

			// TODO use granuleHelper
			// LOG.info(GranuleHelper.getGranuleType(granule.getName()));
			// getting fileExtension for front to display according functionnalities
			String fileType = null;

			String fileExtension = FilenameUtils.getExtension(granule.getDataList().get(0).getFilePath());
			if (fileExtension != null && !fileExtension.isEmpty()) {
				if (fileExtension.equals("tiff") || fileExtension.equals("tif")) {
					fileType = "tiff";
				} else if (fileExtension.equals("shp") || fileExtension.equals("shx") || fileExtension.equals("prj")
						|| fileExtension.equals("dbf")) {
					fileType = "roi";
				} else {
					fileType = "undefined";
				}
			} else {
				fileType = "undefined";
			}

			// setting attributes
			resourceRequest.setAttribute("granule", granule);
			resourceRequest.setAttribute("fileType", fileType);
			resourceRequest.setAttribute("instanceID", uniqueID);
			resourceRequest.setAttribute("dataOverlayList", dataOverlay);

			// getting portletContext for Dispatcher
			PortletContext portletContext = resourceRequest.getPortletSession().getPortletContext();

			// forwarding to given jsp file
			PortletRequestDispatcher dispatcher = portletContext.getRequestDispatcher(portletActionName + ".jsp");

			dispatcher.include(resourceRequest, resourceResponse);

			super.serveResource(resourceRequest, resourceResponse);
		}

	}

	/**
	 * Generate a unique String
	 * 
	 * @return StringBuilder unique String
	 */
	public StringBuilder generateUniqueID() {
		LOG.info("generating unique instance id");
		// creating unique id for portlet instance setting
		final String AB = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
		SecureRandom rnd = new SecureRandom();
		StringBuilder uniqueID = new StringBuilder(10);
		for (int i = 0; i < 15; i++)
			uniqueID.append(AB.charAt(rnd.nextInt(AB.length())));
		return uniqueID;
	}

	/**
	 * Convert granule List to a valid JSON Format for MMI to parse
	 *
	 * @param airDataList
	 * @return String Json
	 */
	public String transformToJson(Collection<Granule> granuleCollection) {

		// wms url
		String geoserverWMS = GEOSERVER_URL + GEOSERVER_WORKSPACE + "/wms";

		// creating a json object and a json array to store the retrieved granules
		JSONObject rootJSONObject = JSONFactoryUtil.createJSONObject();
		JSONArray jsonArray = JSONFactoryUtil.createJSONArray();
		for (Granule granule : granuleCollection) {

			// if datalist is not empty then it is a granule data
			if (!granule.getDataList().isEmpty()) {
				JSONObject granuleObject = JSONFactoryUtil.createJSONObject();

				// COMMON METADATA
				granuleObject.put("id", granule.getId());
				granuleObject.put("granuleName", granule.getName());
				granuleObject.put("acquisitionDate", granule.getDataList().get(0).getAcquisitionDate());
				granuleObject.put("collection", granule.getCollection().getShortName());

				// ESA METADATA (category key words is a esa attribute )
				if (granule.getCollection().getCategoryKeyWords() != null) {

					granuleObject.put("layerName", granule.getDataList().get(0).getLayerName());

					// setting granule grouping attribute --> granule scene name if exists
					if (granule.getGranuleScene() != null) {
						granuleObject.put("granuleGrouping", granule.getGranuleScene().getName());
					} else {
						if (granule.getProductType() != null
								&& granule.getProductType().equals(Granule.PRODUCT_TYPE_ROI)) {
							granuleObject.put("granuleGrouping", "Region_of_Interest");
						} else {
							granuleObject.put("granuleGrouping", "n/a");
						}

					}

					// granule sub region attribute
					if (granule.getSubRegion() != null) {

						granuleObject.put("subRegion", granule.getSubRegion().getName());
					} else {
						granuleObject.put("subRegion", "n/a");
					}

					// METADATA depending on geometryType
					switch (granule.getDataList().get(0).getGeometryType()) {
					case "geolocated":
						// if the granule is not geolocated we display it with its declared projection
						// code (4326 by default)
						Double centroidLat = granule.getQuadrangle().getGeometry().getEnvelope().getCentroid().getX();
						Double centroidLon = granule.getQuadrangle().getGeometry().getEnvelope().getCentroid().getY();
						granuleObject.put("centroidLat", centroidLat.toString());
						granuleObject.put("centroidLon", centroidLon.toString());

						Coordinate[] coordinateList = granule.getQuadrangle().getGeometry().getEnvelope()
								.getCoordinates();

						String minimumY = String.valueOf(coordinateList[0].y);
						String maximumY = String.valueOf(coordinateList[2].y);
						String minimumX = String.valueOf(coordinateList[0].x);
						String maximumX = String.valueOf(coordinateList[2].x);
						// we use wkt to draw the bounding box on the globe map
						granuleObject.put("wkt", granule.getQuadrangle().getGeometry().getEnvelope().toString());
						granuleObject.put("minimumY", minimumY);
						granuleObject.put("minimumX", minimumX);
						granuleObject.put("maximumY", maximumY);
						granuleObject.put("maximumX", maximumX);

						// getting metadata used for layer preview
						if (granule.getProductType() != null
								&& granule.getProductType().equals(Granule.PRODUCT_TYPE_ROI)) {
							granuleObject.put("layerPreviewURL",
									geoserverWMS + "?service=WMS&version=1.1.0&request=GetMap&layers="
											+ granule.getDataList().get(0).getLayerName() + "&bbox=" + minimumX + ","
											+ minimumY + "," + maximumX + "," + maximumY + "&width=500&height=500&srs="
											+ granule.getEpsgCodeDeclared() + "&format=image%2Fpng");
						} else {
							if (granule.getDataList().get(0).getMins().isEmpty()
									|| granule.getDataList().get(0).getMins() == null) {
								// the wms request is different (use the default geoserver style)
								granuleObject.put("layerPreviewURL",
										geoserverWMS + "?service=WMS&version=1.1.0&request=GetMap&layers="
												+ granule.getDataList().get(0).getLayerName() + "&bbox=" + minimumX
												+ "," + minimumY + "," + maximumX + "," + maximumY
												+ "&width=500&height=500&srs=" + granule.getEpsgCodeDeclared()
												+ "&format=image%2Fpng");

							} else {
								// if datastats are not empty then it is a raster, it is possible to render with
								// a color scale
								granuleObject.put("layerPreviewURL",
										geoserverWMS + "?service=WMS&version=1.1.0&request=GetMap&layers="
												+ granule.getDataList().get(0).getLayerName() + "&bbox=" + minimumX
												+ "," + minimumY + "," + maximumX + "," + maximumY
												+ "&width=500&height=500&srs=" + granule.getEpsgCodeDeclared()
												+ "&format=image%2Fpng&ENV=valueMin:"
												+ granule.getDataList().get(0).getMins().get(0) + ";valueMax:"
												+ granule.getDataList().get(0).getMaxs().get(0) + "");
							}
						}

						break;

					default:

						// for non geolocated data, we use the quadrangle we got from granule's dem:
						granuleObject.put("wkt", granule.getQuadrangle().getGeometry().getEnvelope().toString());
						Double centroidLatNonGeo = granule.getQuadrangle().getGeometry().getEnvelope().getCentroid()
								.getX();
						Double centroidLonNonGeo = granule.getQuadrangle().getGeometry().getEnvelope().getCentroid()
								.getY();
						granuleObject.put("centroidLat", centroidLatNonGeo.toString());
						granuleObject.put("centroidLon", centroidLonNonGeo.toString());
						granuleObject.put("minimumY", 0);
						granuleObject.put("minimumX", 0);
						granuleObject.put("maximumY", granule.getHeight());
						granuleObject.put("maximumX", granule.getWidth());
						granuleObject.put("wkt", granule.getQuadrangle().getGeometry().getEnvelope().toString());

						if (granule.getDataList().get(0).getMins().isEmpty()
								|| granule.getDataList().get(0).getMins() == null) {
							// the wms request is different (use the default geoserver style)
							granuleObject.put("layerPreviewURL",
									geoserverWMS + "?service=WMS&version=1.1.0&request=GetMap&layers="
											+ granule.getDataList().get(0).getLayerName() + "&bbox=0,0,"
											+ granule.getWidth() + "," + granule.getHeight()
											+ "&width=500&height=500&srs=" + granule.getEpsgCodeNative()
											+ "&format=image%2Fpng");
						} else {
							granuleObject.put("layerPreviewURL",
									geoserverWMS + "?service=WMS&version=1.1.0&request=GetMap&layers="
											+ granule.getDataList().get(0).getLayerName() + "&bbox=0,0,"
											+ granule.getWidth() + "," + granule.getHeight()
											+ "&width=500&height=500&srs=" + granule.getEpsgCodeNative()
											+ "&format=image%2Fpng&ENV=valueMin:"
											+ granule.getDataList().get(0).getMins().get(0) + ";valueMax:"
											+ granule.getDataList().get(0).getMaxs().get(0) + "");
						}

						break;
					}

				} else {
					// else it is nasa products
					granuleObject.put("layerPreviewURL", "undefined");
					granuleObject.put("granuleGrouping", "Nasa_products");
					granuleObject.put("subRegion", "N/A");
					Double centroidLat = granule.getQuadrangle().getGeometry().getEnvelope().getCentroid().getX();
					Double centroidLon = granule.getQuadrangle().getGeometry().getEnvelope().getCentroid().getY();
					granuleObject.put("centroidLat", centroidLat.toString());
					granuleObject.put("centroidLon", centroidLon.toString());
					granuleObject.put("wkt", granule.getQuadrangle().getGeometry().getEnvelope().toString());
					Coordinate[] coordinateList = granule.getQuadrangle().getGeometry().getEnvelope().getCoordinates();
					String minimumY = String.valueOf(coordinateList[0].y);
					String maximumY = String.valueOf(coordinateList[2].y);
					String minimumX = String.valueOf(coordinateList[0].x);
					String maximumX = String.valueOf(coordinateList[2].x);

					granuleObject.put("minimumY", minimumY);
					granuleObject.put("minimumX", minimumX);
					granuleObject.put("maximumY", maximumY);
					granuleObject.put("maximumX", maximumX);

				}

				jsonArray.put(granuleObject);

				rootJSONObject.put("collectionDataList", jsonArray);

			}
		}
		return rootJSONObject.toJSONString();
	}
}