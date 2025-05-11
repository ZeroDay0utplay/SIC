module CompanyScoped
  extend ActiveSupport::Concern

  included do
    scope :current_company, -> { where(company: Current.company) }
    before_validation :set_company
  end

  private

  def set_company
    if has_attribute?(:company_id)
      self.company ||= Company.current
    end
  end
end
