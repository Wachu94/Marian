int population_size = 500;
Population population;
static boolean AI_ON = true;
static boolean show_NN = false;
static int active_agent;
Agent player;

int[][] terrain;
int tile_size = 16;
static ArrayList<Tile> map = new ArrayList<Tile>();

static final int WIDTH = 256;
static final int HEIGHT = 240;

void setup()
{
  size(256, 240);
  //size(2800, 240);
  terrain = lvl_1_1;

  for (int y=0; y<terrain.length; y++)
    {
      for (int x=0; x<terrain[0].length; x++)
      {
        if(terrain[y][x] != 0)
        {
          color colour = 0xFF000000;
          switch(terrain[y][x])
          {
            case 1:
            colour = color(200,76,12);
            break;
            case 2:
            colour = color(0,168,0);
            break;
            case 3:
            colour = color(0,128,136);
            break;
          }
          Tile tile = new Tile(x, y, colour);
          map.add(tile);
        }
      }
    }
    
   if(AI_ON)
     population = new Population(population_size);
   else
     player = new Agent();
}

void draw()
{
  background(92,148,252);
  
  update();
  
  if(AI_ON)
  {
    if(show_NN)
      population.agents[active_agent].brain.draw();
    else
    {
      population.agents[active_agent].draw();
      population.draw();
    }
  }
  else
    player.draw();
}

void update()
{
  if(AI_ON)
  {
    if(!population.done())
      population.update();
    else
    {
      population.avgs.add(population.getAVG());
      population.naturalSelection();
      population.reset();
    }
  }
  else
    player.update();
}

void keyPressed()
{
  if(!AI_ON)
  {
    switch(keyCode)
    {
      case RIGHT:
        player.acceleration.x = 0.5f;
        if(player.position.x == 160.5 * 16 && player.position.y <= 27.5 * 16 && player.position.y >= 26.5 * 16)
        {
          player.position = new PVector(164 * 16, 10.5 * 16);
          player.velocity.x = 0;
          player.acceleration.x = 0;
          player.camera.position = new PVector(162 * 16, 0);
          player.camera.locked = false;
        }
        break;
      case LEFT:
        player.acceleration.x = -0.5f;
        break;
      case DOWN:
        if(player.position.x > 57.5 * 16 && player.position.x < 58.5 * 16 && player.position.y == 8.5 * 16)
        {
          player.position = new PVector(149.5 * 16, 15 * 16);
          player.camera.position = new PVector(148 * 16, 15 * 16);
          player.camera.locked = true;
        }
      break;
    }

    switch(key)
    {
      case ' ':
        player.jump = true;
      break;
      case 'p':
      print(player.position.toString());
      break;
      case 'r':
        player.reset();
      break;
    }
  }
  else
  {
    switch(key)
    {
      case ',':
      active_agent -=1;
      if(active_agent == -1)
        active_agent = population_size -1;
      break;
      case '.':
      active_agent +=1;
      if(active_agent == population_size)
        active_agent = 0;
      break;
      case 'n':
        show_NN = !show_NN;
      break;
      case 's':
        population.agents[active_agent].saveWeights();
      break;
      case 'l':
        population.agents[active_agent].loadWeights();
      break;
    }
  }
}

void keyReleased()
{
  if(!AI_ON)
  {
    switch(keyCode)
    {
      case RIGHT:
      case LEFT:
        player.acceleration.x = 0;
        break;
    }
  }
}
