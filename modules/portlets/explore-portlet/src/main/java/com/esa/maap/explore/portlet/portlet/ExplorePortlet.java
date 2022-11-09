package com.esa.maap.explore.portlet.portlet;

import com.esa.bmap.common.exceptions.BmapException;
import com.esa.maap.common.service.Common;
import com.esa.maap.explore.portlet.constants.ExplorePortletKeys;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;

import javax.portlet.Portlet;
import javax.portlet.PortletConfig;
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
		"com.liferay.portlet.display-category=category.sample",
		"com.liferay.portlet.header-portlet-css=/css/main.css",
		"com.liferay.portlet.instanceable=true",
		"javax.portlet.display-name=Explore",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.name=" + ExplorePortletKeys.EXPLORE,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user"
	},
	service = Portlet.class
)
public class ExplorePortlet extends MVCPortlet {
	
	private static Logger LOG;
	private String ESA_MAAP_EDAV_URL;
	
	@Override
	public void init (PortletConfig config) throws PortletException {
		LOG = LoggerFactory.getLogger(this.getClass().getName());
		LOG.info("Portlet init ");
		LOG.info("Edav init {}", ESA_MAAP_EDAV_URL);
		super.init(config);
	}
	
	@Reference
	public void setPlaceCommonLocalService(Common commonService) throws BmapException {

		ESA_MAAP_EDAV_URL = commonService.getValueFromKeyInPropertiesFile("ESA_MAAP_EDAV_URL");
		
	}
	
	/**
	 * During the render we get the path of variables
	 */
	@Override
	public void render (RenderRequest request, RenderResponse response)
			throws PortletException, java.io.IOException {
		LOG.info("Inside the render ");
		//We set the correct url
		LOG.info("Edav url render {}", ESA_MAAP_EDAV_URL);
		request.setAttribute("ESA_MAAP_EDAV_URL", ESA_MAAP_EDAV_URL);

		super.render(request, response);
	}
}