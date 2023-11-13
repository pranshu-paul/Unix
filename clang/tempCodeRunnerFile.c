int **create_matrix(int rows, int cols, int fill_value){
     int **matrix = malloc(sizeof(int *) * rows);

     for (int i = 0; i < rows; i++){
          matrix[i] = malloc(sizeof(int) * cols);
     }

     for (int i = 0; i < rows; i++){
          for (int j = 0; j < cols; j++){
               matrix[i][j] = fill_value;
          }
     }

     return matrix;
}