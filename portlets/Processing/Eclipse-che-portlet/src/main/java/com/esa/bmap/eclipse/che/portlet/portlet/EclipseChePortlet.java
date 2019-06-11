package com.esa.bmap.eclipse.che.portlet.portlet;

import com.esa.bmap.eclipse.che.portlet.constants.EclipseChePortletKeys;

import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;

import javax.portlet.Portlet;

import org.osgi.service.component.annotations.Component;

/**
 * @author liferay
 */
@Component(
	immediate = true,
	property = {
		"com.liferay.portlet.display-category=Processing",
		"com.liferay.portlet.instanceable=false",
		"javax.portlet.display-name=Eclipse-che-portlet Portlet",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.name=" + EclipseChePortletKeys.EclipseChe,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user"
	},
	service = Portlet.class
)
public class EclipseChePortlet extends MVCPortlet {
}