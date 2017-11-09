class CreateFreeProxies < ActiveRecord::Migration[5.0]
  def change
    create_table :free_proxies do |t|
      t.string :url
      t.string :host
      t.string :port
      t.timestamps
    end
  end
end
