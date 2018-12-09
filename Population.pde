class Population
{
  Agent[] agents;
  float mutationRate = 0.1;
  int generation = 0;
  float current_best = 0;
  ArrayList avgs;
  
  Population(int size)
  {
    agents = new Agent[size];
    avgs = new ArrayList();
    for (int i=0; i<size; i++)
    {
      agents[i] = new Agent();
    }
  }
  
  void update()
  {
    for (Agent agent : agents)
    {
      if(!agent.done)
        agent.update();
    }
  }
  
  void draw()
  {
    textSize(12);
    fill(255, 255, 255);
    text(("Agent "+Marian.active_agent), Marian.WIDTH/2 - 30, 15);
    
    text("TIME\n" + agents[Marian.active_agent].timer, Marian.WIDTH - 50, 15);
    
    text(("Generation: " + generation), 10, 40);
    
    for(int i=0; i<avgs.size(); i++)
    {
      fill(255, 255, 255);
      text((avgs.get(i)).toString(), 20 + 80 * (i%3), 55 + 15 * floor(i/3));
    }
  }
  
  void naturalSelection()
  {
    Agent[] new_agents = new Agent[agents.length];
    for(int i=0; i<agents.length; i++)
    {
      if(i<ceil(agents.length/5))
        new_agents[i] = findBest(agents);
      else
        new_agents[i] = crossover(agents[i], new_agents[floor(new_agents.length/i)-1]);
      
      if(i!=0)
        mutate(new_agents[i]);
    }
    agents = new_agents;
    
    generation += 1;
  }
  
  Agent findBest(Agent[] agents)
  {
    Agent best_agent = agents[0];
    for (Agent agent : agents)
    {
      if (agent.fitness > best_agent.fitness)
        best_agent = agent;
    }
    if(best_agent.fitness > current_best)
      current_best = best_agent.fitness;
    best_agent.fitness = -1;
    return best_agent;
  }
  
  Agent crossover(Agent agent1, Agent agent2)
  {
    Agent new_agent = new Agent();
    
    ArrayList<Matrix> weights1 = agent1.brain.weights;
    ArrayList<Matrix> weights2 = agent2.brain.weights;
    ArrayList<Matrix> new_weights = new ArrayList<Matrix>();
    
    for(int i=0; i<weights1.size(); i++)
    {
      new_weights.add(weights1.get(i).randomJoin(weights2.get(i)));
    }
    new_agent.brain.weights = new_weights;
    return new_agent;
  }
  
  void mutate(Agent agent)
  {
    for (int i=0; i<agent.brain.weights.size(); i++)
      agent.brain.weights.get(i).randomDistort(mutationRate);
  }
  
  boolean done()
  {
    for (Agent agent : agents)
    {
      if(!agent.done)
        return false;
    }
    return true;
  }
  
  void reset()
  {
    for(int i=0; i<agents.length; i++)
    {
      agents[i].reset();
      agents[i].fitness = 0;
    }
  }
  
  float getAVG()
  {
    float result = 0;
    for(int i=0; i<agents.length; i++)
    {
      result += agents[i].fitness;
    }
    result /= agents.length;
    return result;
  }
}
