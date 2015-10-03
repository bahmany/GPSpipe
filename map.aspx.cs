using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class map : System.Web.UI.Page
{
    public string add_nec_script_codes()
    {
        string scr = "";



            scr = " <meta name=\"viewport\" content=\"initial-scale=1.0, user-scalable=no\" /> " +
            " <script src=\"http://maps.google.com/maps?file=api&amp;v=2&amp;sensor=false&amp;key=ABQIAAAArrevZR6A2Il2kVkLEx835hR7y2mAQ51QpQE_q4EQ-zce0InynhS4gYN_jSeqOq9bhMOQ3UwioXBPQw\" type=\"text/javascript\"> " +
            "    /*ABQIAAAArrevZR6A2Il2kVkLEx835hShUouseIHqOXoXQLY8cwfSo1jZ3xSbp3vx8p7EuTAMPKfotRSpJRItIQ*/ " +
            " </script> " +
            "    <script src=\"js/epoly.js\" type=\"text/javascript\"></script> ";


     
        return scr;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Session["OwnerID"] = "1";
        Session["OwnerWeight"] = "1";
        Session["Owner"] = "1";
    }

}
