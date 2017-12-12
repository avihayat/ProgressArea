using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;

namespace Graffiti_CloseEvent
{

    /// <summary>
    /// Summary description for SaveLogout
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class SaveLogout : System.Web.Services.WebService
    {
        public SaveLogout()
        {
            //Uncomment the following line if using designed components 
            //InitializeComponent(); 
        }

        [WebMethod (EnableSession = true)]
        public string SaveLogoffInf()
        {
            string sData = (string) Session["TestData"];
            string sFileName = Server.MapPath("~/LogOffTime.txt");
            File.WriteAllText(sFileName, "LogoffTime " + DateTime.Now.ToShortTimeString());
            return "Hello World";
        }
    }
}