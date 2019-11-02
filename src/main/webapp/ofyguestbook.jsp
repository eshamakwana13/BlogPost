<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="guestbook.BlogPost" %>
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
		<img src='stylesheets/foodBlog.jpg' alt="Header Pic"> 
		<br/>
		<p>Recent Food Buzz!!</p>
		<form action="postblog.jsp">
			<input type="submit" value="Post Blog">
		</form>
		<form action="/subscribe" method="post">
			<input type="submit" value="Subscribe">
		</form>
		
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
			}
				    
				    ObjectifyService.register(BlogPost.class);
				    List<BlogPost> blogs = ObjectifyService.ofy().load().type(BlogPost.class).list();
				    Collections.sort(blogs);
				    Collections.reverse(blogs);

				    if (blogs.isEmpty()) {
		%>
			<p>Guestbook '${fn:escapeXml(guestbookName)}' has no messages.</p>
		<%
			} else {

			for (BlogPost blog : blogs) {
		            	pageContext.setAttribute("greeting_content", blog.getContent());
		            	pageContext.setAttribute("greeting_title", "No title");
		            	if (blog.getTitle() != null) {
		            		pageContext.setAttribute("greeting_title", blog.getTitle());
		            	} 
						if (blog.getUser() == null) {
		%>
					<p>An anonymous person wrote:</p>
		<%
				} else {
					pageContext.setAttribute("greeting_user", blog.getUser());
					%>
					<p><b>${fn:escapeXml(greeting_user.nickname)}</b> wrote:</p>
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