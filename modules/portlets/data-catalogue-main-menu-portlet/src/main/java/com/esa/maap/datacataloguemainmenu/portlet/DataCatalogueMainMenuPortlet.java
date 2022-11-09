package com.esa.maap.datacataloguemainmenu.portlet;

import com.esa.bmap.common.exceptions.BmapException;
import com.esa.maap.common.service.Common;
import com.esa.maap.data.api.DataInterface;
import com.esa.maap.datacataloguemainmenu.portlet.constants.DataCatalogueMainMenuPortletKeys;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;

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
		"javax.portlet.display-name=DataCatalogueMainMenu",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.name=" + DataCatalogueMainMenuPortletKeys.DATACATALOGUEMAINMENU,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user"
	},
	service = Portlet.class
)
public class DataCatalogueMainMenuPortlet extends MVCPortlet {
	private static final Logger LOG = LoggerFactory.getLogger(DataCatalogueMainMenuPortlet.class);

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet#render(javax.portlet
	 * .RenderRequest, javax.portlet.RenderResponse)
	 */
	@Override
	public void render(RenderRequest request, RenderResponse response) throws PortletException, java.io.IOException {

	}

	/**
	 * Setting a Common Service to use
	 * 
	 * @param commonService
	 * @throws BmapException
	 */
	@Reference
	public void setCommonService(Common commonService) throws BmapException {


	}

	/**
	 * Setting a dataService to use
	 * 
	 * @param restClient
	 */
	@Reference
	public void setDataClientLocalService(DataInterface dataService) {

	}

	
}