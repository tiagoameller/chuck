class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.integer :kind
      t.string :question
      t.integer :answer_count, default: 0

      t.timestamps
    end
    add_index :questions, [:created_at], order: { created_at: :desc }
  end
end
