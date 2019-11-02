package guestbook;

import java.io.IOException;
import com.google.appengine.api.users.*;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class BlogServlet extends HttpServlet {
	@Override
	  public void doGet(HttpServletRequest request, HttpServletResponse response) 
	      throws IOException {

	    response.setContentType("text/plain");
	    response.getWriter().println("Hello, world");
	    
	    UserService userService = UserServiceFactory.getUserService();
	    User user = userService.getCurrentUser();
	    
	    if (user != null) {
	    	response.setContentType("text/plain");
	    	response.getWriter().println("Hello, " + user.getNickname());
	    } else {
	    	response.sendRedirect(userService.createLoginURL(request.getRequestURI()));
	    }

	  }
}
