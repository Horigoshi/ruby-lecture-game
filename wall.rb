# coding:utf-8

require 'dxopal'
include DXOpal

require 'dxruby'
#
# 通路を奥に進んでいく背景演出
#
class PassageWayTypeA
  attr_accessor :walls
 
  #
  # 壁1枚分
  #
  class Wall
    attr_accessor :image
    attr_accessor :x, :y, :z
    attr_accessor :sz
    attr_accessor :angle_z
  #  attr_accessor :shader
 
    # 明度調整用
#     @@hlsl = <<EOS
#   float v;
#   texture tex0;
 
#   sampler Samp0 = sampler_state
#   {
#   Texture =<tex0>;
#   };
 
#   float4 PS(float2 input : TEXCOORD0) : COLOR0 {
#     float4 output;
#     output = tex2D( Samp0, input );
#     output.rgb *= v;
#     return output;
#   }
 
#   technique {
#   pass {
#     PixelShader = compile ps_2_0 PS();
#   }
#   }

# EOS
 
    #
    # コンストラクタ
    #
    # @param [Object] img Imageオブジェクト
    # @param [Number] x 初期位置x
    # @param [Number] y 初期位置y
    # @param [Number] z 初期位置z
    # @param [Number] scr_z 視点からスクリーン(画面)までの距離
    #
    def initialize(img, x, y, z, scr_z)
      self.image = img
      self.sz = scr_z
      self.angle_z = 0
      self.x = x
      self.y = y
      self.z = z
  #   core = Shader::Core.new(@@hlsl, {:v => :float})
    #  self.shader = Shader.new(core)
     # self.shader.v = 1.0
    end
 
    #
    # 座標を更新
    #
    # @param [Number] dx 速度x
    # @param [Number] dy 速度y
    # @param [Number] dz 速度z
    # @param [Number] d_ang_z z軸回転速度
    #
    def update(dx, dy, dz, d_ang_z = 0)
      self.x += dx
      self.y += dy
      self.z += dz
      self.angle_z += d_ang_z
    end
 
    #
    # 描画
    #
    # @param [Number] bx 描画位置オフセットx
    # @param [Number] by 描画位置オフセットy
    #
    def draw(bx, by)
      sx = (self.sz * (bx + self.x) / self.z) + Window.width / 2
      sy = (self.sz * (by + self.y) / self.z) + Window.height / 2
      scale = self.sz / self.z
      p Window.width
      #a = 1.0 - (1.0 * (self.z - 300) / 2900.0)
      #a = 0 if a < 0
      #a = 1.0 if a > 1.0
      #self.shader.v = a
      Window.draw_ex(sx, sy, self.image,
                    :scale_x => scale, :scale_y => scale,
                    :center_x => self.image.width / 2,
                    :center_y => self.image.height / 2,
                    :angle => self.angle_z,
                    :offset_sync => true,
                    :z => -self.z)#,
                    #:shader => self.shader)
    end
  end
 
  #
  # コンストラクタ
  #
  # @param [Array] imgs Imageオブジェクトの配列
  # @param [Number] scr_z 視点からスクリーン(画面)までの距離
  # @param [Number] num 壁の枚数
  #
  def initialize(imgs, scr_z, num = 8)
    self.walls = []
    z = 3200.0
    zadd = 3200 / num
    num.times do |i|
      x, y = 0, 0
      self.walls.push(Wall.new(imgs[i % imgs.length], x, y, z, scr_z))
      z += zadd
    end
    #self.x = 0
    #self.y = 0
    #self.z = z
  end
 
  #
  # 座標を更新
  #
  # @param [Number] dx 速度x
  # @param [Number] dy 速度y
  # @param [Number] dz 速度z
  # @param [Number] d_ang_z z軸回転速度
  # @param [Boolean] del_enable trueなら、スクリーン手前に来た段階で壁を消去
  # @return [Number] 壁の数を返す
  #
  def update(dx, dy, dz, d_ang_z = 0, del_enable = false)
    self.walls.each do |spr|
      spr.update(dx, dy, dz, d_ang_z)
      if spr.z < spr.sz - 100
        # 投影面より手前に来たので
        if del_enable
          self.walls.delete(spr)
        else
          # 遠方に配置し直し
          spr.z += 3200.0
          spr.x, spr.y = 0, 0
        end
      end
    end
 
    return self.walls.size
  end
 
  #
  # 描画
  #
  # @param [Number] bx 描画位置オフセットx
  # @param [Number] by 描画位置オフセットy
  #
  def draw(bx, by)
    self.walls.each { |spr| spr.draw(bx, by) }
  end
end
 
