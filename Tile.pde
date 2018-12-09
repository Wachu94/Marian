class Tile
{
  int size = 16;
  PVector position;
  color colour;
  
  Tile(int pos_x, int pos_y, color colour)
  {
    position = new PVector(pos_x * size, pos_y * size);
    this.colour = colour;
  }
}