MineCraft

This is a board of mines 0 represents a cell WITHOUT a mine 1 represents a cell WITH a mine. The top left corner is 0,0. The bottom right corner is 8,8.

```
101000000
000010010
100100000
000010001
001010000
010001000
001000100
100100000
010000001
```

When a mine is exploded, it blows up all the adjacent cells, including diagonals. For example, blowing up the mine A:

```
101000000         
000010010
100100000
0000A0001
001010000  
010001000
001000100
100100000
010000001
```

Blows up all surrounding cells (B):

```
101000000
000010010
100BBB000
000BAB001
001BBB000
010001000
001000100
100100000
010000001
```

When a mine is present in one of the adjacent cells, that mine blows up as well, triggering a chain reaction.
Given this, write a method or a class that returns the coordinates of the mine that when blown up will cause the biggest chain reaction of other mines

```ruby
board_string = <<-BOARD
101000000
000010010
100100000
000010001
001010000
010001000
001000100
100100000
010000001
BOARD
```
