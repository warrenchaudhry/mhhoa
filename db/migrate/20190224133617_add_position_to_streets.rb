class AddPositionToStreets < ActiveRecord::Migration[5.2]
  def change
    add_column :streets, :position, :integer, default: 0
    add_column :homeowners, :position, :integer, default: 0
  end
end
