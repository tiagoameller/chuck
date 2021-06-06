# Preview all emails at http://localhost:3000/rails/mailers/user
class UserPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user/answer
  def answers
    UserMailer.answers('fake@email.com')
  end
end
