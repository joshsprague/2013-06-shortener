require 'sinatra'
require "sinatra/reloader" if development?
require 'active_record'
require 'pry'

configure :development, :production do
    ActiveRecord::Base.establish_connection(
       :adapter => 'sqlite3',
       :database =>  'db/dev.sqlite3.db'
     )
end

# Quick and dirty form for testing application
#
# If building a real application you should probably
# use views: 
# http://www.sinatrarb.com/intro#Views%20/%20Templates
form = <<-eos
    <form id='myForm'>
        <input type='text' name="url">
        <input type="submit" value="Shorten"> 
    </form>
    <h2>Results:</h2>
    <h3 id="display"></h3>
    <script src="jquery.js"></script>

    <script type="text/javascript">
        $(function() {
            $('#myForm').submit(function() {
            $.post('/new', $("#myForm").serialize(), function(data){
                $('#display').html(data);
                });
            return false;
            });
    });
    </script>
eos

# Models to Access the database
# through ActiveRecord.  Define
# associations here if need be
#
# http://guides.rubyonrails.org/association_basics.html
class Link < ActiveRecord::Base
  attr_accessible :original_link, :short_link
end

# Check for root or shortened link
get '/' do
    form
end

get '/jquery.js' do
    send_file 'jquery.js'
end

get '/favicon.ico' do
    #
end

get '/jquery.min.map' do
    #
end

# If shortened link, extract URL extension
# then check database for redirect
# If shortened URL does not exist, return 404
get '/:path_info' do
    temp = request.path_info
    selector = Link.where(short_link: temp[1..5])[0]
    # binding.pry
    if selector
        redirect to ("http://" + selector.original_link)
    else
        [404]
    end
end

# Check input url
# If not in database, create new shortened URL
# If in database return previous shortened URL

post '/new' do
    # PUT CODE HERE TO CREATE NEW SHORTENED LINKS
    # Find URL from request body
    #temp = request.url.slice[8,4]
    # binding.pry
    long = request.params['url']
    short = request.body.read[8,4]
    link = Link.new original_link: long, short_link: short
    link.save
    # Return shortened URL
    [201, short]
end



get '/jquery.js' do
    send_file 'jquery.js'
end

####################################################
####  Implement Routes to make the specs pass ######
####################################################
