class InvitationMailer < ApplicationMailer
  def invite(invitation)
    @invitation = invitation
    @pool = invitation.pool
    @invited_by = invitation.invited_by
    @accept_url = accept_invitation_url(token: invitation.token)

    mail(
      to: @invitation.email,
      subject: "#{@invited_by.first_name} invited you to join #{@pool.name} on Survivor Pool"
    )
  end
end
