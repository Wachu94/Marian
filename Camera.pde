class Camera
{
  PVector position = new PVector(0,0);
  boolean locked;
  Agent agent;
  
  Camera(Agent agent)
  {
    this.agent = agent;
  }
  
  void update()
  {
    float distance = agent.position.x - (this.position.x + Marian.WIDTH/2);
    
    if(distance > 0 && !locked)
    {
      this.position.x += distance;
    }
    
    if(distance < (-Marian.WIDTH/2 + agent.size.x/2 - 0.5f))
    {
      agent.position.x = this.position.x + agent.size.x/2;
    }
  }
  
  void drawMap()
  {
    for(Tile tile : Marian.map)
    {
      fill(tile.colour);
      //strokeWeight(tile.stroke_weight);
      stroke(tile.colour);
      rect(tile.position.x - this.position.x, tile.position.y - this.position.y, tile.size, tile.size);
    }
  }
}
