package guestbook;

import java.util.Date;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;

@Entity
public class BlogPost implements Comparable<BlogPost> {

	@Parent Key<Blog> blogName;
    @Id Long id;
    @Index User user;
    @Index String title;
    @Index String content;
    @Index Date date;
    
    private BlogPost() {}
    
    public BlogPost(User user, String content, String title, String guestbookName) {
    	this.user = user;
    	this.title = title;
    	this.content = content;
    	this.blogName = Key.create(Blog.class, guestbookName);
    	date = new Date();
    }
    
    public User getUser() {
    	return user;
    }
    
    public String getTitle() {
    	return title;
    }
    
    public String getContent() {
    	return content;
    }
    
	@Override
	public int compareTo(BlogPost other) {
		if (date.after(other.date)) {
            return 1;
        } else if (date.before(other.date)) {
            return -1;
        }
        return 0;
	}
}
