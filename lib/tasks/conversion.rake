namespace :conversion do
  desc "convert out"
  task :all => :environment do
    puts "Writing conversion script..."
    
    o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten;
    script = ''; 
    
    User.all.each do |user|
      first_name = user.name.split.first
      last_name = user.name.split.size > 1 ? user.name.split.last : ""
      password = (0..50).map{ o[rand(o.length)]  }.join;
      script += "user = User.create(:first_name => #{first_name.dump}, :last_name => #{last_name.dump}, :login => #{user.login.dump}, :email => #{user.email.dump}, :created_at => '#{user.created_at}', :extensions_count => #{user.extensions_count}, :password => '#{password}', :password_confirmation => '#{password}')\n"
      script += "unless user.errors.empty?\n"
      script += "  user = User.find_by_email(#{user.email.dump})\n"
      script += "end\n"
      script += "if user\n"
      user.extensions.each do |ext|
        script += "  ext = Extension.new(:id => #{ext.id}, :user_id => user.id, :name => #{ext.name.dump}, :summary => #{ext.summary.dump}, :description => #{ext.description.dump}, :website => #{ext.website.dump}, :scm_location => #{ext.scm_location.dump}, :permalink => #{ext.permalink.dump}, :github_username => #{ext.github_username.dump}, :github_project => #{ext.github_project.dump}, :created_at => '#{ext.created_at}', :author_name => #{ext.author_name.dump rescue ''.dump})\n"
        script += "  ext.save(:validate => false)\n"
        ext.versions.each do |ver|
          script += "  ext.spree_versions << SpreeVersion.find_by_name(#{ver.name.dump})\n"
        end
        ext.tags.each do |tag|
          script += "  ext.tags << Tag.find_or_create_by_name(#{tag.name.dump})\n"
        end
      end
      script += "end\n"
    end
    
    File.open("create_extensions.rb", 'w') {|f| f.write(script) }
    
  end
end