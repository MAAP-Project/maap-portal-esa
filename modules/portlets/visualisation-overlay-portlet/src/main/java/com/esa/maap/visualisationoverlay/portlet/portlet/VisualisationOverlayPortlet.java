package com.esa.maap.visualisationoverlay.portlet.portlet;

import com.esa.bmap.common.exceptions.BmapException;
import com.esa.bmap.model.Granule;
import com.esa.bmap.model.GranuleCriteria;
import com.esa.bmap.model.Privacy;
import com.esa.maap.common.service.Common;
import com.esa.maap.data.api.DataInterface;
import com.esa.maap.visualisation.api.VisualisationInterface;
import com.esa.maap.visualisationoverlay.portlet.constants.VisualisationOverlayPortletKeys;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.util.ParamUtil;
import com.vividsolutions.jts.geom.Coordinate;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
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
		"javax.portlet.display-name=VisualisationOverlay",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.name=" + VisualisationOverlayPortletKeys.VISUALISATIONOVERLAY,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user"
	},
	service = Portlet.class
)
public class VisualisationOverlayPortlet extends MVCPortlet {
	
	private static final Logger LOG = LoggerFactory.getLogger(VisualisationOverlayPortlet.class.getName());

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
	private static String NASA_CARTO_SERVER_URL;

	private static String NASA_CARTO_SERVER_WMS_URL;
	private static String NASA_CARTO_SERVER_WMS_ENDPOINT;

	private DataInterface dataService;
	private VisualisationInterface visualisationService;

	/**
	 * Setting a data Service to use
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
	 * Setting a Common service to use
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
				.getValueFromKeyInPropertiesFile(VisualisationOverlayPortletKeys.ESA_CARTO_SERVER_URL_KEY);
		ESA_CARTO_SERVER_WORKSPACE = commonService
				.getValueFromKeyInPropertiesFile(VisualisationOverlayPortletKeys.ESA_CARTO_SERVER_WORKSPACE_KEY);
		ESA_CARTO_SERVER_WMS_ENDPOINT = commonService
				.getValueFromKeyInPropertiesFile(VisualisationOverlayPortletKeys.ESA_WMS_ENDPOINT_KEY);
		ESA_CARTO_SERVER_WMS_URL = ESA_CARTO_SERVER_URL + ESA_CARTO_SERVER_WORKSPACE + ESA_CARTO_SERVER_WMS_ENDPOINT;

		/**
		 * SETTING NASA SERVER URL
		 */

		NASA_CARTO_SERVER_URL = commonService
				.getValueFromKeyInPropertiesFile(VisualisationOverlayPortletKeys.NASA_CARTO_SERVER_URL_KEY);
		NASA_CARTO_SERVER_WMS_ENDPOINT = commonService
				.getValueFromKeyInPropertiesFile(VisualisationOverlayPortletKeys.NASA_WMS_ENDPOINT_KEY);
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
		LOG.info("Rendering Portlet");

		// setting overlay granuleUR list
		List<String> granuleURList = null;
		// setting overlay granules list
		List<Granule> granuleOverlayList = new ArrayList<>();

		// initializing extent of the view
		String minimumY = null;
		String minimumX = null;
		String maximumY = null;
		String maximumX = null;

		// getting base granule attributes
		String granuleName =  ParamUtil.getString(request, VisualisationOverlayPortletKeys.GRANULE_NAME_PARAM);
		String collectionName = ParamUtil.getString(request, VisualisationOverlayPortletKeys.COLLECTION_NAME_PARAM);

		// Getting list of Granule used to generate overlay
		String dataOverlayListS = ParamUtil.getString(request, VisualisationOverlayPortletKeys.DATA_OVERLAYLIST_PARAM);

		// Initializing base granule object
		Granule granule = null;

		// if not null split the string to get list of granuleUR
		if (dataOverlayListS != null) {
			granuleURList = new ArrayList<>(Arrays.asList(dataOverlayListS.split(",")));
		}

		try {
			// getting granule object from granuleCriteria
			GranuleCriteria granuleCrit = new GranuleCriteria();
			List<String> collectionList = new ArrayList<>();
			collectionList.add(collectionName);
			granuleCrit.setCollectionNames(collectionList);
			granuleCrit.setGranuleName(granuleName);
			granuleCrit.setPrivacy(
					Privacy.valueOf(ParamUtil.getString(request, VisualisationOverlayPortletKeys.PRIVACY_TYPE_PARAM)));
			granule = dataService.getGranuleByCriteria(granuleCrit).iterator().next();

			String fileType = null;
			String fileExtension = FilenameUtils.getExtension(granule.getDataList().get(0).getUrlToData());

			// if the file is a tiff, rendering statistics
			if (fileExtension.equalsIgnoreCase(Granule.RASTER_EXTENSION_TIFF)
					|| fileExtension.equalsIgnoreCase(Granule.RASTER_EXTENSION_TIF)) {
				fileType = Granule.RASTER_EXTENSION_TIFF;

				if (granule.getDataList().get(0).getMins() != null
						&& !granule.getDataList().get(0).getMins().isEmpty()) {
					request.setAttribute(VisualisationOverlayPortletKeys.STATS_MIN_PARAM,
							granule.getDataList().get(0).getMins().get(0));
					request.setAttribute(VisualisationOverlayPortletKeys.STATS_MAX_PARAM,
							granule.getDataList().get(0).getMaxs().get(0));
					request.setAttribute(VisualisationOverlayPortletKeys.STATS_AVG_PARAM,
							granule.getDataList().get(0).getAvgs().get(0));
				} else {
					LOG.info("No statistics metadata in granule. Setting default ones");
					request.setAttribute(VisualisationOverlayPortletKeys.STATS_MIN_PARAM, 0);
					request.setAttribute(VisualisationOverlayPortletKeys.STATS_MAX_PARAM, 1);
					request.setAttribute(VisualisationOverlayPortletKeys.STATS_AVG_PARAM, 0.5);
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
				request.setAttribute(VisualisationOverlayPortletKeys.STATS_MIN_PARAM, 0);
				request.setAttribute(VisualisationOverlayPortletKeys.STATS_MAX_PARAM, 0);
				request.setAttribute(VisualisationOverlayPortletKeys.STATS_AVG_PARAM, 0);
			}
			// setting map extent to either georeferenced coordinates if base granule is
			// geolocated, or granule width/height if non-geolocated
			if (granule.getDataList().get(0).getGeometryType().equals(Granule.GEOMETRY_TYPE_GEOLOCATED)) {
				Coordinate[] coordinateList = granule.getQuadrangle().getGeometry().getEnvelope().getCoordinates();
				minimumY = String.valueOf(coordinateList[0].y);
				minimumX = String.valueOf(coordinateList[0].x);
				maximumY = String.valueOf(coordinateList[2].y);
				maximumX = String.valueOf(coordinateList[2].x);

			} else {

				minimumY = String.valueOf(0);
				minimumX = String.valueOf(0);
				maximumY = String.valueOf(granule.getHeight());
				maximumX = String.valueOf(granule.getWidth());

			}

			// adding base granule to overlay granule list
			granuleOverlayList.add(granule);

			// for each granuleUR in granuleURlist, getting the granules object and adding
			// them to overlay granule list
			if (granuleURList != null) {
				for (String granuleOverlayString : granuleURList) {
					// splitting granuleUR to get granuleCollection & granuleName
					String[] granuleURTable = granuleOverlayString.split("/");

					if (granuleURTable.length >= 2) {
						// getting granule collection & name
						String granuleOverlayCollection = granuleURTable[0];
						String granuleOverlayName = granuleURTable[1];

						// getting granule object from granuleCriteria
						GranuleCriteria granuleCritOver = new GranuleCriteria();
						List<String> collectionListOver = new ArrayList<String>();
						
						collectionListOver.add(granuleOverlayCollection);
						granuleCritOver.setCollectionNames(collectionListOver);
						granuleCritOver.setGranuleName(granuleOverlayName);
						Granule granuleOverlay = dataService.getGranuleByCriteria(granuleCritOver).iterator().next();
						// adding retrieved granule to arraylist
						granuleOverlayList.add(granuleOverlay);
					}
				}
			}

			// setting attributes for render
			request.setAttribute(VisualisationOverlayPortletKeys.FILE_TYPE_PARAM, fileType);
			request.setAttribute(VisualisationOverlayPortletKeys.GRANULE_PARAM, granule);
			request.setAttribute(VisualisationOverlayPortletKeys.MIN_X_PARAM, minimumX);
			request.setAttribute(VisualisationOverlayPortletKeys.MIN_Y_PARAM, minimumY);
			request.setAttribute(VisualisationOverlayPortletKeys.MAX_Y_PARAM, maximumY);
			request.setAttribute(VisualisationOverlayPortletKeys.MAX_X_PARAM, maximumX);
			request.setAttribute(VisualisationOverlayPortletKeys.GEOSERVER_WMS_PARAM, ESA_CARTO_SERVER_WMS_URL);
			request.setAttribute(VisualisationOverlayPortletKeys.GEOSERVER_WMTS_PARAM, GEOSERVER_WMTS);
			request.setAttribute(VisualisationOverlayPortletKeys.GRANULE_LIST_PARAM, granuleOverlayList);
			request.setAttribute(VisualisationOverlayPortletKeys.NASA_CARTO_SERVER_WMS_PARAM,
					NASA_CARTO_SERVER_WMS_URL);

		} catch (BmapException e) {
			request.setAttribute(VisualisationOverlayPortletKeys.ERROR_MESSAGE_ATTR, e.getMessage());
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

		// Rendering result of ROI statistics when this functionnality is triggered
		case VisualisationOverlayPortletKeys.ROI_STATS_TRIGGER:
			LOG.info("Generating raster Statistics from roi");
			String jsonRoiStats = null;
			try {
				String rasterGranule[] = ParamUtil.getString(resourceRequest, VisualisationOverlayPortletKeys.GRANULE_RASTER_ID_PARAM)
						.split(Granule.GRANULE_ID_DELIMITER);
				String roiGranule[] =  ParamUtil.getString(resourceRequest, VisualisationOverlayPortletKeys.GRANULE_ROI_ID_PARAM).split(Granule.GRANULE_ID_DELIMITER);
				// getting json response from customProfile service
				jsonRoiStats = visualisationService.getRasterRoiSubsetStats(
						rasterGranule[0].toLowerCase() + Granule.GRANULE_ID_DELIMITER + rasterGranule[1],
						roiGranule[0].toLowerCase() + Granule.GRANULE_ID_DELIMITER + roiGranule[1]);
				// printing json as response
				PrintWriter printout = resourceResponse.getWriter();
				printout.print(jsonRoiStats);

			} catch (NumberFormatException | BmapException e) {
				resourceRequest.setAttribute(VisualisationOverlayPortletKeys.ERROR_MESSAGE_ATTR, e.getMessage());
				SessionErrors.add(resourceRequest, "error");
				LOG.error(e.getMessage(), e);
			}
			break;

		// Rendering result of raster Comparison when this functionnality is triggered
		case VisualisationOverlayPortletKeys.RASTER_COMPARISON_TRIGGER:
			LOG.info("Generating raster scatterplot from wkt");
			String jsonPlotComparison = null;
			try {
				String xAxis[] = ParamUtil.getString(resourceRequest, VisualisationOverlayPortletKeys.GRANULE_RASTER_XAXIS_PARAM)
						.split(Granule.GRANULE_ID_DELIMITER);
				String yAxis[] = ParamUtil.getString(resourceRequest, VisualisationOverlayPortletKeys.GRANULE_RASTER_YAXIS_PARAM)
						.split(Granule.GRANULE_ID_DELIMITER);
				jsonPlotComparison = visualisationService.getRasterPlotComparison(
						xAxis[0].toLowerCase() + Granule.GRANULE_ID_DELIMITER + xAxis[1],
						yAxis[0].toLowerCase() + Granule.GRANULE_ID_DELIMITER + yAxis[1],
						ParamUtil.getString(resourceRequest, VisualisationOverlayPortletKeys.WKT_VECTOR_PARAM));

				// printing json as response
				PrintWriter printout = resourceResponse.getWriter();
				printout.print(jsonPlotComparison);

			} catch (NumberFormatException | BmapException e) {
				resourceRequest.setAttribute(VisualisationOverlayPortletKeys.ERROR_MESSAGE_ATTR, e.getMessage());
				SessionErrors.add(resourceRequest, "error");
				LOG.error(e.getMessage(), e);
			}
			break;

		}

	}
}