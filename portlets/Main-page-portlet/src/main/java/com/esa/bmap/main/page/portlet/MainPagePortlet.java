package com.esa.bmap.main.page.portlet;

import javax.portlet.Portlet;
import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.osgi.service.component.annotations.Component;

import com.esa.bmap.main.page.constants.MainPagePortletKeys;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;

/**
 * @author liferay
 */
@Component(
		immediate = true,
		property = {
				"com.liferay.portlet.display-category=Welcome",
				"com.liferay.portlet.instanceable=true",
				"javax.portlet.display-name=Main-page-portlet Portlet",
				"javax.portlet.init-param.template-path=/",
				"javax.portlet.init-param.view-template=/view.jsp",
				"javax.portlet.name=" + MainPagePortletKeys.MainPage,
				"javax.portlet.resource-bundle=content.Language",
				"javax.portlet.security-role-ref=power-user,user"
		},
		service = Portlet.class
		)
public class MainPagePortlet extends MVCPortlet {


	@Override
	public void render (RenderRequest request, RenderResponse response)	throws PortletException, java.io.IOException {
		
	}
}