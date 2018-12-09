class Agent
{
  boolean done;
  NeuralNetwork brain;
  final int INPUT_SIZE = 4;
  float[] observation = new float[INPUT_SIZE];
  float fitness;
  float timer;
  
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  Camera camera;
  
  float scale = 1;
  float max_speed = 3.2f;
  float linear_drag = 0.1f;
  boolean jump;
  float jump_power = 8f;
  float gravity = 0.98/2.25f;
  
  PVector size = new PVector(16,16);
  
  Agent()
  {
    brain = new NeuralNetwork(INPUT_SIZE,4);
    reset();
  }
  
  void draw()
  {
    camera.drawMap();
    
    fill(0xFFFF8833);
    //stroke(0);
    strokeWeight(0);
    ellipse(position.x - camera.position.x, position.y - camera.position.y, size.x, size.y);
  }
  
  void update()
  {
    timer -= 1/frameRate;
    
    float velocity_sign = velocity.x / abs(velocity.x);
    
    if(abs(velocity.x) > linear_drag)
      velocity.x -= linear_drag * velocity_sign;
    
    velocity.add(acceleration);
    
    if(abs(velocity.x) > max_speed * scale)
    {
      velocity.x = velocity_sign * max_speed * scale;
    }
    
    position.add(velocity);
    checkCollisions();
    if(jump && velocity.y == 0)
        jump();
    jump = false;
    
    camera.update();
    
    checkIfDone();
    
    if(Marian.AI_ON)
      {
      observation[0] = position.x/(terrain[0].length*tile_size);
      observation[1] = position.y/(terrain.length*tile_size);
      observation[2] = velocity.x;
      observation[3] = velocity.y;
      
      int output = brain.calculate_output(observation);
      switch(output)
      {
        case 0:
          if(velocity.y != 0)
          {
            acceleration.x = 0;
            break;
          }
          acceleration.x = 0.5f * scale;
          if(this.position.x == 160.5 * 16 && this.position.y <= 27.5 * 16 && this.position.y >= 26.5 * 16)
          {
            this.position = new PVector(164 * 16, 10.5 * 16);
            this.velocity.x = 0;
            this.acceleration.x = 0;
            this.camera.position = new PVector(162 * 16, 0);
            this.camera.locked = false;
          }
        break;
        case 1:
          acceleration.x = -0.5f * scale;
        break;
        case 2:
          jump = true;
        break;
        case 3:
          acceleration.x = 0;
          //if(this.position.x > 57.5 * 16 && this.position.x < 58.5 * 16 && this.position.y < 9 * 16 && this.position.y > 8 * 16)
          if(this.position.x > 57.5 * 16 && this.position.x < 58.5 * 16 && this.position.y >= 8.4 * tile_size && this.position.y <= 8.6 * tile_size)
          {
            this.position = new PVector(149.5 * 16, 15 * 16);
            this.camera.position = new PVector(148 * 16, 15 * 16);
            this.camera.locked = true;
          }
        break;
      }
    }
  }
  
  void checkCollisions()
  {
    for (Tile tile : Marian.map)
    {
      if((int) tile.position.x/tile.size == (int) this.position.x/tile.size)
      {
        if(this.position.y + this.size.y/2 > tile.position.y && this.position.y  + this.size.y/2 < tile.position.y + 3*tile.size/4)
        {
          this.position.y = tile.position.y - this.size.y/2;
          this.velocity.y = 0;
        }
        if(this.position.y - this.size.y/2 < tile.position.y + tile.size && this.position.y - this.size.y/2 >= tile.position.y + tile.size/4)
        {
          this.position.y = tile.position.y + tile.size + this.size.y/2;
          this.velocity.y = -0.1f;
        }
      }
      
      if((int) tile.position.y/tile.size == (int) this.position.y/tile.size)
        {
          if(this.position.x + this.size.x/2 > tile.position.x && this.position.x  + this.size.x/2 < tile.position.x + tile.size/2)
          {
            this.position.x = tile.position.x - this.size.x/2;
            this.velocity.x = 0;
          }
          
          if(this.position.x - this.size.x/2 < tile.position.x + tile.size && this.position.x - this.size.x/2 >= tile.position.x + tile.size/2)
          {
            this.position.x = tile.position.x + tile.size + this.size.x/2;
            this.velocity.x = 0;
          }
        }
      
    }
  }
  
  void jump()
  {
    velocity.y = -jump_power * (float)Math.sqrt(scale);
  }
  
  void checkIfDone()
  {
    fitness = this.position.x;
    if(timer <= 0)
      done = true;
    if((this.position.y > 13.5 * 16 && this.position.y < 14.5 * 16) || this.position.y > 30 * 16)
    {
      if (position.x <= 3 * 16)
      {
        camera.position.y = 15 * tile_size;
        return;
      }
      this.position = new PVector(0, 0);
      //fitness = 0;
      done = true;
    }
    if(this.position.x > 198.5 * 16)
    {
      this.position.x = 198.5 * 16;
      fitness += timer * 100;
      done = true;
      velocity = new PVector(0, 0);
    }
  }
  
  void reset()
  {
    done = false;
    timer = 30;
    position = new PVector(3 * 16, 12.5 * 16);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, gravity * scale);
    camera = new Camera(this);
  }
  
  void saveWeights()
  {
    PrintWriter output = createWriter("weights.txt");
    for(int i=0;i<brain.weights.size();i++)
      output.print(brain.weights.get(i).toString());
    output.flush();
    output.close();
  }
  
  void loadWeights()
  {
    BufferedReader reader = createReader("weights.txt");
    try {
      for(int i=0; i<brain.weights.size();i++)
      {
        for(int j=0; j<brain.weights.get(i).values.length;j++)
        {
          String[] pieces = split(reader.readLine(),' ');
          for(int k=0; k<pieces.length-1;k++)
            brain.weights.get(i).values[j][k] = float(pieces[k]);
        }
      }
      reset();
    } catch (IOException e)
    {
      e.printStackTrace();
    }
  }
}
