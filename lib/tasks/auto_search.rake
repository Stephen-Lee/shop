namespace :auto_search do
  desc "generate suggestions"
  task index: :environment do
    AutoSearch.seed
  end 	
end