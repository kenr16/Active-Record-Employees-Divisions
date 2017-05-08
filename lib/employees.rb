class Employee < ActiveRecord::Base
  belongs_to(:division)
  validates(:name, {:presence => true, :length => { :maximum => 50 }})
  before_save(:downcase_name)

private

  define_method(:downcase_name) do
    self.name=(name().downcase())
  end

end
