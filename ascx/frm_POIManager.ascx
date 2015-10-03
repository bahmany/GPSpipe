<%@ Control Language="C#" AutoEventWireup="true" CodeFile="frm_POIManager.ascx.cs" Inherits="ascx_frm_POIManager" %>

<%@ Register assembly="Telerik.Web.UI" namespace="Telerik.Web.UI" tagprefix="telerik" %>
    

    <telerik:RadScriptManager ID="RadScriptManager1" Runat="server">
</telerik:RadScriptManager>

<div style="top: 220px">

<div id="div_RightBarPOI">
<table style="">
        <tr>
            <td style="width: 0px; vertical-align: top; text-align: right; background-color: #FFFFFF;    -moz-border-radius: 5px;border-radius: 5px;">
                          <asp:UpdatePanel ID="UpdatePanel_BTN" runat="server">
                      
                        <ContentTemplate>

            
                <table>
                    <tr>
                        <td>
                                 <asp:LinkButton ID="LinkButton1" runat="server" onclick="LinkButton1_Click">افزودن شاخه جدید</asp:LinkButton>
                                <br />
                                <asp:LinkButton ID="LinkButton2" runat="server" onclick="LinkButton2_Click">افزودن زیر شاخه</asp:LinkButton>
               
                          &nbsp;<br />
                        </td>
                        <td>
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td dir="rtl" style="text-align: right">
                            <asp:Panel ID="pnl_edit" runat="server" Visible="False">
                                <table>
                                    <tr>
                                        <td>
                                            <asp:TextBox ID="txtCaptionEdit" runat="server"></asp:TextBox>
                                            <br />
                                            <asp:LinkButton ID="LinkButton4" runat="server" onclick="LinkButton4_Click">تائید ویرایش</asp:LinkButton>
                                                             <br />
                                <asp:LinkButton ID="LinkButton3" runat="server" onclick="btnDeleteBranch_Click">حذف</asp:LinkButton>
                                        </td>
                                        <td>
                                            &nbsp;</td>
                                    </tr>
                                </table>
                            </asp:Panel>
                            <telerik:RadTreeView ID="rtvLayers" Runat="server" 
                                onnodeclick="RadTreeView1_NodeClick">
                                <CollapseAnimation Duration="100" Type="OutQuint" />
                                <ExpandAnimation Duration="100" />
                            </telerik:RadTreeView>
                        </td>
                        <td>
                            &nbsp;</td>
                    </tr>
                </table>
                <div>

                    
                </div>
                
                                        </ContentTemplate>
                         
                        </asp:UpdatePanel>
                
                
            </td>
            <td style="vertical-align: top; text-align: right">
            



</td>
        </tr>
    </table>
</div>


<div id="div_Center_inf_poi" style="font-family: tahoma; font-size: 11px; background-color: #FFFFFF;" dir="rtl">
<div>
<div class="poi_list" id="div_poi_list">
</div>

                <div  class="map_canvas_div_poi">
                
                <div id="map_canvas" class="map_canvas">
                
                </div>
                
                </div>
</div>






    

</div>

</div>


<script type="text/javascript">

    var _map = new GMap2(document.getElementById("map_canvas"));  // creating map;
    _map.setCenter(new GLatLng(32, 51), 4);
    var gmrk;
    GEvent.addListener(_map, "singlerightclick", mapSingleRightClick);



    var POI_ID = 0;
    function SetActiveNodeID(PointID, nodename) {

        var NodeName = nodename;
        POI_ID = PointID;
        layerID = POI_ID;

        var http = false;
        var resp = "";
        if (navigator.appName == "Microsoft Internet Explorer") {
            http = new ActiveXObject("Microsoft.XMLHTTP");
        } else {
            http = new XMLHttpRequest();
        }
        http.open("GET", "Handler.ashx?getfrmunderpoidiv=" + layerID.toString() + "&oi=" + Get_Cookie("OwnerID"));
        http.onreadystatechange = function() {
            if (http.readyState == 4) {
                resp = http.responseText;
                if (resp != " " && resp != "") {
                    document.getElementById("div_poi_list").innerHTML = resp;
                    CallPointOfIntr(layerID);
                }
            }
        }
        http.send(null);
    }

    function CallPointOfIntr(LayerID) {

        ClearPOI();
        var str = "";
        var http = false;
        var resp = "";
        if (navigator.appName == "Microsoft Internet Explorer") {
            http = new ActiveXObject("Microsoft.XMLHTTP");
        } else {
            http = new XMLHttpRequest();
        }
        http.open("GET", "Handler.ashx?gvmepoimrklist=" + layerID.toString());
        http.onreadystatechange = function() {
            if (http.readyState == 4) {
                resp = http.responseText;
                if (resp != " " && resp != "") {

                    CreatePOIMarkerAccordingToLayerID(resp);






                }
            }
        }
        http.send(null);

        return str;
    }

    var POIMarker = new Array();
    var POIELable = new Array();
    function mapSingleRightClick(point, src, overlay) {

        var latlng = _map.fromContainerPixelToLatLng(point);
        var marker = new GMarker(latlng, { draggable: true });
        marker.id = "";
        //        GEvent.addListener(marker, "click", POIClick);
        GEvent.addListener(marker, "click", POIClick);
        GEvent.addListener(marker, "dragstart", function() {
            _map.closeInfoWindow();
        });

        GEvent.addListener(marker, "dragend", MarkerPOIDragEnd);

        gmrk = marker;
        _map.addOverlay(marker);

    }

    function POIClick(latlng) {

        gmrk = this;
        POICurrentSelectedPointID = gmrk.ID;

        if (POICurrentSelectedPointID == undefined) {
            POICurrentSelectedPointID = -1;
        }


        if (layerID != 0) {
            __lat = latlng.lat();
            __lng = latlng.lng();
            elat = __lat;
            elng = __lng;

            // Requesting the page

            var http = false;
            var resp = "";
            if (navigator.appName == "Microsoft Internet Explorer") {
                http = new ActiveXObject("Microsoft.XMLHTTP");
            } else {
                http = new XMLHttpRequest();
            }
            http.open("GET", "Handler.ashx?getfrmunderpoi=" + layerID.toString() + "&pid=" + POICurrentSelectedPointID + "&lat=" + gmrk.getLatLng().lat() + "&lng=" + gmrk.getLatLng().lng());
            http.onreadystatechange = function() {
                if (http.readyState == 4) {
                    resp = http.responseText;
                    if (resp != " " && resp != "") {
                        gmrk.openInfoWindowHtml(resp);

                    }
                }
            }
            http.send(null);
        }
        else {
            alert("لطفا لایه مورد را انتخاب کرده سپس اقدام به ایجاد نقطه نمایید");
        }


        try {
            POICurrentSelectedPointID = gmrk.ID;
        }
        catch (err) {
            POICurrentSelectedPointID = -1;
        }

        if (POICurrentSelectedPointID == undefined) {
            POICurrentSelectedPointID = -1;
        }




    }

    function ClearPOI() {
        for (var i = 0; i < POIMarker.length; i++) {
            _map.removeOverlay(POIMarker[i]);
        }
        POIMarker.length = 0;
        POIELable.length = 0;
        _map.clearOverlays();
    }


    function CreatePOIMarkerAccordingToLayerID(hasedstr) {
        if (hasedstr != " " && hasedstr != "") {
            var arr = new Array();
            var are = new Array();
            arr = hasedstr.split("?");
            for (var i = 0; i < arr.length; i++) {
                are = arr[i].split(",");
                CreatePOIMarker(are[0], are[1], are[2], are[3], are[4], are[5], are[6])
                //"p_e""p_n""p_nf_name""poi_layer_link""p_color"
            }
        }
    }

    function CreatePOIMarker(p_e, p_n, p_nf_name, poi_layer_link, p_color, p_id, p_shopname) {
        var pnt = new GLatLng(parseFloat(p_n), parseFloat(p_e));
        var mrk = new GMarker(pnt, { draggable: true });
        mrk.ID = p_id;

        //mrk.PointID = UnitID;
        GEvent.addListener(mrk, "click", POIClick);


        GEvent.addListener(mrk, "dragstart", function() {
            _map.closeInfoWindow();
        });

        GEvent.addListener(mrk, "dragend", MarkerPOIDragEnd);


        POIMarker.push(mrk);

        CreatePOILabel(mrk.getLatLng(), p_nf_name, p_shopname, p_id);
        _map.addOverlay(POIMarker[POIMarker.length - 1]);
    }


    function SendStrToServer(str) {
        var http = false;
        var resp = "";
        if (navigator.appName == "Microsoft Internet Explorer") {
            http = new ActiveXObject("Microsoft.XMLHTTP");
        } else {
            http = new XMLHttpRequest();
        }
        http.open("GET", str);
        http.onreadystatechange = function() {
            if (http.readyState == 4) {
                resp = http.responseText;
                if (resp != " " && resp != "") {


                }
            }
        }
        http.send(null);

    }

    function DetectPOIMarkerID(mrk) {
        try {
            POICurrentSelectedPointID = gmrk.ID;
        }
        catch (err) {
            POICurrentSelectedPointID = -1;
        }

        if (POICurrentSelectedPointID == undefined) {
            POICurrentSelectedPointID = -1;
        }

        return POICurrentSelectedPointID;
    }

    function UpdatePositionOnELabelOfPOI(LabelPointID, latlng) {
        if (POIELable.length != 0) {
            for (var i = 0; i < POIELable.length; i++) {
                if (POIELable[i].ID == LabelPointID) {
                    POIELable[i].setPoint(latlng);
                }
            }
        }

    }

    function MarkerPOIDragEnd(latlng) {
        // first i must to handle the label to move with icon
        gmrk = this;
        POICurrentSelectedPointID = DetectPOIMarkerID(gmrk);

        if (POICurrentSelectedPointID != -1) {
            var _e = latlng.lng();
            var _n = latlng.lat();
            SendStrToServer("handler.ashx?updpoi=" + POICurrentSelectedPointID + "&e=" + _e + "&n=" + _n);
            UpdatePositionOnELabelOfPOI(POICurrentSelectedPointID, latlng);

        }

    }
    var POICurrentSelectedPointID = -1;

    function CreatePOILabel(latlngpoi, name, shopname, p_id) {
        if (p_id != undefined) {

            var lbl = CreateLabelPoi(p_id, latlngpoi, name + " " + shopname, POIELable.length, name);
            POIELable.push(lbl);
            _map.addOverlay(lbl);

        }

    }


    function UpdateELabelPOICaption(poiID, NewCaption) {
        if (POIELable.length != 0) {
            for (var i = 0; i < POIELable.length; i++) {
                if (POIELable[i].ID == poiID) {
                    POIELable[i].setContents(NewCaption);
                }
            }
        }
        if (poiID == -1) {
            CreateLabelPoi(gmrk.ID, gmrk.getLatLng(), NewCaption, gmrk.ID, NewCaption);
        }
    }









    //--------------------------------------------------------------------------
    // best way detector :

    function DetectedTheBestayBetweenPOIs() {
        var POIMarkersCount = POIMarker.length;
        var whichPOItoStart = 60;
        var firstMarker;
        // selecting current poi
        for (var i = 0; i < POIMarkersCount; i++) {
            if (POIMarker[i].ID == whichPOItoStart) {
                firstMarker = POIMarker[i];
                // break;
            }
        }
        // the first poi was selected
        POITempTwoLatLngArray = new Array();
        var drn = new GDirections();

        GEvent.addListener(drn, "load", function() {

            var ds = drn.getDistance().meters;
            alert(ds.toString());

        });


        // for (var i =0;i<POIMarkersCount;i++)
        for (var i = 0; i < 2; i++) {
            //  POITempTwoLatLngArray.length = 0;

            // if (POIMarker[i].ID != whichPOItoStart)  // it means plz do not check ur self .
            {
                POITempTwoLatLngArray.push(POIMarker[i].getLatLng().lat().toString() + "," + POIMarker[i].getLatLng().lng().toString());
            }
        }

        drn.loadFromWaypoints(POITempTwoLatLngArray);


    }
function Get_Cookie( check_name ) {
	// first we'll split this cookie up into name/value pairs
	// note: document.cookie only returns name=value, not the other components
	var a_all_cookies = document.cookie.split( ';' );
	var a_temp_cookie = '';
	var cookie_name = '';
	var cookie_value = '';
	var b_cookie_found = false; // set boolean t/f default f

	for ( i = 0; i < a_all_cookies.length; i++ )
	{
		// now we'll split apart each name=value pair
		a_temp_cookie = a_all_cookies[i].split( '=' );


		// and trim left/right whitespace while we're at it
		cookie_name = a_temp_cookie[0].replace(/^\s+|\s+$/g, '');

		// if the extracted name matches passed check_name
		if ( cookie_name == check_name )
		{
			b_cookie_found = true;
			// we need to handle case where cookie has no value but exists (no = sign, that is):
			if ( a_temp_cookie.length > 1 )
			{
				cookie_value = unescape( a_temp_cookie[1].replace(/^\s+|\s+$/g, '') );
			}
			// note that in cases where cookie is initialized but no value, null is returned
			return cookie_value;
			break;
		}
		a_temp_cookie = null;
		cookie_name = '';
	}
	if ( !b_cookie_found )
	{
		return null;
	}
}
var prevTick;
var preAnimatedD;
var elat = 0.0;
var elng = 0.0;
var NodeName = "Tttt";
var layerID = 1;
var __lat = 0.0;
var __lng = 0.0;









    function sendParams() {

        var http = false;
        var resp = "";
        if (navigator.appName == "Microsoft Internet Explorer") {
            http = new ActiveXObject("Microsoft.XMLHTTP");
        } else {
            http = new XMLHttpRequest();
        }

        var txt_name = document.getElementById("txt_name").value;
        var txt_tel = document.getElementById("txt_tel").value;
        var txt_mob = document.getElementById("txt_mob").value;
        var txt_addr = document.getElementById("txt_addr").value;
        var cl = document.getElementById("txt_color").value;
        var txt_shopname = document.getElementById("txt_shopname").value;

        http.open("GET", "handler.ashx?getfrmpoi=" + POICurrentSelectedPointID + "&tn="
        + txt_name + "&tt=" + txt_tel + "&tm=" + txt_mob
        + "&ta=" + txt_addr + "&e=" + elat.toString()
        + "&n=" + elng.toString() + "&lid=" + layerID.toString() + "&cl=" + cl + "&shpnm=" + txt_shopname
        );

        UpdateELabelPOICaption(POICurrentSelectedPointID, txt_name + " " + txt_shopname);


        http.onreadystatechange = function() {
            if (http.readyState == 4) {
                resp = http.responseText;
                if (resp != " " && resp != "") {

                    setTimeout(resp, 10);
                    //alert(resp);

                }
            }
        }
        http.send(null);

    }



    function CreateLabel(_id, point, txt, pointID, name) {
        var stuff = '<div style="padding: 0px 0px 8px 8px; background: url(point_bottom_left.png) no-repeat bottom left;"><div style="background-color: #f2efe9; padding: 2px;"><b> <a href="javascript:ShowLastPostStaticWin(' + _id + ')">' + _id + ' <br/>' + name + '<\/a> <\/b><\/div><\/div>';
        var label = new ELabel(_id, point, stuff, null, null, 65);
        label.id = pointID;
        return label;

    }
    function CreateLabelPoi(_id, point, txt, pointID, name) {
        if (_id != undefined) {
            var stuff = '<div style="padding: 0px 0px 8px 8px; background: url(point_bottom_left.png) no-repeat bottom left;"><div style="background-color: #f2efe9; padding: 2px;"><b>' + txt + '<\/b><\/div><\/div>';

            var label = new ELabel(_id, point, stuff, null, null, 65);
            label.ID = _id;
            return label;
        }

    }


    //--------------------------------------------------------------------
    //--------------------------------------------------------------------
    //--------------------------------------------------------------------
    //--------------------------------------------------------------------
    //--------------------------------------------------------------------

    // ELabel.js 
    //
    //   This Javascript is provided by Mike Williams
    //   Community Church Javascript Team
    //   http://www.bisphamchurch.org.uk/   
    //   http://econym.org.uk/gmap/
    //
    //   This work is licenced under a Creative Commons Licence
    //   http://creativecommons.org/licenses/by/2.0/uk/
    //
    // Version 0.2      the .copy() parameters were wrong
    // version 1.0      added .show() .hide() .setContents() .setPoint() .setOpacity() .overlap
    // version 1.1      Works with GMarkerManager in v2.67, v2.68, v2.69, v2.70 and v2.71
    // version 1.2      Works with GMarkerManager in v2.72, v2.73, v2.74 and v2.75
    // version 1.3      add .isHidden()
    // version 1.4      permit .hide and .show to be used before addOverlay()
    // version 1.5      fix positioning bug while label is hidden
    // version 1.6      added .supportsHide()
    // version 1.7      fix .supportsHide()
    // version 1.8      remove the old GMarkerManager support due to clashes with v2.143


    function ELabel(id, point, html, classname, pixelOffset, percentOpacity, overlap) {
        // Mandatory parameters
        this.point = point;
        this.html = html;
        this.id = id;

        // Optional parameters
        this.classname = classname || "";
        this.pixelOffset = pixelOffset || new GSize(0, 0);
        if (percentOpacity) {
            if (percentOpacity < 0) { percentOpacity = 0; }
            if (percentOpacity > 100) { percentOpacity = 100; }
        }
        this.percentOpacity = percentOpacity;
        this.overlap = overlap || false;
        this.hidden = false;
    }

    ELabel.prototype = new GOverlay();

    ELabel.prototype.initialize = function(map) {
        var div = document.createElement("div");
        div.style.position = "absolute";

        div.innerHTML = '<div class="' + this.classname + '">' + this.html + '</div>';
        map.getPane(G_MAP_FLOAT_SHADOW_PANE).appendChild(div);
        this.map_ = map;
        this.div_ = div;
        if (this.percentOpacity) {
            if (typeof (div.style.filter) == 'string') { div.style.filter = 'alpha(opacity:' + this.percentOpacity + ')'; }
            if (typeof (div.style.KHTMLOpacity) == 'string') { div.style.KHTMLOpacity = this.percentOpacity / 100; }
            if (typeof (div.style.MozOpacity) == 'string') { div.style.MozOpacity = this.percentOpacity / 100; }
            if (typeof (div.style.opacity) == 'string') { div.style.opacity = this.percentOpacity / 100; }
        }
        if (this.overlap) {
            var z = GOverlay.getZIndex(this.point.lat());
            this.div_.style.zIndex = z;
        }
        if (this.hidden) {
            this.hide();
        }
    }

    ELabel.prototype.remove = function() {
        this.div_.parentNode.removeChild(this.div_);
    }

    ELabel.prototype.copy = function() {
        return new ELabel(this.point, this.html, this.classname, this.pixelOffset, this.percentOpacity, this.overlap);
    }

    ELabel.prototype.redraw = function(force) {
        var p = this.map_.fromLatLngToDivPixel(this.point);
        var h = parseInt(this.div_.clientHeight);
        this.div_.style.left = (p.x + this.pixelOffset.width) + "px";
        this.div_.style.top = (p.y + this.pixelOffset.height - h) + "px";
    }

    ELabel.prototype.show = function() {
        if (this.div_) {
            this.div_.style.display = "";
            this.redraw();
        }
        this.hidden = false;
    }

    ELabel.prototype.hide = function() {
        if (this.div_) {
            this.div_.style.display = "none";
        }
        this.hidden = true;
    }

    ELabel.prototype.isHidden = function() {
        return this.hidden;
    }

    ELabel.prototype.supportsHide = function() {
        return true;
    }

    ELabel.prototype.setContents = function(html) {
        this.html = html;
        this.div_.innerHTML = '<div class="' + this.classname + '">' + this.html + '</div>';
        this.redraw(true);
    }

    ELabel.prototype.setPoint = function(point) {
        this.point = point;
        if (this.overlap) {
            var z = GOverlay.getZIndex(this.point.lat());
            this.div_.style.zIndex = z;
        }
        this.redraw(true);
    }

    ELabel.prototype.setOpacity = function(percentOpacity) {
        if (percentOpacity) {
            if (percentOpacity < 0) { percentOpacity = 0; }
            if (percentOpacity > 100) { percentOpacity = 100; }
        }
        this.percentOpacity = percentOpacity;
        if (this.percentOpacity) {
            if (typeof (this.div_.style.filter) == 'string') { this.div_.style.filter = 'alpha(opacity:' + this.percentOpacity + ')'; }
            if (typeof (this.div_.style.KHTMLOpacity) == 'string') { this.div_.style.KHTMLOpacity = this.percentOpacity / 100; }
            if (typeof (this.div_.style.MozOpacity) == 'string') { this.div_.style.MozOpacity = this.percentOpacity / 100; }
            if (typeof (this.div_.style.opacity) == 'string') { this.div_.style.opacity = this.percentOpacity / 100; }
        }
    }

    ELabel.prototype.getPoint = function() {
        return this.point;
    }



    function gp(UnitID) //
    {
        ajaxpageWithOutDIV("handler.ashx?geposunid=" + UnitID);
        alert("درخواست شما جهت آخرین موقعیت درخواستی ارسال گردید");


    }

    function autoRotate() {
        // Determine if we're showing aerial imagery
        if (map.isRotatable) {
            // start auto-rotating at 3 second intervals
            setTimeout('map.changeHeading(90)', 3000);
            setTimeout('map.changeHeading(180)', 6000);
            setTimeout('map.changeHeading(270)', 9000);
            setTimeout('map.changeHeading(0)', 12000);
        }
    }
    //-------------------------------------------------------------------------
    //-------------------------------------------------------------------------
    //-------------------------------------------------------------------------

</script>