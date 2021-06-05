class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.belongs_to :question, null: false, foreign_key: true
      t.string :categories
      t.string :url
      t.text :value

      t.timestamps
    end
  end
end
