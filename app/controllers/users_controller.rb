class UsersController < ApplicationController
  protect_from_forgery except: :login
	def index
		render :json => {msg: "The Website is building!"}
	end
  def login
    result = {is_succeed: false, msg: ""}
    user = User.find_by(username: params["username"])
    if(user.nil?)
      result[:msg] = "The user is not exist!"
    elsif user.password != params["password"]
      result[:msg] = "The password is not correct!"
    else
      user.access_key = SecureRandom.hex;
      result[:is_succeed]=true
      result[:access_key] = user.access_key;
      result[:msg] = "Login succeed!";
      user.save;
    end
    render :json => result
  end
  def list
    users = User.all
    result = []
    users.each do |user|
      result << {username: user.username}
    end
    render :json => result
  end
end
