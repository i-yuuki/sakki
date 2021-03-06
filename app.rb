require "bundler/setup"
Bundler.require(:default)

Dir["models/*.rb"].each do |model|
  require_relative model
end

Dir["repositories/*.rb"].each do |model|
  require_relative model
end

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end
  configure do
    set :views, settings.root + "/views"
  end
  def self.database_config
    YAML.load_file("config/database.yml")[ENV['RACK_ENV'] || 'development']
  end
  def self.database
    @database ||= Mysql2::Client.new(database_config)
  end
  helpers do
    def entry_repository
      @@entry_repository ||= EntryRepository.new(App.database)
    end
  end
  get "/" do
    slim :index
  end
  get "/entries/new" do
    slim :new
  end
  post "/entries" do
    entry = Entry.new
    entry.title = params[:title]
    entry.body = params[:body]
    id = entry_repository.save(entry)
    
    redirect to("/entries/#{id}")
  end
  get "/entries/:id" do
    @entry = entry_repository.fetch(params[:id].to_i)
    slim :entry
  end
  get "/:name" do
    @name = params[:name]
    slim :index
  end
  get "/frank-says" do
    "ヌベヂョンヌゾジョンベルミッティスモゲロンボョｗｗｗ"
  end
end
