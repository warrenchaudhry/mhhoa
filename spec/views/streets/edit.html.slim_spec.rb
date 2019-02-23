require 'rails_helper'

RSpec.describe 'streets/edit', type: :view do
  before(:each) do
    @street = assign(:street, Street.create!(
      :name => 'MyString'
    ))
  end

  it 'renders the edit street form' do
    render

    assert_select 'form[action=?][method=?]', street_path(@street), 'post' do
      assert_select 'input[name=?]', 'street[name]'
    end
  end
end
