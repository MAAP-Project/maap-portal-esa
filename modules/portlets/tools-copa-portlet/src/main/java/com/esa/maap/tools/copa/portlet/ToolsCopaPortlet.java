package com.esa.maap.tools.copa.portlet;

import com.esa.bmap.common.exceptions.BmapException;
import com.esa.maap.common.service.Common;
import com.esa.maap.tools.copa.constants.ToolsCopaPortletKeys;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.WebKeys;

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
		"com.liferay.portlet.display-category=Tools",
		"com.liferay.portlet.header-portlet-css=/css/main.css",
		"com.liferay.portlet.instanceable=true",
		"javax.portlet.display-name=ToolsCopa",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.name=" + ToolsCopaPortletKeys.TOOLSCOPA,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user"
	},
	service = Portlet.class
)
public class ToolsCopaPortlet extends MVCPortlet {
	
	private static Logger Log;
	private String BMAP_COPA_URL;



	@Override
	public void init (PortletConfig config) throws PortletException {
		Log = LoggerFactory.getLogger(this.getClass().getName());
		Log.info("Portlet init ");
		super.init(config);
	}

	@Reference
	public void setPlaceCommonLocalService(Common commonService) throws BmapException {

		BMAP_COPA_URL = commonService.getValueFromKeyInPropertiesFile("BMAP_COPA_URL");
		
	}

	/**
	 * During the render we get the path of variables
	 */
	@Override
	public void render (RenderRequest request, RenderResponse response)
			throws PortletException, java.io.IOException {
		Log.info("Inside the render ");
		//We get all the algorithms in the database, for the view

		ThemeDisplay themeDisplay = (ThemeDisplay)request.getAttribute(WebKeys.THEME_DISPLAY);
		long userId = themeDisplay.getRealUserId();
		String fname = themeDisplay.getUser().getFirstName();
		String lname = themeDisplay.getUser().getLastName();
		String email = themeDisplay.getUser().getEmailAddress();
		String password = themeDisplay.getUser().getPassword();

		Log.info("user id is {}", userId);

		Log.info("Set Url BMAP_COPA_URL for view {}", BMAP_COPA_URL);

		//We set the correct url
		request.setAttribute("BMAP_COPA_URL", BMAP_COPA_URL);
		request.setAttribute("user_id", userId);
		request.setAttribute("fname", fname);
		request.setAttribute("lname", lname);
		request.setAttribute("email", email);
		request.setAttribute("password", password);

		super.render(request, response);
	}

}