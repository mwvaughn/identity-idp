module Idv
  class ReviewController < StepController
    include PhoneConfirmation

    before_action :confirm_idv_steps_complete

    helper_method :idv_params

    def confirm_idv_steps_complete
      redirect_to idv_finance_path unless idv_finance_complete?
      redirect_to idv_phone_path unless idv_phone_complete?
    end

    def new
      idv_session.params.symbolize_keys!
    end

    def create
      resolution = start_idv_session
      process_resolution(resolution)
    end

    private

    def process_resolution(resolution)
      if resolution.success
        init_questions_and_profile(resolution)
        redirect_on_success
      elsif idv_attempter.exceeded?
        redirect_to idv_fail_url
      else
        redirect_to idv_retry_url
      end
    end

    def idv_finance_complete?
      (idv_session.params.keys & Idv::FinanceForm::FINANCE_TYPES).any?
    end

    def idv_phone_complete?
      idv_session.params[:phone].present?
    end

    def redirect_on_success
      if phone_confirmation_required?
        prompt_to_confirm_phone(phone: idv_params[:phone], otp_method: nil, context: 'idv')
      else
        redirect_to idv_questions_path
      end
    end

    def idv_params
      idv_session.params
    end

    def phone_confirmation_required?
      !idv_params[:phone_confirmed_at] || idv_params[:phone] != current_user.phone
    end

    def start_idv_session
      idv_session.applicant = idv_session.applicant_from_params
      idv_session.vendor = idv_agent.vendor
      submit_applicant
    end

    def submit_applicant
      resolution = idv_agent.start(idv_session.applicant)
      idv_attempter.increment
      resolution
    end
  end
end
