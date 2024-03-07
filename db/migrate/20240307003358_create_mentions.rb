class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.integer :mentioning_report_id
      t.integer :mentioned_report_id

      t.timestamps
    end
    add_foreign_key :mentions, :reports, column: :mentioning_report_id
    add_foreign_key :mentions, :reports, column: :mentioned_report_id
    add_index :mentions, [:mentioning_report_id, :mentioned_report_id], unique: true
  end
end
