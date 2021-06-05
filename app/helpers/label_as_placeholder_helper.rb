require 'label_as_placeholder_form_builder'

module LabelAsPlaceholderHelper
  def label_as_placeholder_form_for(object, *args, &block)
    options = args.extract_options!
    simple_form_for(object, *(args << options.merge(builder: LabelAsPlaceholderFormBuilder)), &block)
  end

  def label_as_placeholder_fields_for(*args, &block)
    options = args.extract_options!
    simple_fields_for(*(args << options.merge(builder: LabelAsPlaceholderFormBuilder)), &block)
  end
end
