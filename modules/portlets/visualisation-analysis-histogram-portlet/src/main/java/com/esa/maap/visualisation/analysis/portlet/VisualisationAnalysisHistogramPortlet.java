package com.esa.maap.visualisation.analysis.portlet;

import com.esa.bmap.common.exceptions.BmapException;
import com.esa.bmap.model.Granule;
import com.esa.bmap.model.GranuleCriteria;
import com.esa.bmap.model.Privacy;
import com.esa.maap.data.api.DataInterface;
import com.esa.maap.visualisation.analysis.portlet.constants.VisualisationAnalysisHistogramPortletKeys;
import com.esa.maap.visualisation.api.VisualisationInterface;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONException;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.util.ParamUtil;

import java.util.ArrayList;
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
		"javax.portlet.display-name=VisualisationAnalysisHistogram",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.name=" + VisualisationAnalysisHistogramPortletKeys.VISUALISATIONANALYSISHISTOGRAM,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user"
	},
	service = Portlet.class
)
public class VisualisationAnalysisHistogramPortlet extends MVCPortlet {
	
	private static final Logger LOG = LoggerFactory.getLogger(VisualisationAnalysisHistogramPortlet.class.getName());
	private DataInterface dataService;
	private VisualisationInterface visualisationService;

	private static final String GRANULE_NAME_PARAM = "granuleName";
	private static final String GRANULE_PARAM = "granule";
	private static final String PRIVACY_TYPE_PARAM = "privacyType";
	private static final String COLLECTION_NAME_PARAM = "collectionName";
	private static final String JSON_HISTOGRAM_PARAM = "jsonHist";
	private static final String ERROR_MESSAGE_ATTR = "errorMessage";

	@Reference
	public void setDataClientLocalService(DataInterface data) {

		this.dataService = data;
	}

	@Reference
	public void setVisualisationClientLocalService(VisualisationInterface visualisation) {

		this.visualisationService = visualisation;
	}

	@Override
	public void render(RenderRequest request, RenderResponse response) throws PortletException, java.io.IOException {

		LOG.info("rendering portlet");
		// getting granule attributes
		String granuleName = ParamUtil.getString(request, GRANULE_NAME_PARAM);
		String collectionName = ParamUtil.getString(request, COLLECTION_NAME_PARAM);
		// initializing json hist String
		String jsonHist = null;
		// initializing granule object
		Granule granule = null;
		try {
			GranuleCriteria granuleCrit = new GranuleCriteria();
			List<String> collectionList = new ArrayList<>();
			collectionList.add(collectionName);
			granuleCrit.setCollectionNames(collectionList);
			granuleCrit.setGranuleName(granuleName);
			granuleCrit.setPrivacy(Privacy.valueOf(ParamUtil.getString(request, PRIVACY_TYPE_PARAM)));
			granule = dataService.getGranuleByCriteria(granuleCrit).iterator().next();
			// getting granule histogram from granuleUR
			jsonHist = getDataHistogram(collectionName.toLowerCase() + Granule.GRANULE_ID_DELIMITER + granuleName);

			request.setAttribute(GRANULE_PARAM, granule);
			request.setAttribute(JSON_HISTOGRAM_PARAM, jsonHist);

		} catch (BmapException e) {
			request.setAttribute(ERROR_MESSAGE_ATTR, e.getMessage());
			SessionErrors.add(request, "error");
			LOG.error(e.getMessage(), e);
		}

		super.render(request, response);
	}

	/**
	 * Get json histogram representing granule pixel's frequency
	 * 
	 * @param granuleId
	 * @return json String representing histogram
	 * @throws BmapException
	 */
	public String getDataHistogram(String granuleId) throws BmapException {
		JSONArray jsonArray = JSONFactoryUtil.createJSONArray();
		JSONObject jsonObject = null;

		try {
			// get json string from raster histogram service
			String json = visualisationService.getRasterHistogram(granuleId);

			jsonObject = JSONFactoryUtil.createJSONObject(json);
			jsonArray.put(jsonObject);
		} catch (JSONException e) {
			throw new BmapException(e.getMessage(), e);
		}

		return jsonArray.toString();
	}

}