module SessionsHelper

    # Sets a :user_id key of the session hash to the id of the user passed to the function.
    def log_in(user)
        session[:user_id] = user.id
        # The below line will protect against session replay attacks by resetting the session token to 
        # the users session token everytime they login. 
        session[:session_token] = user.session_token
    end 

    # Sets the current user if none is set. 
    def current_user 
        if (user_id = session[:user_id])
            user = User.find_by(id: user_id) 
            @current_user ||= user if session[:session_token] == user.session_token
        elsif (user_id = cookies.encrypted[:user_id])
            user = User.find_by(id: user_id)
            if user&.authenticated?(cookies[:remember_token])
                log_in user
                @current_user = user
            end
        end
    end

    # Returns true if the current user is logged in. Returns false otherwise.
    def logged_in?
        !current_user.nil?
    end

    # Forgets persistant session.
    def forget(user)
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end

    # Logs out the current user.
    def log_out
        forget(current_user)
        reset_session
        @current_user = nil
    end

    def remember(user)
        user.remember
        cookies.permanent.encrypted[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end

    def session_token
        remember_digest || remember
    end
end
