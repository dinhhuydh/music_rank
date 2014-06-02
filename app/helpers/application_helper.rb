module ApplicationHelper
  def application_options(user = nil)
    { user: user }.to_json
  end
end
