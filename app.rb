require "bundler/setup"
Bundler.require(:default)

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end
  configure do
    set :views, settings.root + "/views"
  end
  get "/" do
    @name = "ドラえもん"
    slim :index
  end
  get "/:name" do
    @name = params[:name]
    slim :index
  end
  get "/frank-says" do
    "ヌベヂョンヌゾジョンベルミッティスモゲロンボョｗｗｗ"
  end
end
