package com.esa.maap.visualisationlayer.portlet;

import com.esa.bmap.common.exceptions.BmapException;
import com.esa.bmap.model.Granule;
import com.esa.bmap.model.GranuleCriteria;
import com.esa.bmap.model.Privacy;
import com.esa.maap.common.service.Common;
import com.esa.maap.data.api.DataInterface;
import com.esa.maap.visualisation.api.VisualisationInterface;
import com.esa.maap.visualisationlayer.portlet.constants.VisualisationLayerPortletKeys;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.util.ParamUtil;
import com.vividsolutions.jts.geom.Coordinate;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.portlet.Portlet;
import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import org.apache.commons.io.FilenameUtils;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author tkossoko
 */
@Component(
	immediate = true,
	property = {
		"com.liferay.portlet.display-category=category.sample",
		"com.liferay.portlet.header-portlet-css=/css/main.css",
		"com.liferay.portlet.instanceable=true",
		"javax.portlet.display-name=VisualisationLayer",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.name=" + VisualisationLayerPortletKeys.VISUALISATIONLAYER,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user"
	},
	service = Portlet.class
)
public class VisualisationLayerPortlet extends MVCPortlet {
	/**
	 * ESA CARTO SERVER INFORMATION
	 */
	private static String ESA_CARTO_SERVER_WORKSPACE;
	private static String ESA_CARTO_SERVER_URL;
	private static String ESA_CARTO_SERVER_WMS_URL;
	private static String ESA_CARTO_SERVER_WMS_ENDPOINT;

	private static String GEOSERVER_WMTS;

	/**
	 * NASA CARTO SERVER INFORMATION
	 */
	private static String  NASA_CARTO_SERVER_URL;

	private static String NASA_CARTO_SERVER_WMS_URL;
	private static String NASA_CARTO_SERVER_WMS_ENDPOINT;

	private static final Logger LOG = LoggerFactory.getLogger(VisualisationLayerPortlet.class.getName());
	private DataInterface dataService;
	private VisualisationInterface visualisationService;

	/**
	 * Setting a dataService to use
	 * 
	 * @param dataService
	 */
	@Reference
	public void setDataService(DataInterface dataService) {

		this.dataService = dataService;
	}

	/**
	 * Setting a visualisationService to use
	 * 
	 * @param visualisationService
	 */
	@Reference
	public void setVisualisationClientLocalService(VisualisationInterface visualisationService) {

		this.visualisationService = visualisationService;
	}

	/**
	 * Setting a Common Service to use
	 * 
	 * @param commonService
	 * @throws BmapException
	 */
	@Reference
	public void setCommonService(Common commonService) throws BmapException {

		/**
		 * SETTING ESA SERVER URL
		 */
		ESA_CARTO_SERVER_URL = commonService
				.getValueFromKeyInPropertiesFile(VisualisationLayerPortletKeys.ESA_CARTO_SERVER_URL_KEY);
		ESA_CARTO_SERVER_WORKSPACE = commonService
				.getValueFromKeyInPropertiesFile(VisualisationLayerPortletKeys.ESA_CARTO_SERVER_WORKSPACE_KEY);
		ESA_CARTO_SERVER_WMS_ENDPOINT = commonService
				.getValueFromKeyInPropertiesFile(VisualisationLayerPortletKeys.ESA_WMS_ENDPOINT_KEY);
		ESA_CARTO_SERVER_WMS_URL = ESA_CARTO_SERVER_URL + ESA_CARTO_SERVER_WORKSPACE + ESA_CARTO_SERVER_WMS_ENDPOINT;

		/**
		 * SETTING NASA SERVER URL
		 */

		NASA_CARTO_SERVER_URL = commonService
				.getValueFromKeyInPropertiesFile(VisualisationLayerPortletKeys.NASA_CARTO_SERVER_URL_KEY);
		NASA_CARTO_SERVER_WMS_ENDPOINT = commonService
				.getValueFromKeyInPropertiesFile(VisualisationLayerPortletKeys.NASA_WMS_ENDPOINT_KEY);
		NASA_CARTO_SERVER_WMS_URL = NASA_CARTO_SERVER_URL + NASA_CARTO_SERVER_WMS_ENDPOINT;

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet#render(javax.portlet
	 * .RenderRequest, javax.portlet.RenderResponse)
	 */
	@Override
	public void render(RenderRequest request, RenderResponse response) throws PortletException, java.io.IOException {
		LOG.info("rendering portlet");
		// getting granule attributes
		String granuleName = ParamUtil.getString(request, VisualisationLayerPortletKeys.GRANULE_NAME_PARAM);
		String collectionName = ParamUtil.getString(request, VisualisationLayerPortletKeys.COLLECTION_NAME_PARAM);
		Privacy privacyType =  Privacy.valueOf(ParamUtil.getString(request, VisualisationLayerPortletKeys.PRIVACY_TYPE_PARAM));
		// initializing extent of the view
		String minimumY = null;
		String minimumX = null;
		String maximumY = null;
		String maximumX = null;

		// Initializing granule object
		Granule granule = null;
		try {
			// getting granule object from granuleCriteria
			GranuleCriteria granuleCrit = new GranuleCriteria();
			List<String> collectionList = new ArrayList<>();
			collectionList.add(collectionName);
			granuleCrit.setCollectionNames(collectionList);
			granuleCrit.setGranuleName(granuleName);
			granuleCrit.setPrivacy(privacyType);
			granule = dataService.getGranuleByCriteria(granuleCrit).iterator().next();

			// getting fileType and setting attributes accordingly
			// Stats are used for colorSclae
			String fileType = null;
			String fileExtension = FilenameUtils.getExtension(granule.getDataList().get(0).getUrlToData());

			// if the file is a tiff, rendering statistics
			if (fileExtension.equalsIgnoreCase(Granule.RASTER_EXTENSION_TIFF)
					|| fileExtension.equalsIgnoreCase(Granule.RASTER_EXTENSION_TIF)) {
				fileType = Granule.RASTER_EXTENSION_TIFF;

				if (granule.getDataList().get(0).getMins() != null
						&& !granule.getDataList().get(0).getMins().isEmpty()) {
					request.setAttribute(VisualisationLayerPortletKeys.STATS_MIN_PARAM,
							granule.getDataList().get(0).getMins().get(0));
					request.setAttribute(VisualisationLayerPortletKeys.STATS_MAX_PARAM,
							granule.getDataList().get(0).getMaxs().get(0));
					request.setAttribute(VisualisationLayerPortletKeys.STATS_AVG_PARAM,
							granule.getDataList().get(0).getAvgs().get(0));
				} else {
					LOG.info("No statistics metadata in granule. Setting default ones");
					request.setAttribute(VisualisationLayerPortletKeys.STATS_MIN_PARAM, 0);
					request.setAttribute(VisualisationLayerPortletKeys.STATS_MAX_PARAM, 1);
					request.setAttribute(VisualisationLayerPortletKeys.STATS_AVG_PARAM, 0.5);
					granule.getDataList().get(0).setMins(new ArrayList<>());
					granule.getDataList().get(0).setAvgs(new ArrayList<>());
					granule.getDataList().get(0).setMaxs(new ArrayList<>());
					
					granule.getDataList().get(0).getMins().add(Double.valueOf("0"));
					granule.getDataList().get(0).getAvgs().add(Double.valueOf("0.5"));
					granule.getDataList().get(0).getMaxs().add(Double.valueOf("1"));
				}

			} else if (fileExtension.equals(Granule.PRODUCT_TYPE_SHP) || fileExtension.equals(Granule.PRODUCT_TYPE_SHX)
					|| fileExtension.equals(Granule.PRODUCT_TYPE_PRJ)
					|| fileExtension.equals(Granule.PRODUCT_TYPE_DBF)) {
				fileType = Granule.PRODUCT_TYPE_ROI;
				request.setAttribute(VisualisationLayerPortletKeys.STATS_MIN_PARAM, 0);
				request.setAttribute(VisualisationLayerPortletKeys.STATS_MAX_PARAM, 0);
				request.setAttribute(VisualisationLayerPortletKeys.STATS_AVG_PARAM, 0);
			}

			// setting map extent to either georeferenced coordinates if base granule is
			// geolocated, or granule width/height if non-geolocated
			if (granule.getDataList().get(0).getGeometryType().equals(Granule.GEOMETRY_TYPE_GEOLOCATED)) {
				Coordinate[] coordinateList = granule.getQuadrangle().getGeometry().getEnvelope().getCoordinates();

				minimumX = String.valueOf(coordinateList[0].x);
				minimumY = String.valueOf(coordinateList[0].y);

				maximumX = String.valueOf(coordinateList[2].x);
				maximumY = String.valueOf(coordinateList[2].y);

			} else {
				// non georeferenced granule, setting map extent to pixels height & width
				minimumX = String.valueOf(0);
				minimumY = String.valueOf(0);

				if (granule.getWidth() == null || granule.getHeight() == null) {
					LOG.info("no height or width information found for this granule");
					maximumX = String.valueOf(granule.getWidth());
					maximumY = String.valueOf(granule.getHeight());
				} else {
					maximumX = String.valueOf(250);
					maximumY = String.valueOf(250);
				}

			}

			// lvis_collection_level_2:ILVIS2_GA2016_0220_R1611_038024

			// setting attributes for render
			request.setAttribute(VisualisationLayerPortletKeys.FILE_TYPE_PARAM, fileType);
			request.setAttribute(VisualisationLayerPortletKeys.GRANULE_PARAM, granule);
			request.setAttribute(VisualisationLayerPortletKeys.MIN_X_PARAM, minimumX);
			request.setAttribute(VisualisationLayerPortletKeys.MIN_Y_PARAM, minimumY);
			request.setAttribute(VisualisationLayerPortletKeys.MAX_Y_PARAM, maximumY);
			request.setAttribute(VisualisationLayerPortletKeys.MAX_X_PARAM, maximumX);

			// request.setAttribute(VisualisationLayerPortletKeys.GEOSERVER_WMS_PARAM,
			request.setAttribute(VisualisationLayerPortletKeys.GEOSERVER_WMTS_PARAM, GEOSERVER_WMTS);

			request.setAttribute(VisualisationLayerPortletKeys.GEOSERVER_WMS_PARAM, ESA_CARTO_SERVER_WMS_URL);
			request.setAttribute(VisualisationLayerPortletKeys.NASA_CARTO_SERVER_WMS_PARAM, NASA_CARTO_SERVER_WMS_URL);
			// request.setAttribute(VisualisationLayerPortletKeys.GEOSERVER_WMTS_PARAM,

		} catch (BmapException e) {
			request.setAttribute(VisualisationLayerPortletKeys.ERROR_MESSAGE_ATTR, e.getMessage());
			SessionErrors.add(request, "error");
			LOG.error(e.getMessage(), e);
		}
		super.render(request, response);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet#serveResource(javax.
	 * portlet.ResourceRequest, javax.portlet.ResourceResponse)
	 */
	@Override
	public void serveResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse)
			throws IOException, PortletException {

		// getting resourceID and execute actions accordingly
		LOG.debug(resourceRequest.getResourceID());
		switch (resourceRequest.getResourceID()) {

		// Rendering result of Custom Profiling when this functionnality is triggered
		case VisualisationLayerPortletKeys.CUSTOM_PROFILE_TRIGGER:
			String jsonCustomProfile = null;
			try {
				// getting json response from customProfile service
				
				jsonCustomProfile = visualisationService.getRasterCustomProfile(ParamUtil.getString(resourceRequest, VisualisationLayerPortletKeys.COLLECTION_NAME_PARAM).toLowerCase()
								+ Granule.GRANULE_ID_DELIMITER
								+ ParamUtil.getString(resourceRequest, VisualisationLayerPortletKeys.GRANULE_NAME_PARAM),
						          ParamUtil.getString(resourceRequest, VisualisationLayerPortletKeys.VECTOR_WKT_PARAM));

				// printing json as response
				PrintWriter printout = resourceResponse.getWriter();
				printout.print(jsonCustomProfile);

			} catch (NumberFormatException | BmapException e) {
				resourceRequest.setAttribute(VisualisationLayerPortletKeys.ERROR_MESSAGE_ATTR, e.getMessage());
				SessionErrors.add(resourceRequest, "error");
				LOG.error(e.getMessage(), e);
			}
			break;

		// Rendering result of zonal statistics when this functionnality is triggered
		case VisualisationLayerPortletKeys.ZONAL_STATS_TRIGGER:

			String jsonZonalStats = null;
			try {
				// getting json response from zonalStats service
				jsonZonalStats = visualisationService.getRasterSubsetStats(ParamUtil.getString(resourceRequest, VisualisationLayerPortletKeys.COLLECTION_NAME_PARAM).toLowerCase()
						
								+ Granule.GRANULE_ID_DELIMITER
								+ ParamUtil.getString(resourceRequest, VisualisationLayerPortletKeys.GRANULE_NAME_PARAM),
								ParamUtil.getString(resourceRequest, VisualisationLayerPortletKeys.VECTOR_WKT_PARAM));

				// printing json as response
				PrintWriter printout = resourceResponse.getWriter();
				printout.print(jsonZonalStats);

			} catch (NumberFormatException | BmapException e) {
				resourceRequest.setAttribute(VisualisationLayerPortletKeys.ERROR_MESSAGE_ATTR, e.getMessage());
				SessionErrors.add(resourceRequest, "error");
				LOG.error(e.getMessage(), e);
			}
			break;

		}

	}

}