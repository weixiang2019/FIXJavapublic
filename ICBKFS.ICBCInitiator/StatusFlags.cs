using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ICBKFS.ICBCInitiator
{
    public class StatusFlags
    {

        public bool IsConnected { get; set; }

        public bool HitEsc { get; set; }

        public int BeatCounts { get; set; }
        public List<string> Emaills { get; set; }
        public string EmailIP { get; set; }
        public int EmailPort { get; set; }

        public StatusFlags()
        {
            Emaills = new List<string>();
        }
        private static StatusFlags instance;

        public static StatusFlags Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = new StatusFlags();

                }
                return instance;
            }
        }
    }
}
