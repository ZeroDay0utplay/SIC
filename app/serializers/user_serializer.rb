class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :active, :authentication_token
end
