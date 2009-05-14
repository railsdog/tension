class RemoveGithubColumn < ActiveRecord::Migration
  def self.up 
    change_table :extensions do |t|
      t.remove :github
      t.rename :username, :github_username
      t.rename :repository, :github_project
    end
  end

  def self.down
  end
end
