using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Messaging;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using QuickFix;
using QuickFix.Fields;
using QuickFix.FIX44;
using Message = QuickFix.Message;

namespace ICBKFS.ICBCInitiator
{
    public class IcbcClientApp:IApplication
    {
        private SessionID _currentSessionID;

        public SessionSettings FIXSessionSettings { get; set; }

        public MessageQueue MQ1 { get; set; }
        public MessageQueue MQ2 { get; set; }

        public string ReadMQ1 { get; set; }
        public bool MQ1Transational { get; set; }

        public string ReadMQ2 { get; set; }
        public bool MQ2Transational { get; set; }

        public string WriteMQ { get; set; }
        public bool WriteMQTransational { get; set; }

        public bool SendEmailAlert { get; set; }
        public string EmailsToAert { get; set; }
        public string EmailGateway { get; set; }
        public string AppName { get; set; }


        public int SendTimes { get; set; }

        public void FromAdmin(Message message, SessionID sessionID)
        {
            var messageType = new MsgType();
            try
            {
                if (message == null)
                    return;
                message.Header.GetField(messageType);
                var msgType = messageType.getValue();
                //if (msgType == MsgType.HEARTBEAT)
                //{
                //    if (!ConnectionFlag.Instance.IsOn)
                //    {
                //        ConnectionFlag.Instance.IsOn = true;
                //    }
          
                //    //Console.WriteLine("a2:is connected");
                //}
                if (msgType == MsgType.TESTREQUEST)
                {

                    var testRequest = (TestRequest) message;
                    var testReqID = testRequest.TestReqID;
                    var heartBeat = new Heartbeat();
                    heartBeat.SetField(testReqID);
                    Session.SendToTarget(heartBeat, _currentSessionID);
                    Console.WriteLine("this heartbeat is manually sent"+heartBeat.ToString());

                }

            }
            catch (Exception ex)
            {

                Console.WriteLine(ex.Message);
            }
 
            Console.WriteLine("IN:  " + message.ToString());
            StatusFlags.Instance.IsConnected = true;
            StatusFlags.Instance.BeatCounts += 1;
        }

        public void FromApp(Message message, SessionID sessionID)
        {
            Console.WriteLine("IN:  " + message.ToString());
            SendtoMsmq(message.ToString(), WriteMQTransational);
        }

        public void OnCreate(SessionID sessionID)
        {
            _currentSessionID = sessionID;
        }

        public void OnLogon(SessionID sessionID)
        {
            Console.WriteLine("Log on session id: " + sessionID);

            
        }

        public void OnLogout(SessionID sessionID)
        {
           // ConnectionFlag.Instance.IsOn = false;
            Console.WriteLine("Log out session id: " + sessionID);
            if (StatusFlags.Instance.IsConnected)
            {
                StatusFlags.Instance.IsConnected = false;
            }

        }

        public void ToAdmin(Message message, SessionID sessionID)
        {
            var messageType = new MsgType();
            try
            {
                if (message == null)
                    return;
                message.Header.GetField(messageType);
                var msgType = messageType.getValue();
                //if (msgType == MsgType.HEARTBEAT)
                //{
                //    if (!ConnectionFlag.Instance.IsOn)
                //    {
                //        ConnectionFlag.Instance.IsOn = true;
                //    }
                //    //Console.WriteLine("a:is connected");
                //}

                if (msgType == MsgType.LOGON)
                {

                    message.RemoveField(141);
                }

            }
            catch (Exception ex)
            {

                Console.WriteLine(ex.Message);
            }
 

            Console.WriteLine("OUT: " + message.ToString());
        }

        public void ToApp(Message message, SessionID sessionId)
        {
            Console.WriteLine("OUT: " + message.ToString());
        }


        public void Run()
        {
     
            Task.Run(() =>
            {
            Repeat:

                Thread.Sleep(5000);


                InitialMQ1();

                using (var mq = this.MQ1)
                {
                    while (true)
                    {

                        //if (ConnectionFlag.Instance.IsOn)
                        //{
                            //Console.WriteLine("b:is connected");
                            try
                            {
                                var str = ReadaMsg(mq, MQ1Transational);
                                if (str != null)
                                {
                                    str = str.Trim().TrimEnd('\u0001');
                                    var msg = new Message();

                                    //var arr = str.Split('^');
                                    var arr = Regex.Split(str, "\u0001");
                                    foreach (var s in arr)
                                    {
                                        var tv = s.Split('=');
                                        if (tv.Length == 2)
                                        {
                                            int tag = 0;
                                            int t;
                                            if (Int32.TryParse(tv[0], out t))
                                            {
                                                tag = t;
                                            }
                                            else
                                            {
                                                Console.WriteLine("Tag {0} has error converted to int", tv[0]);
                                                continue;
                                            }
                                            var value = string.IsNullOrEmpty(tv[1]) ? " " : tv[1];

                                            if (tag == 35)
                                            {
                                                msg.Header.SetField(new MsgType(value));
                                                continue;
                                            }
                                            if (tag == 8) continue;

                                            if (tag == 9) continue;
                                            if (tag == 10) continue;

                                            msg.SetField(new StringField(tag, value));
                                        }

                                    }

                                    Session.SendToTarget(msg, _currentSessionID);
                                }
                                else
                                {
                                    Console.WriteLine("alert: read msg from msmq is null or empty");
                                }
                            }
                            catch (MessageQueueException ex)
                            {
                                Console.WriteLine("Fix Msmq exception" + ex.Message);
                                this.MQ1.Close();
                                this.MQ1 = null;
                                goto Repeat;
                            }
                            catch (Exception e)
                            {
                                Console.WriteLine("Message Not Sent: " + e.Message);
                                Console.WriteLine("StackTrace: " + e.StackTrace);
                                //Console.ReadKey();
                            }
                        //}
                        //else
                        //{
                        //    //Console.WriteLine("c:is not connected");
                        //    Thread.Sleep(5000);
                        //}

                        //var str =
                        //   "8=FIX.4.4^9=243^35=8^1=370^12=0.00^13=^15=USD^17=1075211^19=^22=1^29=0^30=^31=99.68750000^32=90000.00^48=31418CHS6^54=1^60=20181022-10:33:08.000^64=20181025^75=20181022^120=USD^150=A^159=149.07^207=^375=702560300^381=,^423=2^448=RAJA^460=3^541=20270301^9039=^10=102";


                    }
                }


            });


            Task.Run(() =>
            {
            Repeat:

                Thread.Sleep(5000);


                InitialMQ2();

                using (var mq = this.MQ2)
                {
                    while (true)
                    {

                        //if (ConnectionFlag.Instance.IsOn)
                        //{
                        //Console.WriteLine("b:is connected");
                        try
                        {
                            var str = ReadaMsg(mq, MQ1Transational);
                            if (str != null)
                            {
                                str = str.Trim().TrimEnd('\u0001');
                                var msg = new Message();

                                //var arr = str.Split('^');
                                var arr = Regex.Split(str, "\u0001");
                                foreach (var s in arr)
                                {
                                    var tv = s.Split('=');
                                    if (tv.Length == 2)
                                    {
                                        int tag = 0;
                                        int t;
                                        if (Int32.TryParse(tv[0], out t))
                                        {
                                            tag = t;
                                        }
                                        else
                                        {
                                            Console.WriteLine("Tag {0} has error converted to int", tv[0]);
                                            continue;
                                        }
                                        var value = string.IsNullOrEmpty(tv[1]) ? " " : tv[1];

                                        if (tag == 35)
                                        {
                                            msg.Header.SetField(new MsgType(value));
                                            continue;
                                        }
                                        if (tag == 8) continue;

                                        if (tag == 9) continue;
                                        if (tag == 10) continue;

                                        msg.SetField(new StringField(tag, value));
                                    }

                                }

                                Session.SendToTarget(msg, _currentSessionID);
                            }
                            else
                            {
                                Console.WriteLine("alert: read msg from msmq is null or empty");
                            }
                        }
                        catch (MessageQueueException ex)
                        {
                            Console.WriteLine("Fix Msmq exception" + ex.Message);
                            this.MQ2.Close();
                            this.MQ2 = null;
                            goto Repeat;
                        }
                        catch (Exception e)
                        {
                            Console.WriteLine("Message Not Sent: " + e.Message);
                            Console.WriteLine("StackTrace: " + e.StackTrace);
                            //Console.ReadKey();
                        }
                        //}
                        //else
                        //{
                        //    //Console.WriteLine("c:is not connected");
                        //    Thread.Sleep(5000);
                        //}

                        //var str =
                        //   "8=FIX.4.4^9=243^35=8^1=370^12=0.00^13=^15=USD^17=1075211^19=^22=1^29=0^30=^31=99.68750000^32=90000.00^48=31418CHS6^54=1^60=20181022-10:33:08.000^64=20181025^75=20181022^120=USD^150=A^159=149.07^207=^375=702560300^381=,^423=2^448=RAJA^460=3^541=20270301^9039=^10=102";


                    }
                }


            });

          
            
           
        }

        private void InitialMQ1()
        {
            string hqpath = string.Format(@"FormatName:DIRECT=OS:.\Private$\"+this.ReadMQ1);

            this.MQ1 = new MessageQueue(hqpath, false, true, QueueAccessMode.Receive)
            {
                Formatter = new XmlMessageFormatter(new Type[1] { typeof(string) })
            };
        }

        private void InitialMQ2()
        {
            string hqpath = string.Format(@"FormatName:DIRECT=OS:.\Private$\" + this.ReadMQ2);

            this.MQ2 = new MessageQueue(hqpath, false, true, QueueAccessMode.Receive)
            {
                Formatter = new XmlMessageFormatter(new Type[1] { typeof(string) })
            };
        }

        private string ReadaMsg(MessageQueue m_SourceQueue, bool transactional)
        {
            string ret = null;

            try
            {
                System.Messaging.Message message = null;
                if (transactional)
                { 
                    message = m_SourceQueue.Receive(MessageQueueTransactionType.Single);
                }
                else {
                    message = m_SourceQueue.Receive();
                }
                using (message)
                {
                    if (message != null)
                    {
                        ret = message.Body as string;
                    }
                }
            }
            catch (MessageQueueException msmqException)
            {
                Console.Write(msmqException.Message);
                if (msmqException.MessageQueueErrorCode == MessageQueueErrorCode.IOTimeout)
                {
                    return null;
                }
              
                return null;

            }
            catch (Exception e)
            {
                Console.Write(e.Message);
                return null;
            }
            Console.WriteLine("Read a msg from msmq: "+ret);
            return ret;
        }


        private void SendtoMsmq(string content, bool transactional)
        {
            var path = string.Format(@"FormatName:DIRECT=OS:.\Private$\"+this.WriteMQ);
            MessageQueue mQueue = new MessageQueue(path);
            System.Messaging.Message msg = new System.Messaging.Message(content)
            {
                Formatter = new ActiveXMessageFormatter()
            };

            if (transactional)
            {
                mQueue.Send(msg, MessageQueueTransactionType.Single);
            }
            else { mQueue.Send(msg ); }

       
            mQueue.Close();
        }
    }
}
