require 'zxcvbn'

module FormPasswordValidator
  extend ActiveSupport::Concern

  included do
    attr_accessor :password
    attr_reader :user

    validates :password,
              presence: true,
              length: Devise.password_length

    validate :strong_password, if: :password_strength_enabled?
  end

  private

  ZXCVBN_TESTER = ::Zxcvbn::Tester.new

  def strong_password
    return unless errors.messages.blank? && password_score.score < min_password_score

    errors.add :password, :weak_password, i18n_variables
  end

  def password_score
    @pass_score ||= ZXCVBN_TESTER.test(password, custom_weak_words)
  end

  def custom_weak_words
    [user_email, split_email(user_email), APP_NAME].flatten
  end

  def user_email
    @user_email ||= user.email
  end

  def split_email(email_address)
    email_address.split(/[[:^word:]_]/)
  end

  def min_password_score
    Figaro.env.min_password_score.to_i
  end

  def i18n_variables
    {
      feedback: zxcvbn_feedback
    }
  end

  def zxcvbn_feedback
    feedback = @pass_score.feedback.values.flatten.reject(&:empty?)

    feedback.join('. ').gsub(/\.\s*\./, '.')
  end

  def password_strength_enabled?
    @enabled ||= FeatureManagement.password_strength_enabled?
  end
end
