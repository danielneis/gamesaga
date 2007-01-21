#!/usr/bin/python
#
# Tom's Pong

VERSION = "0.5.1"

try:
	import sys
	import random
	import math
	import os
	import getopt
	import pygame
	from socket import *
	from pygame.locals import *
except ImportError, err:
   print "couldn't load module. %s" % (err)
   sys.exit(2)

keysdown = []


def load_png(name):
	""" Load image and return image object"""
	fullname = os.path.join('data', name)
	try:
		image = pygame.image.load(fullname)
		if image.get_alpha is None:
			image = image.convert()
		else:
			image = image.convert_alpha()
	except pygame.error, message:
        	print 'Cannot load image:', fullname
        	raise SystemExit, message
	return image, image.get_rect()

# Load sound function
def load_sound(name):
	"""Load sound and return sound object"""
	class NoneSound:
		def play(self): pass
	if not pygame.mixer or not pygame.mixer.get_init():
		return NoneSound()
	fullname = os.path.join('data', name)
	try:
		sound = pygame.mixer.Sound(fullname)
	except pygame.error, message:
		print 'Cannot load sound:', fullname
		raise SystemExit, message
	return sound




class Bat(pygame.sprite.Sprite):
	"""Moveable tannis 'bat' with which one hits the ball"""
	def __init__(self, which):
		pygame.sprite.Sprite.__init__(self)
		self.image, self.rect = load_png('bat.png')
		screen = pygame.display.get_surface()
		self.area = screen.get_rect()
		self.which = which
		self.scoredpoints = 0
		self.state = "still"
		self.speed = 10
		self.reinit()

	def reinit(self):
		self.state = "still"
		self.movepos = [0,0]
		self.moving = 0
		if self.which == 1:
			self.rect.midleft = self.area.midleft
			#self.rect = self.rect.move(10,0)
		elif self.which == 2:
			self.rect.midright = self.area.midright
			#self.rect = self.rect.move(-10,0)

	def moveup(self):
		self.movepos[1] = self.movepos[1] - (self.speed)

	def movedown(self):
		self.movepos[1] = self.movepos[1] + (self.speed)

	def upscore(self,score):
		self.scoredpoints += score


class Player(Bat):
	"""User-controlleable bat"""
	def update(self):
		newpos = self.rect.move(self.movepos)
		if self.area.contains(newpos):
			self.rect = newpos
		pygame.event.pump()

class AIPlayer(Bat):
	"""Artificial intelligence bat opponent"""
	def __init__(self, which):
		pygame.sprite.Sprite.__init__(self)
		self.image, self.rect = load_png('bat.png')
		screen = pygame.display.get_surface()
		self.area = screen.get_rect()
		self.which = which
		self.scoredpoints = 0
		self.state = "still"
		self.ballPosition = 220
		self.ballx        = 320
		self.speed = 10 - (0.6 * (10 - aiskill))
		print "   *** AI speed is %s" % self.speed
		self.reinit()
		
	def ballpos(self, ballPosition, ballx):
		self.ballPosition = ballPosition
		self.ballx = ballx
		
	def update(self):
		y = self.rect.centery
		newy = self.ballPosition
		newy += (1 * (10 - aiskill))
		
		# Calculate if the AI player will move or not depending on the distance of the ball from the paddle
		if abs(y-newy) < (((600-self.ballx)*(600-self.ballx) / 640) / (aiskill)):
			return
		# Do nothing if less than 10px adjustment is needed (avoid the twitching)
		if abs(y-newy) < self.speed:
			return

		# Finally, move the bat
		if y - newy > 0: newpos = self.rect.move([0,-self.speed])
		else:            newpos = self.rect.move([0,self.speed])
		
		#Just added some bounds checking here just like for live players
		if self.area.contains(newpos):
			self.rect = newpos



class Ball(pygame.sprite.Sprite):
	"""make a ball that will bounce around the screen"""
	def __init__(self, (xy), vector):
		pygame.sprite.Sprite.__init__(self)
		self.image, self.rect = load_png('ball.png')
		screen = pygame.display.get_surface()
		self.area = screen.get_rect()
		self.vector = vector
		self.hit = 0
		self.stuck = 1
		self.stuckplayer = player1
		self.ballPosition = 220
		if (debug): print "AREA: %s  BALL.RECT: %s" % (self.area, self.rect)

	def update(self):
		if (self.stuck):
			if self.stuckplayer == player1:
				newpos = self.rect
				(x,y) = self.stuckplayer.rect.topright
				newpos.topleft = (x,y)
				newpos = newpos.move((0,32))
			elif self.stuckplayer == player2:
				newpos = self.rect
				(x,y) = self.stuckplayer.rect.topleft
				newpos.topright = (x,y)
				newpos = newpos.move((0,32))
		else:
			newpos = self.calcnewpos(self.rect,self.vector)
		(angle,z) = self.vector
		(x1,y1,x2,y2) = self.rect
		self.rect = newpos
		self.ballPosition = self.rect.centery

		# BOUNCE ON WALLS
		if not self.area.contains(newpos):
			tl = not self.area.collidepoint(newpos.topleft)
			tr = not self.area.collidepoint(newpos.topright)
			bl = not self.area.collidepoint(newpos.bottomleft)
			br = not self.area.collidepoint(newpos.bottomright)
			if tr and tl or (br and bl):
				angle = -angle
				if (debug) : print "hit top/bottom at %s with vector %s." % (self.rect, self.vector)
			if tl and bl:
				if (debug) : print "off left at %s with vector %s" % (self.rect, self.vector)
				self.offcourt(player=2)
			if tr and br:
				if (debug) : print "off right at %s with vector %s" % (self.rect, self.vector)
				self.offcourt(player=1)
		# BOUNCE ON BATS
		else:
			# Deflate the rectangles so you can't catch a ball behind the bat
			player1.rect.inflate(-3, -3)
			player2.rect.inflate(-3, -3)

			# Do ball and bat collide?
			# Note I put in an odd rule that sets self.hit to 1 when they collide, and unsets it in the next
			# iteration. this is to stop odd ball behaviour where it finds a collision *inside* the
			# bat, the ball reverses, and is still inside the bat, so bounces around inside.
			# This way, the ball can always escape and bounce away cleanly
			if self.rect.colliderect(player1.rect) == 1 and not self.hit:
				angle = math.pi - angle
				self.hit = not self.hit
				self.vector = (angle,z)
				angle = self.checkspin(player1, self.vector, self.rect)
			elif self.rect.colliderect(player2.rect) == 1 and not self.hit:
				angle = math.pi - angle
				self.hit = not self.hit
				self.vector = (angle,z)
				angle = self.checkspin(player2, self.vector, self.rect)
			elif self.hit:
				self.hit = not self.hit
		angle = self.avoid(angle)
		self.vector = (angle,z)
	
	def givenewpos(self):
		return self.ballPosition


	def calcnewpos(self,rect,vector):
		#where would rect be with this vector
		(angle,z) = vector
		(dx,dy) = (z*math.cos(angle),z*math.sin(angle))
		return rect.move(dx,dy)


	def checkspin(self,player,vector,rect):
		# Check if the ball's movement should be changed due to spin;
		# It's a terrible hack, but it works :)
		(angle,z) = vector
		(dx,dy) = (z*math.cos(angle),z*math.sin(angle))

		if player.state == "moveup" and (0.001 - dy) > 0:
			if (debug) : print "SPIN: bat up, ball up, angle:%s" % angle
			angle += (math.pi*0.06)
		elif player.state == "moveup" and (0.001 - dy) < 0:
			if (debug) : print "SPIN: bat up, ball down,angle:%s" % angle
			angle += (math.pi*0.06)
		elif player.state == "movedown" and (0.001 - dy) < 0:
			angle += (math.pi*0.06)
			if (debug) : print "SPIN: bat down, ball down,angle:%s" % angle
		elif player.state == "movedown" and (0.001 - dy) > 0:
			angle += (math.pi*0.06)
			#dy += (
			if (debug) : print "SPIN: bat down, ball up,angle:%s" % angle

		return angle



	def avoid(self,angle,always_avoid = 0,turn = 0):
		# stay away from angles near to pi/2 and 3*pi/2 (which are vertical movements, impossible for players)
		#angle = self.norm(angle)
		pb2 = math.pi / 2
		pb2t3 = 3 * pb2
		tooclose = math.pi / 3
		if not turn:
			turn = math.pi / 40
		if angle < pb2:
			if always_avoid or (pb2 - angle) < tooclose:
				angle -= turn
		elif angle < math.pi:
			if always_avoid or (angle - pb2) < tooclose:
				angle += turn
		elif angle < pb2t3:
			if always_avoid or (pb2t3 - angle) < tooclose:
				angle -= turn
		else:
			if always_avoid or (angle - pb2t3) < tooclose:
				angle += turn
		return angle

	def norm(self,angle):
		p2 = math.pi * 2
		while angle < 0:
			angle += p2
		while angle >= p2:
			angle -= p2
		return angle
	
	def offcourt(self, player):
		#Put the ball in the center of the court so that the score is only counted once
	        self.rect.centerx=320
		self.rect.centery=220

		# Top-up scores
		if player == 1:
			player1.upscore(1)
		else:
			player2.upscore(1)

		# Display new scores
		show_scores()

		# Display congratulations for a little time
		text = "Player %s scores" % player
		font = pygame.font.Font(None, 20)
		ren = font.render(text, 1, (240,240,240))
		textpos = ren.get_rect()
		textpos.centerx = background.get_rect().centerx
		textpos.centery = 220
		screen.blit(ren, textpos)
		pygame.display.flip()
		pygame.time.wait(700)
		
		# Blank out congratulations, and wait a little more
		screen.blit(background, (0,0))
		show_scores()
		pygame.display.flip()
		pygame.time.wait(400)

		# Reset game
		self.stuck = 1
		if player == 1:
			self.stuckplayer = player1
		else:
			self.stuckplayer = player2
		player1.reinit()
		player2.reinit()

def show_scores():
	""" Print scores to screen """
	rect = Rect(10,10,40,40)
	screen.blit(background, rect, rect )
	rect = Rect(595,10,40,40)
	screen.blit(background, rect, rect )

	text = str(player1.scoredpoints)
	score1 = score_font.render(text, 1, (240,240,240))

	text = str(player2.scoredpoints)
	score2 = score_font.render(text, 1, (240,240,240))
	
	screen.blit(score1, (10,10))
	screen.blit(score2, (595,10))

def main():
	# Check for runtime options
	global debug
	global aiskill
	(debug,aimode,fullscreen, speed, server, hostname, port) = (0, 0, 0, 13, 0, 'localhost', 4114)
	for opt in sys.argv:
		if opt == '-f':
			fullscreen = 1
		if opt == '-d':
			debug = 1
			print "   *** In debugging mode ***"
		if opt == '-s':
			server = 1
		if opt[:3] == '-s=':
			speed = int(opt[3:])
			print "   *** Set speed to %s" % speed
		if opt[:4] == '-ai=':
			aimode = 1
			aiskill = int(opt[4:])
			print "   *** In AI mode ***"
			print "   *** Set AI skill to %s" % aiskill

# 	# Set-up server
# 	if server:
# 		sockobj = socket(AF_INET, SOCK_STREAM)
# 		sockobj.bind((hostname,port))
# 		sockobj.listen(1)
# 		connection = 0
# 		connection, address = sockobj.accept()

	# Set-up screen
	pygame.init()
	global screen
	if fullscreen == 0:
		screen = 	pygame.display.set_mode((640,480))
	elif fullscreen == 1:
		screen = 	pygame.display.set_mode((640,480), FULLSCREEN)
	pygame.display.set_caption("Tom's Pong")
	icon, icon_rect = load_png("win_icon.png")
	pygame.display.set_icon(icon)
	pygame.mouse.set_visible(0)
	fullscreen = 0
	pause = 0
	
	# Set-up background surface
	global background
	background = pygame.Surface(screen.get_size())
	background = background.convert()
	background.fill((0, 0, 0))
	bgimage, bgimage_rect = load_png("background.png")
	background.blit(bgimage, (0,0))

	# Initialise players
	#global ballPosition
	#ballPosition = 220
	global player1
	global player2
	player1 = Player(1)
	if aimode: player2 = AIPlayer(2)
	else: player2 = Player(2)
	
	# Initialise ball
	rand = ((0.1 * (random.randint(5,8))))
	ball = Ball((0,0),(rand*math.pi,speed))
	global ballsprite
	ballsprite = pygame.sprite.RenderPlain(ball)
	global playersprites
	playersprites = pygame.sprite.RenderPlain((player1, player2))

	# Write title text
	font = pygame.font.Font(None, 30)
	text = "Tom's Pong, v" + VERSION
	title = font.render(text, 1, (240,240,240))
	textpos = title.get_rect()
	textpos.centerx = background.get_rect().centerx
	background.blit(title, textpos)

	global score_font
	score_font = pygame.font.Font(None, 40)

	# Blit everything to the screen
	screen.blit(background, (0,0) )
	pygame.display.flip()
	
	clock = pygame.time.Clock()
	# Start music
# 	music = load_sound("music.wav")
# 	music.play(-1)

	while 1:
        # Make sure game doesn't run at more than 60 frames per second
		clock.tick(60)
		for event in pygame.event.get():
			if event.type == QUIT:
				return
			elif event.type == KEYDOWN:
				if event.key == K_p:
					pause = not pause
				if event.key == K_a:
					player1.moveup()
					player1.state = "moveup"
				if event.key == K_z:
					player1.movedown()
					player1.state = "movedown"
				if event.key == K_UP:
					player2.moveup()
					player2.state = "moveup"
				if event.key == K_DOWN:
					player2.movedown()
					player2.state = "movedown"
			elif event.type == KEYUP:
				if event.key == K_a or event.key == K_z:
					player1.movepos = [0,0]
					player1.state = "still"
				if event.key == K_UP or event.key == K_DOWN:
					player2.movepos = [0,0]
					player2.state = "still"
				if event.key == K_SPACE:
					ball.stuck = 0
				if event.key == K_f:
					if fullscreen == 0:
						screen = pygame.display.set_mode((640,480),FULLSCREEN)
						fullscreen = 1
					else:
						screen = pygame.display.set_mode((640,480))
						fullscreen = 0
					screen.blit(background, (0,0) )
# 		if server:
# 			sockobj.setblocking(0)
# 			try:
# 				data = connection.recv(1024)
# 				if not data: break
# 				if data == "move player up":
# 					player2.moveup()
# 					player2.state = "moveup"
# 					print "moveup"
# 				elif data == "move player down":
# 					player2.movedown()
# 					player2.state = "movedown"
# 					print "movedown"
# 				elif data == "stop moving player":
# 					player2.movepos = [0,0]
# 					player2.state = "still"
# 					print "stop"
# 			except:
# 				print "no data yet"

		if not pause:
			if aimode:
				ballPosition = ball.givenewpos()
				player2.ballpos(ballPosition, ball.rect.centerx)
			screen.blit(background, ball.rect, ball.rect)
			screen.blit(background, player1.rect, player1.rect)
			screen.blit(background, player2.rect, player2.rect)
			show_scores()
			ballsprite.update()
			playersprites.update()
			ballsprite.draw(screen)
			playersprites.draw(screen)
			pygame.display.flip()
		else:
			font = pygame.font.Font(None, 40)
			pause_text = "[PAUSED]"
			pause_ren = font.render(pause_text, 1, (240, 5, 5))
			screen.blit(pause_ren, (253, 180))
			font = pygame.font.Font(None, 23)
			unpause_text = "press p to resume"
			unpause_ren = font.render(unpause_text, 1, (240, 5, 5))
			screen.blit(unpause_ren, (256, 210))
			pygame.display.flip()


if __name__ == '__main__':
	main()
