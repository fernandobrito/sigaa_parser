# To implement a Browser Adapter,
# the following methods should be implemented.
# See WatirAdapter for more information
SigaaParser::BrowserAdapter = interface do
  required_methods :visit, :source_code, :text_field, :div, :span,
                   :images, :labels, :td, :select_list, :button
end
