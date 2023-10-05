class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.bigint :article_id
      t.text :content

      t.timestamps
    end

    add_index :comments, :article_id
  end
end
