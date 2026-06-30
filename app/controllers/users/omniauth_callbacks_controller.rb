class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    handle_auth("Google")
  end

  def facebook
    handle_auth("Facebook")
  end

  def twitter
    handle_auth("Twitter")
  end

  def failure
    redirect_to root_path, alert: "Authentication failed: #{failure_message}"
  end

  private

  def handle_auth(provider_name)
    auth = request.env["omniauth.auth"]
    identity = OauthIdentity.find_or_initialize_by(provider: auth.provider, uid: auth.uid)

    user = identity.user || User.find_by(email: auth.info.email) || User.new
    user.assign_attributes(
      email: auth.info.email,
      first_name: user.first_name.presence || auth.info.first_name || auth.info.name&.split(" ", 2)&.first,
      last_name: user.last_name.presence || auth.info.last_name || auth.info.name&.split(" ", 2)&.last
    )
    user.password = Devise.friendly_token[0, 20] if user.new_record?
    user.save!

    identity.user = user
    identity.token = auth.credentials&.token
    identity.secret = auth.credentials&.secret
    identity.save!

    sign_in_and_redirect user, event: :authentication
    set_flash_message(:notice, :success, kind: provider_name) if is_navigational_format?
  end
end
