class InvitationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:accept]

  before_action :set_pool, only: [:create]
  before_action :require_commissioner!, only: [:create]

  def create
    @invitation = @pool.invitations.build(invitation_params.merge(invited_by: current_user))

    if @invitation.save
      # TODO: Replace with deliver_later once Sidekiq/Redis is configured
      InvitationMailer.invite(@invitation).deliver_now
      redirect_to manage_pool_path(@pool), notice: "Invitation sent to #{@invitation.email}."
    else
      redirect_to manage_pool_path(@pool), alert: @invitation.errors.full_messages.to_sentence
    end
  end

  def accept
    @invitation = Invitation.find_by!(token: params[:token])

    if @invitation.accepted?
      redirect_to root_path, alert: "This invitation has already been used."
      return
    end

    unless user_signed_in?
      store_location_for(:user, request.url)
      redirect_to new_user_registration_path, notice: "Create an account or sign in to join #{@invitation.pool.name}."
      return
    end

    if @invitation.pool.users.include?(current_user)
      redirect_to @invitation.pool, notice: "You're already a member of this pool."
      return
    end

    @invitation.pool.pool_memberships.create!(user: current_user, role: @invitation.role)
    @invitation.update!(accepted_at: Time.current)

    redirect_to @invitation.pool, notice: "Welcome to #{@invitation.pool.name}!"
  end

  private

  def set_pool
    @pool = if current_user.super_admin?
      Pool.find(params[:pool_id])
    else
      current_user.pools.find(params[:pool_id])
    end
  end

  def require_commissioner!
    unless current_user.can_manage_pool?(@pool)
      redirect_to root_path, alert: "Only commissioners can send invitations."
    end
  end

  def invitation_params
    params.require(:invitation).permit(:email, :role)
  end
end
