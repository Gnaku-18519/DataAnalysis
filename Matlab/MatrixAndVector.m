A(A>=0); %delete all negative elements

%generate random data with nomalized distribution
B = normrnd(μ,sd,rows,cols); % μ -> mean; sd -> standard deviation; rows -> number of rows; cols -> number of columns

%Sort the rows of A based on the values in the second column. When the specified column has repeated elements, the corresponding rows maintain their original order.
C = sortrows(A,2);
D = sortrows(A,[1 7]); %Sort the rows of A based on the elements in the first column, and look to the seventh column to break any ties.
%Sort the rows of A in descending order based on the elements in the fourth column, and display the output vector index to see how the rows were rearranged.
[E,index] = sortrows(A,4,'descend');

row = size(matrix, 1); %count the number of rows for a matrix
colNum = size(matrix, 2); %count the number of columns for a matrix

n = nnz(matrix); %count the number of non-zero elements for a matrix
