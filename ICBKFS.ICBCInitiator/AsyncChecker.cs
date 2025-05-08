using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace ICBKFS.ICBCInitiator
{
    public static class AsyncChecker
    {
        public static void MyCaller(string msmq)
        {

            Thread.Sleep(120000);
            Console.WriteLine("Asychronous checking...");

            if (!StatusFlags.Instance.IsConnected)
            {
                var gateway = StatusFlags.Instance.EmailIP;
                var port = StatusFlags.Instance.EmailPort;
                var subject = string.Format("{0} fix engine is not started successfully", msmq);
                var body = "Please check connection";
                var sendfrom = string.Format("{0}@icbkfs.com", msmq);


                var mail = new MailMessage
                {
                    From = new MailAddress(sendfrom),
                    Subject = subject,
                    Body = body,
                    IsBodyHtml = false
                };

                foreach(string email in StatusFlags.Instance.Emaills) {
                    mail.To.Add(email);
                }
                
          


                var smtpServer = new SmtpClient(gateway) { Port = port };

                try
                {
                    smtpServer.Send(mail);
                }
                catch (Exception ex)
                {

                    Console.WriteLine(ex.Message);
                }
            }



            int ec = StatusFlags.Instance.BeatCounts;

            while (true)
            {

                Thread.Sleep(180000);

                int lc = StatusFlags.Instance.BeatCounts;

                if (!(ec < lc))
                {
                    Console.WriteLine("Heart beats counts doesn't increase in 3 min");
                    var gateway = StatusFlags.Instance.EmailIP;
                    var port = StatusFlags.Instance.EmailPort;
                    var subject = string.Format("{0} fix engine is not running", msmq);
                    var body = "Heart beats counts doesn't increase in 3 min";
                    var sendfrom = string.Format("{0}@icbkfs.com", msmq);


                    var mail = new MailMessage
                    {
                        From = new MailAddress(sendfrom),
                        Subject = subject,
                        Body = body,
                        IsBodyHtml = false
                    };


                    foreach (string email in StatusFlags.Instance.Emaills)
                    {
                        mail.To.Add(email);
                    }


                    var smtpServer = new SmtpClient(gateway) { Port = port };

                    try
                    {
                        smtpServer.Send(mail);
                    }
                    catch (Exception ex)
                    {

                        Console.WriteLine(ex.Message);
                    }
                }
            }

        }
    }
}
