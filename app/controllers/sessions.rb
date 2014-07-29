get '/sessions/new' do
	erb :'sessions/new'
end

post '/sessions' do
	email, password = params[:email], params[:password]
	user=User.authenticate(email,password)
	if user
		session[:user_id] = user.id
		redirect to '/'
	else
		flash.now[:errors]=["The email or password you entered is incorrect"]
		erb :'sessions/new'
	end
end

delete '/sessions' do
	flash[:notice] = "Goodbye!"
	session[:user_id] = nil
	redirect to '/'
end
