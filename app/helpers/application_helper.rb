module ApplicationHelper
  #custom exceptions
  FileSaveError   = Class.new(StandardError)
  FileDeleteError = Class.new(StandardError)    
end
