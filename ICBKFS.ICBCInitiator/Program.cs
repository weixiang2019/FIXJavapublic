using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading;
using QuickFix;
using QuickFix.Transport;

namespace ICBKFS.ICBCInitiator
{
    class Program
    {

        public delegate void Mydel(string msmq);

        [STAThread]
        static void Main(string[] args)
        {


            try
            {

                string path = Assembly.GetExecutingAssembly().Location.Replace(@"\ICBKFS.ICBCInitiator.exe", "");
                var configpath = path + @"\icbcclient.cfg";
        


            var settings = new SessionSettings(configpath);
            var app = new IcbcClientApp()
            {
                FIXSessionSettings = settings,
            };
            var lstSessions = settings.GetSessions();

            string title = string.Empty;

            foreach (var t in lstSessions)
            {
                 title = settings.Get((SessionID)t).GetString("AppTitle");
                if (title != null)
                    break;
            }

            Console.Title = title;
            Console.WriteLine("=============");
            Console.WriteLine(title);
            Console.WriteLine("=============");

            foreach (var t in lstSessions)
            {
                app.ReadMQ1 = settings.Get((SessionID)t).GetString("ReadMQ1");
                if (app.ReadMQ1 != null)
                    break;
            }

            foreach (var t in lstSessions)
            {
                app.ReadMQ2 = settings.Get((SessionID)t).GetString("ReadMQ2");
                if (app.ReadMQ2 != null)
                    break;
            }


            foreach (var t in lstSessions)
            {
                app.WriteMQ = settings.Get((SessionID)t).GetString("WriteMQ");
                if (app.WriteMQ != null)
                    break;
            }

            foreach (var t in lstSessions)
            {
                app.EmailsToAert = settings.Get((SessionID)t).GetString("EmailAlerts");
                if (app.EmailsToAert != null)
                    break;
            }
            foreach (var t in lstSessions)
            {
                app.EmailGateway = settings.Get((SessionID)t).GetString("EmailGateWay");
                if (app.EmailGateway != null)
                    break;
            }
            foreach (var t in lstSessions)
            {
                app.AppName = settings.Get((SessionID)t).GetString("AppTitle");
                if (app.AppName != null)
                    break;
            }
            foreach (var t in lstSessions)
            {
                var tt0 = settings.Get((SessionID)t).GetString("SendEmailAlerts");
                if (tt0 != null)
                {
                    bool sendAlert;
                    if (bool.TryParse(tt0, out sendAlert))
                    {
                        app.SendEmailAlert = sendAlert;
                    }
                    break;
                }

            }

            foreach (var t in lstSessions)
            {
                var tt1 = settings.Get((SessionID)t).GetString("MQ1Transational");
                if (tt1 != null)
                {
                    bool transactional1;
                    if (bool.TryParse(tt1, out transactional1))
                    {
                        app.MQ1Transational = transactional1;
                    }
                    break;
                }

            }

            foreach (var t in lstSessions)
            {
                var tt2 = settings.Get((SessionID)t).GetString("MQ2Transational");
                if (tt2 != null)
                {
                    bool transactional2;
                    if (bool.TryParse(tt2, out transactional2))
                    {
                        app.MQ2Transational = transactional2;
                    }
                    break;
                }

            }

            foreach (var t in lstSessions)
            {
                var tt3 = settings.Get((SessionID)t).GetString("WriteQTransational");
                if (tt3 != null)
                {
                    bool transactional3;
                    if (bool.TryParse(tt3, out transactional3))
                    {
                        app.WriteMQTransational = transactional3;
                    }
                    break;
                }

            }

            InitialEmail(app);
                IMessageStoreFactory storeFactory = new FileStoreFactory(settings);
                ILogFactory logFactory = new FileLogFactory(settings);
                SocketInitiator initiator = new SocketInitiator(app, storeFactory, settings, logFactory);


                Mydel d = AsyncChecker.MyCaller;
                d.BeginInvoke(app.AppName, null, null);

                initiator.Start();
     
                app.Run();

                Console.Read();
                
                initiator.Stop();
            }
            catch (Exception e)
            {
                Console.WriteLine("==FATAL ERROR==");
                Console.WriteLine(e.ToString());
            }
        }

        private static void InitialEmail(IcbcClientApp app)
        {
            string[] emails = app.EmailsToAert.Split('|');
            foreach(string email in emails) {
                StatusFlags.Instance.Emaills.Add(email);                 
            }
            String gateway = app.EmailGateway;
            string[] gws = gateway.Split(':');
            StatusFlags.Instance.EmailIP = gws[0];


            int port;
            if (int.TryParse(gws[1], out port))
            {
                StatusFlags.Instance.EmailPort = port;
            }
  

            

        }
    }


}
