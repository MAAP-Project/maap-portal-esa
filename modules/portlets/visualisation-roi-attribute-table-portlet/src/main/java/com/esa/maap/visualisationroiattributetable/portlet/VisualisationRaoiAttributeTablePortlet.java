package com.esa.maap.visualisationroiattributetable.portlet;

import com.esa.bmap.common.exceptions.BmapException;
import com.esa.bmap.model.Granule;
import com.esa.bmap.model.GranuleCriteria;
import com.esa.bmap.model.Privacy;
import com.esa.maap.common.service.Common;
import com.esa.maap.data.api.DataInterface;
import com.esa.maap.model.roi.featurecollection.Feature;
import com.esa.maap.visualisationroiattributetable.constants.VisualisationRaoiAttributeTablePortletKeys;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONException;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.util.ParamUtil;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.portlet.Portlet;
import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

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
		"com.liferay.portlet.display-category=Maap",
		"com.liferay.portlet.header-portlet-css=/css/main.css",
		"com.liferay.portlet.instanceable=true",
		"javax.portlet.display-name=VisualisationRaoiAttributeTable",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.name=" + VisualisationRaoiAttributeTablePortletKeys.VISUALISATIONRAOIATTRIBUTETABLE,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user"
	},
	service = Portlet.class
)
public class VisualisationRaoiAttributeTablePortlet extends MVCPortlet {
	private static String GEOSERVER_WORKSPACE;
	private static String GEOSERVER_URL;
	private static String GEOSERVER_WMS;
	private final static Logger LOG = LoggerFactory.getLogger(VisualisationRaoiAttributeTablePortlet.class);
	private DataInterface dataService;

	// GEOSERVER
	private static final String GEOSERVER_URL_KEY = "BMAP_GEOSERVER_URL";
	private static final String GEOSERVER_WORKSPACE_KEY = "BMAP_GEOSERVER_WORKSPACE";
	private static final String WMS_URL = "/wms";
	
	private static String ERROR_MESSAGE_ATTR = "errorMessage";
	
	private static final String GRANULE_NAME_PARAM = "granuleName";
	private static final String COLLECTION_NAME_PARAM = "collectionName";
	private static final String PRIVACY_TYPE_PARAM = "privacyType";
	
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
	 * @throws BmapException 
	 */
	@Reference
	public void setCommonService(Common commonService) throws BmapException {

		GEOSERVER_URL = commonService.getValueFromKeyInPropertiesFile(GEOSERVER_URL_KEY);
		GEOSERVER_WORKSPACE = commonService.getValueFromKeyInPropertiesFile(GEOSERVER_WORKSPACE_KEY);
		GEOSERVER_WMS = GEOSERVER_URL + GEOSERVER_WORKSPACE + WMS_URL;

	}

	@Override
	public void render(RenderRequest renderRequest, RenderResponse renderResponse)
			throws PortletException, java.io.IOException {

		String granuleName = ParamUtil.getString(renderRequest, GRANULE_NAME_PARAM);
		String collectionName = ParamUtil.getString(renderRequest, COLLECTION_NAME_PARAM);

		LOG.info("rendering portlet");

		// getting Data object by a given Id
		Granule granule = null;
		try {

			GranuleCriteria granuleCrit = new GranuleCriteria();
			List<String> collectionList = new ArrayList<>();
			collectionList.add(collectionName);
			granuleCrit.setCollectionNames(collectionList);
			granuleCrit.setGranuleName(granuleName);
			granuleCrit.setPrivacy(Privacy.valueOf(ParamUtil.getString(renderRequest, PRIVACY_TYPE_PARAM)));
			granule = dataService.getGranuleByCriteria(granuleCrit).iterator().next();
			renderRequest.setAttribute("data", granule);

			String url = GEOSERVER_WMS + "?SERVICE=WFS&VERSION=1.1.1&REQUEST=GetFeature&typename="
					+ granule.getDataList().get(0).getLayerName() + "&outputFormat=application/json";

			ArrayList<Feature> listFeatures = getFeaturesFromLayer(url);

			renderRequest.setAttribute("listFeatures", listFeatures);

		} catch (BmapException | JSONException e) {
			renderRequest.setAttribute(ERROR_MESSAGE_ATTR, e.getMessage());
			SessionErrors.add(renderRequest, "error");
			LOG.error(e.getMessage(), e);
		}

		super.render(renderRequest, renderResponse);
	}

	/**
	 * Get feature list from geoserver data shapefile url
	 * 
	 * @param geoserver layer url
	 * @return list of Feature objects
	 * @throws IOException
	 * @throws JSONException
	 */
	private ArrayList<Feature> getFeaturesFromLayer(String url) throws IOException, JSONException {
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

		return extractFeatureFromJson(response);
	}

	/**
	 * extract feature objects from a json string
	 * @param response
	 * @return
	 * @throws JSONException
	 */
	private ArrayList<Feature> extractFeatureFromJson(StringBuilder response) throws JSONException {
		JSONObject roiLayerInfo = JSONFactoryUtil.createJSONObject(response.toString());
		JSONArray featureCollection = roiLayerInfo.getJSONArray("features");

		ArrayList<Feature> listFeatures = new ArrayList<>();

		int keyid = 1;

		for (Object object : featureCollection) {

			HashMap<String, String> featureAttributeTable = new HashMap<>();

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
		return listFeatures;
	}
}