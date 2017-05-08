require('sinatra')
require('sinatra/reloader')
require('sinatra/activerecord')
also_reload('lib/**/*.rb')
require('./lib/divisions')
require('./lib/employees')
require('pg')
require('pry')

get('/') do
  @divisions = Division.all
  @employees = Employee.all
  erb(:index)
end

post('/divisions') do
  name = params.fetch("division_name")
  @division = Division.new({:name => name, :id => nil})
  @division.save()
  @divisions = Division.all
  @employees = Employee.all
  erb(:index)
end

get('/divisions/:id') do
  @division = Division.find(params.fetch("id").to_i())
  erb(:division)
end

post('/employees') do
  name = params.fetch("employee_name")
  @division = Division.find(params.fetch("division_id"))
  @employee = Employee.new({:name => name, :id => nil, :division_id => @division.id})
  @employee.save()
  @divisions = Division.all
  @employees = Employee.all
  erb(:index)
end

patch('/divisions/:id') do
  @division = Division.find(params.fetch("id").to_i())
  name = params.fetch("division_name")
  @division.update({:name => name})
  erb(:division)
end

delete('/divisions/:id') do
  @division = Division.find(params.fetch("id").to_i())
  @division.delete
  # I NEED THE CODE HERE TO DELETE ALL EMPLOYEES ASSIGNED TO THIS DIVISION.
  @employees = Employee.all()
  @employees.each do |employee|
    if employee.division_id == @division.id
      employee.delete
    end
  end
  @divisions = Division.all
  @employees = Employee.all
  erb(:index)
end
