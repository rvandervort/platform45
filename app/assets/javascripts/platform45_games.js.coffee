# Place all the behaviors and hooks related to the matching controller here.
# All @logic will automatically be available in application.js.
# You can use CoffeeScript in @file: http://jashkenas.github.com/coffee-script/
#
class window.Board
  coordinateToPos: (x, y) ->
    ret =
      x: ((x + 1) * @dim)
      y: ((y + 2) * @dim)

  dim: 40
  draw_square: (col, row) ->
    context = @canvas.getContext("2d")
    context.rect(col * @dim, row * @dim, @dim, @dim)
    context.lineWidth = 2
    context.strokeStyle = '#a0a0a0'
    context.stroke()

  initialize: (dom_id, ships, salvos) ->
    @dom_id = dom_id
    @canvas = document.getElementById(@dom_id)
    vertices = [1..10]
    
    for x in vertices
      for y in vertices
        @draw_square x, y

    @label x for x in vertices

    @place_ship(ship) for ship in ships
    @mark_space(salvo.x, salvo.y, salvo.state) for salvo in salvos

    @

  label: (v) ->
    context = @canvas.getContext("2d")
    context.fillStyle = "#000000"
    context.font = "bold 18px sans-serif"
    context.fillText v - 1, v  * @dim + 14, 20
    context.fillText v - 1, 10, v * @dim + 24

  mark_space: (x, y, state) ->
    context = @canvas.getContext("2d")
    dim = @coordinateToPos(x, y)
   
    dim.x += 8
    dim.y -= 8

    context.font = "bold 32px sans-serif"
    
    if state == "hit"
      context.fillStyle = "red"
      context.fillText "X", dim.x, dim.y
    else
      if state == "miss"
        context.fillStyle = "#000000"
        context.fillText "O", dim.x, dim.y

  paint_square: (x, y, color) ->
    dims = @coordinateToPos(x, y - 1)
    context = @canvas.getContext("2d")
    context.beginPath()
    context.rect(dims.x + 1, dims.y + 1, @dim - 2, @dim - 2)
    context.fillStyle = color
    context.fill()

  place_ship: (ship) ->
    length = @ship_lengths[ship.name]
    x = ship.x
    y = ship.y

    if ship.orientation == "horizontal"
      spaces = [x..(x + length - 1)]
      @paint_square(x, y,"#CAEAEB") for x in spaces
    else
      spaces = [y..(y + length - 1)]
      @paint_square(x, y,"#CAEAEB") for y in spaces
      

    false

  ship_lengths:
    "Carrier": 5
    "Battleship": 4
    "Destroyer": 3
    "Submarine": 2
    "Patrol Boat": 1

class window.Game
  alert: (heading, msg, type) ->
    $(".alert").fadeOut().remove()
    $(".content").prepend("<div class=\"alert fade in alert-block alert-"+type+"\"><button class=\"close\" data-dismiss=\"alert\">x</button><h4>"+heading+"</h4>"+msg+"</div>")

  error: (data) ->
    @alert "Error!", data.msg, "error"

  ok: (data) ->
    this[data.game_status](data)

  iwon: (data) ->
    @alert("I've won!", data.prize, "success")

  active: (data) ->
    their_board_obj.mark_space data.my_fired_salvo.x, data.my_fired_salvo.y, data.my_fired_salvo.state
    my_board_obj.mark_space data.their_fired_salvo.x, data.their_fired_salvo.y, data.their_fired_salvo.state

    @alert "Fire!", data.msg, "info"




