# coding:utf-8

require 'dxopal'
include DXOpal

#マップの座標値の意味
#　1:wall    0:floor
#　以下プレイヤーの動きの向き
#　2:右向き 3:下向き 4:左向き 5:上向き


class Map
    attr_accessor :p_x
    attr_accessor :p_y
    attr_accessor :img_wall
    @map = Array.new(3) {Array.new(7)}
    
    
    #プレイヤーの初期位置の決定
    def initialize(x,y)
      for i in 0..6 do
         map[0][i] =0;
         map[2][i] =0;
      end
        self.p_x = x
        self.p_y = y
        map[p_x][p_y] = 2 
    end
    
    #マップ読み込みと表示する画像用の変換
    def map_read(map_around)
        for i in 0..2
           #playerの状態によって探索する方向の変更 探索した値をwallに格納
           if map[p_x][p_y] == 2
              wall = map[p_x + i][p_y - 1]*100 + map[p_x + i][p_y]*10 + map[p_x + i][p_y + 1]
           elsif map[p_x][p_y] == 3
              wall = map[p_x - 1][p_y + i]*100 + map[p_x][p_y + i]*10 + map[p_x - 1][p_y + i]
           elsif map[p_x][p_y] == 4
              wall = map[p_x -i][p_y - 1]*100 + map[p_x - i][p_y]*10 + map[p_x - i][p_y + 1] 
           elsif map[p_x][p_y] == 5
              wall = map[p_x - 1][p_y - i]*100 + map[p_x][p_y - i]*10 + map[p_x - 1][p_y - i]
           end
           
           #wallの値によって画像用の値に変換
           #　0:両側壁      1:右側に通路  2:左側に通路  3:行き止まり 
           if(wall == 101)
              map_around[i] = 0
           elsif(wall == 100)
              map_around[i] = 1
           elsif(wall == 0)
              map_around[i] = 2
           elsif(wall == 111)
              map_around[i] = 3
           end
        end
    end
    
    
end   
    

    
    
    