class ApplicationController < ActionController::Base
  protect_from_forgery
  # include SessionsHelper module facility for packaging functions together
  # and including them in multiple places (like controllers AND views)
  # by defaults all helpers are available in the views but not in the 
  # controllers, which is why we need to include it here (we need the 
  # ApplicationController to be able to deal with sessions - almost everybody
  # has to)
  include SessionsHelper
end
