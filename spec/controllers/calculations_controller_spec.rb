require 'rails_helper'

RSpec.describe CalculationsController, type: :controller do
    describe 'GET /new' do
        it 'should redirect unauthorized user to login path' do
            get :new
            expect(response).to redirect_to(new_user_session_path)
        end

        context 'logged in user' do
            login_user
            it 'should render new calculation template to logged in user' do
                get :new
                expect(response).to render_template('new')
            end
        end
    end

    describe 'GET /all' do

        it 'should redirect unathorized user to login path' do
            get :all
            expect(response).to redirect_to(new_user_session_path)
        end

        context 'logged in user' do
            login_user
            it 'should show all user calculations template to logged in user' do
                get :all
                expect(response).to render_template('all')
            end
        end
    end

    describe 'GET /edit' do

        it 'should redirect unathorized user to login path' do
            get :edit, params: {'calculation_id' => 1}
            expect(response).to redirect_to(new_user_session_path)
        end

        context 'logged in user' do
            login_user
            it 'should show user calculation edit template if user has this calculation' do
                @user = subject.current_user
                @calculation = Calculation.create({'base_currency' => 'EUR', 'target_currency' => 'EUR', 'user' => @user, 'period' => 1,
                 'base_amount' => 2500, 'date' => '01-01-2017' })
                get :edit, params: { 'calculation_id' => @calculation['id'] }
                expect(response).to render_template('edit')
            end
            it 'should redirect user to root path if user do not have this calculation' do
                @user = subject.current_user
                @calculation = Calculation.create({'base_currency' => 'EUR', 'target_currency' => 'EUR', 'user' => @user, 'period' => 1,
                 'base_amount' => 2500, 'date' => '01-01-2017' })
                get :edit, params: { 'calculation_id' => 3 }
                expect(response).to redirect_to('/')
            end     
        end
    end

    describe 'PATCH /update' do
        
    end

end