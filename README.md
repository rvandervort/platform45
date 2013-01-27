A Rails Battleship App
=============================
This is my entry into the Platform45 Developer Challenge.

http://battle.platform45.com

Basics / Components
-------------------
* Rails/Ruby
* Twitter bootstrap
* Coffeescript
* HTML5 canvas

Ship Placement Strategy
-----------------------
Ships are placed using a very basic strategy -- one ship per row, each in the first column. 

Guessing Strategy
-----------------------
Salvos are fired based on a probability-density algorithm. In general, the next guess will be the space with 
the maximum probability of containing a ship.
