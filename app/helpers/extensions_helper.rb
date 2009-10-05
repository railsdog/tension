module ExtensionsHelper
  def website_url(extension)
    extension.website? ? link_to(extension.website, extension.website) : '<i>Not defined</i>'
  end

  def can_edit_extension?(extension = @extension)
    logged_in? && (
      extension.owned_by(current_user) ||
        current_user.has_role?('site_admin') ||
        current_user.has_role?('extension_team')
    )
  end

  def can_remove_extension?(extension = @extension)
    logged_in? && (
      extension.owned_by(current_user) || current_user.has_role?('site_admin') 
    )
  end
end
