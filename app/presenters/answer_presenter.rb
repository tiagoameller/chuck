class AnswerPresenter < ApplicationPresenter
  def categories_array
    if categories.blank?
      []
    else
      categories.split '|'
    end
  end
end
