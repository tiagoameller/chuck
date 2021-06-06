class SetLanguageController < ApplicationController
  def spanish
    I18n.default_locale = :es
    set_locale_and_reload
  end

  def english
    I18n.default_locale = :en
    set_locale_and_reload
  end

  private

  def set_locale_and_reload
    # session[:locale] = I18n.default_locale
    # respond_to do |format|
    #   format.js { render inline: 'location.reload();' }
    # end
  end
end
