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

	<body>
		<h1> Welcome to FoodiesMeet!!!</h1>
		<h2>A blog page for foodies in Austin. Share your favorite spots to eat, recipes and more! Make sure to subscribe at the bottom for all the latest buzz!</h2>
		<img src="stylesheets/foodBlog.jpg" alt="Header Pic"> 
		
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

		<p>Hello, ${fn:escapeXml(user.nickname)}!</p>

		<%
	    	}
		    
		    ObjectifyService.register(Greeting.class);
		    List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();
		    Collections.sort(greetings);
		    Collections.reverse(greetings);

		    if (greetings.isEmpty()) {
		%>
			<p>No posts.</p>
		<%
		    } else {
		%>	
		
			<p>Recent Food Buzz!!</p>
			<form action="postblog.jsp">
				<input type="submit" value="Post Blog">
			</form>

		<%
			for (Greeting greeting : greetings) {}
			for (Greeting greeting : greetings) {
            	pageContext.setAttribute("greeting_content", greeting.getContent());
            	pageContext.setAttribute("greeting_title", "No title");
            	if (greeting.getTitle() != null) {
            		pageContext.setAttribute("greeting_title", greeting.getTitle());
            	} 
				if (greeting.getUser() == null) {
		%>
					<p>An anonymous person posted:</p>
		<%
				} else {
					pageContext.setAttribute("greeting_user", greeting.getUser());
					%>
					<p><b>${fn:escapeXml(greeting_user.nickname)}</b> posted:</p>
					<%
				}
		%>
			<div class="blog-container">
				<blockquote class="title">${fn:escapeXml(greeting_title)}</blockquote>
				<blockquote>${fn:escapeXml(greeting_content)}</blockquote>
			</div>
			
		<%
			}
		}
		%>

  	</body>

</html>