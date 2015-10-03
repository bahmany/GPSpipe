<%@ WebHandler Language="C#" Class="Handler" %>

using System;
using System.Web;

public class Handler : IHttpHandler {
    public string gvmepoimrklist(int LayerID)
    {
        string str = "";
        string ch = "";
        int intOwnerID = 1;// Convert.ToInt32(HttpContext.Current.Session["OwnerID"].ToString());
        foreach (System.Data.DataRow dr in new MainDataModuleTableAdapters.tbl_poiTableAdapter().GetDateBySelectedLayer(intOwnerID, LayerID))
        {
            if (str == "") { ch = ""; } else { ch = "?"; }

            str = str + ch + string.Format("{0},{1},{2},{3},{4},{5},{6}", dr["p_e"].ToString(), dr["p_n"].ToString(), dr["p_nf_name"].ToString(), dr["p_poi_layer_link"].ToString(), dr["p_color"].ToString(), dr["p_id"].ToString(), dr["p_shopname"].ToString());
        }



        return str;
    }
    public string GetPOIForm(int PointID)
    {
        string path = System.Web.HttpContext.Current.Server.MapPath("~/htmlfrm/html_POI_Form.htm");
        string str;
        System.IO.FileStream fs = System.IO.File.Open(path, System.IO.FileMode.Open);
        //GetDataBy

        byte[] b = new byte[fs.Length];
        System.Text.UTF8Encoding temp = new System.Text.UTF8Encoding(true);
        str = "";
        while (fs.Read(b, 0, b.Length) > 0)
        {
            str = str + (temp.GetString(b));
        }

        fs.Close();

        string LayerName = "";
        string name = "";
        string telno = "";
        string cellno = "";
        string addr = "";


       // HttpContext.Current.Session.Add("OwnerID","1");

        int ssid = 1; // Convert.ToInt32(HttpContext.Current.Session["OwnerID"].ToString());

        foreach (System.Data.DataRow dr in
            new MainDataModuleTableAdapters.tbl_poiTableAdapter().GetDataBy(
            ssid, PointID).Rows)
        {



            LayerName = new MainDataModuleTableAdapters.tbl_poi_layersTableAdapter().GetLayerName(Convert.ToInt32(dr["p_poi_layer_link"].ToString())).ToString();
            name = dr["p_nf_name"].ToString();
            telno = dr["p_tel"].ToString();
            cellno = dr["p_mobile"].ToString();
            addr = dr["p_addr"].ToString();



        }

        str = System.Text.RegularExpressions.Regex.Replace(str, "#1", LayerName);
        str = System.Text.RegularExpressions.Regex.Replace(str, "#2", name);
        str = System.Text.RegularExpressions.Regex.Replace(str, "#3", telno);
        str = System.Text.RegularExpressions.Regex.Replace(str, "#4", cellno);
        str = System.Text.RegularExpressions.Regex.Replace(str, "#5", addr);
        return str;
    }






    public string POI_Divs(int LayerID, string OwnerID)
    {
        string str = "";
        main_class mc = new main_class();

        string pfrm = "";
        int intOwnerID = 1;// Convert.ToInt32(HttpContext.Current.Session["OwnerID"].ToString());
        foreach (System.Data.DataRow dr in new MainDataModuleTableAdapters.tbl_poiTableAdapter().GetDateBySelectedLayer(intOwnerID, LayerID))
        {
            string frm = mc.loadFromHtml("~/htmlfrm/html_POI_Grd.htm");
            frm = System.Text.RegularExpressions.Regex.Replace(frm, "#1", dr["p_nf_name"].ToString());
            frm = System.Text.RegularExpressions.Regex.Replace(frm, "#2", dr["p_id"].ToString());
            frm = System.Text.RegularExpressions.Regex.Replace(frm, "#3", dr["p_addr"].ToString());
            str = str + frm;
        }
        if (str == "") { str = "اطلاعاتی یافت نشد"; }
        return str;

    }

   
    
    
    
    
    
    
    public void ProcessRequest (HttpContext context) {

        if (context.Request.Params["getfrmunderpoidiv"] != null)
        {
            context.Response.Write(
                POI_Divs(
                Convert.ToInt32(context.Request.Params["getfrmunderpoidiv"].ToString()),
                context.Request.Params["oi"].ToString())
                );
        }
        if (context.Request.Params["updpoi"] != null)  // POI Update
        {

            int PointID = Convert.ToInt32(context.Request.Params["updpoi"].ToString());
            double _e = Convert.ToDouble(context.Request.Params["e"].ToString());
            double _n = Convert.ToDouble(context.Request.Params["n"].ToString());
            new MainDataModuleTableAdapters.tbl_poiTableAdapter().UpdatePOIPosition(_e, _n, PointID);

        }
        if (context.Request.Params["gvmepoimrklist"] != null)
        {
            context.Response.Write(gvmepoimrklist(
                Convert.ToInt32(
                context.Request.Params["gvmepoimrklist"].ToString()
                )));
        }
        if (context.Request.Params["getfrmunderpoi"] != null)
        {
            context.Response.Write(GetPOIForm(
                Convert.ToInt32(context.Request.Params["pid"].ToString())));
        }


        if (context.Request.Params["getfrmpoi"] != null)
        {
            string txt_name = context.Request.Params["tn"];
            string txt_tel = context.Request.Params["tt"];
            string txt_mob = context.Request.Params["tm"];
            string txt_addr = context.Request.Params["ta"];
            double lat = Convert.ToDouble(context.Request.Params["n"]);
            double lng = Convert.ToDouble(context.Request.Params["e"]);
            int layerid = Convert.ToInt32(context.Request.Params["lid"]);
            int getfrmpoi = Convert.ToInt32(context.Request.Params["getfrmpoi"]);
            int ownerID = 1;//Convert.ToInt32(context.Session["OwnerID"].ToString());
            string b = "";
            try
            {
                if (getfrmpoi != -1)
                {

                    new MainDataModuleTableAdapters.tbl_poiTableAdapter().Update(
                        txt_name, txt_tel, txt_mob, txt_addr, layerid,
                         lat, lng,
                         context.Request.Params["cl"],
                         context.Request.Params["shpnm"],
                         Convert.ToInt32(context.Request.Params["getfrmpoi"])
                         );
                }
                else
                {
                    new MainDataModuleTableAdapters.tbl_poiTableAdapter().InsertQuery
                        (
                        txt_name, txt_tel, txt_mob, txt_addr,
                        layerid, ownerID, lat, lng,
                        context.Request.Params["shpnm"]
                        );
                    b = new MainDataModuleTableAdapters.tbl_poiTableAdapter().GetPointIDByData(lat, lng, txt_name, ownerID).ToString();

                }

                string sstr = "alert('نقطه مورد نظر ثبت شد'); gmrk.ID=" + b + "; POICurrentSelectedPointID=" + b + ";" + " CreateLabelPoi(" +
                    b + ",gmrk.getLatLng(),'" + txt_name + " " +
                    context.Request.Params["shpnm"]
                    + "'," + b + ",'" + txt_name + "');";


                context.Response.Write(sstr);

            }
            catch (Exception ee)
            {
                context.Response.Write("alert('" + "اطلاعات مورد نظر شما ثبت نشد لطفا اطلاعات ورودی را اصلاح نمایید" + "');");
            }
        }

        
        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}