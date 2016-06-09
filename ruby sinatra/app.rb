require 'sinatra'
require 'rubygems'
require 'haml'
require 'data_mapper'
require 'pony'
require './class'
require 'sinatra/param'

def send_message(name, email, message)
   Pony.mail(
   :from => params[:name] + "<" + params[:email] + ">",
   :to => "gamedevcode@gmail.com",
   :subject => params[:name] + " has contacted you",
   :body => params[:message],
   :via => :smtp,
   :via_options => {
     :arguments => '-t', # -t and -i are the defaults
     :address              => 'smtp.gmail.com',
     :port                 => '587',
     :user_name            => 'gamedevcode@gmail.com',
     :password             => 'bloodness',
     :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
     :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
   })
end

get '/' do
	haml :index
end

get '/new' do
	haml :new_software
end

post '/new_software' do
    param :title,	String, required: true
	new_software = Software.new
	new_software.title = params[:title]
	new_software.description = params[:description]
	new_software.language = params[:language]
	if Software.first(:title => params[:title]) 
  		haml :alreadyexists
    elsif params[:title] == "" || params[:title] == " " 
    	haml :alertblank
    elsif	
    	new_software.save
    	haml :alertnew
    end
end

get '/all' do
	@sware = Software.all
	haml :sware
end

get '/contact' do
	haml :contact
end

post '/contact' do
	send_message(:name, :email, :message)
#	redirect to("/")
	haml :alertmail
end

get '/software/:id' do
	@software = Software.get(params[:id])
	haml :software
	@success_message = session[:success_message]
    session[:success_message] = nil
end

get '/software/delete/:id' do
	@software = Software.get(params[:id])
	@software.destroy
#	redirect '/all'
	haml :alertdestroy
end

get '/software/edit/:id' do
	if Software.first(:id => params[:id]) 
		@software = Software.get(params[:id])
		haml :edit
    elsif	
    	haml :alertmail
    end

end

put '/software/edit/:id' do
	software = Software.get params[:id]
	software.title = params[:title]
	software.description = params[:description]
	software.language = params[:language]
	software.save
	 session[:success_message] = "Software entry successfully updated."
#	redirect '/all'
	haml :alertedit
end	