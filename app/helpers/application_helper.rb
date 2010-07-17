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

  def options_for_select_with_attributes(container, selected = nil)
    container = container.to_a if Hash === container
    selected, disabled = extract_selected_and_disabled(selected)

    options_for_select = container.inject([]) do |options, element|
      text, value, html_attributes = option_text_value_and_html_attributes(element)
      selected_attribute = ' selected="selected"' if option_value_selected?(value, selected)
      disabled_attribute = ' disabled="disabled"' if disabled && option_value_selected?(value, disabled)
      unless html_attributes.blank?
        attribute_string = ""
        html_attributes.each do |k,v|
           attribute_string += " #{k}=\"#{v}\""
        end
      end
      options << %(<option value="#{html_escape(value.to_s)}"#{selected_attribute}#{disabled_attribute}#{attribute_string}>#{html_escape(text.to_s)}</option>)
    end
    options_for_select.join("\n")
  end

  #based on option_text_and_value method, see vendor/rails/actionpack/lib/action_view/helpers/form_options_helper.rb:488
  def option_text_value_and_html_attributes(option)
    # Options are [text, value, attributes] pairs or triples, or a string which is used for content and value
    if !option.is_a?(String) and option.respond_to?(:first)
      [option.first, option[1], option[2]]
    else
      #just return the string for the content and value and nothing for the title
      [option, option, nil]
    end
  end
end

