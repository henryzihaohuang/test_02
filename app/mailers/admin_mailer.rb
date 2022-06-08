class AdminMailer < ApplicationMailer
  def pipelines_export(zip_file_path)
    attachments["pipelines.gz"] = File.read(zip_file_path)

    mail to: "david@onmogul.com", subject: "Pipelines export", body: ""
  end
end
