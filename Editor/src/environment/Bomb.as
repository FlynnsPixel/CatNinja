package environment {
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import tools.Collision;
	
	/**
	 * ...
	 * @author Feffers
	 */
	public class Bomb extends Sprite {
		
		//bomb variables
		private var container:Sprite = new Sprite();
		private var base:Bitmap;
		private var coord:Point = new Point();
		private var speedx:Number;
		private var gravity:Number;
		public var removed:Boolean = false;
		
		public function Bomb(posx:int, posy:int, maxpowerx:int = 16, minpowerx:int = 2, maxpowery:int = 10, minpowery:int = 4, random:Boolean = true):void {
			base = new Bitmap(Main.textures.bomb);
			addChild(container);
			container.addChild(base);
			base.x = -base.width / 2;
			base.y = -base.height / 2;
			scaleX = .8;
			scaleY = .8;
			
			x = posx; y = posy;
			if (random) {
				speedx = minpowerx + Math.random() * (maxpowerx - minpowerx);
				gravity = minpowery + Math.random() * (maxpowery - minpowery);
			}else {
				speedx = maxpowerx - minpowerx;
				gravity = maxpowery - minpowery;
			}
		}
		
		public function update():void {
			Main.trail.create(x, y, null, 4, this, .04, .8);
			visible = false;
			x -= speedx;
			y -= gravity;
			gravity -= .25;
			speedx = speedx * .99;
			
			coord.x = int(x / 20); coord.y = int(y / 20);
			if (!Main.map.collideRight(coord.x, coord.y).walkable || !Main.map.collideLeft(coord.x, coord.y).walkable ||
			!Main.map.collideDown(coord.x, coord.y - 1).walkable || !Main.map.collideUp(coord.x, coord.y).walkable) {
				explode();
				return;
			}
			if (!Main.player.dead) {
				if (coord.x == Main.player.coordx && coord.y == Main.player.coordy ||
				Math.round(coord.x) == Main.player.coordx && Math.round(coord.y) == Main.player.coordy ||
				Math.floor(coord.x) == Main.player.coordx && Math.floor(coord.y) == Main.player.coordy) {
					explode();
					Main.player.die();
				}
			}
		}
		
		private function explode():void {
			removed = true;
			Main.sound.playsfx(4);
			if (x >= Main.player.x - 20 && x <= Main.player.x + 20 && y >= Main.player.y - 20 && y <= Main.player.y + 20) {
				Main.player.die();
			}
			Main.particles.create(x, y, 20, 15, 15, 7, null);
			--Main.env.bombcounter;
		}
	}
}