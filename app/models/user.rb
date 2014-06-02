class User < ActiveRecord::Base

  before_create :generate_name

  private

  def generate_name
    self.name = Faker::Internet.user_name
  end
end
