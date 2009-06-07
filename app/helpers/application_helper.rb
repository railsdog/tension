# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def flash_message
    messages = ""
    [:notice, :info, :warning, :error].each do|type|
      if flash[type]
        messages= "<div id='flash' class=\"#{type}\">#{flash[type]}</div>"
      end
    end
    messages
  end

  def navigation(*links)
      items = []
      links.each do |link|
        if (controller.controller_name.to_sym == link[0])
          items << content_tag(:li, link_to("#{link[1]}", link[0], :title => "Go to #{link[1]}"), :class => "active")
        else
          items << content_tag(:li, link_to("#{link[1]}", link[0], :title => "Go to #{link[1]}"))
        end
      end
      content_tag :ul, items, :id => 'tabnav'
  end

  # this version calculates relative popularity, not absolute popularity
  # eg [1,1,100,100] is very different from [50,50,100,100] 
  def tag_cloud(tags, classes)
    return if tags.empty?

    counts = tags.sort_by(&:count)
    min_count = counts.first.count
    max_count = counts.last.count
    count_range = max_count - min_count + 0.1 

    tags.each do |tag|
      index = (tag.count - min_count) * classes.size / count_range
      yield tag, classes[index.truncate]
    end
  end


end
