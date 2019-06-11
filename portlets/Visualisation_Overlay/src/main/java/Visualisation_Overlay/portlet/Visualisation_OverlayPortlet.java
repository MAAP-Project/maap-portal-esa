package Visualisation_Overlay.portlet;

import java.util.ArrayList;
import java.util.Arrays;

import javax.portlet.Portlet;
import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.apache.commons.io.FilenameUtils;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.esa.bmap.common.exceptions.BmapException;
import com.esa.bmap.common.service.Common;
import com.esa.bmap.data.api.DataInterface;
import com.esa.bmap.model.Granule;
import com.esa.bmap.model.GranuleCriteria;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.vividsolutions.jts.geom.Coordinate;

import Visualisation_Overlay.constants.Visualisation_OverlayPortletKeys;

/**
 * @author liferay
 */
@Component(immediate = true, property = { "com.liferay.portlet.display-category=category.sample",
		"com.liferay.portlet.instanceable=true", "javax.portlet.display-name=Visualisation_Overlay Portlet",
		"javax.portlet.init-param.template-path=/", "javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.name=" + Visualisation_OverlayPortletKeys.Visualisation_Overlay,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user" }, service = Portlet.class)
public class Visualisation_OverlayPortlet extends MVCPortlet {
	private static String GEOSERVER_WORKSPACE;
	private static String GEOSERVER_URL;

	private static Logger LOG;
	private DataInterface dataService;

	@Override
	public void init() throws PortletException {
		LOG = LoggerFactory.getLogger(this.getClass().getName());
		LOG.info("Portlet init");

		super.init();
	}

	/**
	 * Setting a data Service to use
	 * 
	 * @param restClient
	 */
	@Reference
	public void setDataService(DataInterface data) {

		this.dataService = data;
	}

	/**
	 * Setting a Common service to use
	 * 
	 * @param commonService
	 */
	@Reference
	public void setCommonService(Common commonService) {

		GEOSERVER_URL = commonService.getValueFromKeyInPropertiesFile("BMAP_GEOSERVER_URL");
		GEOSERVER_WORKSPACE = commonService.getValueFromKeyInPropertiesFile("BMAP_GEOSERVER_WORKSPACE");

	}

	@Override
	public void render(RenderRequest request, RenderResponse response) throws PortletException, java.io.IOException {
		LOG.info("Rendering Portlet");

		// Setting Geoserver WMS URL
		String geoserverWMS = GEOSERVER_URL + GEOSERVER_WORKSPACE + "/wms";
		LOG.info("Setting geoserverWMS :" + geoserverWMS);
		ArrayList<String> dataOverlayList = null;
		// Getting list of Data to do an overlay with
		String dataOverlayListS = request.getParameter("dataOverlayList");
		LOG.info(dataOverlayListS);

		if (dataOverlayListS != null) {
			dataOverlayList = new ArrayList<String>(Arrays.asList(dataOverlayListS.split(",")));
		}

		String granuleName = request.getParameter("granuleName");
		String collectionName = request.getParameter("collectionName");

		String minimumY = null;
		String minimumX = null;
		String maximumY = null;
		String maximumX = null;

		// getting Data object by the given Id
		Granule granule = null;
		try {

			granule = dataService.getGranuleByName(collectionName + ":@" + granuleName);

		} catch (BmapException e) {
			request.setAttribute("errorMessage", e.getMessage());
			SessionErrors.add(request, "error");
			LOG.info("Failed to get Data by its id :" + e);
		}

		// setting data Id et instance id as attribute for the portlet that will be
		// displayed
		String fileType = null;
		String fileExtension = FilenameUtils.getExtension(granule.getDataList().get(0).getFilePath());

		if (fileExtension.equals("tiff")) {
			fileType = "tiff";
		} else if (fileExtension.equals("shp") || fileExtension.equals("shx") || fileExtension.equals("prj")
				|| fileExtension.equals("dbf")) {
			fileType = "roi";
		}

		// Checking Object instance and setting bounding box as appropriate

		if (granule.getDataList().get(0).getGeometryType().equals("geolocated")) {
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

		// setting attribute needed by jsp for render
		request.setAttribute("fileType", fileType);
		request.setAttribute("granule", granule);
		request.setAttribute("minX", minimumX);
		request.setAttribute("minY", minimumY);
		request.setAttribute("maxY", maximumY);
		request.setAttribute("maxX", maximumX);

		ArrayList<Granule> granuleList = new ArrayList<>();

		try {
			granuleList.add(granule);

			if (dataOverlayList != null) {
				for (String granuleOverlayString : dataOverlayList) {

					String[] granuleOverlayTable = granuleOverlayString.split("/");

					if (granuleOverlayTable.length >= 2) {
						String granuleOverlayCollection = granuleOverlayTable[0];
						String granuleOverlayName = granuleOverlayTable[1];

						GranuleCriteria granuleCriteria = new GranuleCriteria();
						ArrayList<String> collectionNames = new ArrayList<String>();
						collectionNames.add(granuleOverlayCollection);
						granuleCriteria.setCollectionNames(collectionNames);
						granuleCriteria.setGranuleName(granuleOverlayName);
						Granule granuleOverlay = ((ArrayList<Granule>) dataService
								.getGranuleByCriteria(granuleCriteria)).get(0);
						granuleList.add(granuleOverlay);
					}
				}
			}

		} catch (BmapException e) {
			LOG.error("Failed to add the chosen Data to Overlay Data list " + e);

		}

		request.setAttribute("geoserverWMS", geoserverWMS);
		request.setAttribute("granuleList", granuleList);

		super.render(request, response);
	}

}
