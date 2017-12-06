require 'rails_helper'
RSpec.describe WelcomeController, type: :controller do
  before do
    @user = FactoryBot.create(:user)
    get :index
  end

  it 'responses with status 200' do
    expect(response).to be_success
  end

  it 'allows authenticated access' do
    current_user = sign_in @user
    expect(current_user).to_not eq(nil)
  end

  it 'renders the right template' do
    expect(response).to render_template('index')
  end
end
