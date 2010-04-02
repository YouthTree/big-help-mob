class CreateDynamicTemplates < ActiveRecord::Migration
  def self.up
    create_table :dynamic_templates do |t|
      t.string :key
      t.string :template_type
      t.string :content_type
      t.text   :parts
      t.belongs_to :parent, :polymorphic => true
      t.timestamps
    end
    add_index :dynamic_templates, :key
    add_index :dynamic_templates, :template_type
    add_index :dynamic_templates, [:key, :template_type]
    add_index :dynamic_templates, [:key, :template_type, :content_type], :name => "idx_dynamic_templates_on_keys"
  end

  def self.down
    drop_table :dynamic_templates
  end
end
