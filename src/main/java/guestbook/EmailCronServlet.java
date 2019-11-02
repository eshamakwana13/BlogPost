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

public class EmailCronServlet extends HttpServlet {

	
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException  {
		
	    List<Blogger> subscribers = ofy().load().type(Blogger.class).list();
	    List<BlogPost> posts = ofy().load().type(BlogPost.class).list();
	    String body = "<div><h1>Blog Posts</h1>";
	    for (BlogPost post : posts) {
	    	body += "<h3>" + post.getTitle() + "</h3>";
	    	body += "<p>" + post.getContent() + "</p>";
	    	body += "<br/>";
	    }
	    body += "</div>";
	    
	    Properties props = new Properties();
	    Session session = Session.getDefaultInstance(props, null);

	    try {
	      Message msg = new MimeMessage(session);
	      msg.setFrom(new InternetAddress("hello@swift-implement-255320.appspot.com", "Example.com Admin"));
	      for (Blogger blogger : subscribers) {
	    	  msg.addRecipient(Message.RecipientType.TO,
                      new InternetAddress(blogger.getEmail()));
	      }

	      msg.setSubject("Your Example.com account has been activated");
	      msg.setContent(body, "text/html");
	      Transport.send(msg);
	    } catch (Exception e) {
	    	System.out.println(e);
	    }
	    
	    resp.sendRedirect("/");
		
	}
}
