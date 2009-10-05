class AddAuthorNameToExtension < ActiveRecord::Migration
  def self.up
    add_column :extensions, :author_name, :string
  end

  def self.down
    remove_column :extensions, :author_name
  end
end
