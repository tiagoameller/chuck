module ControllerMacros
  def login_user(options = {})
    @request.env['devise.mapping'] = Devise.mappings[:user]
    attr = FactoryBot.attributes_for(:user)
    attr[:role] = options[:role] || :basic
    user = FactoryBot.create(:user, attr)
    sign_in user
    user
  end

  def login_admin(options = {})
    login_user(options.merge(role: :admin))
  end

  def login_employee(options = {})
    login_user(options.merge(role: :employee))
  end

  def prepare_attributes(attrs, enum_sym = nil, enum_class = nil)
    # from this:
    # {"id"=>1, "code"=>6050, "ref"=>"CE6101", "name"=>"BASICA FEMENINA", "status"=>0, "min_sale_units"=>0, "created_at"=>Fri,
    # #                                                                             ^
    # 17 Jul 2015 15:22:02 CEST +02:00, "updated_at"=>Fri, 17 Jul 2015 15:22:02 CEST +02:00}
    # to this:
    # {:id=>1, :code=>6050, :ref=>"CE6101", :name=>"BASICA FEMENINA", :status=>"on_creation", :min_sale_units=>0,
    # #                                                                        ^^^^^^^^^^^^^
    # :created_at=>Fri, 17 Jul 2015 15:22:02 CEST +02:00, :updated_at=>Fri, 17 Jul 2015 15:22:02 CEST +02:00}
    #
    # Sample:
    # enum_sym = :status
    # enum_class: Item
    attrs.map do |k, v|
      kk = k.to_sym
      if enum_sym && kk == enum_sym
        { kk => enum_class.send(enum_sym.to_s.pluralize).keys[v] }
      else
        { kk => v }
      end
    end.reduce(:merge)
  end
end
