using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Text;

/// <summary>
/// Summary description for main_class
/// </summary>
public class main_class
{
	public main_class()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public string loadFromHtml(string FileAddr)
    {
        string path = System.Web.HttpContext.Current.Server.MapPath(FileAddr);//"~/htmlfrm/html_CarInfoWindow_Point.htm");
        string str;
        System.IO.FileStream fs = File.Open(path, FileMode.Open);
        //HttpContext.Current.Session["UnitID"] = PointID.ToString();

        byte[] b = new byte[fs.Length];
        UTF8Encoding temp = new UTF8Encoding(true);
        str = "";
        while (fs.Read(b, 0, b.Length) > 0)
        {
            str = str + (temp.GetString(b));
        }

        fs.Close();
        return str;
    }
}
