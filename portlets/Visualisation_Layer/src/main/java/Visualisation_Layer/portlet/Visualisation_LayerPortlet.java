package Visualisation_Layer.portlet;

import java.util.ArrayList;

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

import Visualisation_Layer.constants.Visualisation_LayerPortletKeys;

/**
 * @author liferay
 */
@Component(immediate = true, property = { "com.liferay.portlet.display-category=Visualisation",
		"com.liferay.portlet.instanceable=true", "javax.portlet.display-name=Visualisation_Layer Portlet",
		"javax.portlet.init-param.template-path=/", "javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.name=" + Visualisation_LayerPortletKeys.Visualisation_Layer,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user" }, service = Portlet.class)
public class Visualisation_LayerPortlet extends MVCPortlet {

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
	 * Setting a dataService to use
	 * 
	 * @param dataService
	 */
	@Reference
	public void setDataService(DataInterface dataService) {

		this.dataService = dataService;
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

		String geoserverWMS = GEOSERVER_URL + GEOSERVER_WORKSPACE + "/wms";
		//

		String granuleName = request.getParameter("granuleName");
		String collectionName = request.getParameter("collectionName");

		// Initializing data bounds
		String minimumY = null;
		String minimumX = null;
		String maximumY = null;
		String maximumX = null;

		// getting Data object by a given Id
		Granule granule = null;
		try {

			granule = dataService.getGranuleByName(collectionName + ":@" + granuleName);
		

			// setting data Id et instance id as attribute for the portlet that will be
			// displayed
			String fileType = null;
			String fileExtension = FilenameUtils.getExtension(granule.getDataList().get(0).getFilePath());

			if (fileExtension.equals("tiff")) {
				fileType = "tiff";

				request.setAttribute("statsMin", granule.getDataList().get(0).getMins().get(0));
				request.setAttribute("statsMax", granule.getDataList().get(0).getMaxs().get(0));
				request.setAttribute("statsAvg", granule.getDataList().get(0).getAvgs().get(0));

			} else if (fileExtension.equals("shp") || fileExtension.equals("shx") || fileExtension.equals("prj")
					|| fileExtension.equals("dbf")) {
				fileType = "roi";
			}

			// Checking Object instance and setting bounding box as appropriate

			if (granule.getDataList().get(0).getGeometryType().equals("geolocated")) {
				Coordinate[] coordinateList = granule.getQuadrangle().getGeometry().getEnvelope().getCoordinates();

				minimumX = String.valueOf(coordinateList[0].x);
				minimumY = String.valueOf(coordinateList[0].y);

				maximumX = String.valueOf(coordinateList[2].x);
				maximumY = String.valueOf(coordinateList[2].y);

			} else {
				minimumX = String.valueOf(0);
				minimumY = String.valueOf(0);

				maximumX = String.valueOf(granule.getWidth());
				maximumY = String.valueOf(granule.getHeight());

			}

			// setting attribute needed by jsp for render
			request.setAttribute("fileType", fileType);
			request.setAttribute("granule", granule);
			request.setAttribute("minX", minimumX);
			request.setAttribute("minY", minimumY);
			request.setAttribute("maxY", maximumY);
			request.setAttribute("maxX", maximumX);

			request.setAttribute("geoserverWMS", geoserverWMS);
		} catch (BmapException e) {
			request.setAttribute("errorMessage", e.getMessage());
			SessionErrors.add(request, "error");
			LOG.error(e.getMessage());
		}
		super.render(request, response);
	}

}
