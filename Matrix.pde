class Matrix
{
  float[][] values;
  
  Matrix(float[] values)
  {
    this(values, false);
  }
  
  //One Dimention
  Matrix(float[] values, boolean asColumn)
  {
    if(asColumn)
    {
      this.values = new float[values.length][1];
      for(int i=0; i<values.length; i++)
        this.values[i][0] = values[i];
    } 
    else
    {
      this.values = new float[1][values.length];
      for(int i=0; i<values.length; i++)
        this.values[0][i] = values[i];
    }
  }
  
  //Empty matrix
  Matrix(int rows)
  {
    this(rows, 1);
  }
  
  Matrix(int rows, int columns)
  {
    values = new float[rows][columns];
  }
  
  
  Matrix dot(Matrix other)
  {
    Matrix result;
    if(values[0].length == other.values.length)
    {
      result = new Matrix(values.length, other.values[0].length);
      for(int i=0; i<values.length; i++)
      {
        for(int j=0; j<other.values[0].length; j++)
        {
          float sum = 0;
          for(int k=0; k<values[0].length; k++)
          {
            sum += values[i][k] * other.values[k][j];
          }
          result.values[i][j] = sum;
        }
      }
    }
    else
    {
      result = new Matrix(new float[1]);
      result.values[0][0] = -1;
    }
    return result;
  }
  
  Matrix randomJoin(Matrix other)
  {
    Matrix new_matrix = new Matrix(values.length, values[0].length);
    int randomR = floor(random(values.length));
    int randomC = floor(random(values[0].length));
    
    for(int x=0; x<values.length; x++)
    {
      for(int y=0; y<values[0].length; y++)
      {
        if(x <= randomR && y <= randomC)
          new_matrix.values[x][y] = other.values[x][y];
        else
          new_matrix.values[x][y] = values[x][y];
      }
    }
    return new_matrix;
  }
  
  void randomDistort(float probability)
  {
    for(int x=0; x<values.length; x++)
    {
      for(int y=0; y<values[0].length; y++)
      {
        float rnd = random(1);
        if(rnd<probability)
          values[x][y] += randomGaussian()/20;
      }
    }
  }
  
  int max()
  {
    float value = 0;
    int index = 0;
    for(int i=0; i<values.length; i++)
      {
        if(values[i][0] > value)
        {
          value = values[i][0];
          index = i;
        }
      }
      return index;
  }
  
  
  String toString()
  {
    String result = "";
    for(int x=0; x<values.length; x++)
    {
      for(int y=0; y<values[0].length; y++)
      {
        result += (values[x][y] + " ");
      }
      result += "\n";
    }
    return result;
  }
}