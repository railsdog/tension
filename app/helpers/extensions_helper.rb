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

  def github_api_url(user, project)
    "http://github.com/api/v1/json/#{user.strip}/#{project.strip}/commits/master"
  end

  def get_last_update_date(extension)
    if extension.github?
      api_url = github_api_url(extension.github_username, extension.github_project)
      parsed_response = Cache.get(api_url, 24.hours){
        response = Net::HTTP.get_response(URI.parse(api_url) )
        JSON.parse(response.body) rescue nil
      }
      if parsed_response
        last_update_at = Time.parse(parsed_response["commits"].first["authored_date"]) rescue ""
        return last_update_at.blank? ? "" : time_ago_in_words(last_update_at)+" ago (from github)"
      end
    end
    nil
  end

  def extension_author(extension)
    (extension.author && extension.author_name.blank?) ?
      link_to(extension.author.name, user_path(extension.author)) :
      extension.author_name
  end
end
