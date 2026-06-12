# frozen_string_literal: true

class UserInvitationMailer < ApplicationMailer
  def invitation_email
    @recipient = params[:recipient]
    @invited_by_name = params[:invited_by_name]
    @signup_url = url_for(controller: 'users', action: 'new', only_path: false)

    mail(
      to: @recipient,
      subject: 'You\'ve been invited to join SSStutterBuddy!'
    )
  end
end
