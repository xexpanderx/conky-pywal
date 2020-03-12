require 'cairo'

function hex2rgb(hex)
	hex = hex:gsub("#","")
	return (tonumber("0x"..hex:sub(1,2))/255), (tonumber("0x"..hex:sub(3,4))/255), tonumber(("0x"..hex:sub(5,6))/255)
end

-- HTML colors
color0="#33304b"
color1="#D76C84"
color2="#4CA293"
color3="#6AA28E"
color4="#9EA48A"
color5="#E2A188"
color6="#9CCB96"
color7="#e7dbc0"
color8="#a19986"
color9="#D76C84"
color10="#4CA293"
color11="#6AA28E"
color12="#9EA48A"
color13="#E2A188"
color14="#9CCB96"
color15="#e7dbc0"
color66="#33304b"
t0= 1
t0_border= 0.3
r0, g0, b0 = hex2rgb(color0)
t1= 1
r1, g1, b1 = hex2rgb(color2)
t2= 1
r2, g2, b2 = hex2rgb(color7)
t3= 1
r3, g3, b3 = hex2rgb(color8)

pathname="Root"
pathway="/"

function fix_text(text)
	if string.len(text) == 1 then
		new_text = "0" .. text .. "%"
		return new_text
	else
		new_text = text .. "%"
		return new_text
	end
end

function draw_circle_background(cr, w, h)
	cairo_set_source_rgba(cr, r0, g0, b0, t0)
	cairo_arc(cr,w/2,h/2,52,0*math.pi/180,360*math.pi/180)
    cairo_fill(cr)
end

function draw_circle_background_border(cr, w, h)
	cairo_set_source_rgba(cr, r0, g0, b0, t0_border)
	cairo_set_line_width(cr, 2)
	cairo_arc(cr,w/2,h/2,52,0*math.pi/180,360*math.pi/180)
    cairo_stroke(cr)
end

function draw_ssd(cr, w, h, pathname, pathway)
	local c1=42
	local c2_x=(w-c1)/2
	local c2_y=(h-c1)/2
	local c3_x=w/2
	local c3_y=h/2
	cairo_set_source_rgba(cr, r1, g1, b1, t1)
	cairo_set_line_width(cr, 2)
	cairo_arc(cr,c2_x,c2_y-5,10,180*math.pi/180,270*math.pi/180)
	cairo_rel_line_to(cr,c1,0)
	cairo_arc(cr,c2_x+c1,c2_y-5,10,270*math.pi/180,360*math.pi/180)
	cairo_rel_line_to(cr,0,52)
	cairo_arc(cr,c2_x+c1,c2_y-5+52,10,0*math.pi/180,90*math.pi/180)
	cairo_rel_line_to(cr,-7,0)
	cairo_rel_line_to(cr,0,-10)
	cairo_rel_line_to(cr,-28,0)
	cairo_rel_line_to(cr,0,10)
	cairo_rel_line_to(cr,-7,0)
	cairo_arc(cr,c2_x,c2_y+47,10,90*math.pi/180,180*math.pi/180)
	cairo_close_path(cr)
	cairo_stroke(cr)
	--Holes
	cairo_arc(cr,c2_x-1,c2_y+46,3,0*math.pi/180,360*math.pi/180)
	cairo_arc(cr,c2_x+43,c2_y+46,3,0*math.pi/180,360*math.pi/180)
	cairo_fill(cr)
	cairo_arc(cr,c2_x-1,c2_y-4,3,0*math.pi/180,360*math.pi/180)
	cairo_arc(cr,c2_x+43,c2_y-4,3,0*math.pi/180,360*math.pi/180)
	cairo_fill(cr)
	cairo_rectangle (cr, c2_x-1, c2_y+10, 44, 22);
	cairo_stroke(cr)
	--Pathname
	cairo_set_source_rgba(cr, r3, g3, b3, t3)
	ct = cairo_text_extents_t:create()
	cairo_text_extents(cr,pathname,ct)
    cairo_move_to(cr,w/2-ct.width/2,h/2+ct.height/2)
    cairo_show_text(cr,pathname)
    --Pathway indicator
    cairo_set_source_rgba(cr, r1, g1, b1, t1)
	cairo_set_line_width(cr, 1)
	for i=0, 3 do
		cairo_rectangle (cr,c2_x+10+6*i,c2_y+50, 4, 7);
		cairo_stroke(cr)
    end
    cairo_set_source_rgba(cr, r2, g2, b2, t2)
    fs_used = math.floor(4*tonumber(conky_parse("${fs_used_perc " .. pathway .. "}"))/100)
    for i=0, fs_used do
		cairo_rectangle (cr,c2_x+10+6*i,c2_y+50, 4, 7);
		cairo_fill(cr)
    end
	
end

function draw_widgets(cr)
	local w,h=conky_window.width,conky_window.height
	cairo_select_font_face (cr, "Dejavu Sans", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
	cairo_set_font_size(cr, 10)
	
	--Draw background
	draw_circle_background(cr, w, h)
	draw_circle_background_border(cr, w, h)
	--Draw ssd
	draw_ssd(cr, w, h, pathname, pathway)
	
end

function conky_start_widgets()

	if conky_window==nil then return end
	local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)
	local cr=cairo_create(cs)	
	local ok, err = pcall(function () draw_widgets(cr) end)
	cairo_surface_destroy(cs)
	cairo_destroy(cr)
end
