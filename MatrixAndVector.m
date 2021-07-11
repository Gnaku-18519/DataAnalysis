A(A>=0); %delete all negative elements

%Sort the rows of A based on the values in the second column. When the specified column has repeated elements, the corresponding rows maintain their original order.
C = sortrows(A,2);
D = sortrows(A,[1 7]); %Sort the rows of A based on the elements in the first column, and look to the seventh column to break any ties.
%Sort the rows of A in descending order based on the elements in the fourth column, and display the output vector index to see how the rows were rearranged.
[E,index] = sortrows(A,4,'descend');
