package com.esa.bamp.algorithm.catalogue.portlet.portlet;

import com.esa.bamp.algorithm.catalogue.portlet.constants.AlgorithmCataloguePortletKeys;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;

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
 * @author liferay
 */
@Component(
		immediate = true,
		property = {
				"com.liferay.portlet.display-category=category.catalogue",
				"com.liferay.portlet.instanceable=true",
				"javax.portlet.display-name=Algorithm-catalogue-portlet Portlet",
				"javax.portlet.init-param.template-path=/",
				"javax.portlet.init-param.view-template=/view.jsp",
				"javax.portlet.name=" + AlgorithmCataloguePortletKeys.AlgorithmCatalogue,
				"javax.portlet.resource-bundle=content.Language",
				"javax.portlet.security-role-ref=power-user,user"
		},
		service = Portlet.class
		)
public class AlgorithmCataloguePortlet extends MVCPortlet {


	public void render(RenderRequest request, RenderResponse response) throws PortletException, java.io.IOException {

		// redirect to a specify form if redirectJSP parameter exists
		if (request.getParameter("redirectJSP") == null || request.getParameter("redirectJSP").equals("")) {
			super.render(request, response);
		} else {

			PortletRequestDispatcher dispatcher = getPortletContext()
					.getRequestDispatcher("/" + request.getParameter("redirectJSP") + ".jsp");
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

		response.setRenderParameter("redirectJSP", request.getParameter("redirectURL"));
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

		System.out.println("je suis dans la redirection");
		response.setRenderParameter("redirectJSP", request.getParameter("redirectURL"));
	}
	
}