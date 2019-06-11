package Test.portlet;

import java.util.List;

import com.liferay.portal.kernel.service.ServiceContext;

public class GuestbookService {

	public GuestbookService() {
		// TODO Auto-generated constructor stub
	}

	public Guestbook addGuestbook(long userId, String string, ServiceContext serviceContext) {
		return new Guestbook(userId, string, serviceContext);
	}

	public List<Guestbook> getGuestbooks(long groupId) {
		// TODO Auto-generated method stub
		return null;
	}

}
