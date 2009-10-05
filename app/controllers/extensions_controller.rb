class ExtensionsController < ApplicationController
  before_filter :load_data, :only => [:new, :edit, :create, :update]  
  before_filter :load_extension, :only => [:show, :destroy]
  def index
    respond_to do |format|
      format.html {
        conditions = params[:version] ? {:version=> params[:version]} : nil
        @extensions = Extension.paginate(:all,
          :conditions => conditions,
          :page => params[:page],
          :order => 'updated_at DESC',
          :per_page => 10
        )
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
      @extension = current_user.has_role?(:site_admin) ? Extension.find(params[:id]) : current_user.extensions.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Extension not found as yours!" 
      redirect_to extensions_url
    end
  end
  
  def update
    @extension = current_user.has_role?(:site_admin) ? Extension.find(params[:id]) : current_user.extensions.find(params[:id])
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
