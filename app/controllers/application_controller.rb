class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  def log(item, action, item_amount = nil, exp_date = nil)
    @log = ActivityLog.new
    @log.user = current_user
    @log.item_id = item
    @log.action = action
    @log.item_amount = item_amount
    @log.item_amount_exp_date = exp_date
    @log.save!
  end

  def user
    @username = current_user.username
    @email = current_user.email
  end
end
