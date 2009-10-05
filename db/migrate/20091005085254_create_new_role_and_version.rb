class CreateNewRoleAndVersion < ActiveRecord::Migration
  def self.up
    Role.create({:name => "extension_team", :description => "Members of extension team.(can edit extensions)"})
    Version.create(:name => "0.9.0")
  end

  def self.down
    Role.destroy_all(:name => "extension_team")
    Version.destroy_all(:name => "0.9.0")
  end
end
