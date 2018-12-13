require 'sinatra'
require 'sinatra/cookies'
require './ssl'

configure do
  set :port => 2019
  disable :logging, :show_exceptions
  enable :quiet
end

# KAMAR portal
get '/' do 'Fake KAMAR portal <input name="csrf_kamar_sn" value="nil" type="hidden" />' end

get '/index.php/:page' do
  puts 'GOT ' + cookies[:csrf_kamar_cn]
  # TODO: use cookie with their StuID to send proper data
  case params['page']
  when 'change-password' then '<h1 id="notification">Done</h1>'
  when 'financial' then 'TODO:'
  when 'course_selection' then 'TODO:'
  when 'reports' then 'TODO:'
  when 'current_year_results' then 'TODO:'
  else "Unknown page: #{params['page']}"
  end
end
post '/index.php/:page' do
  case params['page']
  when 'login'
    cookies[:csrf_kamar_cn] = 'C 👏 S 👏 R 👏 F'
    cookies[:kamar_session] = params['StudentID']
    send_file './data/login.html'
  when 'change-password' then '' # no response
  else "Unknown page: #{params['page']}"
  end
end

# TODO: add report and finance receipts PDFs

# KAMAR API
get '/api/img.php' do send_file "./data/#{params['StuID'] or params['Code']}/dp.jpg" end
post '/api/api.php' do
  # TODO: handle submit attendance
  id = params['StudentID']
  case params['Command']
  when 'GetGlobals' then send_file './data/GetGlobals.xml'
  when 'GetSettings' then send_file './data/GetSettings.xml'
  when 'GetCalendar' then send_file './data/GetCalendar.xml'
  when 'Logon' then send_file './generic-responses/Logon.xml'
  when 'GetStudentDetails' then send_file "./data/#{id}/GetStudentDetails.xml"
  when 'GetStudentAttendance' then send_file "./data/#{id}/GetStudentAttendance.xml"
  when 'GetStudentTimetable' then send_file "./data/#{id}/GetStudentTimetable.xml"
  when 'GetStudentAbsenceStats' then send_file "./data/#{id}/GetStudentAbsenceStats.xml"
  when 'GetStudentNCEASummary' then send_file "./data/#{id}/GetStudentNCEASummary.xml"
  when 'GetStudentOfficialResults' then send_file "./data/#{id}/GetStudentOfficialResults.xml"
  when 'GetStudentResults' then send_file "./data/#{id}/GetStudentResults.xml"
  when 'GetStudentGroups' then send_file "./data/#{id}/GetStudentGroups.xml"
  when 'GetStudentPastoral' then send_file "./data/#{id}/GetStudentPastoral.xml"
  else "Unknown command: #{params['Command']}"
  end
end
