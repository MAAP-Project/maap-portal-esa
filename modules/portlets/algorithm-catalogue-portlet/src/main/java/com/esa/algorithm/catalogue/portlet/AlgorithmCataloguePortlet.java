package com.esa.algorithm.catalogue.portlet;

import com.esa.algorithm.catalogue.constants.AlgorithmCataloguePortletKeys;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.util.ParamUtil;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.Portlet;
import javax.portlet.PortletException;
import javax.portlet.PortletRequestDispatcher;
import javax.portlet.ProcessAction;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.osgi.service.component.annotations.Component;

/**
 * @author tkossoko
 */
@Component(
	immediate = true,
	property = {
		"com.liferay.portlet.display-category=Maap",
		"com.liferay.portlet.header-portlet-css=/css/main.css",
		"com.liferay.portlet.instanceable=true",
		"javax.portlet.display-name=AlgorithmCatalogue",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.name=" + AlgorithmCataloguePortletKeys.ALGORITHMCATALOGUE,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user"
	},
	service = Portlet.class
)
public class AlgorithmCataloguePortlet extends MVCPortlet {
	
	public void render(RenderRequest request, RenderResponse response) throws PortletException, java.io.IOException {

		// redirect to a specify form if redirectJSP parameter exists
		if (ParamUtil.getString(request, "redirectJSP") == null || ParamUtil.getString(request, "redirectJSP").isEmpty()) {
			super.render(request, response);
		} else {

			PortletRequestDispatcher dispatcher = getPortletContext()
					.getRequestDispatcher("/" + ParamUtil.getString(request, "redirectJSP") + ".jsp");
			dispatcher.include(request, response);
		}
	}


	/**
	 * We redirect the user to the form of algorithm officialisation
	 * @param request
	 * @param response
	 * @throws PortletException
	 * @throws java.io.IOException
	 */
	@ProcessAction(name = "redirectionOfficialisationAlgoForm")
	public void redirectionOfficialisationAlgoForm (ActionRequest request, ActionResponse response) throws PortletException, java.io.IOException {

		response.setRenderParameter("redirectJSP", ParamUtil.getString(request, "redirectURL"));
	}
	
	
	/**
	 * We redirect the user when he clicks on link from the side-menu (for example RADAR page)
	 * @param request
	 * @param response
	 * @throws PortletException
	 * @throws java.io.IOException
	 */
	@ProcessAction(name = "redirectionFromSideMenu")
	public void redirectionFromSideMenu (ActionRequest request, ActionResponse response) throws PortletException, java.io.IOException {

		response.setRenderParameter("redirectJSP", ParamUtil.getString(request, "redirectURL"));
	}
	
}