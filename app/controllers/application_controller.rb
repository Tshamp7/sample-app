class ApplicationController < ActionController::Base
    def hello_word
        render html: "hello, world!"
    end
end
