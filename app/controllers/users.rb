PASSWORD_RESET_TIMEOUT = 60*60

get '/users/new' do
	@user = User.new
	erb :'users/new'
end

post '/users' do
	@user = User.new(	:email =>params[:email],
						:password => params[:password],
						:password_confirmation => params[:password_confirmation])
	
	if @user.save
	session[:user_id] = @user.id
	redirect to('/')
	else
		flash.now[:errors] = @user.errors.full_messages
		erb :'users/new'
	end
end

get '/users/reset_password' do
	erb :'users/reset_password'
end

post '/users/reset_password' do
	email = params[:email]
	user = User.first(:email => email)
	user.set_reset_token
	send_password_reset(user.email,create_link(user.password_token))
	erb :'users/email_sent'
end

get '/users/reset_password/:token' do
	token = params[:token]
	@user = User.first(:password_token => token)
	if (Time.now-@user.password_token_timestamp) < PASSWORD_RESET_TIMEOUT
		erb :'users/new_password'
	else
		flash.now[:notice] = "Sorry your password reset has timed out"
		erb :'users/reset_password'
	end
end

post '/users/set_new_password' do
	@user = User.first(	:email =>params[:email])
	if @user.update(:password => params[:password],
				 :password_confirmation => params[:password_confirmation],
				 :password_token => nil,
				 :password_token_timestamp => nil)
	session[:user_id] = @user.id
	redirect to('/')
	else
		flash.now[:errors] = @user.errors.full_messages
		erb :'users/new_password'
	end
end

def create_link password_token
	"#{request.url.to_s}/#{password_token.to_s}"
end

def send_password_reset(email, link)
  RestClient.post "https://api:key-d733bc88a2fb89d47ef91cfa2a5fb31a"\
  "@api.mailgun.net/v2/sandbox8e90015459c74825b6714ab541d9ac60.mailgun.org/messages",
  :from => "Bookmark Manager <postmaster@sandbox8e90015459c74825b6714ab541d9ac60.mailgun.org>",
  :to => "<#{email}>",
  :subject => "Password Reset",
  :text => "Please click the link below to reset your password\n#{link}."
end



