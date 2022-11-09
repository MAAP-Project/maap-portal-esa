package com.esa.maap.administration.portlet;

import java.util.List;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.Portlet;
import javax.portlet.PortletConfig;
import javax.portlet.PortletException;
import javax.portlet.ProcessAction;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;

import com.esa.bmap.common.exceptions.BmapException;
import com.esa.bmap.model.Algorithm;
import com.esa.bmap.model.BmaapUser;
import com.esa.bmap.model.Executable;
import com.esa.maap.administration.portlet.constants.AdministrationPortletKeys;
import com.esa.maap.algorithm.api.AlgorithmServiceInterface;
import com.esa.maap.usermanagement.api.BmapUserServiceInterface;
import com.liferay.portal.kernel.model.User;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.service.UserLocalServiceUtil;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.util.ParamUtil;

/**
 * @author tkossoko
 */
@Component(
	immediate = true,
	property = {
		"com.liferay.portlet.display-category=Maap",
		"com.liferay.portlet.header-portlet-css=/css/main.css",
		"com.liferay.portlet.instanceable=true",
		"javax.portlet.display-name=Administration",
		"javax.portlet.init-param.template-path=/",
		"javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.name=" + AdministrationPortletKeys.ADMINISTRATION,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user"
	},
	service = Portlet.class
)
public class AdministrationPortlet extends MVCPortlet {

	private static final Logger logger = LoggerFactory.getLogger(AdministrationPortlet.class);

	// Services imported to be used
	private AlgorithmServiceInterface algocatalogueInterface;
	private BmapUserServiceInterface bmapUserInterface;

	@Override
	public void init(PortletConfig config) throws PortletException {
		String message = "Initialisation of the admin catalogue portlet";
		logger.info(message);

		super.init(config);
	}

	/**
	 * The first time we render the page, we get the list of the users in the
	 * liferay
	 * 
	 * @param request
	 * @param response
	 * @throws PortletException
	 * @throws java.io.IOException
	 */
	@Override
	public void render(RenderRequest request, RenderResponse response) throws PortletException, java.io.IOException {
		// When send the user list to the ihm
		this.userList(request);
		super.render(request, response);
	}

	/**
	 * Initialisation of the the OSGI module to delete or add an algorithm
	 * 
	 * @param algoInterface
	 */
	@Reference
	public void setAlgoCatalogueClientLocalService(AlgorithmServiceInterface algoInterface) {
		this.algocatalogueInterface = algoInterface;
	}

	/**
	 * Initialisation of the the OSGI module to get a user
	 * 
	 * @param algoInterface
	 */
	@Reference
	public void setUserManagementClientLocalService(BmapUserServiceInterface bmapUserInterface) {
		this.bmapUserInterface = bmapUserInterface;
	}

	/**
	 * Action launched when the algo is deleted
	 * 
	 * @param request
	 * @param response
	 * @throws PortletException
	 */
	@ProcessAction(name = "deleteAlgoAction")
	public void deleteAlgoAction(ActionRequest request, ActionResponse response) {
		// First we get the algorithm withit's u
		Algorithm algo;
		try {
			
			algo = algocatalogueInterface.getAlgorithmByUrl(ParamUtil.getString(request, "algoSourceUrl" ));
			// If the algo exists we can start the deletion
			if (algo != null) {
				int status = algocatalogueInterface.deleteAlgorithm(algo.getId());

				if (status == HttpStatus.OK.value()) {
					request.setAttribute("sucessMessage", "Algorithm deleted successfuly");
					SessionMessages.add(request, "success");
				} else if (status == HttpStatus.NOT_FOUND.value()) {
					request.setAttribute("errorMessage", "Algorithm not found");
					SessionErrors.add(request, "error");
				} else {
					// Internal server error
					request.setAttribute("errorMessage", "Internal server error");
					SessionErrors.add(request, "error");
				}
			} else {
				request.setAttribute("errorMessage", "Algorithm not found");
				SessionErrors.add(request, "error");
			}
		} catch (BmapException e) {
			// We have another error the process
			request.setAttribute("errorMessage", e.getMessage());
			SessionErrors.add(request, "error");
		}
	}

	@ProcessAction(name = "addAlgoAction")
	public void addAlgoAction(ActionRequest request, ActionResponse response) {

		// First, we verify if the algorithm is already in the database
		Algorithm algo;
		try {
			
			algo = algocatalogueInterface.getAlgorithmByUrl(ParamUtil.getString(request, "algoSourceUrl2" ));

			if (algo != null) {
				// Error
				request.setAttribute("errorMessage",
						"The Algorithm " + algo.getName() + " is already in the algorithm store");
				SessionErrors.add(request, "error");
				logger.info("The Algorithm {} is already in the algorithm store", algo.getName());
			} else {

				// We get all of the information
				String algoSourceUrl = ParamUtil.getString(request, "algoSourceUrl2");
				String dockerImageUrl = ParamUtil.getString(request, "dockerImageUrl" );
				int author = Integer.parseInt(ParamUtil.getString(request, "author"));
				String applicationZone = ParamUtil.getString(request, "applicationZone" );
				String averageTime = ParamUtil.getString(request, "averageTime");
				String currentVer = ParamUtil.getString(request, "currentVer");

				BmaapUser user;
				user = this.bmapUserInterface.getBmapUserById(author);
				if (user == null) {
					// Internal server error
					request.setAttribute("errorMessage", "The author is unkonwn to the platform");
					SessionErrors.add(request, "error");
					logger.info("The author with id {}  is unkonwn to the platform", author);
				} else {
					// We set the information about the algorithm
					algo = new Algorithm();
					algo.setApplicationZone(applicationZone);
					algo.setAverageTime(averageTime);
					algo.setCurrentVersion(currentVer);

					algo.setGitUrl(algoSourceUrl);
					Executable exe = new Executable(null, dockerImageUrl);
					algo.setExecutable(exe);
					algo.setAuthor(user);

					algo = this.algocatalogueInterface.addAlgorithm(algo);

					if (algo.getId() != null) {
						request.setAttribute("sucessMessage",
								"Algorithm " + algo.getName() + " added successfuly to the algorithm store");
						request.setAttribute("algoSourceUrl2Id", "test");
						SessionMessages.add(request, "success");
					}
				}
			}
		} catch (BmapException e) {
			request.setAttribute("errorMessage", e.getMessage());
			SessionErrors.add(request, "error");
			logger.info(e.getMessage());
		}

	}

	/**
	 * We get the list of the users
	 * 
	 * @param request
	 */
	private void userList(RenderRequest request) {
		int countUser = UserLocalServiceUtil.getUsersCount();
		logger.info("User Present In DB {}  ", countUser);
		List<User> users = UserLocalServiceUtil.getUsers(0, countUser);
		request.setAttribute("users", users);
	}
}