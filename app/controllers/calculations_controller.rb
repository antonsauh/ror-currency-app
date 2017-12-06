# Controller for Calculations
class CalculationsController < ApplicationController
  def new
    @calculation = Calculation.new
  end

  def all
    @user = current_user
    @calculations = @user.calculations.all
  end

  def edit
    @user = current_user
    if @user.calculations.exists?(params[:calculation_id])
      @calculation = @user.calculations.find(params[:calculation_id])
    else
      flash[:alert] = 'You do not have this calculation!'
      redirect_to root_path
    end
  end

  def update
    @calculation = Calculation.find(params[:calculation_id])
    if @calculation.update(calculation_params)
      flash[:success] = 'Calculation Updated'
      redirect_to calculations_path
    else
      render 'edit'
    end
  end

  def delete
    @calculation = Calculation.find(params[:calculation_id])
    if @calculation.destroy
      flash[:success] = 'Calculation Deleted!'
    else
      flash[:alert] = 'There was a problem with deleting your calclation,
       please try again'
    end
    redirect_to calculations_path
  end

  def show
    @user = current_user
    if @user.calculations.exists?(id: params['calculation_id'])
      @calculation = @user.calculations.find_by(id: params['calculation_id'])
      @top_three = @calculation.calculation_records.group_by { |r| r['total'] }
                               .sort_by { |k, _v| -k }
                               .first(3)
                               .map(&:last)
                               .flatten
    else
      flash[:alert] = 'You do not have this calculation!'
      redirect_to root_path
    end
  end

  def create
    params = calculation_params
    params['user'] = current_user
    if params['base_currency'] == params['target_currency']
      flash[:alert] = 'Base And Target currencies cannot be the same'
      redirect_to calculation_new_path
    else
      info_from_db = ApiService.get_rates(params['base_currency'], params['target_currency'])
      if info_from_db != 'ERROR'
        todays_rate = info_from_db[0]
        info_from_db.delete_at(0)
        params['date'] = Date.parse(todays_rate['date'])
        params['rate'] = todays_rate['rates']
        @calculation = Calculation.new(params)
        if @calculation.save
          if CalculationRecord.save_records_for_calculation(todays_rate, info_from_db, params['base_amount'].to_f, @calculation)
            redirect_to calculations_path
          else
            flash[:alert] = 'There was a problem with your calculation, please try again. Cannot save Calculation to Database.'
            redirect_to calculation_new_path
          end
        else
          flash[:alert] = 'There was a problem with your calculation, please try again. Cannot save Calculation to Database.'
          redirect_to calculation_new_path
        end
      else
        flash[:alert] = 'There was a problem with your calculation, please try again. API responded with error'
        redirect_to calculation_new_path
      end
    end
  end

  private

  def calculation_params
    params.require(:calculation).permit(:base_currency, :target_currency, :period, :base_amount)
  end
end
