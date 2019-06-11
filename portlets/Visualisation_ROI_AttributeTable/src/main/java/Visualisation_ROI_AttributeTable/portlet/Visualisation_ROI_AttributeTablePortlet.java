package Visualisation_ROI_AttributeTable.portlet;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import javax.portlet.Portlet;
import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.esa.bmap.common.exceptions.BmapException;
import com.esa.bmap.common.service.Common;
import com.esa.bmap.data.api.DataInterface;
import com.esa.bmap.model.Granule;
import com.esa.bmap.model.GranuleCriteria;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONException;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.servlet.SessionErrors;

import Visualisation_ROI_AttributeTable.constants.Visualisation_ROI_AttributeTablePortletKeys;
import featurecollection.Feature;

/**
 * @author liferay
 */
@Component(immediate = true, property = { "com.liferay.portlet.display-category=category.sample",
		"com.liferay.portlet.instanceable=true", "javax.portlet.display-name=Visualisation_ROI_AttributeTable Portlet",
		"javax.portlet.init-param.template-path=/", "javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.name=" + Visualisation_ROI_AttributeTablePortletKeys.Visualisation_ROI_AttributeTable,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user" }, service = Portlet.class)
public class Visualisation_ROI_AttributeTablePortlet extends MVCPortlet {

	private static String GEOSERVER_WORKSPACE;
	private static String GEOSERVER_URL;

	private static Logger LOG = LoggerFactory.getLogger(Visualisation_ROI_AttributeTablePortlet.class);
	private DataInterface dataService;

	@Override
	public void init() throws PortletException {

		LOG.info("Portlet init");

		super.init();
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
	 * Setting a restClient to use
	 * 
	 * @param restClient
	 */
	@Reference
	public void setCommonService(Common commonService) {

		GEOSERVER_URL = commonService.getValueFromKeyInPropertiesFile("BMAP_GEOSERVER_URL");
		GEOSERVER_WORKSPACE = commonService.getValueFromKeyInPropertiesFile("BMAP_GEOSERVER_WORKSPACE");

	}

	@Override
	public void render(RenderRequest renderRequest, RenderResponse renderResponse)
			throws PortletException, java.io.IOException {

		String granuleName = renderRequest.getParameter("granuleName");
		String collectionName = renderRequest.getParameter("collectionName");

		LOG.info("rendering portlet");
		String geoserverRequestUrl = GEOSERVER_URL + GEOSERVER_WORKSPACE + "/ows";

		// getting Data object by a given Id
		Granule granule = null;
		try {

			// searching granule with given criteria
			GranuleCriteria granuleCriteria = new GranuleCriteria();
			ArrayList<String> collectionNames = new ArrayList<String>();
			collectionNames.add(collectionName);
			granuleCriteria.setCollectionNames(collectionNames);
			granuleCriteria.setGranuleName(granuleName);
			granule = ((ArrayList<Granule>) dataService.getGranuleByCriteria(granuleCriteria)).get(0);
			renderRequest.setAttribute("data", granule);

		} catch (BmapException e) {
			renderRequest.setAttribute("errorMessage", e.getMessage());
			SessionErrors.add(renderRequest, "error");
			LOG.error("Failed to get Data by its id :" + e);
		}

		try {

			String url = geoserverRequestUrl + "?SERVICE=WFS&VERSION=1.1.1&REQUEST=GetFeature&typename="
					+ granule.getDataList().get(0).getLayerName() + "&outputFormat=application/json";

			URL obj = new URL(url);

			HttpURLConnection con = (HttpURLConnection) obj.openConnection();
			// optional default is GET
			con.setRequestMethod("GET");

			BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
			String inputLine;
			StringBuilder response = new StringBuilder();
			while ((inputLine = in.readLine()) != null) {
				response.append(inputLine);
			}
			in.close();

			JSONObject roiLayerInfo = JSONFactoryUtil.createJSONObject(response.toString());
			JSONArray featureCollection = roiLayerInfo.getJSONArray("features");

			ArrayList<Feature> listFeatures = new ArrayList<Feature>();

			int keyid = 1;

			for (Object object : featureCollection) {

				HashMap<String, String> featureAttributeTable = new HashMap<String, String>();

				Feature roiFeature = new Feature(keyid, featureAttributeTable);

				JSONObject jsonFeature = JSONFactoryUtil.createJSONObject(object.toString());

				JSONObject featureProperties = JSONFactoryUtil.createJSONObject(jsonFeature.getString("properties"));

				Iterator<?> keys = featureProperties.keys();
				while (keys.hasNext()) {

					String key = (String) keys.next();
					String value = featureProperties.get(key).toString();

					roiFeature.getAttributeTable().put(key, value);
				}

				listFeatures.add(roiFeature);

				keyid++;
			}

			renderRequest.setAttribute("listFeatures", listFeatures);

		} catch (JSONException e) {

			LOG.error("Couldn't parse the ROI attribute Table");
		}

		super.render(renderRequest, renderResponse);
	}

}