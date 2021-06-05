#
# company
#

m01sl = Company.create!(
  name: 'Menorca Zeros i Uns SL',
  vat_number: 'ESB57534125',
  address_one: 'Font i Vidal, 5',
  address_two: 'Local comercial',
  zip_code: '07703',
  city: 'Maó',
  state: 'IB',
  country: 'ES',
  email: 'info@sistemasc.net',
  website: 'https://www.sistemasc.net',
  phone: '971352233',
  admin_name: 'Tiago Ameller'
)

#
# users
#

m01sl.users.create!(
  name: 'Tiago Ameller',
  password: '123456',
  email: 'tiago@sistemasc.net',
  comment: '',
  role: :admin,
  default_admin: true
)

m01sl.users.create!(
  name: 'Tiago Ameller',
  password: '123456',
  email: 'tiago.ameller@gmail.com',
  comment: '',
  role: :super_admin
)

