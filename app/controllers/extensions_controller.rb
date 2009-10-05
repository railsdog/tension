class ExtensionsController < ApplicationController
  before_filter :load_data, :only => [:new, :edit, :create, :update]  
  before_filter :load_extension, :only => [:show, :destroy]

  include ExtensionsHelper
  
  def index
    respond_to do |format|
      format.html {
        options = {
          :page => params[:page],
          :order => 'extensions.updated_at DESC',
          :per_page => 10
        }
        if params[:versions]
          options.merge!({
              :include => :versions, 
              :conditions => ["extensions_versions.version_id IN (?)", params[:versions].map(&:to_i)]      
            })
        end
          
        @extensions = Extension.paginate(:all, options)
      }
      format.rss {
        @extensions = Extension.find(:all,
          :order => 'updated_at DESC',
          :limit => 5
        )
      }
    end
  end
  
  def my_extensions
    @extensions = current_user.extensions.paginate(:all, 
      :page => params[:page],
      :order => 'updated_at DESC',
      :per_page => 10
    )
  end

  def show
  end

  def new
    @extension = current_user.extensions.new
  end

  def create
    @extension = current_user.extensions.new(params[:extension])

    respond_to do |format|
      if @extension.save
        flash[:notice] = "Spree Extension added succesfully."
        format.html { redirect_to extension_path(@extension)}
      else
        flash[:error] = "There're some problems adding this extension'."
        format.html { render :action => "new" }
      end
    end
  end
  
  def edit
    begin
      @extension = Extension.find(params[:id])
      unless can_edit_extension?
        flash[:error] = "You can't edit this extension!" 
        redirect_to extensions_url
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Could not find extension with that id!"
      redirect_to extensions_url
    end
  end
  
  def update
    @extension = Extension.find(params[:id])
    unless can_edit_extension?
      flash[:error] = "You can't edit this extension!"
      redirect_to extensions_url
    end
    respond_to do |format|
      if @extension.update_attributes(params[:extension])
        flash[:notice] = "Spree Extension updated succesfully."
        format.html { redirect_to extension_path(@extension)}
      else
        flash[:error] = "There're some problems updating this extension'."
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy    
    respond_to do |format|    
      if @extension.destroy
        flash[:notice] = "Spree Extension deleted succesfully."
        format.html { redirect_to extensions_url}        
      else
        flash[:error] = "There're some problems deleting this extension'."        
      end
    end
  end

  

  private
  def load_data
    @available_versions = Version.all
  end
  
  def load_extension
    @extension = object
  end

  def object
    Extension.find(params[:id])    
  end
end
