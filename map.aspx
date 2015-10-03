<%@ Page Language="C#" AutoEventWireup="true" CodeFile="map.aspx.cs" Inherits="map" %>

<%@ Register src="ascx/frm_POIManager.ascx" tagname="frm_POIManager" tagprefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%Response.Write(add_nec_script_codes()); %>
<html xmlns="http://www.w3.org/1999/xhtml">

<script src="js/fixed-1.8.js" type="text/javascript"></script>
<link href="css/map.css" rel="stylesheet" type="text/css" />





<head runat="server">
    <title></title>

</head>
<body dir="rtl" >







    <form id="form1" runat="server">






    <uc1:frm_POIManager ID="frm_POIManager1" runat="server" />






    </form>
</body>




</html>
