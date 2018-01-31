class FileUploader < Shrine
  # plugins and uploading logic
  plugin :determine_mime_type
end
