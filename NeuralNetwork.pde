class NeuralNetwork
{
  ArrayList<Matrix> weights = new ArrayList<Matrix>();
  Matrix input_layer;
  ArrayList<Matrix> layers = new ArrayList<Matrix>();
  
  NeuralNetwork(int input_size, int output_size)
  {
    Matrix network;
    network = add_input_layer(input_size);
    //network = add_layer(network, 128);
    //network = add_layer(network, 2);
    network = add_layer(network, output_size);
  }
  
  int calculate_output(float[] observation)
  {
    Matrix calculated = input_layer(observation);
    for(int i = 0; i<weights.size(); i++)
    {
      calculated = weights.get(i).dot(calculated);
      if(i<weights.size()-1)
        activate(calculated, "reLU");
      else
        activate(calculated, "softmax");
    }
    
    return calculated.max();
  }
  
  Matrix input_layer(float[] input_values)
  {
    for (int j = 0; j<input_values.length; j++) {
      input_layer.values[j][0] = input_values[j];
    }
    return input_layer;
  }
  
  Matrix add_input_layer(int size)
  {
    Matrix input = new Matrix(size);
    input_layer = input;
    layers.add(input_layer);
    return input;
  }
  
  Matrix add_layer(Matrix network, int layer_size)
  {
    Matrix new_layer = new Matrix(layer_size, network.values.length);
    randomize(new_layer);
    weights.add(new_layer);
    new_layer = new_layer.dot(network);
    layers.add(new_layer);
    return new_layer;
  }
  
  void randomize(Matrix matrix)
  {
    for (int i =0; i<matrix.values.length; i++) {
      for (int j = 0; j<matrix.values[0].length; j++) {
        matrix.values[i][j] = random(-1, 1);
      }
    }
  }
  void activate(Matrix matrix, String function_name)
  {
    switch(function_name)
    {
      case "reLU":
      Matrix layer_with_bias = new Matrix(matrix.values.length + 1, 1);
      for (int i =0; i<matrix.values.length; i++) {
          if (matrix.values[i][0] < 0)
            layer_with_bias.values[i][0] = 0;
          else
            layer_with_bias.values[i][0] = matrix.values[i][0];
      }
      layer_with_bias.values[matrix.values.length][0] = 1;
      break;
      
      case "softmax":
      float sum = 0;
      for (int i =0; i<matrix.values.length; i++) {
          matrix.values[i][0] = pow((float)Math.E, matrix.values[i][0]);
          sum += matrix.values[i][0];
      }
      for (int i =0; i<matrix.values.length; i++) {
          matrix.values[i][0] /= sum;
      }
      layers.get(layers.size()-1).values = matrix.values;
      break;
    }
  }
  
  void draw()
  {
    strokeWeight(0);
    float node_distance = 20;
    float starting_width = (Marian.WIDTH - layers.size() * node_distance)/2;
    for(int j=0; j< layers.size(); j++)
    {
      float starting_height = (Marian.HEIGHT - layers.get(j).values.length * node_distance)/2;
      
      for(int i=0; i< layers.get(j).values.length; i++)
      {
        float value = layers.get(j).values[i][0] * 255;
        if (value > 255)
          value = 255;
        if(value < 0)
          value = 0;
        fill(value);
        ellipse(starting_width + node_distance * j, starting_height + node_distance * i , 10, 10);
      }
    }
  }
}
