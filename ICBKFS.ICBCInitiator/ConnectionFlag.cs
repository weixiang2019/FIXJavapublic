using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ICBKFS.ICBCInitiator
{
    public class ConnectionFlag
    {

        public bool IsOn { get; set; }

        private static ConnectionFlag instance;

        public static ConnectionFlag Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = new ConnectionFlag();

                }
                return instance;
            }
        }
    }
}
