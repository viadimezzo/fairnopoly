module Fairtastic
  module Inputs
    module Base
      module Tooltips 

        def tooltip_html(tooltip_content = options[:tooltip])
          if tooltip_content
            tooltip_content = I18n.t("#{object_name}.hints.#{method}") if options[:tooltip] == true
    
            template.content_tag(:a,
              template.content_tag(:span,
              tooltip_content),
              :class => "input-tooltip")
          else
            ""
          end
        end
        
      end
    end
  end
end
