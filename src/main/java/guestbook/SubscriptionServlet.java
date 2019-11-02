package guestbook;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.Message.RecipientType;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.Authenticator;

public class SubscriptionServlet extends HttpServlet {

	
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException  {
		System.out.println("Subscribing");

		String to = "grace.anconetani@gmail.com";
		String from = "grace.anconetani@gmail.com";
		
		final String username = "grace.anconetani@gmail.com";
		final String password = "Xetorca18";
		
		String host = "smtp.gmail.com";
		
		Properties eProps = new Properties();
		eProps.put("mail.smtp.auth", "true");
	    eProps.put("mail.smtp.starttls.enable", "true");
		eProps.put("mail.smtp.host", host);
		eProps.put("mail.smtp.port", "587");
		
		Session session = Session.getInstance(eProps,
			new Authenticator() {
				protected PasswordAuthentication getPasswordAuthenticaton() {
					return new PasswordAuthentication(username, password);
				}
		});
		
		try {
			Message message = new MimeMessage(session);
			
			message.setFrom(new InternetAddress(from));
			message.setRecipients(RecipientType.TO, InternetAddress.parse(to));
			message.setSubject("Test Subscribe Feature");
			message.setText("Did the test work?");
			
			Transport.send(message);
			
		} catch (Exception e) {
			System.out.println(e);
		}
		
		
	    resp.sendRedirect("/");
		System.out.println("Email sent!");
		
	}
}
