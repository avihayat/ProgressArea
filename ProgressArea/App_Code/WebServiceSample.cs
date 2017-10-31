using Model.ViewModel.Rad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;

/// <summary>
/// Summary description for WebServiceSample
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[ScriptService]
public class WebServiceSample : System.Web.Services.WebService
{
    // Remark for GitHub 5
    public WebServiceSample()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string HelloWorld()
    {
        String sMsg = "Hello World";

        MdlRadProgress radProgress = null;
        // Wait no more than 10 Seconds
        for (int i = 0; i < 100; i++)
        {
            radProgress = (MdlRadProgress)Session["PerfromLinkButton_Click"];
            if (radProgress == null)
            {
                radProgress = new MdlRadProgress();
                radProgress.bFinished = true;
            }
            else if (radProgress.bFinished)
            {
                break;
            }
            Thread.Sleep(100);
        }
        return new JavaScriptSerializer().Serialize(radProgress);
    }

}
