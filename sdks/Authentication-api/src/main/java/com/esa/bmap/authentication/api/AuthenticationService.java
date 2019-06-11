package com.esa.bmap.authentication.api;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.osgi.service.component.annotations.Component;

import com.liferay.portal.kernel.events.ActionException;
import com.liferay.portal.kernel.events.LifecycleAction;
import com.liferay.portal.kernel.events.LifecycleEvent;
import com.liferay.portal.kernel.model.Role;
import com.liferay.portal.kernel.model.User;
import com.liferay.portal.kernel.util.WebKeys;

@Component(
		immediate = true, 
		property = { "key=login.events.post" }, 
		service = LifecycleAction.class
		)
public class AuthenticationService implements LifecycleAction {

	private static final String AlgoDeveloper = "Algorithm Developer";
	
	@Override
	public void processLifecycleEvent(LifecycleEvent lifecycleEvent) throws ActionException {
		//We assign data specialist role to a user if it is not the case
		initUser(lifecycleEvent);
		
	}
	
	/**
	 * Method that assign data specialist role to a user after registration
	 * @param lifecycleEvent
	 */
	private void initUser(LifecycleEvent lifecycleEvent) {
		
		//We get the session. Inside the session we have the id of the user
		final HttpSession session = lifecycleEvent.getRequest().getSession();
		Boolean isRoleAssigned = false;
		
		//We get the user session and information
		User user = (User) session.getAttribute(WebKeys.USER);
		//We get all user roles and check if the role is already assign
		List<Role> userRoles = user.getRoles();
		for(Role userRole : userRoles) {
			if(userRole.getName().equals(AlgoDeveloper)) {
				isRoleAssigned = true;
				break;
			}
		}
		
//		//If data specialist role is not assigned, we assign the role
//		if(!isRoleAssigned) {
//			//We get the list of companies. Normally, we have just one company
//			List<Company> listOfCompanies = CompanyLocalServiceUtil.getCompanies();
//			
//			//We check first if the list is not empty, then we retrieve the first company and roles
//			if(!listOfCompanies.isEmpty()) {
//				List<Role> roles = RoleLocalServiceUtil.getRoles(listOfCompanies.get(0).getCompanyId());
//				
//				for(Role role : roles) {
//					if(role.getName().equals(DataSpecialist)) {
//						//We create a link to this role for the user
//						RoleUtil.addUser(role.getRoleId(), user.getUserId());
//						//We update the user in database
//					    UserLocalServiceUtil.updateUser(user);
//						break;
//					}
//				}
//			}
//		}
	}


}
