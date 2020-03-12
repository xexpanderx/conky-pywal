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
r1, g1, b1 = hex2rgb(color5)
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

function draw_gpu(cr, w, h)
	local c1=66
	local c2_x=(w-c1)/2
	local c2_y=(h-c1)/2
	local c3_x=w/2
	local c3_y=h/2
	cairo_set_source_rgba(cr, r1, g1, b1, t1)
	cairo_set_line_width(cr, 2)
	--GPU structure
	cairo_move_to(cr,c2_x+4,c2_y+10)
	cairo_rel_line_to(cr,c1,0)
	cairo_rel_line_to(cr,0,c2_y+27)
	cairo_rel_line_to(cr,-c1,0)
	cairo_rel_line_to(cr,0,-c2_y-35)
	cairo_rel_line_to(cr,-4,0)
	cairo_rel_line_to(cr,4,0)
	cairo_rel_line_to(cr,0,7)
	cairo_rel_line_to(cr,0,9)
	cairo_rel_line_to(cr,-8,0)
	cairo_rel_line_to(cr,0,12)
	cairo_rel_line_to(cr,8,0)
	cairo_rel_line_to(cr,0,8)
	cairo_rel_line_to(cr,-8,0)
	cairo_rel_line_to(cr,0,12)
	cairo_rel_line_to(cr,8,0)
	cairo_rel_line_to(cr,0,16)
	cairo_rel_line_to(cr,0,-8)
	cairo_rel_line_to(cr,10,0)
	cairo_rel_line_to(cr,0,6)
	cairo_rel_line_to(cr,46,0)
	cairo_rel_line_to(cr,0,-6)
	cairo_rel_line_to(cr,10,0)
    cairo_stroke(cr)
    --Lines
    for i=0, 1 do
    cairo_move_to(cr,c2_x+12+6*i,c2_y+22)
    cairo_set_line_width(cr, 2)
    cairo_set_line_cap  (cr, CAIRO_LINE_CAP_ROUND);
    cairo_rel_line_to(cr,0,24)
    cairo_stroke(cr)
    end
    --Circle
    cairo_arc(cr,w/2+12,h/2+1,19,0*math.pi/180,360*math.pi/180)
    cairo_stroke(cr)
    --Hertz text
	cairo_set_source_rgba(cr, r2, g2, b2, t2)
	ct = cairo_text_extents_t:create()
	hz=conky_parse("${exec xrandr | grep '*' | tr ' ' '\n' | grep '*' | tr -d '*' | awk '{printf(\"%d\\\n\",$1 + 0.5)}'}")
	cairo_text_extents(cr,hz .. "Hz",ct)
    cairo_move_to(cr,w/2+12-ct.width/2,h/2+1+ct.height/2)
    cairo_show_text(cr,hz .. "Hz")
end

function draw_widgets(cr)
	local w,h=conky_window.width,conky_window.height
	cairo_select_font_face (cr, "Dejavu Sans", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
	cairo_set_font_size(cr, 9)
	
	--Draw background
	draw_circle_background(cr, w, h)
	draw_circle_background_border(cr, w, h)
	--Draw NVIDIA
	draw_gpu(cr, w, h)
	
end

function conky_start_widgets()

	if conky_window==nil then return end
	local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)
	local cr=cairo_create(cs)	
	local ok, err = pcall(function () draw_widgets(cr) end)
	cairo_surface_destroy(cs)
	cairo_destroy(cr)
end
