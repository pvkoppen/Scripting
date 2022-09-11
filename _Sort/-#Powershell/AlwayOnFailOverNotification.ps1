function sendMail{

     Write-Host "Sending Email"

     #SMTP server name
     $smtpServer = "smtp.tol.local"

     #Creating a Mail object
     $msg = new-object Net.Mail.MailMessage

     #Creating SMTP server object
     $smtp = new-object Net.Mail.SmtpClient($smtpServer)

     #Email structure 
     $msg.From = "TOLDB03@TOL.local"
     $msg.ReplyTo = "IT.Services@tuiora.co.nz"
     $msg.To.Add("IT.Services@tuiora.co.nz")
     $msg.subject = "TOLDB03 - Alway On Availabilty Group Failing Over"
     $msg.body = "TOLDB03 - Alway On Availabilty Group Failing Over"

     #Sending email 
     $smtp.Send($msg)
  
}

#Calling function
sendMail