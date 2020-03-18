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
r1, g1, b1 = hex2rgb(color2)
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

function draw_clock(cr, w, h)
	local c1=72
	local c2_x=(w-c1)/2
	local c2_y=(h-c1)/2
	local c3_x=w/2
	local c3_y=h/2
	--Border
	cairo_set_source_rgba(cr, r1, g1, b1, t1)
	cairo_set_line_width(cr, 2)
	cairo_move_to(cr,c2_x,c2_y+11)
	cairo_rel_line_to(cr,72,0)
	cairo_arc(cr,c2_x+72,c2_y+15,4,270*math.pi/180,0*math.pi/180)
	cairo_rel_line_to(cr,0,41)
	cairo_arc(cr,c2_x+72,c2_y+57,4,0*math.pi/180,90*math.pi/180)
	cairo_rel_line_to(cr,-72,0)
	cairo_arc(cr,c2_x,c2_y+57,4,90*math.pi/180,180*math.pi/180)
	cairo_arc(cr,c2_x,c2_y+15,4,180*math.pi/180,270*math.pi/180)	
	cairo_close_path(cr)
	cairo_stroke(cr)
	--Left foot
	cairo_move_to(cr,c2_x+9,c2_y+61)
	cairo_rel_line_to(cr,0,5)
	cairo_close_path(cr)
	cairo_stroke(cr)
	cairo_arc(cr,c2_x+13,c2_y+66,4,90*math.pi/180,180*math.pi/180)
	cairo_stroke(cr)
	cairo_move_to(cr,c2_x+12,c2_y+70)
	cairo_rel_line_to(cr,6,0)
	cairo_stroke(cr)
	cairo_arc(cr,c2_x+17,c2_y+66,4,0*math.pi/180,90*math.pi/180)
	cairo_stroke(cr)
	cairo_move_to(cr,c2_x+21,c2_y+66)
	cairo_rel_line_to(cr,0,-5)
	--Right foot
	cairo_rel_line_to(cr,30,0)
	cairo_rel_line_to(cr,0,5)
	cairo_stroke(cr)
	cairo_arc(cr,c2_x+55,c2_y+66,4,90*math.pi/180,180*math.pi/180)
	cairo_stroke(cr)
	cairo_move_to(cr,c2_x+54,c2_y+70)
	cairo_rel_line_to(cr,6,0)
	cairo_stroke(cr)
	cairo_arc(cr,c2_x+59,c2_y+66,4,0*math.pi/180,90*math.pi/180)
	cairo_stroke(cr)
	cairo_move_to(cr,c2_x+63,c2_y+66)
	cairo_rel_line_to(cr,0,-5)
	cairo_stroke(cr)
	--Radio antenna
	cairo_move_to(cr,c2_x+34,c2_y+11)
	cairo_rel_line_to(cr,-15,-15)
	cairo_stroke(cr)
	cairo_move_to(cr,c2_x+36,c2_y+11)
	cairo_rel_line_to(cr,15,-15)
	cairo_stroke(cr)
	--Middle line
	cairo_set_line_width(cr, 1)
	cairo_set_dash(cr,{4,4},1)
	cairo_move_to(cr,c2_x+2,h/2)
	cairo_rel_line_to(cr,72,0)
	cairo_stroke(cr)
	--Clock text
	cairo_set_source_rgba(cr, r2, g2, b2, t2)
	cairo_set_font_size(cr, 12)
	ct = cairo_text_extents_t:create()
	cairo_text_extents(cr,conky_parse('${exec date +%H:%M}'),ct)
	cairo_move_to(cr,w/2-ct.width/2,h/2+ct.height/2-13)
	cairo_show_text(cr,conky_parse('${exec date +%H:%M}'))
	--Date text
	cairo_set_source_rgba(cr, r3, g3, b3, t3)
	cairo_set_font_size(cr, 9)
	ct = cairo_text_extents_t:create()
	cairo_text_extents(cr,conky_parse('${exec date +%A}'),ct)
	cairo_move_to(cr,w/2-ct.width/2,h/2+ct.height/2+6)
	cairo_show_text(cr,conky_parse('${exec date +%A}'))
	ct = cairo_text_extents_t:create()
	cairo_text_extents(cr,conky_parse('${exec date +"%d %B"}'),ct)
	cairo_move_to(cr,w/2-ct.width/2,h/2+ct.height/2+17)
	cairo_show_text(cr,conky_parse('${exec date +"%d %B"}'))
end

function draw_widgets(cr)
	local w,h=conky_window.width,conky_window.height
	cairo_select_font_face (cr, "Dejavu Sans", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
	cairo_set_font_size(cr, 9)
	
	--Draw background
	draw_circle_background(cr, w, h)
	draw_circle_background_border(cr, w, h)
	--Draw NVIDIA
	draw_clock(cr, w, h)
	
end

function conky_start_widgets()

	if conky_window==nil then return end
	local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)
	local cr=cairo_create(cs)	
	local ok, err = pcall(function () draw_widgets(cr) end)
	cairo_surface_destroy(cs)
	cairo_destroy(cr)
end
