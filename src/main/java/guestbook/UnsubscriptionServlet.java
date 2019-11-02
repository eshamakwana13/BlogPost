package guestbook;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.Message.RecipientType;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.Authenticator;

public class UnsubscriptionServlet extends HttpServlet {

	
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException  {
	    UserService userService = UserServiceFactory.getUserService();
	    User user = userService.getCurrentUser();
	    
	    List<Blogger> subscribers = ofy().load().type(Blogger.class).list();
	    
	    for (Blogger blogger : subscribers) {
	    	if (blogger.getEmail().equals(user.getEmail())) {
	    	    ofy().delete().entity(blogger).now();
	    	}
	    }
	    
	    resp.sendRedirect("/");
		
	}
}
