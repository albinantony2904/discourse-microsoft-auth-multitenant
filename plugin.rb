# frozen_string_literal: true

# name: discourse-microsoft-auth-multitenant
# about: Enable Login via Microsoft Identity Platform (Office 365 / Microsoft 365 Accounts)
# meta_topic_id: 51731
# version: 1.0
# authors: Albin Antony
# url: https://github.com/albinantony2904/discourse-microsoft-auth-multitenant

require_relative "lib/omniauth-microsoft365"

enabled_site_setting :microsoft_auth_enabled

register_svg_icon "fab-microsoft"

class ::MicrosoftAuthenticator < ::Auth::ManagedAuthenticator
  def name
    "microsoft_office365"
  end

  def register_middleware(omniauth)
    omniauth.provider :microsoft_office365,
                      setup:
                        lambda { |env|
                          strategy = env["omniauth.strategy"]
                          strategy.options[:client_id] = SiteSetting.microsoft_auth_client_id
                          strategy.options[
                            :client_secret
                          ] = SiteSetting.microsoft_auth_client_secret
                          strategy.options[:tenant_id] = SiteSetting.microsoft_auth_tenant_id
                        }
  end

  def enabled?
    SiteSetting.microsoft_auth_enabled
  end

  # Microsoft doesn't let users login with OAuth2 to websites unless the user
  # has verified their email address so we can assume whatever email we get
  # from MS is verified.
  def primary_email_verified?(auth_token)
    true
  end
end

auth_provider authenticator: MicrosoftAuthenticator.new, icon: "fab-microsoft"
