# From: https://github.com/heartcombo/simple_form#custom-components
# Sample use:
# = f.input( \
#   :password, \
# =>  wrapper: :vertical_form_password_view, \
# =>  show_password_eye: true, \
#  label: t('devise.partials--passwords.new_password'), \
#   required: true, autofocus: true, \
#  hint: (t('devise.partials--passwords.characters_minimum', characters_minimum: @minimum_password_length) if @minimum_password_length), \
#  input_html: { data: { action: 'input->partials--passwords#check', target: 'partials--passwords.password'} } \
# )
#
# This add-on works with the Stimulus.js controller: passwords_controller.js

module ShowPasswordEye
  # To avoid deprecation warning, you need to make the wrapper_options explicit
  # even when they won't be used.
  def show_password_eye(_wrapper_options = nil)
    @show_password_eye ||= begin
      tag.span(
        tag.i(class: 'c-icon cil-lightbulb'),
        class: 'input-group-text',
        data: {
          target: 'partials--passwords.eye',
          action: 'click->partials--passwords#eyeToggle'
        }
      ) if options[:show_password_eye].present?
    end
  end
end

SimpleForm.include_component(ShowPasswordEye)
