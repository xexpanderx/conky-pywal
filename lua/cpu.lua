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
r1, g1, b1 = hex2rgb(color4)
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

function draw_cpu(cr, w, h)
	local c1=52
	local c2_x=(w-c1)/2
	local c2_y=(h-c1)/2
	local c3_x=w/2
	local c3_y=h/2
	cairo_set_line_width(cr, 2)
	--CPU hole
	cairo_set_source_rgba(cr, r1, g1, b1, t1)
	cairo_arc(cr,c2_x+5,c2_y+5,2,0*math.pi/180,360*math.pi/180)
	cairo_close_path(cr)
    cairo_fill(cr)
	--CPU border
	cairo_move_to(cr,c2_x,c2_y)
	cairo_rel_line_to(cr,52,0)
	cairo_rel_line_to(cr,0,52)
	cairo_rel_line_to(cr,-52,0)
	cairo_set_line_join (cr, CAIRO_LINE_JOIN_ROUND);
    cairo_close_path(cr)
    cairo_stroke(cr)
	--Top pins
	cairo_set_line_width(cr, 2)
	cairo_set_line_cap (cr, CAIRO_LINE_CAP_ROUND);
	cairo_move_to(cr,c2_x+5,c2_y-5)
	cairo_rel_line_to(cr,0,-5)
	cairo_close_path(cr)
	cairo_stroke(cr)
    for i=1, 6 do
		cairo_move_to(cr,c2_x+5+7*i,c2_y-5)
		cairo_rel_line_to(cr,0,-5)
		cairo_close_path(cr)
		cairo_stroke(cr)
    end
    --Left pins
	cairo_move_to(cr,c2_x-5,c2_y+5)
	cairo_rel_line_to(cr,-5,0)
	cairo_close_path(cr)
	cairo_stroke(cr)
    for i=1, 6 do
		cairo_move_to(cr,c2_x-5,c2_y+5+7*i)
		cairo_rel_line_to(cr,-5,0)
		cairo_close_path(cr)
		cairo_stroke(cr)
    end
    --Right pins
	cairo_move_to(cr,c2_x+62,c2_y+5)
	cairo_rel_line_to(cr,-5,0)
	cairo_close_path(cr)
	cairo_stroke(cr)
    for i=1, 6 do
		cairo_move_to(cr,c2_x+62,c2_y+5+7*i)
		cairo_rel_line_to(cr,-5,0)
		cairo_close_path(cr)
		cairo_stroke(cr)
    end
    --Bottom pins
	cairo_move_to(cr,c2_x+5,c2_y+62)
	cairo_rel_line_to(cr,0,-5)
	cairo_close_path(cr)
	cairo_stroke(cr)
    for i=1, 6 do
		cairo_move_to(cr,c2_x+5+7*i,c2_y+62)
		cairo_rel_line_to(cr,0,-5)
		cairo_close_path(cr)
		cairo_stroke(cr)
    end
    
    --Unused CPU ring
    cairo_set_source_rgba(cr, r1, g1, b1, t1)
    cairo_set_line_width(cr, 1)
	cairo_arc(cr,c3_x,c3_y,20,0*math.pi/180,360*math.pi/180)
	cairo_stroke(cr)
    
    --Used CPU ring
    cpu_used = math.floor(360*tonumber(conky_parse("${cpu cpu0}"))/100)
    cairo_set_source_rgba(cr, r2, g2, b2, t2)
    cairo_set_line_width(cr, 4)
	cairo_arc(cr,c3_x,c3_y,20,270*math.pi/180,(270+cpu_used)*math.pi/180)
	cairo_stroke(cr)
	
	--CPU temp structure
	cairo_set_line_width(cr, 1)
	cairo_set_source_rgba(cr, r1, g1, b1, t1)
	cairo_arc(cr,w/2,h/2+10,5,310*math.pi/180,230*math.pi/180)
	cairo_rel_line_to(cr,0,-14)
	cairo_arc(cr,w/2,h/2+10-14-6,3,180*math.pi/180,360*math.pi/180)
	cairo_close_path(cr)
	cairo_stroke(cr)
	
	--CPU temp
	cairo_set_source_rgba(cr, r2, g2, b2, t2)
	cairo_arc(cr,w/2,h/2+10,2,0*math.pi/180,360*math.pi/180)
	cairo_fill(cr)
	cairo_move_to(cr,w/2,h/2+10)
	temp = math.floor(20*tonumber(conky_parse("${execi 5 sensors | grep 'id 0:' | awk '{print $4}' | tr -d '+C°'}"))/100)
	cairo_rel_line_to(cr,0,-temp)
	cairo_stroke(cr)
end

function draw_widgets(cr)
	local w,h=conky_window.width,conky_window.height
	cairo_select_font_face (cr, "Terminus", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
	cairo_set_font_size(cr, 9)
	
	--Draw background
	draw_circle_background(cr, w, h)
	draw_circle_background_border(cr, w, h)
	--Draw cpu
	draw_cpu(cr, w, h)
	
end

function conky_start_widgets()

	if conky_window==nil then return end
	local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)
	local cr=cairo_create(cs)	
	local ok, err = pcall(function () draw_widgets(cr) end)
	cairo_surface_destroy(cs)
	cairo_destroy(cr)
end
