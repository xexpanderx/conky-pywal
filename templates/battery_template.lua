require 'cairo'

function hex2rgb(hex)
	hex = hex:gsub("#","")
	return (tonumber("0x"..hex:sub(1,2))/255), (tonumber("0x"..hex:sub(3,4))/255), tonumber(("0x"..hex:sub(5,6))/255)
end

-- HTML colors
COLORFIELD
t0= 1
t0_border= 0.3
r0, g0, b0 = hex2rgb(color0)
t1= 1
r1, g1, b1 = hex2rgb(color6)
t2= 1
r2, g2, b2 = hex2rgb(color7)
t3= 1
r3, g3, b3 = hex2rgb(color8)

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

function draw_battery(cr, w, h)
	local c1=72
	local c2_x=(w-c1)/2
	local c2_y=(h-c1)/2
	local c3_x=w/2
	local c3_y=h/2
	cairo_set_source_rgba(cr, r1, g1, b1, t1)
	cairo_set_line_width(cr, 2)
	--Battery structure
	cairo_move_to(cr,c2_x,c2_y+21)
	cairo_rel_line_to(cr,72,0)
	cairo_rel_line_to(cr,0,30)
	cairo_rel_line_to(cr,-72,0)
	cairo_close_path(cr)
	cairo_stroke(cr)
	--Right
	cairo_set_line_width(cr, 2)
	cairo_move_to(cr,c2_x+73,c2_y+29)
	cairo_rel_line_to(cr,5,0)
	cairo_arc(cr,c2_x+78,c2_y+33,4,270*math.pi/180,0*math.pi/180)
	cairo_rel_line_to(cr,0,6)
	cairo_arc(cr,c2_x+78,c2_y+39,4,0*math.pi/180,90*math.pi/180)
	cairo_rel_line_to(cr,-5,0)
	--cairo_close_path(cr)
	cairo_stroke(cr)
	--Battery percentage
	battery_status = conky_parse("${battery_short}")
	battery_status = string.sub(battery_status,1,1)
	battery_percentage = math.floor(10*tonumber(conky_parse("${battery_percent}"))/100)
	if battery_status == "C" or battery_status == "F" then
		cairo_set_source_rgba(cr, r1, g1, b1, t1)
		for i=0, battery_percentage do
			cairo_rectangle (cr, c2_x+4+4*i+2*i, c2_y+25, 4, 22);
			cairo_fill(cr)
		end
	elseif battery_status == "D" then
		cairo_set_source_rgba(cr, r2, g2, b2, t2)
		for i=0, battery_percentage do
			cairo_rectangle (cr, c2_x+4+4*i+2*i, c2_y+25, 4, 22);
			cairo_fill(cr)
		end
	else
		cairo_set_source_rgba(cr, r3, g3, b3, t3)
		ct = cairo_text_extents_t:create()
		status=conky_parse("${battery}")
		cairo_text_extents(cr,status,ct)
		cairo_move_to(cr,w/2-ct.width/2,h/2+ct.height/2)
		cairo_show_text(cr,status)
	end
end

function draw_widgets(cr)
	local w,h=conky_window.width,conky_window.height
	cairo_select_font_face (cr, "Dejavu Sans", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
	cairo_set_font_size(cr, 9)
	
	--Draw background
	draw_circle_background(cr, w, h)
	draw_circle_background_border(cr, w, h)
	--Draw battery
	draw_battery(cr, w, h)
	
end

function conky_start_widgets()

	if conky_window==nil then return end
	local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)
	local cr=cairo_create(cs)	
	local ok, err = pcall(function () draw_widgets(cr) end)
	cairo_surface_destroy(cs)
	cairo_destroy(cr)
end
