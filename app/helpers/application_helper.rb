# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  #returns a title even if no @title is given in the method
  def title
    base_title = Constant::SITE_NAME
    if @title.blank?
      base_title
    else
      "#{base_title} | #{h @title}"
    end
  end

  def logo
    image_tag("logo.png", :alt => "budgit_logo", :title => "Budgit", :class => "round")
  end
end

