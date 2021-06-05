class CreateDbExtensions < ActiveRecord::Migration[5.2]
def change
  enable_extension 'pgcrypto'
end
#  def up
#     execute <<-SQL
#       CREATE extension IF NOT EXISTS pgcrypto;
#     SQL
#   end

#   def down
#     execute 'drop extension if exists pgcypto'
#   end
end
