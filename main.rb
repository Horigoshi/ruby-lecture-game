# coding: utf-8
require 'dxopal'
include DXOpal

require_remote 'player.rb'
require_remote 'enemy.rb'
require_remote 'wall.rb'

Image.register(:player, 'images/player.png') 
Image.register(:enemy, 'images/enemy.png') 

Image.register(:wall1,'images/wall1.png')
Image.register(:wall2,'images/wall2.png')
Image.register(:floor,'images/floor_fg.png')
Image.register(:title, 'images/TITLE.png') 
Image.register(:fin, 'images/fin.png') 


Window.load_resources do
  Window.width  = 640
  Window.height = 480

  player_img = Image[:player]
  player_img.set_color_key([0, 0, 0])

  enemy_img = Image[:enemy]
  enemy_img.set_color_key([0, 0, 0])
  
  wall_img1 = Image[:wall1] 
  wall_img2 = Image[:wall2]
  
  wall_img1.set_color_key([255, 255, 255])
  wall_img2.set_color_key([255, 255, 255])
  
  wall_imgs = [wall_img1,wall_img2]
  
  floor = Image[:floor]
  
  player = Player.new(400, 500, player_img)
  wall =PassageWayTypeA.new(wall_imgs,400)
  title_img = Image[:title] 
  fin_img = Image[:fin]
  
  game_flag = 0
  is_print_title = true
  Window.loop do
    if(game_flag == 0)
        if(is_print_title == true)
            Window.draw(0,0,title_img)
        #    is_print_title = false
        end
        if Input.key_down?(K_ENTER)
            game_flag = 1
        end
    elsif(game_flag == 1)
        if Input.key_down?(K_W)
            wall.update(0, 0, -10)
        elsif Input.key_down?(K_S)
            wall.update(0, 0, 10)
        end
        if Input.key_down?(K_Q)
            game_flag = 2
        end
        wall.draw(0, 0)
        Window.draw(rand(8)-4, rand(3), floor)
    elsif(game_flag == 2)
        Window.draw(0,0,fin_img)
        if Input.key_down?(K_ENTER)
            game_flag = 0
        end
    end
 end
end