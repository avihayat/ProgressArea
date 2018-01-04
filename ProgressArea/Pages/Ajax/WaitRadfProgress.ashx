<%@ WebHandler Language="C#" Class="WaitRadfProgress" %>

using System;
using System.Web;
using System.Web.SessionState;
using System.Threading;
using Newtonsoft.Json;
using Model.ViewModel.Rad;

public class WaitRadfProgress : IHttpHandler, IRequiresSessionState  {

    public void ProcessRequest(HttpContext context)
    {
        MdlRadProgress radProgress = null;
        // Wait no more than 10 Seconds
        for (int i = 0; i < 100; i++)
        {
            radProgress = (MdlRadProgress)context.Session["PerfromLinkButton_Click"];
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

        context.Response.Write(JsonConvert.SerializeObject(radProgress));
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}