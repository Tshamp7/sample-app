module SessionsHelper

    # Sets a :user_id key of the session hash to the id of the user passed to the function.
    def log_in(user)
        session[:user_id] = user.id
    end 

    # Sets the current user if none is set. 
    def current_user 
        if session[:user_id]
            @current_user ||= User.find_by(id: session[:user_id])
        end
    end

    # Returns true if the current user is logged in. Returns false otherwise.
    def logged_in?
        !current_user.nil?
    end

    # Logs out the current user.
    def log_out
        reset_session
        @current_user = nil
    end
end
