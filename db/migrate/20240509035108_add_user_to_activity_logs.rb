class AddUserToActivityLogs < ActiveRecord::Migration[7.1]
  def change
    add_reference :activity_logs, :user, null: false, foreign_key: true
  end
end
