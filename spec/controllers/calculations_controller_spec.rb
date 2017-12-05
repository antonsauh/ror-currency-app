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
                @calculation = Calculation.create({'base_currency' => 'EUR', 'target_currency' => 'USD', 'user' => @user, 'period' => 1,
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
        let(:calc_params) do
                {
                :base_currency => 'USD',
                :target_currency => 'EUR',
                :period => 2,
                :base_amount => 2500,
                :date => '01-01-2017',
                :user_id => @user.id
                }
        end
        let(:wrong_calc_params) do
                {
                :base_currency => 'USD',
                :target_currency => 'USD',
                :period => 1,
                :base_amount => 2500,
                :date => '01-01-2017',
                :user_id => @user.id
                }
        end
        context 'logged in user' do
            login_user
            it 'should update the calculation' do
                @user = subject.current_user
                @calculation = Calculation.create({'base_currency' => 'USD', 'target_currency' => 'EUR', 'user' => @user, 'period' => 1,
                 'base_amount' => 2500, 'date' => '01-01-2017' })
                patch :update, params: {'calculation_id' => @calculation.id, 'calculation' => calc_params}
                @calculation.reload
                expect(@calculation.period).to eql calc_params[:period]
                expect(response).to redirect_to(calculations_path)
            end
            it 'should not update the calculation and show flash error message' do
                @user = subject.current_user
                @calculation = Calculation.create({'base_currency' => 'USD', 'target_currency' => 'EUR', 'user' => @user, 'period' => 1,
                 'base_amount' => 2500, 'date' => '01-01-2017' })
                patch :update, params: {'calculation_id' => @calculation.id, 'calculation' => wrong_calc_params}
                @calculation.reload
                expect(@calculation.period).not_to eql calc_params[:period]
                expect(response).to render_template('edit')
                expect(flash[:danger]).to be_present
            end
        end
    end
    describe 'DELETE /delete' do
        context 'logged in user' do
            login_user
            it 'should delete the calculation' do
                @user = subject.current_user
                @calculation = Calculation.create({'base_currency' => 'USD', 'target_currency' => 'EUR', 'user' => @user, 'period' => 1,
                    'base_amount' => 2500, 'date' => '01-01-2017' })
                expect do
                    delete :delete, params: {'calculation_id' => @calculation.id}
                end.to change {
                    Calculation.count
                }
            end
            it 'should redirect to /all after deletion' do
                @user = subject.current_user
                @calculation = Calculation.create({'base_currency' => 'USD', 'target_currency' => 'EUR', 'user' => @user, 'period' => 1,
                    'base_amount' => 2500, 'date' => '01-01-2017' })
                calc_cnt = Calculation.count
                delete :delete, params: {'calculation_id' => @calculation.id}
                expect(response).to redirect_to(calculations_path)
                expect(flash[:success]).to be_present

            end
        end
    end
    describe 'GET /show' do
        context 'not logged in user' do
            it 'should redirect unauthorized user to login path' do
                get :show, params: {'calculation_id' => 1}
                expect(response).to redirect_to(new_user_session_path)
            end
        end
        context 'logged in user' do
            login_user
            it 'should show user calculation page' do
                @user = subject.current_user
                @calculation = Calculation.create({'base_currency' => 'EUR', 'target_currency' => 'USD', 'user' => @user, 'period' => 1,
                 'base_amount' => 2500, 'date' => '01-01-2017' })
                 get :show, params: {'calculation_id' => @calculation.id}
                 expect(response).to render_template('show')
            end
            it 'should redirect user to "/" and show error message if user doesnt have this calcualtion' do
                @user = subject.current_user
                get :show, params: {'calculation_id' => 3}
                expect(response).to redirect_to(root_path)
                expect(flash[:alert]).to be_present
            end
        end
    end
    describe 'POST /create' do
        let(:calc_params) do
            { calculation:   {
                :base_currency => 'USD',
                :target_currency => 'EUR',
                :period => 2,
                :base_amount => 2500,
                :date => '01-01-2017',
                :user_id => @user.id
                }
            }
        end
        context 'logged in user' do
            login_user
            it 'should create new calculation with records' do
                @user = subject.current_user
                post :create, params: calc_params
                expect(response).to redirect_to (calculations_path)

            end
            it 'should not create new calculation if base_currency and target_currency are equal' do

            end
        end
    end

end