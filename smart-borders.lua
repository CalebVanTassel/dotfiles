local gears         = require("gears")
local cairo         = require("lgi").cairo
local awful         = require("awful")
local wibox         = require("wibox")

local smartBorders = {}

local GUTTER = 0
local WEIGHT = 3
local ARROW_WEIGHT = 15
local ARROW_WIDTH = 100
local COLOR = gears.color("#2b303b")

function smartBorders.set(c, firstRender)

  -- createFragment(c, "top")
  -- createFragment(c, "right")
  -- createFragment(c, "bottom")
  -- createFragment(c, "left")

  -- do return end
  local COLOR = gears.color("#ffffff")

  local b_weight = 4
  local b_string_weight = 4
  local b_gutter = 0
  local b_arrow = 12

  if c.floating then
    b_weight = 0
    b_string_weight = 0
    b_gutter = 0
    b_arrow = 0
  end

  local side = b_weight + b_gutter
  local total_width = c.width
  local total_height = c.height

  -- for some reasons, the client height/width are not the same at first
  -- render (when called by request title bar) and when resizing
  if firstRender then
    total_width = total_width + 2 * (b_weight + b_gutter)
  else
    total_height = total_height - 2 * (b_weight + b_gutter)
    total_width = total_width + 2 * (b_weight + b_gutter)
  end
--------------
-- TOP
-------------
  local imgTop = cairo.ImageSurface.create(cairo.Format.ARGB32, total_width, side)
  local crTop  = cairo.Context(imgTop)

  crTop:set_source(COLOR)
  crTop:rectangle(6, b_weight / 2 - b_string_weight / 2, total_width-20, b_string_weight)
  crTop:fill()

  crTop:set_source(COLOR)
  crTop:set_antialias(cairo.Antialias.DEFAULT)
  crTop:arc(5, 5, 5, 0, 2*math.pi)
  crTop:arc(total_width-13, 5, 5, 0, 2*math.pi)
  crTop:fill()
--------------
-- BOTTOM
-------------

  local imgBot = cairo.ImageSurface.create(cairo.Format.ARGB32, total_width, side)
  local crBot  = cairo.Context(imgBot)

  crBot:set_source(COLOR)
  crBot:rectangle(6, side - b_weight / 2 - b_string_weight / 2, total_width-20, b_string_weight)
  crBot:fill()

  crBot:set_source(COLOR) 
  crBot:set_antialias(cairo.Antialias.DEFAULT)
  crBot:arc(5, 0, 5, 0, 2*math.pi)
  crBot:arc(total_width-13, 0, 5, 0, 2*math.pi)
  crBot:fill()
--------------
-- LEFT
-------------

  local imgLeft = cairo.ImageSurface.create(cairo.Format.ARGB32, side, total_height)
  local crLeft  = cairo.Context(imgLeft)

  crLeft:set_source(COLOR)
  crLeft:rectangle(b_weight / 2 - b_string_weight / 2, 0, b_string_weight, total_height)
  crLeft:fill()

  crLeft:set_source(COLOR)
  --crLeft:rectangle(0, 0, b_weight, b_arrow - side)
  --crLeft:rectangle(0, total_height - b_arrow + side, b_weight, b_arrow - side)
  crLeft:fill()
--------------
-- RIGHT
-------------

  local imgRight = cairo.ImageSurface.create(cairo.Format.ARGB32, side, total_height)
  local crRight  = cairo.Context(imgRight)

  crRight:set_source(COLOR)
  crRight:rectangle(b_gutter + b_weight / 2 - b_string_weight / 2, 0, b_string_weight, total_height)
  crRight:fill()

  crRight:set_source(COLOR)
  crRight:rectangle(b_gutter, 0, b_weight, b_arrow - side)
  crRight:rectangle(b_gutter, total_height - b_arrow + side, b_weight, b_arrow - side)
  crRight:fill()

  awful.titlebar(c, {
    size = b_weight + b_gutter,
    position = "top",
    bg_normal = "transparent",
    bg_focus = "transparent",
    bgimage_focus = imgTop,
    bgimage_normal = imgTop,
  }) : setup { layout = wibox.layout.align.horizontal, }

  awful.titlebar(c, {
    size = b_weight + b_gutter,
    position = "left",
    bg_normal = "transparent",
    bg_focus = "transparent",
    bgimage_focus = imgLeft,
    bgimage_normal = imgLeft,
  }) : setup { layout = wibox.layout.align.horizontal, }

  awful.titlebar(c, {
    size = b_weight + b_gutter,
    position = "right",
    bg_normal = "transparent",
    bg_focus = "transparent",
    bgimage_focus = imgRight,
    bgimage_normal = imgRight,
  }) : setup { layout = wibox.layout.align.horizontal, }

  awful.titlebar(c, {
    size = b_weight + b_gutter,
    position = "bottom",
    bg_normal = "transparent",
    bg_focus = "transparent",
    bgimage_focus = imgBot,
    bgimage_normal = imgBot,
  }) : setup { layout = wibox.layout.align.horizontal, }

end

function createFragment(c, position)

  local img = cairo.ImageSurface.create(
    cairo.Format.ARGB32,
    c.width + GUTTER + WEIGHT,
    c.height + GUTTER + WEIGHT
  )

  local ctx  = cairo.Context(img)
  ctx:set_source(COLOR)

  if position == "top" then
    ctx:rectangle(0, 0, c.width + GUTTER + WEIGHT, WEIGHT)
    ctx:rectangle(0, 0, ARROW_WIDTH, ARROW_WEIGHT)
    ctx:rectangle(0, 0, ARROW_WEIGHT, WEIGHT + GUTTER)
  elseif position == "left" then
    ctx:rectangle(0, 0, WEIGHT, c.height + GUTTER + WEIGHT)
    ctx:rectangle(0, 0, ARROW_WEIGHT, ARROW_WIDTH - GUTTER - WEIGHT)
    ctx:rectangle(0, c.height - ARROW_WIDTH - GUTTER - WEIGHT, ARROW_WEIGHT, ARROW_WIDTH - GUTTER - WEIGHT)
  elseif position == "bottom" then
    ctx:rectangle(0, GUTTER, c.width + GUTTER + WEIGHT, WEIGHT)
    ctx:rectangle(0, 0, ARROW_WEIGHT, GUTTER)
    ctx:rectangle(0, GUTTER - ARROW_WEIGHT, ARROW_WIDTH, ARROW_WEIGHT)
  end

  ctx:fill()

  awful.titlebar(c, {
    size = GUTTER + WEIGHT,
    position = position,
    bg_normal = "transparent",
    bg_focus = "transparent",
    bgimage_focus = img,
  }) : setup { layout = wibox.layout.align.horizontal, }

end

return smartBorders

