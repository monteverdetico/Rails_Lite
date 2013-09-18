Rails Lite - built using existing skeleton repo.

Created a basic ControllerBase class with render and redirect_to methods. Then, used WEBrick::Cookie to store session information and set the cookies in the render and redirect_to methods.

Wrote a parse method to parse the parameters sent in the request body and query string allowing for database interaction through ActiveRecord.