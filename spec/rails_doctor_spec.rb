require 'rails_doctor'


describe "Test migration parse" do
  before(:all) do
    @doctor = RailsDoctor.new
  end
  it 'check simple migration' do
    migration = <<EOF
class CreateUsers < ActiveRecord::Migration
  def change
    add_index :users, :role_id
    add_index :users, :other_id
  end
end
EOF
    @doctor.send(:parse_migration, migration).should == {:users =>['role_id', 'other_id']}
  end

  it 'check up-down migration' do
  migration = <<EOF
class CreateUsers < ActiveRecord::Migration
  def up
    add_index :users, :role_id
    add_index :users, :other_id
  end
  def down
    remove_index :users, :role_id
    remove_index :users, :other_id
  end
end
EOF
  @doctor.send(:parse_migration, migration).should == {:users =>['role_id', 'other_id']}
end


  it 'check up-down reverted migration' do
  migration = <<EOF
class CreateUsers < ActiveRecord::Migration
  def down
    add_index :users, :role_id
    add_index :users, :other_id
  end
  def up
    remove_index :users, :role_id
    remove_index :users, :other_id
  end
end
EOF
  @doctor.send(:parse_migration, migration).should == {}
end


end
