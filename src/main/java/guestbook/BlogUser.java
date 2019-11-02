package guestbook;

import java.util.Date;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;

@Entity
public class BlogUser {

    @Id Long id;
    @Index String username;
    @Index String email;
    
    private BlogUser() {}
    
    public BlogUser(String username, String email) {

    	this.username = username;
    	this.email = email;
    }
    
    public String getUsername() {
    	return username;
    }

    public String getEmail() {
    	return email;
    }

}
