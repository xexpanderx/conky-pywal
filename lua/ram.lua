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
r1, g1, b1 = hex2rgb(color3)
t2= 1
r2, g2, b2 = hex2rgb(color7)
t3= 1
r3, g3, b3 = hex2rgb(color8)

function fix_text(text)
	if string.len(text) == 1 then
		new_text = " " .. text .. "%"
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

function draw_ram(cr, w, h)
	cairo_set_source_rgba(cr, r1, g1, b1, t1)
	local c1=72
	local c2_x=(w-c1)/2
	local c2_y=(h-c1)/2
	local c3_x=w/2
	local c3_y=h/2
	local fix=2
	--RAM structure
	cairo_set_line_width(cr, 2)
	cairo_move_to(cr,c2_x,c2_y+10+fix)
	cairo_rel_line_to(cr,72,0)
	cairo_rel_line_to(cr,0,10)
    cairo_stroke(cr)
    ----Right-circle
    cairo_arc(cr, c2_x+72, c2_y+25+fix, 5, 90*math.pi/180,270*math.pi/180)
    cairo_stroke(cr)
    --RAM structure 2
    cairo_move_to(cr,c2_x+72,c2_y+30+fix)
    cairo_rel_line_to(cr,0,20)
    cairo_rel_line_to(cr,-20,0)
    cairo_rel_line_to(cr,0,-10)
    cairo_stroke(cr)
    ----Bottom-circle
    cairo_arc(cr, c2_x+47, c2_y+40+fix, 5, 180*math.pi/180,360*math.pi/180)
    cairo_stroke(cr)
    --RAM structure 3
    cairo_move_to(cr,c2_x+42,c2_y+40+fix)
    cairo_rel_line_to(cr,0,10)
    cairo_rel_line_to(cr,-42,0)
    cairo_rel_line_to(cr,0,-20)
    cairo_stroke(cr)
    ----Left-circle
    cairo_arc(cr,c2_x, c2_y+25+fix, 5, 270*math.pi/180,90*math.pi/180)
    cairo_stroke(cr)
    --RAM structure 4 
    cairo_move_to(cr,c2_x,c2_y+20+fix)
    cairo_rel_line_to(cr,0,-10)
    cairo_stroke(cr)    
    ----Pins-left
    for i=1, 6 do
		cairo_move_to(cr,c2_x+42-5*i,c2_y+47+fix)
		cairo_rel_line_to(cr,0,-8)
		cairo_stroke(cr)
    end 
    ----Pins-right
    for i=1, 2 do
		cairo_move_to(cr,c2_x+52+5*i,c2_y+47+fix)
		cairo_rel_line_to(cr,0,-8)
		cairo_stroke(cr)
    end 
    ----Left-squares
    cairo_rectangle (cr, c2_x+10, c2_y+16+fix, 8, 11);
    cairo_fill(cr)
    cairo_rectangle (cr, c2_x+22, c2_y+16+fix, 8, 11);
    cairo_fill(cr)  
    ----Right-squares
    cairo_rectangle (cr, c2_x+42, c2_y+16+fix, 8, 11);
    cairo_fill(cr)
    cairo_rectangle (cr, c2_x+54, c2_y+16+fix, 8, 11);
    cairo_fill(cr)
    --Indicator line
    cairo_set_line_width(cr, 1)
    cairo_move_to(cr,c2_x,c2_y+58+fix)
    cairo_rel_line_to(cr,72,0)
    cairo_stroke(cr)
    --Indicator used line
    cairo_set_source_rgba(cr, r2, g2, b2, t2)
    cairo_set_line_width(cr, 4)
    mem_used = math.floor(72*tonumber(conky_parse("${memperc}"))/100)
    cairo_move_to(cr,c2_x,c2_y+58+fix)
    cairo_rel_line_to(cr,mem_used,0)
    cairo_stroke(cr) 
    --Mem used text
    --cairo_set_source_rgba(cr, r7, g7, b7, t7)
	--ct = cairo_text_extents_t:create()
	--cairo_text_extents(cr,conky_parse("${mem}") .. "/" .. conky_parse("${memmax}") ,ct)
    --cairo_move_to(cr,w/2-ct.width/2,c2_y+72)
    --cairo_show_text(cr,conky_parse("${mem}") .. "/" .. conky_parse("${memmax}"))
end


function draw_widgets(cr)
	local w,h=conky_window.width,conky_window.height
	cairo_select_font_face (cr, "Terminus", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
	cairo_set_font_size(cr, 9)
	
	--Draw background
	--Draw background
	draw_circle_background(cr, w, h)
	draw_circle_background_border(cr, w, h)
	--Draw RAM
	draw_ram(cr, w, h)
	
end

function conky_start_widgets()

	if conky_window==nil then return end
	local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)
	local cr=cairo_create(cs)	
	local ok, err = pcall(function () draw_widgets(cr) end)
	cairo_surface_destroy(cs)
	cairo_destroy(cr)
end
