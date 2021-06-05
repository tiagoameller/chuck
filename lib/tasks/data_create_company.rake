# call as
# rails namespace:task\[param1, param2\]
# or
# rails 'namespace:task[param1, param2]'
#
# this task:
# rails data:create_company\['5f409194-3615-4604-84b8-52d3d0420b0e'\]
class CreateCompany
  def initialize(prospect_id)
    @prospects =
      if prospect_id.present?
        [Prospect.find(prospect_id)]
      else
        Prospect.where(processed: false)
      end
  end

  def execute
    puts "Creating #{@prospects.size} companies ..."
    @prospects.each do |prospect|
      company = Company.find_by email: prospect.email.downcase
      if company.present?
        puts "Email #{prospect.email} is already used in company #{company.full_name}"
      else
        create_company_from prospect
      end
      prospect.update processed: true
    end
  end

  private

  def create_company_from(prospect)
    puts "Creating #{prospect.company_name} ..."
    company = Company.create!(
      name: prospect.company_name,
      vat_number: prospect.vat_number,
      city: prospect.location,
      email: prospect.email
    )
    passw = SecureRandom.hex[0..7]
    admin = company.users.create!(
      name: prospect.username,
      password: passw,
      email: prospect.email.downcase,
      role: :admin,
      default_admin: true
    )
    puts "Login   : #{admin.loginname}"
    puts "Password: #{passw}"
    puts "Email   : #{admin.email}"
  end
end

desc 'Create a company from a prospect record'
namespace :data do
  task :create_company, [:prospect_id] => [:environment] do |_task, args|
    # main
    CreateCompany.new(args[:prospect_id]).execute
  end
end
