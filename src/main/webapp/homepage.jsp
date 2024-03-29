<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="guestbook.BlogPost" %>
<%@ page import="guestbook.Blogger" %>
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
		
		<p>Recent Food Buzz!!</p>
		<form action="postblog.jsp">
			<input type="submit" value="Post Blog">
		</form>
		
		<%
 					String guestbookName = request.getParameter("guestbookName");
 					if (guestbookName == null) {
 						guestbookName = "default";
 					}
 			        ObjectifyService.register(Blogger.class);
 					pageContext.setAttribute("guestbookName", guestbookName);
 						    UserService userService = UserServiceFactory.getUserService();
 						    User user = userService.getCurrentUser();
 						    if (user != null) {
 						    pageContext.setAttribute("user", user);
 						   	List<Blogger> subscribers = ObjectifyService.ofy().load().type(Blogger.class).list();
 	 					    String email = user.getEmail();
 	 					    Boolean subscribed = false;
 	 					    for (Blogger blogger : subscribers) {
 	 					   		if (email.equals(blogger.getEmail())) subscribed = true;
 	 					    }
 	 					      
 	 					    if (subscribed) {
 		%>
 		<form action="/unsubscribe" method="post">
			<input type="submit" value="Unubscribe">
		</form>
		<%
 	 					      } else {
 	 					    	  
		%>
 		<form action="/subscribe" method="post">
			<input type="submit" value="Subscribe">
		</form>
		<%
 	 					      }
		%>

		<p>Hello, ${fn:escapeXml(user.nickname)}!</p>

		<%
			} 
				    
				    ObjectifyService.register(BlogPost.class);
				    List<BlogPost> blogs = ObjectifyService.ofy().load().type(BlogPost.class).list();
				    Collections.sort(blogs);
				    Collections.reverse(blogs);
				    if (blogs.isEmpty()) {
		%>
			<p>No Posts</p>
		<%
		    } else {
		    	
			for (int i = 0; i < blogs.size() && i < 3; i++) {
				pageContext.setAttribute("greeting_content", blogs.get(i).getContent());
            	pageContext.setAttribute("greeting_title", "No title");
            	if (blogs.get(i).getTitle() != null) {
            		pageContext.setAttribute("greeting_title", blogs.get(i).getTitle());
            	} 
				if (blogs.get(i).getUser() == null) {
		%>
					<p>An anonymous person posted:</p>
		<%
				} else {
					pageContext.setAttribute("greeting_user", blogs.get(i).getUser());
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
	
		<form action="ofyguestbook.jsp">
			<input type="submit" value="Show All">
		</form>

  	</body>

</html>