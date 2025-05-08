using System;
using System.Collections.Generic;
using System.Linq;
using System.Messaging;
using System.Text;
using System.Text.RegularExpressions;
using QuickFix.Fields;
using Message = QuickFix.Message;

namespace ICBKFS.TradesValidation
{
    class Program
    {
        static void Main(string[] args)
        {
            string hqpath = string.Format(@"FormatName:DIRECT=OS:.\Private$\test");

            var mq = new MessageQueue(hqpath, false, true, QueueAccessMode.Receive)
            {
                Formatter = new XmlMessageFormatter(new Type[1] { typeof(string) })
            };
            Console.WriteLine("Reading");
            Console.WriteLine("1");
            var str = ReadaMsg(mq);
            Console.WriteLine(str);
            if (str != null)
            {
                str = str.Trim().TrimEnd('\u0001');
                var msg = new Message();
                Console.WriteLine("2");
                //var arr = str.Split('^');
                var arr = Regex.Split(str, "\u0001");
                foreach (var s in arr)
                {
                    var tv = s.Split('=');
                    Console.WriteLine("3");
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
                        Console.WriteLine("4");
                        if (tag == 35)
                        {
                            msg.Header.SetField(new MsgType(value));
                            continue;
                        }
                        if (tag == 8) continue;

                        if (tag == 9) continue;
                        if (tag == 10) continue;
                        Console.WriteLine("5");
                        msg.SetField(new StringField(tag, value));
                        Console.WriteLine("6");
                    }

                }

            }
        }
        private static string ReadaMsg(MessageQueue m_SourceQueue)
        {
            string ret = null;
            Console.WriteLine("a1");

            try
            {
                Console.WriteLine("a2");
                using (System.Messaging.Message message = m_SourceQueue.Receive(MessageQueueTransactionType.Single))
                {
                    Console.WriteLine("a3");
                    if (message != null)
                    {
                        Console.WriteLine("a4");
                        ret = message.Body as string;
                    }
                    Console.WriteLine("a5");
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
                Console.WriteLine("a6");
                Console.Write(e.Message);
                return null;
            }
            Console.WriteLine("Read a msg from msmq: " + ret);
            return ret;
        }


    }
}
