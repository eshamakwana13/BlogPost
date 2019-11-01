<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="guestbook.Greeting" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections"%>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
	<head>
		<link type="text/css" rel="stylesheet" href="stylesheets/main.css">
		
	</head>
	<h1> Welcome to FoodiesMeet!!!</h1>
	<h2>A blog page for foodies in Austin. Share your favorite spots to eat, recipes and more! Make sure to subscribe at the bottom for all the latest buzz!</h2>
	<img src='/stylesheets/foodBlog.jpg' alt="Header Pic" align=> 
	<br>
	<body>
		<%
			String guestbookName = request.getParameter("guestbookName");
			if (guestbookName == null) {
				guestbookName = "default";
			}
			pageContext.setAttribute("guestbookName", guestbookName);
		    UserService userService = UserServiceFactory.getUserService();
		    User user = userService.getCurrentUser();
		    if (user != null) {
		      pageContext.setAttribute("user", user);
		%>

		<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
		<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>

		<%
		    } else {
		%>
	
		<p>Hello!
		<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
			to include your name with greetings you post.</p>
	
		<%
	    	}
		    
		    ObjectifyService.register(Greeting.class);
		    List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();
		    Collections.sort(greetings);
		    Collections.reverse(greetings); 
		    if (greetings.isEmpty()) {
		%>
			<p>Guestbook '${fn:escapeXml(guestbookName)}' has no messages.</p>
		<%
		    } else {
		%>	
			<p>Recent Blogs '${fn:escapeXml(guestbookName)}'.</p>
		<%
			for (Greeting greeting : greetings) {
            	pageContext.setAttribute("greeting_content", greeting.getContent());
				if (greeting.getUser() == null) {
		%>
					<p>An anonymous person wrote:</p>
		<%
				} else {
					pageContext.setAttribute("greeting_user", greeting.getUser());
					%>
					<p><b>${fn:escapeXml(greeting_user.nickname)}</b> wrote:</p>
					<%
				}
				%>
				<blockquote>${fn:escapeXml(greeting_content)}</blockquote>
				<%
			}
		}
		%>
		
	
	 	<form action="/ofysign" method="post">
	 		<div>
	 			<textarea name="content" rows="3" cols="60"></textarea>
	 		</div>
	 		<div>
	 			<input type="submit" value="Post Greeting">
	 		</div>
	 		<input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
	 	</form>

  	</body>

</html>