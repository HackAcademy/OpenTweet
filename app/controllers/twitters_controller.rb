class TwittersController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  before_action :find_user, except: [:create]
  before_action :find_twitter, only: [:follows, :show, :unfollows]

  def index
    @twitters = Twitter.all
  end

  def create
    @twitter = Twitter.new twitter_params

    unless @twitter.save
      @messages = @twitter.errors.messages
      render status: :conflict, template: 'errors/show'
    end
  end

  def show

  end

  def follows
    begin
      @current_twitter.followings.push(@twitter)
    rescue
      @messages = {error: 'AlreadyFollowing'}
      render status: :conflict, template: 'errors/show'
    end
  end

  def unfollows
    Follow.where(followed_id: @twitter.id, twitter_id: @current_twitter.id).destroy_all
  end

  private

  def twitter_params
    params.require(:user_attributes)
    params.permit(:username, :biography,
                                    user_attributes: [:id, :email, :password]
    )
  end

  def find_twitter
    @twitter = Twitter.find params[:id]
  end

  def record_not_found
    @messages = {error: 'TwitterNotFound'}
    render status: :conflict, template: 'errors/show'
  end
end