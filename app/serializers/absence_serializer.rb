class AbsenceSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :date_start, :date_end, :motif, :document, :state, :absence_type, :user_name

  def state
    I18n.t("enums.absence_state.#{object.state}")
  end

  def user_name
    object.user.full_name
  end

  def absence_type
    I18n.t("enums.type_absence.#{object.type_absence}")
  end
end
