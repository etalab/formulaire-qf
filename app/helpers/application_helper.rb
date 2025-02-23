module ApplicationHelper
  def external_link(text, url)
    link_to text, url, target: "_blank", rel: "noopener noreferrer", title: "#{text} - nouvelle fenêtre"
  end
end
