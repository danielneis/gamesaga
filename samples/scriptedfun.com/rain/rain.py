#! /usr/bin/env python

# scriptedfun.com
# Rain Demo
# MIT License

import pygame, random
from pygame.locals import *

CHANCE = 0.5
SCREENX = 640
SCREENY = 480
ACCELERATION = 1.0
DROPSIZE = (3, 3)
COLORSTART = 255
COLOREND = 0
COLORSBETWEEN = 10

def trailimages(f, i):
    length = f - i + 1
    interval = (COLORSTART - COLOREND) / (COLORSBETWEEN + 1)
    images = []
    for x in range(COLORSBETWEEN):
        image = pygame.Surface((1, length)).convert()
        color = COLORSTART - (x + 1)*interval
        image.fill((color, color, color))
        images.append(image)
    return images

def dropimage():
    image = pygame.Surface(DROPSIZE).convert()
    image.fill((COLORSTART, COLORSTART, COLORSTART))
    return image

def prepare(drop, trail):
    y = 0.0
    v = 0.0
    ylist = []
    while int(y) <  SCREENY:
        ylist.insert(0, int(y))
        v = v + ACCELERATION
        y = y + v
    drop.ylist = ylist[:]
    ylist.insert(0, SCREENY)
    trail.imageset = []
    for i in range(len(ylist) - 1):
        trail.imageset.insert(0, trailimages(ylist[i], ylist[i + 1]))

class Drop(pygame.sprite.Sprite):
    def __init__(self, x):
        pygame.sprite.Sprite.__init__(self, self.updategroup, self.displaygroup)
        self.rect = self.image.get_rect()
        self.rect.centerx = x
        self.trailindex = 0
        self.ynum = len(self.ylist)
    def update(self):
        self.ynum = self.ynum - 1
        if self.ynum < 0:
            self.kill()
        else:
            self.rect.centery = self.ylist[self.ynum]
            Trail(self, self.trailindex)
            self.trailindex = self.trailindex + 1

class Trail(pygame.sprite.Sprite):
    def __init__(self, drop, trailindex):
        pygame.sprite.Sprite.__init__(self, self.updategroup)
        self.images = self.imageset[trailindex]
        self.rect = self.images[0].get_rect()
        self.rect.midtop = drop.rect.center
        self.update = self.start
    def start(self):
        self.add(self.displaygroup)
        self.update = self.fade
        self.imagenum = 0
        self.fade()
    def fade(self):
        if self.imagenum == len(self.images):
            self.kill()
        else:
            self.image = self.images[self.imagenum]
            self.imagenum = self.imagenum + 1

def main():
    pygame.init()
    screen = pygame.display.set_mode((SCREENX, SCREENY))
    background = pygame.Surface(screen.get_rect().size)

    updategroup = pygame.sprite.Group()
    displaygroup = pygame.sprite.RenderUpdates()

    Drop.image = dropimage()
    prepare(Drop, Trail)

    for thing in [Drop, Trail]:
        thing.updategroup = updategroup
        thing.displaygroup = displaygroup

    clock = pygame.time.Clock()

    while 1:

        for event in pygame.event.get():
            if event.type == QUIT:
                return

        displaygroup.clear(screen, background)

        updategroup.update()

        if random.random() < CHANCE:
            Drop(random.randrange(SCREENX))

        pygame.display.update(displaygroup.draw(screen))

        clock.tick(40)

if __name__ == '__main__':
    main()
