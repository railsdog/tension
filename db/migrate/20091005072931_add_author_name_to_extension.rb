class AddAuthorNameToExtension < ActiveRecord::Migration
  def self.up
    add_column :extensions, :author_name, :string
    Extension.all.each do |e|
      e.update_attribute(:author_name, e.author.name)
    end
  end

  def self.down
    remove_column :extensions, :author_name
  end
end
