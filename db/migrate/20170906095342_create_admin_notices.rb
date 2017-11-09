class CreateAdminNotices < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_notices do |t|
      t.string :message
      t.boolean :published
    end
  end
end
